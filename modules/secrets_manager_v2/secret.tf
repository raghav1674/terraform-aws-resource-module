resource "aws_secretsmanager_secret_version" "this" {
  count     = length(local.secrets)
  secret_id = aws_secretsmanager_secret.this[count.index].id
  secret_string = coalesce(lookup(local.secrets[count.index], "secret_string", ""),
  jsonencode(lookup(local.secrets[count.index], "secret_kv", "{}")))
}


output "h"{
  value = coalesce(lookup(local.secrets[0], "secret_string", ""),
  jsonencode(lookup(local.secrets[0], "secret_kv", {})))
}
