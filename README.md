# terraform-vsphere-vm-cloud-init

![Terraform Version](https://img.shields.io/badge/Terraform-0.13.5-green.svg) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Deploy cloud images to vCenter using cloud-init userdata.

This module is designed to work with the OVA versions of [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/) or other vApp images.

## Information

The common vSphere customiztions conflict with vApp deployments and are not used.  vApp customiztions are used to pass configuration to the VM.

## Additional Disks Example

```hcl
  additional_disks = {
    disk1 = {
      size_gb          = 10,
      thin_provisioned = false,
      eagerly_scrub    = true
      datastore_id     = "datastore-20273"
    },
    disk2 = {
      size_gb          = 10,
      thin_provisioned = true,
      eagerly_scrub    = true
    }
  }
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.4 |
| vsphere | >= 1.25.0 |

## Providers

| Name | Version |
|------|---------|
| vsphere | >= 1.25.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [vsphere_compute_cluster](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/compute_cluster) |
| [vsphere_datacenter](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) |
| [vsphere_datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) |
| [vsphere_network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) |
| [vsphere_virtual_machine](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/virtual_machine) |
| [vsphere_virtual_machine](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_disks | Disks to add in addition to the disks in the template. | `map(map(string))` | `{}` | no |
| cluster | The name of the cluster to deploy this virtual machine to. | `string` | n/a | yes |
| cpu\_hot\_add\_enabled | Allow CPUs to be added to this virtual machine while it is running. | `bool` | `null` | no |
| cpu\_hot\_remove\_enabled | Allow CPUs to be removed to this virtual machine while it is running. | `bool` | `null` | no |
| cpu\_reservation | The amount of CPU (in MHz) guaranteed for this virtual. | `number` | `null` | no |
| datacenter | The name of the datacenter to deploy this virtual machine to. | `string` | n/a | yes |
| datastore | The name of the datastore to deploy this virtual machine to. | `string` | n/a | yes |
| disk\_sizes | List of disk sizes (in GB) to override for the template disks. | `list(number)` | `null` | no |
| eagerly\_scrub | All allocated space for the vmdk is zeroed out.  If enabled, thin provisioned must be false. | `bool` | `false` | no |
| enable\_disk\_uuid | Expose the UUIDs of attached virtual disks to the virtual machine, allowing access to them in the guest. | `bool` | `true` | no |
| memory | The amount of memory (in MB) for the virtual machine. | `number` | `4096` | no |
| memory\_hot\_add\_enabled | Allow memory to be added to this virtual machine while it is running. | `bool` | `null` | no |
| memory\_reservation | The amount of memory (in MB) guaranteed for this virtual machine. | `number` | `null` | no |
| network | The name of the network to use for this virtual machine. | `string` | n/a | yes |
| network\_type | The network type for each network interface. | `string` | `null` | no |
| num\_cores\_per\_socket | The number of cores to distribute among the CPUs in this virtual machine. If specified, the value supplied to num\_cpus must be evenly divisible by this value. | `number` | `1` | no |
| num\_cpus | The number of CPUs for this virtual machine. | `number` | `2` | no |
| scsi\_type | Type of scsi controller. acceptable values lsilogic, pvscsi. | `string` | `""` | no |
| thin\_provisioned | Space for the vmdk disk allocated as needed. | `bool` | `true` | no |
| vapp\_properties | The network type for each network interface. | `any` | n/a | yes |
| vm\_folder | The name of the folder for this virtual machine. | `string` | `""` | no |
| vm\_name | The name of the virtual machine. | `string` | n/a | yes |
| vm\_template | The name of the template to cone. | `string` | n/a | yes |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

[MIT](LICENSE)