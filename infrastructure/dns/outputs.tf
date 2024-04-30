output "private_ip" {
  value = [
    for n in docker_container.dns.networks_advanced :
    n.ipv4_address if n.name == var.net.private_network_id
  ][0]
}
