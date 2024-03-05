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
    }
  }
}

# TODO: Lambda IaC is WIP
# resource "aws_lambda_function" "image_processor" {
#   function_name = "image_processor"
#   role = "TBD"
  
#   filename = ""
#   description = "This function resized images and store the result in a S3 Bucket."
#   handler = "TBD"
#   layers = "TBD"
#   runtime = "python3.12"

# }

resource "aws_s3_bucket" "origin" {
  bucket = "origin-image-store"
  force_destroy = true
}

resource "aws_s3_bucket" "archive" {
  bucket = "archive-image-store"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "origin" {
  bucket = aws_s3_bucket.origin

  rule {
    id = "cleanup"
    filter {}
    expiration {
      days = 30
    }

    status = "Enabled"
  }
}