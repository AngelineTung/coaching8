terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# set your default region here (change if needed)
variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

provider "aws" {
  region = var.aws_region
}
