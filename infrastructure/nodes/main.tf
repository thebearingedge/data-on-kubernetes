resource "talos_machine_secrets" "main" {
  talos_version = "v${var.cluster.talos_version}"
}

resource "random_id" "ctrl" {
  for_each    = var.ctrl
  byte_length = 2
}

resource "docker_container" "ctrl" {
  for_each     = var.ctrl
  name         = join("-", compact([each.value.name, random_id.ctrl[each.key].hex]))
  hostname     = join("-", compact([each.value.name, random_id.ctrl[each.key].hex]))
  image        = each.value.image
  network_mode = "bridge"
  networks_advanced {
    name = var.net.bridge_network_id
  }
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = each.key
  }
  env = [
    "PLATFORM=container",
    "USERDATA=${base64encode(data.talos_machine_configuration.ctrl.machine_configuration)}"
  ]
  privileged = true
  security_opts = [
    "seccomp:unconfined"
  ]
  read_only = true
  dynamic "mounts" {
    for_each = local.mounts.tmpfs
    content {
      target = mounts.value
      type   = "tmpfs"
    }
  }
  dynamic "mounts" {
    for_each = local.mounts.volume
    content {
      target = mounts.value
      type   = "volume"
    }
  }
  lifecycle {
    ignore_changes = [
      env,
      security_opts
    ]
  }
}

resource "docker_container" "cmd" {
  name         = replace(var.cmd.hostname, ".", "-")
  hostname     = var.cmd.hostname
  image        = var.cmd.image
  network_mode = "bridge"
  networks_advanced {
    name = var.net.bridge_network_id
  }
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = var.cmd.private_ip
    aliases = [
      var.cmd.hostname
    ]
  }
  ports {
    internal = local.ports.k8s
    external = local.ports.k8s
  }
  ports {
    internal = local.ports.apid
    external = local.ports.apid
  }
  upload {
    file = "/usr/local/etc/haproxy/haproxy.cfg"
    content = templatefile("${path.module}/templates/haproxy.tftpl.cfg", {
      nodes = [
        for node in docker_container.ctrl : {
          name = node.name
          ipv4 = [
            for n in node.networks_advanced : n.ipv4_address if n.name == var.net.private_network_id
          ][0]
        }
      ]
    })
  }
}

resource "random_id" "work" {
  for_each    = var.work
  byte_length = 2
}

resource "docker_container" "work" {
  for_each     = var.work
  name         = join("-", compact([each.value.name, random_id.work[each.key].hex]))
  hostname     = join("-", compact([each.value.name, random_id.work[each.key].hex]))
  image        = each.value.image
  network_mode = "bridge"
  networks_advanced {
    name = var.net.bridge_network_id
  }
  networks_advanced {
    name         = var.net.private_network_id
    ipv4_address = each.key
  }
  env = [
    "PLATFORM=container",
    "USERDATA=${base64encode(data.talos_machine_configuration.work.machine_configuration)}"
  ]
  privileged = true
  security_opts = [
    "seccomp:unconfined"
  ]
  read_only = true
  dynamic "mounts" {
    for_each = local.mounts.tmpfs
    content {
      target = mounts.value
      type   = "tmpfs"
    }
  }
  dynamic "mounts" {
    for_each = local.mounts.volume
    content {
      target = mounts.value
      type   = "volume"
    }
  }
  lifecycle {
    ignore_changes = [
      env,
      security_opts
    ]
  }
}

resource "terraform_data" "deps" {
  input = [
    local.cilium_values,
    local.talos_extra_manifests
  ]
}

resource "talos_machine_configuration_apply" "deps" {
  depends_on = [
    docker_container.cmd,
    docker_container.ctrl
  ]
  client_configuration        = talos_machine_secrets.main.client_configuration
  machine_configuration_input = data.talos_machine_configuration.ctrl.machine_configuration
  node                        = local.boot_node
  endpoint                    = docker_container.cmd.hostname
  config_patches = [
    local.deps_machine_patch
  ]
  lifecycle {
    ignore_changes = [
      machine_configuration_input,
      config_patches
    ]
    replace_triggered_by = [
      terraform_data.deps
    ]
  }
}

resource "talos_machine_bootstrap" "main" {
  depends_on = [
    talos_machine_configuration_apply.deps
  ]
  client_configuration = talos_machine_secrets.main.client_configuration
  node                 = local.boot_node
  endpoint             = docker_container.cmd.hostname
}

resource "terraform_data" "kubeconfig" {
  input = data.talos_cluster_kubeconfig.main.kubeconfig_raw
  lifecycle {
    ignore_changes = [
      input
    ]
    replace_triggered_by = [
      talos_machine_bootstrap.main
    ]
  }
}

resource "terraform_data" "talosconfig" {
  input = replace(data.talos_client_configuration.main.talos_config, var.cmd.private_ip, var.cmd.hostname)
  lifecycle {
    ignore_changes = [
      input
    ]
    replace_triggered_by = [
      talos_machine_bootstrap.main
    ]
  }
}
