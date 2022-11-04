# terraform {
#   backend "s3" {
#     bucket         = "bambuk"
#     key            = "global/s3/terraform.tfstate"
#     region         = "eu-central-1"
#     encrypt        = true
#     dynamodb_table = "dynamoDb"
#     #role_arn       = "arn:aws:iam::<AWS_ACCOUNT_ID_OF_BACKEND>:role/terraform-backend"
#   }
# }