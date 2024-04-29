locals {
  cluster_name = replace(var.cluster_hostname, ".", "-")
}

locals {
  network_cidr = "10.0.0.0/8"
  ctrl_cidr    = "10.0.64.0/24"
  work_cidr    = "10.0.32.0/24"
  proxy_cidr   = "10.0.16.0/24"
}

locals {
  server_images = {
    talos   = docker_image.talos.image_id
    haproxy = docker_image.haproxy.image_id
  }
}

locals {
  ctrl_nodes = {
    for i, _ in range(0, 1) :
    cidrhost(local.ctrl_cidr, i + 1) => {
      name  = join("-", compact([local.cluster_name, "ctrl"]))
      image = local.server_images.talos
    }
  }
  work_nodes = {
    for i, _ in range(0, 1) :
    cidrhost(local.work_cidr, i + 1) => {
      name  = join("-", compact([local.cluster_name, "work"]))
      image = local.server_images.talos
    }
  }
}
