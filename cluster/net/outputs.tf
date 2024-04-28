output "private_network_id" {
  value = docker_network.internal.id
}

output "bridge_network_id" {
  value = docker_network.bridge.id
}

output "network_cidr" {
  value = var.network_cidr
}
