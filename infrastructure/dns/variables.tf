variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "hostname" {
  type = string
}

variable "net" {
  type = object({
    private_ip         = string
    cloud_hostname     = string
    cloud_ip_address   = string
    local_hostname     = string
    local_ip_address   = string
    bridge_network_id  = string
    private_network_id = string
  })
}

variable "cmd" {
  type = object({
    hostname   = string
    private_ip = string
  })
}
