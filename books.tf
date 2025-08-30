resource "aws_dynamodb_table" "books" {
  name         = var.books_table_name
  billing_mode = "PAY_PER_REQUEST"

  # Primary key: ISBN (partition), Genre (sort)
  hash_key  = "ISBN"
  range_key = "Genre"

  attribute {
    name = "ISBN"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }

  tags = {
    Name = "books"
  }
}
