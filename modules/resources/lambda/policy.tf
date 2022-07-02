data "aws_iam_policy_document" "assume_policy" {
  statement {
    sid     = "LambdaTrustPolicy"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role_for_${var.role_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

resource "aws_iam_role_policy" "extra_iam_policies" {
  for_each = {for each_policy in var.lambda_iam_policy_jsons: each_policy.name => each_policy.policy}
  name     = each.key
  role     = aws_iam_role.lambda_role.id
  policy   = each.value
}
