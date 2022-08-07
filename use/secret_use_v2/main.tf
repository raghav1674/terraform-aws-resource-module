module "secret_data" {
  source       = "../../modules/secrets_manager_v2"
  description  = "test"
  service_name = "test"
}

