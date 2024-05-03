set dotenv-load

[private]
default:
  @just --list --unsorted --list-heading '' --list-prefix ''

certs:
  mkcert -cert-file infrastructure/.tmp/tls.crt -key-file infrastructure/.tmp/tls.key \
    "$LOCAL_HOSTNAME" \
    "*.$LOCAL_HOSTNAME" \
    "$CLOUD_HOSTNAME" \
    "*.$CLOUD_HOSTNAME" && \
  cat infrastructure/.tmp/tls.crt infrastructure/.tmp/tls.key > infrastructure/.tmp/tls.pem
