resource "docker_image" "minio" {
  name          = data.docker_registry_image.minio.name
  keep_locally  = true
  pull_triggers = [data.docker_registry_image.minio.sha256_digest]
}
