resource "aws_secretsmanager_secret_version" "this" {
  count         = length(local.all_secrets)
  secret_id     = aws_secretsmanager_secret.this[count.index].id
  secret_string = local.all_secrets[count.index].value
}

