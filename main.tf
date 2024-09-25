# Generate random numbers for the bucket name suffix
resource "random_id" "bucket_suffix" {
  byte_length = 4
  keepers = {
    bucket_name = "template-bucket"
  }
}

# Create an S3 bucket with a unique name
resource "aws_s3_bucket" "template_bucket" {
  bucket = "template-${random_id.bucket_suffix.dec}"
  acl    = "private"
}
