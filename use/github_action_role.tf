data "aws_caller_identity" "current" {}

module "github_action_oidc" {
  source                  = "../modules/github_action_oidc"
  aws_account_id          = data.aws_caller_identity.current.account_id
  github_repos            = [{ githubOrg_or_username = "", name = "" }]
  github_action_role_name = "github-action-role-tf"
  tags = {
    "Terraform" = true
  }
}
