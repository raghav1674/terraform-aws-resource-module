locals {

  filename = var.local_existing_package != null ? var.local_existing_package : null

  s3_bucket         = var.s3_existing_package != null ? var.s3_existing_package.bucket : null
  s3_key            = var.s3_existing_package != null ? var.s3_existing_package.key : null
  s3_object_version = ar.s3_existing_package != null ? var.s3_existing_package.version_id : null

}