locals {
  file_basename   = split(".", basename(var.filename))[0]
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.root}/${var.filename}"
  output_path = "${path.root}/files/${local.file_basename}.zip"
}

resource "aws_lambda_function" "this" {

  filename         = "${path.root}/files/${local.file_basename}.zip"
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  source_code_hash = filebase64sha256("${path.root}/files/${local.file_basename}.zip")
  runtime          = var.runtime

}
