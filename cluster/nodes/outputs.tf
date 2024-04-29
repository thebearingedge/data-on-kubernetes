output "public_endpoint" {
  value = local.public_endpoint
}

output "talosconfig" {
  value = replace(data.talos_client_configuration.main.talos_config, var.cmd.private_ip, var.cmd.hostname)
}

output "servers" {
  value = concat([
    for ip, node in docker_container.ctrl : {
      name = node.name
      ipv4 = ip
    }
    ], [
    for ip, node in docker_container.work : {
      name = node.name
      ipv4 = ip
    }
  ])
}

output "boot_node" {
  value = local.boot_node
}

output "kubernetes" {
  value = data.talos_cluster_kubeconfig.main.kubernetes_client_configuration
}

output "kubeconfig" {
  value = data.talos_cluster_kubeconfig.main.kubeconfig_raw
}
