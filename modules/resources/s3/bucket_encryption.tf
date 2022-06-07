resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enable_bucket_encryption ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}