terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    helm = {
      source = "hashicorp/helm"
    }
    http = {
      source = "hashicorp/http"
    }
    random = {
      source = "hashicorp/random"
    }
    talos = {
      source = "siderolabs/talos"
    }
  }
}
