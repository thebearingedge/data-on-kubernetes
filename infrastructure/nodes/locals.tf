locals {
  ports = {
    k8s    = 6443
    apid   = 50000
    trustd = 50001
  }

  public_endpoint  = "https://${var.cmd.hostname}:${local.ports.k8s}"
  private_endpoint = "https://${var.cmd.private_ip}:${local.ports.k8s}"

  cilium_values = templatefile("${path.module}/templates/cilium-values.tftpl.yaml", {

  })

  talos_extra_manifests = [
    "https://github.com/kubernetes-sigs/gateway-api/releases/download/v${var.gateway_api.version}/standard-install.yaml",
    "https://raw.githubusercontent.com/rancher/local-path-provisioner/v${var.local_path_provisioner.version}/deploy/local-path-storage.yaml",
    "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/release-${var.kubelet_serving_cert_approver.version}/deploy/standalone-install.yaml",
  ]

  base_machine_patch = templatefile("${path.module}/templates/base.tftpl.yaml", {
    ctrl_cidr       = var.net.ctrl_cidr
    work_cidr       = var.net.work_cidr
    pod_cidr        = var.net.pod_cidr
    service_cidr    = var.net.service_cidr
    cmd_hostname    = var.cmd.hostname
    cmd_private_ip  = var.cmd.private_ip
    dns_private_ip  = var.dns.private_ip
    public_endpoint = local.public_endpoint
  })

  ctrl_machine_patch = templatefile("${path.module}/templates/ctrl.tftpl.yaml", {
    ctrl_cidr = var.net.ctrl_cidr
  })

  work_machine_patch = templatefile("${path.module}/templates/work.tftpl.yaml", {

  })

  mounts = {
    tmpfs = toset(["/run", "/system", "/tmp"])
    volume = toset(concat(
      ["/etc/cni", "/etc/kubernetes", "/usr/libexec/kubernetes", "/opt"], # overlays
      ["/usr/etc/udev"],                                                  # udev
      ["/var", "/system/state"],                                          # ephemeral
      ["/run/cilium"],
      ["/sys/fs/bpf"]
    ))
  }

  boot_node = flatten([
    for node in values(docker_container.ctrl) : [
      for n in node.networks_advanced : n.ipv4_address if n.name == var.net.private_network_id
    ]
  ])[0]

  deps_machine_patch = yamlencode({
    cluster = {
      inlineManifests = [
        {
          name     = "helm-cilium"
          contents = data.helm_template.cilium.manifest
        }
      ]
      extraManifests = local.talos_extra_manifests
    }
  })
}
