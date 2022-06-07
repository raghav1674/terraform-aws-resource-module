output "name" {
  value = aws_ecr_repository.this.name
}

output "arn" {
  value = aws_ecr_repository.this.arn
}

output "registry_id" {
  value = aws_ecr_repository.this.registry_id
}

output "url" {
  value = aws_ecr_repository.this.repository_url
}
