// ID identifying the cluster to create. Use your username so that resources created can be tracked back to you.
cluster_id = "flatcar-k8s"

// Base domain from which the cluster domain is a subdomain.
base_domain = "projetplatform.local"

// Name of the vSphere server. The dev cluster is on "vcsa.vmware.devcluster.openshift.com".
vsphere_server = "vcst105.projetplatform.local"

// User on the vSphere server.
vsphere_user = "administrator@vsphere.local"

// Password of the user on the vSphere server.
vsphere_password = "MySecretPa55w0rd"

// Name of the vSphere cluster. The dev cluster is "devel".
vsphere_cluster = "cluster01"

// Name of the vSphere data center. The dev cluster is "dc1".
vsphere_datacenter = "dc01"

// Name of the vSphere data store to use for the VMs. The dev cluster uses "nvme-ds1".
vsphere_datastore = ""

// Name of the VM Network for your cluster nodes
vm_network = "vdpg-192.168.100"

// Name of the VM Network for loadbalancer NIC in loadbalancer.
// loadbalancer_network = "vDPortGroup"

// The machine_cidr where IP addresses will be assigned for cluster nodes.
// Additionally, IPAM will assign IPs based on the network ID.
machine_cidr = "192.168.100.0/24"

// The number of control plane VMs to create. Default is 3.
control_plane_count = 3

// The number of compute VMs to create. Default is 3.
compute_count = 3

// The IP addresses to assign to the control plane VMs. The length of this list
// must match the value of control_plane_count.
control_plane_ip_addresses = ["192.168.100.81", "192.168.100.82", "192.168.100.83"]

// The IP addresses to assign to the compute VMs. The length of this list must
// match the value of compute_count.
compute_ip_addresses = ["192.168.100.84", "192.168.100.85", "192.168.100.86"]

// The IP addresses of your DNS servers for your OpenShift nodes
vm_dns_addresses = ["8.8.8.8", "1.1.1.1"]

// The IP address of the default gateway.  If not set, it will use the frist host of the machine_cidr range.
// vm_gateway = "192.168.100.254"


// Set NTP server
// k8s_ntp_server = ""


