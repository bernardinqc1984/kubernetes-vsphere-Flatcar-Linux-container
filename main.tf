locals {
  cluster_domain      = "${var.cluster_id}.${var.base_domain}"
  control_plane_fqdns = [for idx in range(1, var.control_plane_count + 1) : "k8s-master0${idx}.${local.cluster_domain}"]
  compute_fqdns       = [for idx in range(1, var.compute_count + 1) : "k8s-worker0${idx}.${local.cluster_domain}"]
  no_ignition         = ""
  folder_path         = var.vsphere_folder == "" ? var.cluster_id : var.vsphere_folder
  resource_pool_id    = var.vsphere_preexisting_resourcepool ? data.vsphere_resource_pool.resource_pool[0].id : vsphere_resource_pool.resource_pool[0].id
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_resource_pool" "resource_pool" {
  count = var.vsphere_preexisting_resourcepool ? 0 : 1

  name                    = var.vsphere_resource_pool == "" ? var.cluster_id : var.vsphere_resource_pool
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}

data "vsphere_resource_pool" "resource_pool" {
  count = var.vsphere_preexisting_resourcepool ? 1 : 0

  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

//resource "vsphere_folder" "folder" {
//  count = var.vsphere_preexisting_folder ? 0 : 1
//
//  path          = var.vsphere_folder == "" ? var.cluster_id : var.vsphere_folder
//  type          = "vm"
//  datacenter_id = data.vsphere_datacenter.dc.id
//}

module "master01" {

  source = "./modules/master01"

  hostnames_ip_addresses = zipmap(
    local.control_plane_fqdns,
    var.control_plane_ip_addresses
  )

  ignition = local.no_ignition

  resource_pool_id = local.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  network_id       = data.vsphere_network.network.id
  folder_id        = local.folder_path
  //guest_id              = "otherLinux64Guest"
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = local.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.control_plane_num_cpus
  memory        = var.control_plane_memory
  disk_size     = var.control_plane_disk_size
  dns_addresses = var.vm_dns_addresses
  vm_gateway    = var.vm_gateway == null ? cidrhost(var.machine_cidr, 1) : var.vm_gateway
}


module "master02" {

  source = "./modules/master02"

  hostnames_ip_addresses = zipmap(
    local.control_plane_fqdns,
    var.control_plane_ip_addresses
  )

  ignition = local.no_ignition

  resource_pool_id = local.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  network_id       = data.vsphere_network.network.id
  folder_id        = local.folder_path
  //guest_id              = "otherLinux64Guest"
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = local.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.control_plane_num_cpus
  memory        = var.control_plane_memory
  disk_size     = var.control_plane_disk_size
  dns_addresses = var.vm_dns_addresses
  vm_gateway    = var.vm_gateway == null ? cidrhost(var.machine_cidr, 1) : var.vm_gateway
}

module "master03" {

  source = "./modules/master03"

  hostnames_ip_addresses = zipmap(
    local.control_plane_fqdns,
    var.control_plane_ip_addresses
  )

  ignition = local.no_ignition

  resource_pool_id = local.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  network_id       = data.vsphere_network.network.id
  folder_id        = local.folder_path
  //guest_id              = "otherLinux64Guest"
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = local.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.control_plane_num_cpus
  memory        = var.control_plane_memory
  disk_size     = var.control_plane_disk_size
  dns_addresses = var.vm_dns_addresses
  vm_gateway    = var.vm_gateway == null ? cidrhost(var.machine_cidr, 1) : var.vm_gateway
}

module "worker01" {

  source = "./modules/worker01"
  
  hostnames_ip_addresses = zipmap(
    local.compute_fqdns,
    var.compute_ip_addresses
  )

  ignition = local.no_ignition

  resource_pool_id = local.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  network_id       = data.vsphere_network.network.id
  folder_id        = local.folder_path
  //guest_id              = "otherLinux64Guest"
  //disk_thin_provisioned = true
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = local.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.compute_num_cpus
  memory        = var.compute_memory
  disk_size     = var.compute_disk_size
  dns_addresses = var.vm_dns_addresses
  vm_gateway    = var.vm_gateway == null ? cidrhost(var.machine_cidr, 1) : var.vm_gateway
}
module "worker02" {

  source = "./modules/worker02"
  
  hostnames_ip_addresses = zipmap(
    local.compute_fqdns,
    var.compute_ip_addresses
  )

  ignition = local.no_ignition

  resource_pool_id = local.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  network_id       = data.vsphere_network.network.id
  folder_id        = local.folder_path
  //guest_id              = "otherLinux64Guest"
  //disk_thin_provisioned = true
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = local.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.compute_num_cpus
  memory        = var.compute_memory
  disk_size     = var.compute_disk_size
  dns_addresses = var.vm_dns_addresses
  vm_gateway    = var.vm_gateway == null ? cidrhost(var.machine_cidr, 1) : var.vm_gateway
}

module "worker03" {

  source = "./modules/worker03"
  
  hostnames_ip_addresses = zipmap(
    local.compute_fqdns,
    var.compute_ip_addresses
  )

  ignition = local.no_ignition

  resource_pool_id = local.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  datacenter_id    = data.vsphere_datacenter.dc.id
  network_id       = data.vsphere_network.network.id
  folder_id        = local.folder_path
  //guest_id              = "otherLinux64Guest"
  //disk_thin_provisioned = true
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  template_uuid         = data.vsphere_virtual_machine.template.id
  disk_thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned

  cluster_domain = local.cluster_domain
  machine_cidr   = var.machine_cidr

  num_cpus      = var.compute_num_cpus
  memory        = var.compute_memory
  disk_size     = var.compute_disk_size
  dns_addresses = var.vm_dns_addresses
  vm_gateway    = var.vm_gateway == null ? cidrhost(var.machine_cidr, 1) : var.vm_gateway
}
