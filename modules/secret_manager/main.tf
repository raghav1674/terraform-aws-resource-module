resource "aws_secretsmanager_secret" "this" {
  count       = length(local.all_secrets)
  name        = local.all_secrets[count.index].name
  description = local.all_secrets[count.index].description
  recovery_window_in_days = 0
  tags        = var.tags
}
