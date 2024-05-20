output "cloud_name" {
  value = local.cloud_name
}

output "local_name" {
  value = local.local_name
}

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

output "cloud" {
  value = {
    private_ip = cidrhost(local.cloud_cidr, 1)
    name       = local.cloud_name
    image      = local.server_images.haproxy
    hostname   = var.cloud_hostname
  }
}

output "dns" {
  value = {
    private_ip = cidrhost(local.cloud_cidr, 2)
    name       = join("-", ["dns", local.cloud_name])
    image      = local.server_images.coredns
    hostname   = join(".", ["dns", var.cloud_hostname])
  }
}

output "storage" {
  value = {
    private_ip        = cidrhost(local.cloud_cidr, 3)
    name              = join("-", ["storage", local.cloud_name])
    image             = local.server_images.minio
    access_key_id     = var.storage_access_key_id
    secret_access_key = var.storage_secret_access_key
    volume_name       = join("-", ["storage", local.cloud_name])
    buckets = [
      local.storage_buckets.flux2
    ]
    services = {
      s3 = {
        hostname = join(".", ["s3", var.cloud_hostname])
        port     = 9000
      }
      ui = {
        hostname = join(".", ["minio", var.cloud_hostname])
        port     = 9001
      }
    }
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
      hostname   = join(".", ["cmd", var.local_hostname])
    }
  }
}

output "local" {
  value = {
    private_ip = cidrhost(local.local_cidr, 1)
    name       = local.local_name
    image      = local.server_images.haproxy
    hostname   = var.local_hostname
  }
}
