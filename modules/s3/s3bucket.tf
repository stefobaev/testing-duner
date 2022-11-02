resource "aws_s3_bucket" "duneritesnipichki69sexbogguru" {
  bucket = "duneritesnipichki69sexbogguru"

  tags = {
    Name        = "My bucket"
    Environment = "Demo"
  }
}

resource "aws_s3_bucket_acl" "aclduneritesnipichki" {
  bucket = aws_s3_bucket.duneritesnipichki69sexbogguru.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioningduneritesnipichki" {
  bucket = aws_s3_bucket.duneritesnipichki69sexbogguru.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamoDbTreti" {
  name             = "dynamoDbTreti"
  hash_key         = "id"
  #billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "id"
    type = "S"
  }
  tags = {
    "Name" = "dynamoDb"
  }
}