locals {
  postfix = "image-store"
}

resource "aws_s3_bucket" "origin" { // terraform resource id
  bucket = "origin-${local.postfix}"
  force_destroy = true
}

resource "aws_s3_bucket" "archive" {
  bucket = "archive-${local.postfix}"
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

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.origin.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events = [ "s3:ObjectCreated:Put" ]

  }
  depends_on = [ aws_lambda_permission.allow_bucket ]
}