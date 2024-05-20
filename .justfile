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

debug:
  #!/bin/sh -e
  kubectl run debug \
    --rm \
    --tty \
    --stdin \
    --restart=Never \
    --image=cgr.dev/chainguard/busybox:latest \
    --overrides='
      {
        "spec": {
          "nodeSelecor": {
            "k8s-role/work": ""
          },
          "containers": [
            {
              "name": "debug",
              "image": "cgr.dev/chainguard/busybox:latest",
              "tty": true,
              "stdin": true,
              "command": [
                "/bin/sh"
              ],
              "workingDir": "/home/nonroot",
              "securityContext": {
                "runAsNonRoot": true,
                "runAsUserName": "nonroot",
                "allowPrivilegeEscalation": false,
                "seccompProfile": {
                  "type": "RuntimeDefault"
                },
                "capabilities": {
                  "drop": [
                    "ALL"
                  ]
                }
              }
            }
          ]
        }
      }
    '
