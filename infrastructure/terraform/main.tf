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
}


resource "aws_s3_bucket" "origin" {
  bucket = "origin-image-store"
  force_destroy = true

  tags = {
    "project" = "image_processor"
    "owner" = "terraform"
  }
}

resource "aws_s3_bucket" "archive" {
  bucket = "archive-image-store"
  force_destroy = true

  tags = {
    "project" = "image_processor"
    "owner" = "terraform"
  }
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