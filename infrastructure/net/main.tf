resource "docker_network" "bridge" {
  name = "${var.cluster.name}-bridge"
}

resource "docker_network" "internal" {
  name   = "${var.cluster.name}-internal"
  driver = "ipvlan"
  options = {
    ipvlan_mode = "l2"
    ipvlan_flag = "bridge"
  }
  ipam_config {
    ip_range = var.network_cidr
    subnet   = var.network_cidr
    gateway  = cidrhost(var.network_cidr, 1)
  }
}
