variable "cloud_hostname" {
  type    = string
  default = "cloud.test"
}

variable "local_hostname" {
  type    = string
  default = "local.test"
}

variable "talos_version" {
  type    = string
  default = "1.7.0"
}

variable "haproxy_version" {
  type    = string
  default = "2.9.7"
}

variable "k8s_version" {
  type    = string
  default = "1.30.0"
}

variable "cilium_version" {
  type    = string
  default = "1.15.4"
}

variable "local_path_provisioner_version" {
  type    = string
  default = "0.0.26"
}

variable "kubelet_serving_cert_approver_version" {
  type    = string
  default = "0.8"
}

variable "ctrl_nodes" {
  type    = number
  default = 1
}

variable "work_nodes" {
  type    = number
  default = 1
}
