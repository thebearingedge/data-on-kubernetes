variable "cluster_hostname" {
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

variable "ctrl_nodes" {
  type    = number
  default = 1
}

variable "work_nodes" {
  type    = number
  default = 1
}
