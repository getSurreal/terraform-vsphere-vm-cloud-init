terraform {
  required_version = ">= 0.13.4"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 1.25.0"
    }
  }
}