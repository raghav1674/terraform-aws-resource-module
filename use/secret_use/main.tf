module "secret_data"{
    source = "../../modules/secret_manager"
    description = "test"
    service_name = "test"
}

output "v"{
    value = module.secret_data.variables
}