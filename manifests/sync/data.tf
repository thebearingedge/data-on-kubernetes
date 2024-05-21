data "docker_registry_image" "minio" {
  name = "quay.io/minio/minio:${var.minio_version}"
}
