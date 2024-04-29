data "docker_registry_image" "talos" {
  name = "ghcr.io/siderolabs/talos:v${var.talos_version}"
}

data "docker_registry_image" "haproxy" {
  name = "ghcr.io/haproxytech/haproxy-docker-alpine:${var.haproxy_version}"
}
