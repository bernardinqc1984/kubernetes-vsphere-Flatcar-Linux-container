locals {
  disks = compact(tolist([var.disk_size, var.extra_disk_size == 0 ? "" : var.extra_disk_size]))
  disk_sizes = zipmap(
    range(length(local.disks)),
    local.disks
  )
}

resource "vsphere_virtual_machine" "vm" {
  for_each = var.hostnames_ip_addresses

  name = element(split(".", each.key), 0)

  resource_pool_id = var.resource_pool_id
  datastore_id     = var.datastore_id
  num_cpus         = var.num_cpus
  memory           = var.memory
  guest_id         = var.guest_id
  folder           = var.folder_id
  enable_disk_uuid = "true"

  dynamic "disk" {
    for_each = local.disk_sizes
    content {
      label            = "disk${disk.key}"
      size             = disk.value
      thin_provisioned = var.disk_thin_provisioned
      unit_number      = disk.key
    }
  }

  wait_for_guest_net_timeout  = "0"
  wait_for_guest_net_routable = "false"

  nested_hv_enabled = var.nested_hv_enabled

  network_interface {
    network_id = var.network_id
  }

  //ovf_deploy {
  //  allow_unverified_ssl_cert = false
  //  local_ovf_path = "/terraform/ova/flatcar_production_vmware_ova.ova"
  //  disk_provisioning = "thin"
  //  ip_protocol = "IPV4"
  //  ip_allocation_policy = "STATIC_MANUAL"
  //  ovf_network_map = {
  //    "VM Network"   = var.network_id
  //  }
  //}
  clone {
    template_uuid = var.template_uuid
  }
  vapp {
    properties = {
    "guestinfo.ignition.config.data"           = base64encode(file("${path.cwd}/install.ign"))
    "guestinfo.ignition.config.data.encoding"  = "base64"
    "guestinfo.hostname"                       = "${element(split(".", each.key), 0)}.projetplatform.local",
    "guestinfo.interface.0.role"               = "private"
    "guestinfo.interface.0.name"               = "ens192",
    "guestinfo.interface.0.ip.0.address"       = "${each.value}",
    "guestinfo.interface.0.route.0.gateway"    = "xx.xxx.xx.x",
    "guestinfo.dns.server.0"                   = "xx.xxx.2.11",
    "guestinfo.dns.server.1"                   = "xx.xxx.x.xx",
    "guestinfo.interface.0.route.0.destination" = "0.0.0.0/0"
    "guestinfo.interface.0.dhcp"               = "no"
    //"guestinfo.ntp"                            = "xx.xxx.x.xx",
    //"guestinfo.ssh"                            = "True"
    }
  }
  
}
