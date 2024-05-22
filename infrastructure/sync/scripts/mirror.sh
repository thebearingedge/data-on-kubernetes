#!/bin/sh -eu

mirror() {
  mc alias set main "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
  mc ping --count 5 --error-count 5 main
  exec mc mirror --watch /tmp/manifests "main/$MINIO_BUCKET/manifests"
}

mirror "$@"