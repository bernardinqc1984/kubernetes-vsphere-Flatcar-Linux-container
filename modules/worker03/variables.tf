variable "hostnames_ip_addresses" {
  type = map(string)
}

variable "ignition" {
  type    = string
  default = ""
}

variable "disk_thin_provisioned" {
  type = bool
  default = true
}

variable "template_uuid" {
  description = "The UUID of the template to use for the VM"
  type = string
}

variable "guest_id" {
  type = string
}

variable "resource_pool_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "datastore_id" {
  type = string
}

variable "network_id" {
  type = string
}

variable "cluster_domain" {
  type = string
}

variable "datacenter_id" {
  type = string
}

variable "machine_cidr" {
  type = string
}

variable "memory" {
  type = string
}

variable "num_cpus" {
  type = string
}

variable "dns_addresses" {
  type = list(string)
}


variable "disk_size" {
  type    = number
  default = 100
}

variable "extra_disk_size" {
  type    = number
  default = 0
}

variable "nested_hv_enabled" {
  type    = bool
  default = false
}

variable "vm_gateway" {
  type    = string
  default = "xx.xxx.xx.x"
}
