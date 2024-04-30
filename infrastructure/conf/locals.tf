locals {
  cloud_name   = replace(var.cloud_hostname, ".", "-")
  local_name   = replace(var.local_hostname, ".", "-")
  cluster_name = replace(var.local_hostname, ".", "-")
}

locals {
  network_cidr = "10.0.0.0/8"
  cmd_cidr     = "10.0.8.0/24"
  ctrl_cidr    = "10.0.16.0/24"
  work_cidr    = "10.0.32.0/24"
  local_cidr   = "10.0.64.0/24"
  cloud_cidr   = "10.0.128.0/24"
  pod_cidr     = "10.244.0.0/16"
  service_cidr = "10.96.0.0/12"
}

locals {
  server_images = {
    coredns = docker_image.coredns.image_id
    talos   = docker_image.talos.image_id
    haproxy = docker_image.haproxy.image_id
  }
}

locals {
  ctrl_nodes = {
    for n in range(var.ctrl_nodes) :
    cidrhost(local.ctrl_cidr, n + 1) => {
      name  = join("-", ["ctrl", local.local_name])
      image = local.server_images.talos
    }
  }
  work_nodes = {
    for n in range(var.work_nodes) :
    cidrhost(local.work_cidr, n + 1) => {
      name  = join("-", ["work", local.local_name])
      image = local.server_images.talos
    }
  }
}
