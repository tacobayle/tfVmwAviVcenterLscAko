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
    folder = "NicTfVmw"
    networkMgmt = "vxw-dvs-34-virtualwire-3-sid-1080002-sof2-01-vc08-avi-mgmt"
  }
}

variable "controller" {
  default = {
    cpu = 16
    memory = 32768
    disk = 256
//    count = "1"
    cluster = true
    floating_ip = "10.41.134.130"
    version = "21.1.4-9210"
    wait_for_guest_net_timeout = 4
    private_key_path = "~/.ssh/cloudKey"
    environment = "VMWARE"
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
    avisdkVersion = "21.1.4"
    username = "ubuntu"
  }
}

variable "ansible" {
  default = {
    aviPbAbsentUrl = "https://github.com/tacobayle/ansibleAviClear"
    aviPbAbsentTag = "v1.03"
    aviConfigureUrl = "https://github.com/tacobayle/ansibleAviConfig"
    aviConfigureTag = "v1.6"
    version = {
      ansible = "5.7.1"
      ansible-core = "2.12.5"
    }
    k8sInstallUrl = "https://github.com/tacobayle/ansibleK8sInstall"
    k8sInstallTag = "v1.6"
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
    count = 2
    memory = 4096
    disk = 20
    username = "ubuntu"
    network = "vxw-dvs-34-virtualwire-118-sid-1080117-sof2-01-vc08-avi-dev114"
    wait_for_guest_net_timeout = 2
    template_name = "ubuntu-bionic-18.04-cloudimg-template"
    netplanFile = "/etc/netplan/50-cloud-init.yaml"
    ipsData = ["100.64.131.11", "100.64.131.12"]
    maskData = "/24"
  }
}

variable "vmw" {
  default = {
#    name = "dc1_vCenter"
#    datacenter = "sof2-01-vc08"
#    dhcp_enabled = "true"
#    domains = [
#      {
#        name = "vcenter.avi.com"
#      }
#    ]
#    management_network = {
#      name = "vxw-dvs-34-virtualwire-3-sid-1080002-sof2-01-vc08-avi-mgmt"
#      dhcp_enabled = "true"
#      exclude_discovered_subnets = "true"
#      vcenter_dvs = "true"
#      type = "V4"
#    }
#    network_vip = {
#      name = "vxw-dvs-34-virtualwire-118-sid-1080117-sof2-01-vc08-avi-dev114"
#      ipStartPool = "50"
#      ipEndPool = "99"
#      cidr = "100.64.131.0/24"
#      type = "V4"
#      exclude_discovered_subnets = "true"
#      vcenter_dvs = "true"
#      dhcp_enabled = "no"
#    }
#    network_backend = {
#      name = "vxw-dvs-34-virtualwire-117-sid-1080116-sof2-01-vc08-avi-dev113"
#      cidr = "100.64.130.0/24"
#      type = "V4"
#      exclude_discovered_subnets = "true"
#      vcenter_dvs = "true"
#      dhcp_enabled = "yes"
#    }
#    serviceEngineGroup = [
#      {
#        name = "Default-Group"
#        ha_mode = "HA_MODE_SHARED"
#        min_scaleout_per_vs = 2
#        buffer_se = 1
#        max_vs_per_se = "20"
#        extra_shared_config_memory = 0
#        vcenter_folder = "NicTfVmw"
#        vcpus_per_se = 2
#        memory_per_se = 4096
#        disk_per_se = 25
#        realtime_se_metrics = {
#          enabled = true
#          duration = 0
#        }
#      },
#      {
#        name = "seGroupCpuAutoScale"
#        ha_mode = "HA_MODE_SHARED"
#        min_scaleout_per_vs = 1
#        max_scaleout_per_vs = 2
#        max_cpu_usage = 70
#        #vs_scaleout_timeout = 30
#        buffer_se = 2
#        extra_shared_config_memory = 0
#        vcenter_folder = "NicTfVmw"
#        vcpus_per_se = 1
#        memory_per_se = 2048
#        disk_per_se = 25
#        auto_rebalance = true
#        auto_rebalance_interval = 30
#        auto_rebalance_criteria = [
#          "SE_AUTO_REBALANCE_CPU"
#        ]
#        realtime_se_metrics = {
#          enabled = true
#          duration = 0
#        }
#      },
#      {
#        name = "seGroupGslb"
#        ha_mode = "HA_MODE_SHARED"
#        min_scaleout_per_vs = 1
#        buffer_se = 0
#        extra_shared_config_memory = 2000
#        vcenter_folder = "NicTfVmw"
#        vcpus_per_se = 2
#        memory_per_se = 8192
#        disk_per_se = 25
#        realtime_se_metrics = {
#          enabled = true
#          duration = 0
#        }
#      }
#    ]
#    httppolicyset = [
#      {
#        name = "http-request-policy-app3-content-switching-vmw"
#        http_request_policy = {
#          rules = [
#            {
#              name = "Rule 1"
#              match = {
#                path = {
#                  match_criteria = "CONTAINS"
#                  match_str = ["hello", "world"]
#                }
#              }
#              rewrite_url_action = {
#                path = {
#                  type = "URI_PARAM_TYPE_TOKENIZED"
#                  tokens = [
#                    {
#                      type = "URI_TOKEN_TYPE_STRING"
#                      str_value = "index.html"
#                    }
#                  ]
#                }
#                query = {
#                  keep_query = true
#                }
#              }
#              switching_action = {
#                action = "HTTP_SWITCHING_SELECT_POOL"
#                status_code = "HTTP_LOCAL_RESPONSE_STATUS_CODE_200"
#                pool_ref = "/api/pool?name=pool1-vmw-hello"
#              }
#            },
#            {
#              name = "Rule 2"
#              match = {
#                path = {
#                  match_criteria = "CONTAINS"
#                  match_str = ["avi"]
#                }
#              }
#              rewrite_url_action = {
#                path = {
#                  type = "URI_PARAM_TYPE_TOKENIZED"
#                  tokens = [
#                    {
#                      type = "URI_TOKEN_TYPE_STRING"
#                      str_value = ""
#                    }
#                  ]
#                }
#                query = {
#                  keep_query = true
#                }
#              }
#              switching_action = {
#                action = "HTTP_SWITCHING_SELECT_POOL"
#                status_code = "HTTP_LOCAL_RESPONSE_STATUS_CODE_200"
#                pool_ref = "/api/pool?name=pool2-vmw-avi"
#              }
#            },
#          ]
#        }
#      }
#    ]
#    pools = [
#      {
#        name = "pool1-vmw-hello"
#        lb_algorithm = "LB_ALGORITHM_ROUND_ROBIN"
#      },
#      {
#        name = "pool2-vmw-avi"
#        application_persistence_profile_ref = "System-Persistence-Client-IP"
#        default_server_port = 8080
#      },
#      {
#        name = "pool3-vmw-waf"
#        default_server_port = 8081
#      }
#    ]
#    virtualservices = {
#      http = [
#        {
#          name = "app1-hello-world"
#          pool_ref = "pool1-vmw-hello"
#          services: [
#            {
#              port = 80
#              enable_ssl = "false"
#            },
#            {
#              port = 443
#              enable_ssl = "true"
#            }
#          ]
#        },
#        {
#          name = "app2"
#          pool_ref = "pool2-vmw-avi"
#          services: [
#            {
#              port = 80
#              enable_ssl = "false"
#            },
#            {
#              port = 443
#              enable_ssl = "true"
#            }
#          ]
#        },
#        {
#          name = "app3-content-switching"
#          pool_ref = "pool2-vmw-avi"
#          http_policies = [
#            {
#              http_policy_set_ref = "/api/httppolicyset?name=http-request-policy-app3-content-switching-vmw"
#              index = 11
#            }
#          ]
#          services: [
#            {
#              port = 80
#              enable_ssl = "false"
#            },
#            {
#              port = 443
#              enable_ssl = "true"
#            }
#          ]
#        },
#        {
#          name = "app4-se-cpu-auto-scale"
#          pool_ref = "pool1-vmw-hello"
#          services: [
#            {
#              port = 80
#              enable_ssl = "false"
#            },
#            {
#              port = 443
#              enable_ssl = "true"
#            }
#          ]
#          se_group_ref: "seGroupCpuAutoScale"
#        },
#        {
#          name = "app5-waf"
#          pool_ref = "pool3-vmw-waf"
#          services: [
#            {
#              port = 443
#              enable_ssl = "true"
#            }
#          ]
#        },
#      ]
#      dns = [
#        {
#          name = "app6-dns"
#          services: [
#            {
#              port = 53
#            }
#          ]
#        },
#        {
#          name = "app7-gslb"
#          services: [
#            {
#              port = 53
#            }
#          ]
#          se_group_ref: "seGroupGslb"
#        }
#      ]
#    }
    kubernetes = {
      workers = {
        count = 3
      }
      ako = {
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
            version = "1.7.1"
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
            vcenter_folder = "NicTfVmw"
          }
          networks = {
            pod = "192.168.0.0/16"
          }
          docker = {
            version = "5:20.10.7~3-0~ubuntu-bionic"
          }
          interface = "ens224" # interface used by k8s
          cni = {
            url = "https://docs.projectcalico.org/manifests/calico.yaml"
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
            version = "1.7.1"
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
            vcenter_folder = "NicTfVmw"
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
        {
          name = "cluster3"
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
            version = "1.7.1"
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
            name = "seg-cluster3"
            ha_mode = "HA_MODE_SHARED"
            min_scaleout_per_vs = "2"
            buffer_se = 1
            vcenter_folder = "NicTfVmw"
          }
          networks = {
            pod = "10.244.0.0/16"
          }
          docker = {
            version = "5:20.10.7~3-0~ubuntu-bionic"
          }
          interface = "ens224"
          cni = {
            url = "https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml"
            name = "flannel"
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
      ]
    }
  }
}

#variable "lsc" {
#  default = {
#    name = "dc2_bare_metal"
#    domains = [
#      {
#        name = "lsc.avi.com"
#      }
#    ]
#    network_vip = {
#      name = "net-lsc-vip"
#      ipStartPool = "100"
#      ipEndPool = "110"
#      cidr = "100.64.131.0/24"
#      type = "V4"
#    }
#    serviceEngineGroup = {
#      name = "Default-Group"
#      vcpus_per_se = 2
#      kernel_version = "4.4.0-72-generic"
#      memory_per_se = 4096
#      disk_per_se = 25
#      SE_INBAND_MGMT = "False"
#      DPDK = "Yes"
#      count = 2
#      networks = [
#        {
#          name = "vxw-dvs-34-virtualwire-3-sid-1080002-sof2-01-vc08-avi-mgmt"
#        },
#        {
#          name = "vxw-dvs-34-virtualwire-117-sid-1080116-sof2-01-vc08-avi-dev113"
#        },
#        {
#          name = "vxw-dvs-34-virtualwire-118-sid-1080117-sof2-01-vc08-avi-dev114"
#        },
#      ]
#      username = "ubuntu"
#      templateName = "ubuntu-xenial-16.04-cloudimg-template"
#      public_key_path = "~/.ssh/cloudKey.pub"
#      private_key_path = "~/.ssh/cloudKey"
#    }
#    pool = {
#        name = "pool8-lsc"
#        lb_algorithm = "LB_ALGORITHM_ROUND_ROBIN"
#    }
#    virtualservices = {
#      http = [
#        {
#          name = "app8"
#          pool_ref = "pool8-lsc"
#          services: [
#            {
#              port = 80
#              enable_ssl = "false"
#            },
#            {
#              port = 443
#              enable_ssl = "true"
#            }
#          ]
#        }
#      ]
#      dns = [
#        {
#          name = "app9-dns"
#          services: [
#            {
#              port = 53
#            }
#          ]
#        }
#      ]
#    }
#  }
#}