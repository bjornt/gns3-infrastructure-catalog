variable "gns3_host" {
  type        = string
  description = "IP or hostname of the host where GNS3 should be installed"
}

variable "sonic_image_path" {
  type        = string
  description = "Path to the local SONiC image"
}
