locals{
    secrets = jsondecode(file("${path.root}/secrets/${var.env_name}/${var.service_name}.secrets.json")).secrets
}
