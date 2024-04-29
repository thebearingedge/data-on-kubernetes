locals {
  cluster_name = replace(var.cluster_hostname, ".", "-")
}

locals {
  network_cidr = "10.0.0.0/8"
  cmd_cidr     = "10.0.8.0/24"
  ctrl_cidr    = "10.0.16.0/24"
  work_cidr    = "10.0.32.0/24"
}

locals {
  server_images = {
    talos   = docker_image.talos.image_id
    haproxy = docker_image.haproxy.image_id
  }
}

locals {
  ctrl_nodes = {
    for n in range(var.ctrl_nodes) :
    cidrhost(local.ctrl_cidr, n + 1) => {
      name  = join("-", ["ctrl", local.cluster_name])
      image = local.server_images.talos
    }
  }
  work_nodes = {
    for n in range(var.work_nodes) :
    cidrhost(local.work_cidr, n + 1) => {
      name  = join("-", ["work", local.cluster_name])
      image = local.server_images.talos
    }
  }
}
