terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
  default_tags {
    tags = {
      "project" = "image_processor"
      "owner" = "terraform"
      "env" = var.environment
    }
  }
}

locals {
  archive_path = "${path.module}/function.zip"
  layer_archive_path = "${path.module}/layer.zip"
}


variable "environment" {
  type = string
  description = "Environment name"
  default = "dev"
}