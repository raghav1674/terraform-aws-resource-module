output "key_arn"{
    value = aws_kms_key.this.arn
}

output "variables" {
    value = [for secret in local.secrets: {name=secret.var_name,value=secret.name}]
}