output "cluster_name" {
  value = local.cluster_name
}

output "net" {
  value = {
    network_cidr = local.network_cidr
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
