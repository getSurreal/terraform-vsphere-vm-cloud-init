locals {
  name                 = "ubuntu-vapp"
  num_cpus             = "2"
  num_cores_per_socket = "2"
  memory               = "2048"
  vm_template          = "ubuntu-focal-20.04-cloudimg"
  datastore            = "Datastore-1"
  disk_sizes           = [24]
  domain               = "example.home"
  network              = "192.168.0.0"
  ip_address           = "192.168.0.10"
  netmask              = "24"
  gateway              = "192.168.0.1"
  dns_servers = [
    "192.168.0.2",
    "192.168.0.3"
  ]
  dns_search = [
    "example.com"
  ]
  datacenter = "Datacenter-1"
  cluster    = "Cluster-1"
  vm_folder  = "Dev"

  vapp_properties = {
    "instance-id" = random_uuid.instance.id,
    "hostname"    = local.name,
    "public-keys" = var.authorized_key,
    "user-data"   = base64encode(data.template_file.userdata.rendered)
  }
}

module "vapp" {
  source = "git::https://github.com/getSurreal/terraform-vsphere-vm-cloud-init?ref=0.2.1"

  vm_template = local.vm_template
  datastore   = local.datastore
  network     = local.network
  disk_sizes  = local.disk_sizes

  vm_name              = local.name
  num_cpus             = local.num_cpus
  num_cores_per_socket = local.num_cores_per_socket
  memory               = local.memory
  datacenter           = local.datacenter
  cluster              = local.cluster
  vm_folder            = local.vm_folder
  vapp_properties      = local.vapp_properties
}

data "template_file" "userdata" {
  template = file("${path.module}/userdata.yml.tpl")
  vars = {
    vm_ip_address  = local.ip_address
    vm_netmask     = local.netmask
    vm_gateway     = local.gateway
    vm_dns_servers = join(", ", local.dns_servers)
    vm_dns_search  = join(", ", local.dns_search)
  }
}

resource "random_uuid" "instance" {
}
