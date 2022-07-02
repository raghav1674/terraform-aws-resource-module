data "aws_iam_policy" "basic_execution_role" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_caller_identity" "current" {}

module "lambda" {
  role_name = "test-role"
  source        = "../../modules/resources/lambda"
  filename      = "my.py"
  function_name = "handler_function"
  handler       = "my.handler"
  runtime       = "python3.8"
  lambda_iam_policy_jsons = [
    {
        name = "basic_execution_role"
        policy = data.aws_iam_policy.basic_execution_role.policy
    }
  ]
}
