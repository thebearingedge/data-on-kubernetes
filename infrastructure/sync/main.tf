resource "docker_container" "sync" {
  name  = var.name
  image = var.image
  env = [
    "MINIO_BUCKET=${var.s3.bucket}",
    "MINIO_ENDPOINT=${var.s3.endpoint}",
    "MINIO_ROOT_USER=${var.s3.access_key_id}",
    "MINIO_ROOT_PASSWORD=${var.s3.secret_access_key}"
  ]
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = var.net.private_ip
  }
  upload {
    file       = "/tmp/mirror.sh"
    content    = file("${path.module}/scripts/mirror.sh")
    executable = true
  }
  upload {
    file    = "/etc/ssl/certs/local-ca.crt"
    content = trimspace(file(var.local_ca_cert))
  }
  volumes {
    read_only      = true
    host_path      = abspath("${path.root}/../manifests")
    container_path = "/tmp/manifests"
  }
  entrypoint = ["/tmp/mirror.sh"]
}
