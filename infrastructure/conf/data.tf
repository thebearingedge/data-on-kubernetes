data "docker_registry_image" "coredns" {
  name = "index.docker.io/coredns/coredns:${var.coredns_version}"
}

data "docker_registry_image" "talos" {
  name = "ghcr.io/siderolabs/talos:v${var.talos_version}"
}

data "docker_registry_image" "haproxy" {
  name = "ghcr.io/haproxytech/haproxy-docker-alpine:${var.haproxy_version}"
}

data "docker_registry_image" "minio" {
  name = "quay.io/minio/minio:${var.minio_version}"
}

data "docker_registry_image" "busybox" {
  name = "index.docker.io/library/busybox:${var.busybox_version}"
}
