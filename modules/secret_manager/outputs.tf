output "variables" {
    value = [for secret in local.secrets: {name=secret.var_name,value=secret.name}]
}