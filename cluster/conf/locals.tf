locals {
  cluster_name = replace(var.cluster_hostname, ".", "-")
}

locals {
  network_cidr = "10.0.0.0/8"
}
