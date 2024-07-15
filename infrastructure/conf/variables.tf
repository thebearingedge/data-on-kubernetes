variable "cloud_hostname" {
  type    = string
  default = "cloud.test"
}

variable "local_hostname" {
  type    = string
  default = "local.test"
}

variable "coredns_version" {
  type    = string
  default = "1.11.1"
}

variable "talos_version" {
  type    = string
  default = "1.7.2"
}

variable "haproxy_version" {
  type    = string
  default = "2.9.7"
}

variable "minio_version" {
  type    = string
  default = "RELEASE.2024-05-01T01-11-10Z"
}

variable "busybox_version" {
  type    = string
  default = "1.36.1"
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

variable "gateway_api_version" {
  type    = string
  default = "1.0.0"
}

variable "ctrl_nodes" {
  type    = number
  default = 1
}

variable "work_nodes" {
  type    = number
  default = 1
}

variable "storage_access_key_id" {
  type    = string
  default = "minioadmin"
}

variable "storage_secret_access_key" {
  type    = string
  default = "minioadmin"
}
