output "cluster_name" {
  value = local.cluster_name
}

output "versions" {
  value = {
    k8s                           = var.k8s_version
    talos                         = var.talos_version
    cilium                        = var.cilium_version
    local_path_provisioner        = var.local_path_provisioner_version
    kubelet_serving_cert_approver = var.kubelet_serving_cert_approver_version
  }
}

output "net" {
  value = {
    network_cidr = local.network_cidr
    cmd_cidr     = local.cmd_cidr
    ctrl_cidr    = local.ctrl_cidr
    work_cidr    = local.work_cidr
    pod_cidr     = local.pod_cidr
    service_cidr = local.service_cidr
  }
}

output "nodes" {
  value = {
    image = local.server_images.talos
    ctrl  = local.ctrl_nodes
    work  = local.work_nodes
    cmd = {
      private_ip = cidrhost(local.cmd_cidr, 1)
      image      = local.server_images.haproxy
      hostname   = join(".", ["cmd", var.cluster_hostname])
    }
  }
}
