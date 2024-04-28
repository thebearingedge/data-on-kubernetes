variable "cluster" {
  type = object({
    name = string
  })
}

variable "network_cidr" {
  type = string
}
