resource "docker_volume" "data" {
  name = join("-", [var.name, "data"])
}

resource "docker_container" "storage" {
  name  = var.name
  image = var.image
  wait  = true
  env = [
    "MINIO_ROOT_USER=${var.access_key_id}",
    "MINIO_ROOT_PASSWORD=${var.secret_access_key}",
    "MINIO_BROWSER_REDIRECT_URL=https://${var.services.console.hostname}"
  ]
  volumes {
    container_path = "/data"
    volume_name    = docker_volume.data.name
  }
  upload {
    file       = "/tmp/healthcheck.sh"
    content    = file("${path.module}/scripts/healthcheck.sh")
    executable = true
  }
  network_mode = "bridge"
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = var.net.private_ip
  }
  command = ["server", "/data", "--console-address", ":${var.services.console.port}"]
  healthcheck {
    start_period = "3s"
    interval     = "5s"
    retries      = 5
    test = concat(
      [
        "CMD", "/tmp/healthcheck.sh",
        "http://localhost:${var.services.s3.port}",
        var.access_key_id,
        var.secret_access_key
      ],
      var.buckets
    )
  }
}
