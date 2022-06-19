terraform {
  required_version = ">= 1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}