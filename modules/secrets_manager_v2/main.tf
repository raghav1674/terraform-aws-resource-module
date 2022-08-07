resource "aws_secretsmanager_secret" "this" {
  count       = length(local.secrets)
  name        = local.secrets[count.index].name
  description = local.secrets[count.index].description
  recovery_window_in_days = 0
  tags        = var.tags
}
