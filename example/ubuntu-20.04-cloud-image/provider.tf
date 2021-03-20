provider "vsphere" {
  user           = "fill"
  password       = "fill"
  vsphere_server = "fill"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}