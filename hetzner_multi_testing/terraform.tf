# Playbook to start Openstack nodes for packstack multi installation
#

# Node-1 configuration
resource "hcloud_server" "node1" {
  name 		= "node1"
  image         = "centos-7"
  server_type   = "cx11"
  ssh_keys      = ["${data.hcloud_ssh_key.centos7-terraform_key.id}"]

# Calling Ansible playbook from Terraform currently commented out and the playbook is called manually 
#  provisioner "local-exec" {
#   command	= "ansible-playbook -i '${hcloud_server.node1.ipv4_address},' --key-file=~/.ssh/terraform_pwless node1.yml -e 'ANSIBLE_HOST_KEY_CHECKING=False'" 
#  }
}

# Node-2 configuration
resource "hcloud_server" "node2" {
  name          = "node2"
  image         = "centos-7"
  server_type   = "cx11"
  ssh_keys      = ["${data.hcloud_ssh_key.centos7-terraform_key.id}"]
}



# Private netwok configuration
resource "hcloud_network" "openstack_network" {
  name          = "openstack-network"
  ip_range      = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "openstack_vlan" {
  network_id    = hcloud_network.openstack_network.id
  network_zone  = "eu-central"
  type          = "server"
  ip_range      = "10.0.2.0/24"
}

resource "hcloud_server_network" "srvnetwork1" {
  server_id     = hcloud_server.node1.id
  network_id    = hcloud_network.openstack_network.id
  ip            = "10.0.2.1"
}

resource "hcloud_server_network" "srvnetwork2" {
  server_id     = hcloud_server.node2.id
  network_id    = hcloud_network.openstack_network.id
  ip            = "10.0.2.2"
}

output "public_ip4_node1" {
  value         = "${hcloud_server.node1.ipv4_address}"
}

output "public_ip4_node2" {
  value         = "${hcloud_server.node2.ipv4_address}"
}


