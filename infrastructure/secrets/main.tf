resource "docker_container" "secrets" {
  name  = var.name
  image = var.image
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = var.net.private_ip
  }
  entrypoint = ["httpd", "-vv", "-f", "-c", "/etc/httpd.conf", "-h", "/www"]
  upload {
    file = "/etc/httpd.conf"
    content = templatefile("${path.module}/templates/httpd.tftpl.conf", {
      basic_auth = "/:test:test" # todo: parameterize
    })
  }
  upload {
    file       = "/www/cgi-bin/index.cgi"
    executable = true
    content    = file("${path.module}/scripts/index.cgi")
  }
}
