resource "docker_container" "cloud" {
  name         = var.name
  image        = var.image
  hostname     = var.hostname
  network_mode = "bridge"
  networks_advanced {
    name = var.net.bridge_network_id
  }
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = var.net.private_ip
    aliases = flatten([
      for service, hosts in var.aliases : [
        for _, host in hosts : host.hostname
      ]
    ])
  }
  upload {
    file = "/usr/local/etc/haproxy/haproxy.cfg"
    content = templatefile("${path.module}/templates/haproxy.tftpl.cfg", {

    })
  }
  # upload {
  #   file = "/usr/local/etc/haproxy/hosts.map"
  #   content = templatefile("${path.module}/templates/hosts.tftpl.map", {
  #     hosts = flatten([
  #       for service, hosts in var.aliases : [
  #         for host in hosts : {
  #           name    = host.hostname
  #           service = service
  #         }
  #       ]
  #     ])
  #   })
  # }
  # upload {
  #   file = "/usr/local/etc/haproxy/ports.map"
  #   content = templatefile("${path.module}/templates/ports.tftpl.map", {
  #     hosts = flatten([
  #       for service, hosts in var.aliases : [
  #         for host in hosts : {
  #           name = host.hostname
  #           port = host.port
  #         }
  #       ]
  #     ])
  #   })
  # }
  volumes {
    read_only      = true
    host_path      = abspath("${path.module}/../.tmp/tls.pem")
    container_path = "/usr/local/etc/ssh/certs/tls.pem"
  }
}
