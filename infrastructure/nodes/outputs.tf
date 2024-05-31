output "public_endpoint" {
  value = local.public_endpoint
}

output "servers" {
  value = concat(
    [
      for ip, node in docker_container.ctrl : {
        name = node.name
        ipv4 = ip
      }
    ],
    [
      for ip, node in docker_container.work : {
        name = node.name
        ipv4 = ip
      }
    ]
  )
}

output "boot_node" {
  value = local.boot_node
}

output "kubeconfig" {
  value = terraform_data.kubeconfig.output
}

output "talosconfig" {
  value = terraform_data.talosconfig.output
}
