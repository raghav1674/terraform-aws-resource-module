resource "aws_kms_key" "this" {
  count                   = var.create_kms_key ? 1 : 0
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = var.iam_policy
  tags                    = var.tags
}
