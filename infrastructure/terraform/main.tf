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

locals {
  archive_path = "${path.module}/function.zip"
}

data "archive_file" "function" {
  type = "zip"

  source_dir = "../../${path.module}/function"
  output_path = local.archive_path
}

resource "aws_lambda_function" "image_processor" {
  function_name = "image_processor"
  role = aws_iam_role.lambda_exec.arn
  
  filename = local.archive_path
  description = "This function resized images and store the result in a S3 Bucket."
  handler = "lambda_function.lambda_handler"
  # layers = "TBD"
  runtime = "python3.10"
  source_code_hash = data.archive_file.function.output_base64sha256

}

resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${aws_lambda_function.image_processor.function_name}"

  retention_in_days = 5
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

resource "aws_s3_bucket" "origin" {
  bucket = "origin-image-store"
  force_destroy = true
}

resource "aws_s3_bucket" "archive" {
  bucket = "archive-image-store"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "origin" {
  bucket = aws_s3_bucket.origin.id

  rule {
    id = "cleanup"
    filter {}
    expiration {
      days = 30
    }

    status = "Enabled"
  }
}
