variable "datacenter" {
  description = "The name of the datacenter to deploy this virtual machine to."
  type        = string
}

variable "cluster" {
  description = "The name of the cluster to deploy this virtual machine to."
  type        = string
}

variable "datastore" {
  description = "The name of the datastore to deploy this virtual machine to."
  type        = string
}

variable "network" {
  description = "The name of the network to use for this virtual machine."
  type        = string
}

variable "network_type" {
  description = "The network type for each network interface."
  type        = string
  default     = null
}

variable "vapp_properties" {
  description = "The network type for each network interface."
  type        = any
}

variable "vm_template" {
  description = "The name of the template to cone."
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "vm_folder" {
  description = "The name of the folder for this virtual machine."
  type        = string
  default     = ""
}

variable "num_cpus" {
  description = "The number of CPUs for this virtual machine."
  type        = number
  default     = 2
}

variable "cpu_reservation" {
  description = "The amount of CPU (in MHz) guaranteed for this virtual."
  type        = number
  default     = null
}

variable "memory" {
  description = "The amount of memory (in MB) for the virtual machine."
  type        = number
  default     = 4096
}

variable "num_cores_per_socket" {
  description = "The number of cores to distribute among the CPUs in this virtual machine. If specified, the value supplied to num_cpus must be evenly divisible by this value."
  type        = number
  default     = 1
}

variable "cpu_hot_add_enabled" {
  description = "Allow CPUs to be added to this virtual machine while it is running."
  type        = bool
  default     = null
}

variable "cpu_hot_remove_enabled" {
  description = "Allow CPUs to be removed to this virtual machine while it is running."
  type        = bool
  default     = null
}

variable "memory_hot_add_enabled" {
  description = "Allow memory to be added to this virtual machine while it is running."
  type        = bool
  default     = null
}

variable "memory_reservation" {
  description = "The amount of memory (in MB) guaranteed for this virtual machine."
  type        = number
  default     = null
}

variable "scsi_type" {
  description = "Type of scsi controller. acceptable values lsilogic, pvscsi."
  type        = string
  default     = ""
}

variable "enable_disk_uuid" {
  description = "Expose the UUIDs of attached virtual disks to the virtual machine, allowing access to them in the guest."
  type        = bool
  default     = true
}

variable "thin_provisioned" {
  description = "Space for the vmdk disk allocated as needed."
  type        = bool
  default     = true
}

variable "eagerly_scrub" {
  description = "All allocated space for the vmdk is zeroed out.  If enabled, thin provisioned must be false."
  type        = bool
  default     = false
}

variable "disk_sizes" {
  description = "List of disk sizes (in GB) to override for the template disks."
  type        = list(number)
  default     = null
}

variable "additional_disks" {
  description = "Disks to add in addition to the disks in the template."
  type        = map(map(string))
  default     = {}
}
