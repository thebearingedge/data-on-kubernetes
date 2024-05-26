resource "docker_container" "load" {
  name     = var.name
  image    = var.image
  hostname = var.hostname
  networks_advanced {
    name = var.net.bridge_network_id
  }
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = var.net.private_ip
  }
  ports {
    internal = 80
    external = 80
    ip       = "127.0.0.1"
  }
  ports {
    internal = 443
    external = 443
    ip       = "127.0.0.1"
  }
  upload {
    file = "/usr/local/etc/haproxy/haproxy.cfg"
    content = templatefile("${path.module}/templates/haproxy.tftpl.cfg", {
      servers = var.servers
    })
  }
}
