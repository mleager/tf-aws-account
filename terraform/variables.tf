variable "project_name" {
  type        = string
  default     = "tf-s3-global-state"
  description = "Name of the Terraform project"
}

variable "environment" {
  type        = string
  default     = "development"
  description = "The environment name (development, staging, production)"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region of the S3 bucket and DynamoDB table"
}

variable "bucket" {
  type        = string
  default     = "tf-state-8864"
  description = "The name of the S3 bucket"
}

# variable "dynamodb" {
#   type = map(string)
#   default = {
#     table_name  = "tf-state-lock"
#     primary_key = "terraform.tfstate"
#     sort_key    = "timestamp"
#   }
#   description = "DynamoDB table configuration (table_name, primary_key, sort_key)"
# }

