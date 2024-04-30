module "conf" {
  source = "./conf"
}

module "net" {
  source       = "./net"
  network_cidr = module.conf.net.network_cidr
  cluster = {
    name = module.conf.local_name
  }
}

module "dns" {
  source   = "./dns"
  name     = module.conf.dns.name
  image    = module.conf.dns.image
  hostname = module.conf.dns.hostname
  net = {
    private_ip         = module.conf.dns.private_ip
    cloud_hostname     = module.conf.cloud.hostname
    cloud_ip_address   = module.conf.cloud.private_ip
    local_hostname     = module.conf.local.hostname
    local_ip_address   = module.conf.local.private_ip
    bridge_network_id  = module.net.bridge_network_id
    private_network_id = module.net.private_network_id
  }
  cmd = {
    hostname   = module.conf.nodes.cmd.hostname
    private_ip = module.conf.nodes.cmd.private_ip
  }
}

module "nodes" {
  source = "./nodes"
  cluster = {
    name          = module.conf.cluster_name
    k8s_version   = module.conf.versions.k8s
    talos_version = module.conf.versions.talos
  }
  dns = {
    private_ip = module.dns.private_ip
  }
  net = {
    bridge_network_id  = module.net.bridge_network_id
    private_network_id = module.net.private_network_id
    ctrl_cidr          = module.conf.net.ctrl_cidr
    work_cidr          = module.conf.net.work_cidr
    pod_cidr           = module.conf.net.pod_cidr
    service_cidr       = module.conf.net.service_cidr
  }
  cmd  = module.conf.nodes.cmd
  ctrl = module.conf.nodes.ctrl
  work = module.conf.nodes.work
  cilium = {
    version = module.conf.versions.cilium
  }
  kubelet_serving_cert_approver = {
    version = module.conf.versions.kubelet_serving_cert_approver
  }
  local_path_provisioner = {
    version = module.conf.versions.local_path_provisioner
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.nodes.kubeconfig
  filename = "${path.module}/.kube/config"
}

resource "local_sensitive_file" "talosconfig" {
  content  = module.nodes.talosconfig
  filename = "${path.module}/.talos/config"
}
