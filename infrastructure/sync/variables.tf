variable "name" {
  type = string
}

variable "image" {
  type = string
}


variable "net" {
  type = object({
    private_ip         = string
    private_network_id = string
  })
}

variable "local_ca_cert" {
  type = string
}

variable "s3" {
  type = object({
    endpoint          = string
    bucket            = string
    access_key_id     = string
    secret_access_key = string
  })
}
