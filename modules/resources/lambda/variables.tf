variable "filename" {
    type = string
    description = "Path of the file"
}

variable "function_name" {
    type = string
    description = "Name of the function"
}

variable "handler" {
    type = string
    description = "Handler function"
}

variable "runtime" {
    type = string
    description = "Which language"
}

variable "lambda_iam_policy_jsons" {
    type = list(object({
        name = string 
        policy = string 
    }))
    description = "(optional) describe your variable"
    default = []
}

variable "allow_credentials" {
    type = bool 
    default = false
}

variable "allow_origins" {
    type = list(string)
    default = ["*"]
}

variable "allow_methods" {
    type = list(string)
    default = ["*"]
}

variable "allow_headers" {
    type = list(string)
    default = null
}

variable "expose_headers" {
    type = list(string)
    default = null
}
variable "max_age" {
    type = number 
    default = 86400
}

variable "role_name" {
    type = string
    description = "Name of the lambda role"
}

variable "lambda_invoke_principals" {
    type = list(string)
    description = "Who should be allowed to invoke function url"
    default = []
}

variable "create_lambda_url" {
    type = bool
    description = "Whether to create lambda url or not"
    default = false
}