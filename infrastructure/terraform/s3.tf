locals { // Locals usage
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
