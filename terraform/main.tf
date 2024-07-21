################################################################################################
# GENERAL SETTINGS #
################################################################################################
# Terraform settings
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
  required_version = "~> 1.9.0"
}

# cloud provider settings
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}