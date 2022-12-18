data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  count         = var.content_library == null ? 1 : 0
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_content_library" "library" {
  count      = var.content_library != null ? 1 : 0
  name       = var.content_library
  depends_on = [var.tag_depends_on]
}

data "vsphere_content_library_item" "library_item_template" {
  count      = var.content_library != null ? 1 : 0
  library_id = data.vsphere_content_library.library.id[0]
  type       = "ovf"
  name       = var.vm_template
  depends_on = [var.tag_depends_on]
}

data "vsphere_resource_pool" "pool" {
  count         = var.vmrp != null ? 1 : 0
  name          = var.vmrp
  datacenter_id = data.vsphere_datacenter.dc.id
}

locals {
  template_disk_count = length(data.vsphere_virtual_machine.template.disks[0])
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = var.vmrp != null ? data.vsphere_resource_pool.pool.id : data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder

  num_cpus               = var.num_cpus
  num_cores_per_socket   = var.num_cores_per_socket
  cpu_hot_add_enabled    = var.cpu_hot_add_enabled
  cpu_hot_remove_enabled = var.cpu_hot_remove_enabled
  cpu_reservation        = var.cpu_reservation
  memory_reservation     = var.memory_reservation
  memory                 = var.memory
  memory_hot_add_enabled = var.memory_hot_add_enabled

  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = var.scsi_type != "" ? var.scsi_type : data.vsphere_virtual_machine.template.scsi_type
  enable_disk_uuid = var.enable_disk_uuid

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = var.network_type != null ? var.network_type : data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  # Template disks
  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template.disks
    iterator = template_disks
    content {
      label            = "disk${template_disks.key}"
      size             = var.disk_sizes != null ? var.disk_sizes[template_disks.key] : data.vsphere_virtual_machine.template.disks[template_disks.key].size
      thin_provisioned = var.thin_provisioned ? var.thin_provisioned : data.vsphere_virtual_machine.template.disks[template_disks.key].thin_provisioned
      eagerly_scrub    = var.eagerly_scrub ? var.eagerly_scrub : data.vsphere_virtual_machine.template.disks[template_disks.key].eagerly_scrub
    }
  }

  # Additional disks
  dynamic "disk" {
    for_each = var.additional_disks
    iterator = additional_disks
    content {
      label            = additional_disks.key
      unit_number      = index(keys(var.additional_disks), additional_disks.key) + local.template_disk_count
      size             = lookup(additional_disks.value, "size_gb", null)
      thin_provisioned = lookup(additional_disks.value, "thin_provisioned", "true")
      eagerly_scrub    = lookup(additional_disks.value, "eagerly_scrub", "false")
      datastore_id     = lookup(additional_disks.value, "datastore_id", null)
    }
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = var.content_library == null ? data.vsphere_virtual_machine.template.id : data.vsphere_content_library_item.library_item_template.id
  }

  vapp {
    properties = var.vapp_properties
  }
}
