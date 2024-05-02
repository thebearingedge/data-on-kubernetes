variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "net" {
  type = object({
    private_network_id = string
    private_ip         = string
  })
}

variable "services" {
  type = object({
    s3 = object({
      hostname = string
      port     = string
    })
    console = object({
      hostname = string
      port     = number
    })
  })
}

variable "access_key_id" {
  type = string
}

variable "secret_access_key" {
  type = string
}

variable "buckets" {
  type = list(string)
}
