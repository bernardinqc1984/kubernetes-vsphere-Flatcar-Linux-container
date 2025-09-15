//////
//vSphere variables
//////

variable "vsphere_server" {
  type        = string
  description = "This is the vSphere server for the environment"
}

variable "vsphere_user" {
  type        = string
  description = "vSphere server user for the environment"
}

variable "vsphere_password" {
  type        = string
  description = "This the vSphere user password"
}

variable "vsphere_cluster" {
  type        = string
  description = "This the name of the vSphere cluster"
}

variable "vsphere_datacenter" {
  type        = string
  description = "This is the name of the vSphere data center."
}

variable "vm_template" {
  type        = string
  description = "This is the name of the VM template to clone."
}

variable "vsphere_datastore" {
  type        = string
  description = "This is the name of the vSphere data store."
}

//variable "vm_template" {
//  type        = string
//  description = "This is the name of the VM template to clone."
//}

//variable "template_uuid" {
//  description = "The UUID of the template to use for the VM"
//  type        = string
//}

variable "vm_network" {
  type        = string
  description = "This is the name of the publicly accessible network for cluster ingress and access."
  default     = "VM Network"
}

variable "vm_dns_addresses" {
  type        = list(string)
  description = "List of DNS servers to use for your OpenShift Nodes"
  default     = ["xxx.xxx.x.xx", "xxx.xxx.x.xx"]
}

variable "vm_gateway" {
  type        = string
  description = "IP Address to use for VM default gateway.  If not set, default is the first host in the CIDR range"
  default     = "xxx.xxx.xx.x"
}

/////////
// Extra config
/////////


//variable "kubernetes_cluster_cidr" {
//  type = string
//}

//variable "kubernetes_service_cidr" {
//  type = string
//}

//variable "flatcar_version" {
//  type        = string
//  description = "Specify the Flatcar Container Linux version that you would like to deploy."
//}

///////////
// control-plane machine variables
///////////

variable "control_plane_count" {
  type    = string
  default = "3"
}

variable "control_plane_ip_addresses" {
  type    = list(string)
  default = []
}
variable "control_plane_memory" {
  type    = string
  default = "16384"
}

variable "control_plane_num_cpus" {
  type    = string
  default = "6"
}

variable "control_plane_disk_size" {
  type    = number
  default = 100
}

//////////
// compute machine variables
//////////


variable "compute_count" {
  type    = string
  default = "3"
}

variable "compute_ip_addresses" {
  type    = list(string)
  default = []
}

variable "compute_memory" {
  type    = string
  default = "32768"
}

variable "compute_num_cpus" {
  type    = string
  default = "8"
}

variable "compute_disk_size" {
  type    = number
  default = 100
}

variable "ssh_public_key" {
  type        = string
  description = "Path to your ssh public key.  If left blank we will generate one."
  default     = ""
}


variable "vsphere_preexisting_folder" {
  type        = bool
  description = "If false, creates a top-level folder with the name from vsphere_folder_rel_path."
  default     = false
}

variable "vsphere_folder" {
  type        = string
  description = "The relative path to the folder which should be used or created for VMs."
  default     = ""
}

variable "vsphere_preexisting_resourcepool" {
  description = "If false, creates a resource pool for OpenShift nodes."
  default     = false
}

variable "vsphere_resource_pool" {
  type        = string
  description = "The resource pool that should be used or created for VMs"
  default     = ""
}

variable "k8s_ntp_server" {
  type    = string
  default = ""
}

/////////
// Kubernetes cluster variables
/////////

variable "cluster_id" {
  type        = string
  description = "This cluster id must be of max length 27 and must have only alphanumeric or hyphen characters."
}

variable "base_domain" {
  type        = string
  description = "The base DNS zone to add the sub zone to."
}

variable "machine_cidr" {
  type = string
}
