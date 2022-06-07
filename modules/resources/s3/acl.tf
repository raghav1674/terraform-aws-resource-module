resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_policy" "this" {
  count  = length(var.s3_bucket_policies)
  bucket = aws_s3_bucket.this.id
  policy = var.s3_bucket_policies[count.index]
}