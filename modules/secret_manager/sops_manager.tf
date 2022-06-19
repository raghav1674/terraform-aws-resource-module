resource "local_file" "this" {
  count = var.create_kms_key ? 1 : 0
  depends_on = [
    aws_kms_key.this
  ]
  content = templatefile("${path.module}/sops.tftpl", {
    kms_arn = aws_kms_key.this[count.index].arn
  })
  filename        = "${path.root}/.sops.yaml"
  file_permission = "0644"
}

locals {
  secrets = jsondecode(file("${path.root}/secrets/${var.service_name}.secrets.json")).secrets
  file_secrets = [for secret in local.secrets :
  { name = secret.name, description = secret.description, value = file("${path.root}/secrets/files/${secret.value}") } if secret.is_file]
  multivalue_secrets = [for secret in local.secrets :
  { name = secret.name, description = secret.description, value = jsonencode(secret.value) } if secret.multivalue]
  simple_secrets = [for secret in local.secrets :
  { name = secret.name, description = secret.description, value = secret.value } if secret.is_file != true && secret.multivalue != true]

  all_secrets = concat(local.file_secrets, local.multivalue_secrets, local.simple_secrets)

}
