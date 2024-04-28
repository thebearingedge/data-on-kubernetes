terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.5"
    }
  }
}
