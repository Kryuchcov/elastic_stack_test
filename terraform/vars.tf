variable "aws_region" {
  type      = string
  sensitive = true
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "ec2_settings" {
  type = map(any)
  default = {
    "elastic_ec2" = {
      root_block_device_volume_size = 20
      root_block_device_type        = "gp2"
      ami                           = "ami-0862be96e41dcbf74"
      instance_type                 = "t3a.medium"
    }
  }
}