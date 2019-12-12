# Playbook for Ubuntu single node testing


# Node-1 configuration
resource "hcloud_server" "node1" {
  name 		= "node1"
  image         = "ubuntu-18.04"
  server_type   = "cx31"
  ssh_keys      = ["${data.hcloud_ssh_key.centos7-terraform_key.id}"]

}

# Private netwok configuration - Management network
resource "hcloud_network" "openstack_man_network" {
  name          = "openstack-man-network"
  ip_range      = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "openstack_man_vlan1" {
  network_id    = hcloud_network.openstack_man_network.id
  network_zone  = "eu-central"
  type          = "server"
  ip_range      = "10.0.2.0/24"
}

resource "hcloud_server_network" "srvnetwork1" {
  server_id     = hcloud_server.node1.id
  network_id    = hcloud_network.openstack_man_network.id
  ip            = "10.0.2.1"
}


# Private netwok configuration - Tenant network
resource "hcloud_network" "openstack_ten_network" {
  name          = "openstack-ten-network"
  ip_range      = "192.168.0.0/16"
}

resource "hcloud_network_subnet" "openstack_ten_vlan1" {
  network_id    = hcloud_network.openstack_ten_network.id
  network_zone  = "eu-central"
  type          = "server"
  ip_range      = "192.168.10.0/24"
}

resource "hcloud_server_network" "srvnetwork3" {
  server_id     = hcloud_server.node1.id
  network_id    = hcloud_network.openstack_ten_network.id
  ip            = "192.168.10.1"
}


output "public_ip4_node1" {
  value         = "${hcloud_server.node1.ipv4_address}"
}


