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
    bridge_network_id  = string
    private_network_id = string
    private_ip         = string
  })
}

variable "aliases" {
  type = map(map(object({
    hostname = string
    port     = number
  })))
}
