variable "cluster" {
  type = object({
    name          = string
    k8s_version   = string
    talos_version = string
  })
}

variable "net" {
  type = object({
    bridge_network_id  = string
    private_network_id = string
    service_cidr       = string
    ctrl_cidr          = string
    work_cidr          = string
    pod_cidr           = string
  })
}

variable "cmd" {
  type = object({
    hostname   = string
    private_ip = string
    image      = string
  })
}

variable "ctrl" {
  type = map(object({
    name  = string
    image = string
  }))
}

variable "work" {
  type = map(object({
    name  = string
    image = string
  }))
}

variable "cilium" {
  type = object({
    version = string
  })
}

variable "local_path_provisioner" {
  type = object({
    version = string
  })
}

variable "kubelet_serving_cert_approver" {
  type = object({
    version = string
  })
}
