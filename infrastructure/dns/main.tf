resource "docker_container" "dns" {
  name     = var.name
  hostname = var.hostname
  image    = var.image
  command = [
    "-conf",
    "/etc/coredns/Corefile"
  ]
  network_mode = "bridge"
  networks_advanced {
    name = var.net.bridge_network_id
  }
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = var.net.private_ip
    aliases = [
      var.hostname
    ]
  }
  upload {
    file = "/etc/coredns/Corefile"
    content = templatefile("${path.module}/templates/Corefile.tftpl", {
      cloud_hostname = var.net.cloud_hostname
      local_hostname = var.net.local_hostname
    })
  }
  upload {
    file = "/etc/coredns/zones/cloud.zone"
    content = templatefile("${path.module}/templates/cloud.tftpl.zone", {
      hostname         = var.hostname
      cloud_hostname   = var.net.cloud_hostname
      cloud_ip_address = var.net.cloud_ip_address
    })
  }
  upload {
    file = "/etc/coredns/zones/local.zone"
    content = templatefile("${path.module}/templates/local.tftpl.zone", {
      hostname         = var.hostname
      local_hostname   = var.net.local_hostname
      local_ip_address = var.net.local_ip_address
      cmd_subdomain    = split(".", var.cmd.hostname)[0]
      cmd_private_ip   = var.cmd.private_ip
    })
  }
}
