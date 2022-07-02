resource "aws_lambda_function_url" "lambda_url" {
  count              = var.create_lambda_url ? 1 : 0
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "AWS_IAM"
  cors {
    allow_credentials = var.allow_credentials
    allow_origins     = var.allow_origins
    allow_methods     = var.allow_methods
    allow_headers     = var.allow_headers
    expose_headers    = var.expose_headers
    max_age           = var.max_age
  }
}

