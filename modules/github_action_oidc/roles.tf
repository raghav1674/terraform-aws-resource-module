resource "aws_iam_role" "this" {
  name               = var.github_action_role_name
  assume_role_policy = data.aws_iam_policy_document.github_web_identity_trust_policy.json
  inline_policy {
    name = "${var.github_action_role_name}_primary_policy"
    policy = data.aws_iam_policy_document.github_action_primary_policy.json 
  }
  tags = var.tags
}

resource "aws_iam_policy" "this" {
  count       = length(var.github_action_policies)
  name        = var.github_action_policies[count.index].name
  description = var.github_action_policies[count.index].description
  policy      = var.github_action_policies[count.index].policy
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(aws_iam_policy.this)
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[count.index].arn
} 

resource "aws_iam_role_policy_attachment" "already_present_policy_attachment" {
  count      = length(var.already_present_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = var.already_present_policy_arns[count.index]
} 