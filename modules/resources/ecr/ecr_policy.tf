resource "aws_ecr_repository_policy" "this" {
  count      = var.create_ecr_repository_policy ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = var.aws_ecr_repository_policy_document
}
