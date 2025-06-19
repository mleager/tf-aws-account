resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket

  tags = {
    Global = "true"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_dynamodb_table" "tf_state_lock" {
#   name           = var.dynamodb.table_name
#   billing_mode   = "PROVISIONED"
#   hash_key       = "LockID"
#   read_capacity  = 5
#   write_capacity = 5
#
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

