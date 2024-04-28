output "cluster_name" {
  value = local.cluster_name
}

output "net" {
  value = {
    network_cidr = local.network_cidr
  }
}
