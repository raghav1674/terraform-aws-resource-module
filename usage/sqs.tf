module "sqs" {
  source                  = "../resources/sqs/standard"
  name                    = "testqueue"
  sqs_managed_sse_enabled = true
  environment             = "dev"
  queue_iam_access_policy = <<EOT
    {
        "Version": "2008-10-17",
        "Id": "__default_policy_ID",
        "Statement": [
            {
            "Sid": "__owner_statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "SQS:*"
            ],
            "Resource": "*"
            }
        ]
    }
EOT
}
