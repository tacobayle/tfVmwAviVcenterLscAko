data "template_file" "values" {
  count = length(var.vmw.kubernetes.clusters)
  depends_on = [null_resource.ansible_bootstrap_cluster]
  template = file("template/values.yml.template")
  vars = {
    disableStaticRouteSync = var.vmw.kubernetes.clusters[count.index].ako.values.AKOSettings.disableStaticRouteSync
    clusterName  = var.vmw.kubernetes.clusters[count.index].name
    cniPlugin    = var.vmw.kubernetes.clusters[count.index].cni.name
    subnetIP     = split("/", var.avi.config.vcenter.networks.network_vip.cidr)[0]
    subnetPrefix = split("/", var.avi.config.vcenter.networks.network_vip.cidr)[1]
    networkName = var.avi.config.vcenter.networks.network_vip.name
    serviceType = var.vmw.kubernetes.clusters[count.index].ako.values.L7Settings.serviceType
    shardVSSize = var.vmw.kubernetes.clusters[count.index].ako.values.L7Settings.shardVSSize
    serviceEngineGroupName = var.vmw.kubernetes.clusters[count.index].serviceEngineGroup.name
    controllerVersion = split("-", var.controller.version)[0]
    cloudName = var.avi.config.vcenter.name
    controllerHost = vsphere_virtual_machine.controller[0].default_ip_address
  }
}

resource "null_resource" "ako_prerequisites" {
  count = length(var.vmw.kubernetes.clusters)
  connection {
    host = vsphere_virtual_machine.master[count.index].default_ip_address
    type = "ssh"
    agent = false
    user = var.vmw.kubernetes.clusters[count.index].username
    private_key = file(var.jump.private_key_path)
  }

  provisioner "local-exec" {
    command = "cat > values-cluster-${count.index} <<EOL\n${data.template_file.values[count.index].rendered}\nEOL"
  }

  provisioner "file" {
    source = "values-cluster-${count.index}"
    destination = "values.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"avi_password=${var.avi_password}\" | sudo tee -a /home/ubuntu/.profile",
      "echo \"alias k=kubectl\" | sudo tee -a /home/ubuntu/.profile",
      "helm repo add ako ${var.vmw.kubernetes.clusters[count.index].ako.helm.url}",
      "kubectl create secret docker-registry docker --docker-server=docker.io --docker-username=${var.docker_registry_username} --docker-password=${var.docker_registry_password} --docker-email=${var.docker_registry_email}",
      "kubectl patch serviceaccount default -p \"{\\\"imagePullSecrets\\\": [{\\\"name\\\": \\\"docker\\\"}]}\"",
      "kubectl create ns ${var.vmw.kubernetes.clusters[count.index].ako.namespace}",
      "kubectl create secret docker-registry docker --docker-server=docker.io --docker-username=${var.docker_registry_username} --docker-password=${var.docker_registry_password} --docker-email=${var.docker_registry_email} -n ${var.vmw.kubernetes.clusters[count.index].ako.namespace}",
      "kubectl patch serviceaccount default -p \"{\\\"imagePullSecrets\\\": [{\\\"name\\\": \\\"docker\\\"}]}\" -n ${var.vmw.kubernetes.clusters[count.index].ako.namespace}",
      "for ns in $(echo '${jsonencode(var.vmw.kubernetes.clusters[count.index].namespaces)}' | jq -r '.[].name') ; do kubectl create ns $ns ; done",
      "for ns in $(echo '${jsonencode(var.vmw.kubernetes.clusters[count.index].namespaces)}' | jq -r '.[].name') ; do kubectl create secret docker-registry docker --docker-server=docker.io --docker-username=${var.docker_registry_username} --docker-password=${var.docker_registry_password} --docker-email=${var.docker_registry_email} -n $ns ; done",
      "for ns in $(echo '${jsonencode(var.vmw.kubernetes.clusters[count.index].namespaces)}' | jq -r '.[].name') ; do kubectl patch serviceaccount default -p \"{\\\"imagePullSecrets\\\": [{\\\"name\\\": \\\"docker\\\"}]}\" -n $ns ; done",
      "openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out ssl.crt -keyout ssl.key -subj \"/C=US/ST=CA/L=Palo Alto/O=VMWARE/OU=IT/CN=ingress.${var.avi.config.vcenter.domains[0].name}\"",
      "kubectl create secret tls cert01 --key=ssl.key --cert=ssl.crt",
    ]
  }
}

resource "null_resource" "ako_deploy" {
  depends_on = [null_resource.ako_prerequisites]
  count = (var.vmw.kubernetes.ako.deploy == true ? length(var.vmw.kubernetes.clusters) : 0)
  connection {
    host = vsphere_virtual_machine.master[count.index].default_ip_address
    type = "ssh"
    agent = false
    user = var.vmw.kubernetes.clusters[count.index].username
    private_key = file(var.jump.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "helm --debug install ako/ako --generate-name --version ${var.vmw.kubernetes.clusters[count.index].ako.version} -f values.yml --namespace=${var.vmw.kubernetes.clusters[count.index].ako.namespace} --set avicredentials.username=admin --set avicredentials.password=${var.avi_password}"
    ]
  }
}


resource "null_resource" "argocd" {
  depends_on = [null_resource.ako_prerequisites]
  count = (var.vmw.kubernetes.argocd.status == true ? length(var.vmw.kubernetes.clusters) : 0)
  connection {
    host = vsphere_virtual_machine.master[count.index].default_ip_address
    type = "ssh"
    agent = false
    user = var.vmw.kubernetes.clusters[count.index].username
    private_key = file(var.jump.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl create namespace ${var.vmw.kubernetes.argocd.namespace}",
      "kubectl apply -n argocd -f ${var.vmw.kubernetes.argocd.manifest_url}",
      "kubectl patch svc argocd-server -n ${var.vmw.kubernetes.argocd.namespace} -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'"
    ]
  }
}