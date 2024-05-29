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

module "storage" {
  source = "./storage"
  name   = module.conf.storage.name
  image  = module.conf.storage.image
  net = {
    private_network_id = module.net.private_network_id
    private_ip         = module.conf.storage.private_ip
  }
  services          = module.conf.storage.services
  access_key_id     = module.conf.storage.access_key_id
  secret_access_key = module.conf.storage.secret_access_key
  buckets           = module.conf.storage.buckets
}

module "secrets" {
  source   = "./secrets"
  name     = module.conf.secrets.name
  image    = module.conf.secrets.image
  hostname = module.conf.secrets.hostname
  net = {
    private_network_id = module.net.private_network_id
    private_ip         = module.conf.secrets.private_ip
  }
  ingress_ca = {
    cert = var.local_ca_cert
    key  = var.local_ca_key
  }
}

module "sync" {
  depends_on = [
    module.storage
  ]
  source = "./sync"
  name   = module.conf.sync.name
  image  = module.conf.sync.image
  net = {
    private_network_id = module.net.private_network_id
    private_ip         = module.conf.sync.private_ip
  }
  s3 = {
    bucket            = module.conf.sync.bucket
    endpoint          = module.storage.endpoint
    access_key_id     = module.conf.storage.access_key_id
    secret_access_key = module.conf.storage.secret_access_key
  }
  local_ca_cert = var.local_ca_cert
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

module "cloud" {
  source   = "./cloud"
  name     = module.conf.cloud.name
  image    = module.conf.cloud.image
  hostname = module.conf.cloud.hostname
  net = {
    bridge_network_id  = module.net.bridge_network_id
    private_network_id = module.net.private_network_id
    private_ip         = module.conf.cloud.private_ip
  }
  aliases = {
    "${module.conf.storage.name}" = module.conf.storage.services
    "${module.conf.secrets.name}" = module.conf.secrets.services
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

module "local" {
  source   = "./local"
  name     = module.conf.local.name
  image    = module.conf.local.image
  hostname = module.conf.local.hostname
  net = {
    bridge_network_id  = module.net.bridge_network_id
    private_network_id = module.net.private_network_id
    private_ip         = module.conf.local.private_ip
  }
  servers = module.nodes.servers
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.nodes.kubeconfig
  filename = "${path.module}/.kube/config"
}

resource "local_sensitive_file" "talosconfig" {
  content  = module.nodes.talosconfig
  filename = "${path.module}/.talos/config"
}
