data "talos_machine_configuration" "ctrl" {
  machine_type       = "controlplane"
  cluster_name       = var.cluster.name
  talos_version      = "v${var.cluster.talos_version}"
  kubernetes_version = var.cluster.k8s_version
  cluster_endpoint   = local.public_endpoint
  machine_secrets    = talos_machine_secrets.main.machine_secrets
  config_patches = [
    local.base_machine_patch,
    local.ctrl_machine_patch
  ]
}

data "talos_machine_configuration" "work" {
  machine_type       = "worker"
  cluster_name       = var.cluster.name
  talos_version      = "v${var.cluster.talos_version}"
  kubernetes_version = var.cluster.k8s_version
  cluster_endpoint   = local.public_endpoint
  machine_secrets    = talos_machine_secrets.main.machine_secrets
  config_patches = [
    local.base_machine_patch,
    local.work_machine_patch
  ]
}

data "helm_template" "cilium" {
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = var.cilium.version
  values = [
    local.cilium_values
  ]
}

data "http" "kubernetes_endpoint" {
  depends_on = [
    talos_machine_bootstrap.main
  ]
  method      = "GET"
  url         = local.public_endpoint
  ca_cert_pem = base64decode(talos_machine_secrets.main.machine_secrets.certs.k8s.cert)
  retry {
    attempts     = 30
    min_delay_ms = 5000
  }
  lifecycle {
    postcondition {
      condition     = self.status_code == 401
      error_message = "unexpected status code"
    }
  }
}

data "talos_client_configuration" "main" {
  cluster_name         = var.cluster.name
  client_configuration = talos_machine_secrets.main.client_configuration
  endpoints            = [var.cmd.hostname]
  nodes = flatten([
    for node in docker_container.ctrl :
    [
      for n in node.networks_advanced : n.ipv4_address if n.name == var.net.private_network_id
    ]
  ])
}

data "talos_cluster_kubeconfig" "main" {
  depends_on = [
    talos_machine_bootstrap.main
  ]
  client_configuration = talos_machine_secrets.main.client_configuration
  node                 = local.boot_node
  endpoint             = var.cmd.hostname
}
