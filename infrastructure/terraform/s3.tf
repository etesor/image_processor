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