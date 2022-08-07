config {
    module = true
    force = false
    disabled_by_default = false
}
 
plugin "aws" {
    enabled = true
    version = "0.15.0"
    source = "github.com/terraform-linters/tflint-ruleset-aws"
}
 
rule "aws_instance_invalid_type" { enabled = false }

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_standard_module_structure" {
enabled = true
}