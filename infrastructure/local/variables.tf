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
    private_network_id = string
  })
}

variable "servers" {
  type = list(object({
    name = string
    ipv4 = string
  }))
}
