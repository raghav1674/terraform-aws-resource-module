resource "aws_lambda_permission" "this" {
  for_each      = toset(var.lambda_invoke_principals)
  statement_id  = "AllowAccessFromCurrentAccount"
  action        = "lambda:InvokeFunctionUrl"
  function_name = aws_lambda_function.this.function_name
  principal     = each.value
}
