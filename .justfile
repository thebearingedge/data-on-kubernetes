set dotenv-load

[private]
default:
  @just --list --unsorted --list-heading '' --list-prefix ''

apply *args:
  terraform -chdir=infrastructure apply {{args}}

destroy *args:
  terraform -chdir=infrastructure destroy {{args}}

up *args:
  kubectl create secret generic local-ca \
    --dry-run=client \
    --from-file=ca.pem="$LOCAL_CA_CERT" \
    --output yaml > flux-system/.tmp/cloud-ca.yaml
  flux install \
    --components source-controller \
    --components helm-controller \
    --components kustomize-controller \
    --export > flux-system/.tmp/flux-install.yaml
  kubectl apply -k flux-system
  flux create source bucket flux \
    --interval=5s \
    --bucket-name=flux \
    --access-key="$S3_ACCESS_KEY_ID" \
    --secret-key="$S3_SECRET_ACCESS_KEY" \
    --endpoint="s3.$CLOUD_HOSTNAME"
  flux create kustomization flux \
    --prune=true \
    --interval=10s \
    --source=Bucket/flux \
    --path=./manifests/environments/local

down *args:
  flux uninstall --silent
  rm -f flux-system/.tmp/*.yaml

certs:
  mkcert -cert-file infrastructure/.tmp/tls.crt -key-file infrastructure/.tmp/tls.key \
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
