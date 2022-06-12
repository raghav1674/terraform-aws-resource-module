locals {
  subjects = [
    for repo in var.github_repos : "repo:${repo.githubOrg_or_username}/${repo.name}:*"
  ]
}
