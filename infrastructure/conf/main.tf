resource "docker_image" "coredns" {
  name          = data.docker_registry_image.coredns.name
  keep_locally  = true
  pull_triggers = [data.docker_registry_image.coredns.sha256_digest]
}

resource "docker_image" "talos" {
  name          = data.docker_registry_image.talos.name
  keep_locally  = true
  pull_triggers = [data.docker_registry_image.talos.sha256_digest]
}

resource "docker_image" "haproxy" {
  name          = data.docker_registry_image.haproxy.name
  keep_locally  = true
  pull_triggers = [data.docker_registry_image.haproxy.sha256_digest]
}

resource "docker_image" "minio" {
  name          = data.docker_registry_image.minio.name
  keep_locally  = true
  pull_triggers = [data.docker_registry_image.minio.sha256_digest]
}

resource "docker_image" "busybox" {
  name          = data.docker_registry_image.busybox.name
  keep_locally  = true
  pull_triggers = [data.docker_registry_image.busybox.sha256_digest]
}
