variable "aws_account_id" {
  type        = string
  description = "The AWS account ID where the OIDC provider lives"
}

variable "thumbprint_list" {
  type = list(string)
  description = "the github hex-encoded SHA-1 hash value of the X.509 certificate used by the domain where the OpenID Connect provider makes its keys available."
  # https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
  default = [ "6938fd4d98bab03faadb97b34396831e3780aea1" ]
}

variable "github_repos" {
  type = list(object({
    githubOrg_or_username = string
    name                  = string
  }))
  description = "List of github repositories which should be allowed via this role"
}

variable "github_action_role_name" {
  type        = string
  description = "Name of the role for github action"
}

variable "github_action_policies" {
  type = list(object({
    name        = string
    description = string
    policy      = string
  }))
  description = "List of policies to attach to the github action role"
  default     = []
}

variable "already_present_policy_arns" {
  type = list(string)
  description = "List of the already present policies to attach to the github action role"
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Tag for all resources"
  default     = {}
}

