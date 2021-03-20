resource "random_uuid" "instance" {
}

data "template_file" "userdata" {
  template = file("${path.module}/userdata.yml.tpl")
  vars = {
    vm_ip_address  = "192.168.0.21"
    vm_netmask     = "24"
    vm_gateway     = "192.168.0.1"
    vm_dns_servers = join(", ", ["192.168.0.2", "192.168.0.3"])
    vm_dns_search  = join(", ", ["example.com"])
  }
}

locals {
  name = "module"
  vapp_properties = {
    "instance-id" = random_uuid.instance.id,
    "hostname"    = local.name,
    "public-keys" = var.authorized_key,
    "user-data"   = base64encode(data.template_file.userdata.rendered)
  }
}

module "vapp" {
  source          = "git::https://github.com/getSurreal/terraform-vsphere-vm-cloud-init?ref=0.1.0"
  vm_template     = "ubuntu-focal-20.04-cloudimg"
  vm_name         = local.name
  datacenter      = "Datacenter"
  cluster         = "Cluster"
  datastore       = "Datastore"
  network         = "192.168.0.x"
  vapp_properties = local.vapp_properties
}
