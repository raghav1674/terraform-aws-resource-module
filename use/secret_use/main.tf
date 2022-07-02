module "secret_data"{
    source = "../../modules/secret_manager"
    description = "test"
    service_name = "test"
    create_kms_key = true
}

output "v"{
    value = module.secret_data.variables
}