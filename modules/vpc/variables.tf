variable region {
  description = "Region"
  default     = "europe-west6"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default = ["0.0.0.0/0"]
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable vpc_disk_image {
  description = "Disk image for reddit vpc."
  default = "reddit-vpc-base"
}
