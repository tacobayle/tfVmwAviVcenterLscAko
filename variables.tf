#
# Environment Variables
#
variable "vsphere_username" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "avi_password" {}
variable "avi_old_password" {}
variable "avi_username" {}
variable "docker_registry_username" {}
variable "docker_registry_password" {}
variable "docker_registry_email" {}

#
# Other Variables
#

variable "avi" {}

variable "vcenter" {
  type = map
  default = {
    dc = "sof2-01-vc08"
    cluster = "sof2-01-vc08c01"
    datastore = "sof2-01-vc08c01-vsan"
    resource_pool = "sof2-01-vc08c01/Resources"
    folder = "nic-vmw-demo"
    networkMgmt = "vxw-dvs-34-virtualwire-3-sid-1080002-sof2-01-vc08-avi-mgmt"
  }
}

variable "controller" {
  default = {
    cpu = 16
    memory = 32768
    disk = 256
    cluster = true
    floating_ip = "10.41.134.130"
    version = "22.1.3-9096"
    wait_for_guest_net_timeout = 4
    private_key_path = "~/.ssh/cloudKey"
    dns =  ["10.23.108.1", "10.23.108.2"]
    ntp = ["95.81.173.155", "188.165.236.162"]
    from_email = "avicontroller@avidemo.fr"
    se_in_provider_context = "true" # true is required for LSC Cloud
    tenant_access_to_provider_se = "true"
    tenant_vrf = "false"
    aviCredsJsonFile = "~/.avicreds.json"
    public_key_path = "~/.ssh/cloudKey.pub"
  }
}

variable "jump" {
  type = map
  default = {
    name = "jump"
    cpu = 2
    memory = 4096
    disk = 20
    public_key_path = "~/.ssh/cloudKey.pub"
    private_key_path = "~/.ssh/cloudKey"
    wait_for_guest_net_timeout = 2
    template_name = "ubuntu-focal-20.04-cloudimg-template"
    avisdkVersion = "22.1.3"
    username = "ubuntu"
  }
}

variable "ansible" {
  default = {
    aviPbAbsentUrl = "https://github.com/tacobayle/ansibleAviClear"
    aviPbAbsentTag = "v1.04"
    aviConfigureUrl = "https://github.com/tacobayle/ansibleAviConfig"
    aviConfigureTag = "v1.76"
    version = {
      ansible = "5.7.1"
      ansible-core = "2.12.5"
    }
    k8sInstallUrl = "https://github.com/tacobayle/ansibleK8sInstall"
    k8sInstallTag = "v1.66"
  }
}

variable "backend_vmw" {
  default = {
    cpu = 2
    memory = 4096
    disk = 20
    username = "ubuntu"
    network = "vxw-dvs-34-virtualwire-117-sid-1080116-sof2-01-vc08-avi-dev113"
    wait_for_guest_net_timeout = 2
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    ipsData = ["100.64.130.203", "100.64.130.204"]
    netplanFile = "/etc/netplan/50-cloud-init.yaml"
    maskData = "/24"
    url_demovip_server = "https://github.com/tacobayle/demovip_server"
  }
}

variable "backend_vmw_pg" {
  default = {
    cpu = 2
    memory = 4096
    disk = 20
    username = "ubuntu"
    network = "vxw-dvs-34-virtualwire-117-sid-1080116-sof2-01-vc08-avi-dev113"
    wait_for_guest_net_timeout = 2
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    ipsData = ["100.64.130.207", "100.64.130.208"]
    netplanFile = "/etc/netplan/50-cloud-init.yaml"
    maskData = "/24"
    url_demovip_server = "https://github.com/tacobayle/demovip_server"
  }
}

variable "backend_lsc" {
  default = {
    cpu = 2
    memory = 4096
    disk = 20
    username = "ubuntu"
    network = "vxw-dvs-34-virtualwire-117-sid-1080116-sof2-01-vc08-avi-dev113"
    wait_for_guest_net_timeout = 2
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    ipsData = ["100.64.130.205", "100.64.130.206"]
    netplanFile = "/etc/netplan/50-cloud-init.yaml"
    maskData = "/24"
  }
}

variable "client" {
  default = {
    cpu = 2
    count = 3
    memory = 4096
    disk = 20
    username = "ubuntu"
    network = "vxw-dvs-34-virtualwire-118-sid-1080117-sof2-01-vc08-avi-dev114"
    wait_for_guest_net_timeout = 2
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    netplanFile = "/etc/netplan/50-cloud-init.yaml"
    ipsData = ["100.64.131.11", "100.64.131.12", "100.64.131.13"]
    maskData = "/24"
  }
}

variable "vmw" {
  default = {
    kubernetes = {
      workers = {
        count = 3
      }
      ako = {
        deploy = false
      }
      amko = {
        app_selector = "gslb"
        version = "1.7.1"
        deploy = false
      }
      argocd = {
        status = false
        manifest_url = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
        namespace = "argocd"
        client_url = "https://github.com/argoproj/argo-cd/releases/download/v2.0.4/argocd-linux-amd64"
      }
      clusters = [
        {
          name = "cluster1" # cluster name
          netplanApply = true
          username = "ubuntu" # default username dor docker and to connect
          version = "1.21.3-00" # k8s version
          namespaces = [
            {
              name= "ns1"
            },
            {
              name= "ns2"
            },
            {
              name= "ns3"
            },
          ]
          ako = {
            namespace = "avi-system"
            version = "1.7.2"
            helm = {
              url = "https://projects.registry.vmware.com/chartrepo/ako"
            }
            values = {
              AKOSettings = {
                disableStaticRouteSync = "false"
              }
              L7Settings = {
                serviceType = "ClusterIP"
                shardVSSize = "SMALL"
              }
            }
          }
          serviceEngineGroup = {
            name = "seg-cluster1"
            ha_mode = "HA_MODE_SHARED"
            min_scaleout_per_vs = "2"
            buffer_se = 1
            vcenter_folder = "nic-vmw-demo"
          }
          networks = {
            pod = "192.168.0.0/16"
          }
          docker = {
            version = "5:20.10.7~3-0~ubuntu-bionic"
          }
          interface = "ens224" # interface used by k8s
          cni = {
            url = "https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml"
            url_crd = "https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml -O"
            name = "calico" # calico or antrea
          }
          master = {
            cpu = 8
            memory = 16384
            disk = 80
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
          worker = {
            cpu = 4
            memory = 8192
            disk = 40
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
        },
        {
          name = "cluster2"
          netplanApply = true
          username = "ubuntu"
          version = "1.21.3-00"
          namespaces = [
            {
              name= "ns1"
            },
            {
              name= "ns2"
            },
            {
              name= "ns3"
            },
          ]
          ako = {
            namespace = "avi-system"
            version = "1.7.2"
            helm = {
              url = "https://projects.registry.vmware.com/chartrepo/ako"
            }
            values = {
              AKOSettings = {
                disableStaticRouteSync = "false"
              }
              L7Settings = {
                serviceType = "NodePortLocal"
                shardVSSize = "SMALL"
              }
            }
          }
          serviceEngineGroup = {
            name = "Default-Group"
            ha_mode = "HA_MODE_SHARED"
            min_scaleout_per_vs = 2
            buffer_se = 1
            max_vs_per_se = "20"
            extra_shared_config_memory = 0
            vcenter_folder = "nic-vmw-demo"
            vcpus_per_se = 2
            memory_per_se = 4096
            disk_per_se = 25
            realtime_se_metrics = {
              enabled = true
              duration = 0
            }
          }
          networks = {
            pod = "192.168.1.0/16"
          }
          docker = {
            version = "5:20.10.7~3-0~ubuntu-bionic"
          }
          interface = "ens224"
          cni = {
            url = "https://github.com/vmware-tanzu/antrea/releases/download/v1.2.3/antrea.yml"
            name = "antrea"
            enableNPL = true
          }
          master = {
            count = 1
            cpu = 8
            memory = 16384
            disk = 80
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
          worker = {
            cpu = 4
            memory = 8192
            disk = 40
            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
            wait_for_guest_net_routable = "false"
            template_name = "ubuntu-bionic-18.04-cloudimg-template"
            netplanFile = "/etc/netplan/50-cloud-init.yaml"
          }
        },
#        {
#          name = "cluster3"
#          netplanApply = true
#          username = "ubuntu"
#          version = "1.21.3-00"
#          namespaces = [
#            {
#              name= "ns1"
#            },
#            {
#              name= "ns2"
#            },
#            {
#              name= "ns3"
#            },
#          ]
#          ako = {
#            namespace = "avi-system"
#            version = "1.7.2"
#            helm = {
#              url = "https://projects.registry.vmware.com/chartrepo/ako"
#            }
#            values = {
#              AKOSettings = {
#                disableStaticRouteSync = "false"
#              }
#              L7Settings = {
#                serviceType = "ClusterIP"
#                shardVSSize = "SMALL"
#              }
#            }
#          }
#          serviceEngineGroup = {
#            name = "seg-cluster3"
#            ha_mode = "HA_MODE_SHARED"
#            min_scaleout_per_vs = "2"
#            buffer_se = 1
#            vcenter_folder = "nic-vmw-demo"
#          }
#          networks = {
#            pod = "10.244.0.0/16"
#          }
#          docker = {
#            version = "5:20.10.7~3-0~ubuntu-bionic"
#          }
#          interface = "ens224"
#          cni = {
#            url = "https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml"
#            name = "flannel"
#          }
#          master = {
#            count = 1
#            cpu = 8
#            memory = 16384
#            disk = 80
#            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
#            wait_for_guest_net_routable = "false"
#            template_name = "ubuntu-bionic-18.04-cloudimg-template"
#            netplanFile = "/etc/netplan/50-cloud-init.yaml"
#          }
#          worker = {
#            cpu = 4
#            memory = 8192
#            disk = 40
#            network = "vxw-dvs-34-virtualwire-124-sid-1080123-sof2-01-vc08-avi-dev120"
#            wait_for_guest_net_routable = "false"
#            template_name = "ubuntu-bionic-18.04-cloudimg-template"
#            netplanFile = "/etc/netplan/50-cloud-init.yaml"
#          }
#        },
      ]
    }
  }
}