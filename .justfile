TERRAFORM_VERSION := "1.8.2"

[private]
default:
  @just --list --unsorted --list-heading '' --list-prefix ''

terraform *args:
  docker run \
    --rm \
    --interactive \
    --volume ./cluster:/tmp/cluster \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --workdir /tmp/cluster \
    docker.io/hashicorp/terraform:{{TERRAFORM_VERSION}} \
    {{args}}
