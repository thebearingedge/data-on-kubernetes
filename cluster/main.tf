module "conf" {
  source = "./conf"
}

module "net" {
  source       = "./net"
  network_cidr = module.conf.net.network_cidr
  cluster = {
    name = module.conf.cluster_name
  }
}
