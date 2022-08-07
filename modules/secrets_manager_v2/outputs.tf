output "secret_data" {
    value = local.secrets
    sensitive = true
}