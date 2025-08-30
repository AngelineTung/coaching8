# EC2-assumable IAM Role
resource "aws_iam_role" "role_example" {
  name = "${local.name_prefix}-iam-role-example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Sid       = ""
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Consolidated permissions for the role
# - ec2:Describe*
# - s3: GetBucketLocation, ListBucket, ListAllMyBuckets (combined)
# - s3: Get/Put/DeleteObject on your bucket
# - dynamodb: ListTables (*)
# - dynamodb: CRUD on the books table
data "aws_iam_policy_document" "policy_example" {
  # EC2 read-only describe
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  # ---- S3 bucket + list perms (combined) ----
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  # S3 object-level permissions (read/write/delete in your bucket)
  # Uses your TF-managed bucket from state.tf
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.tf_state.arn}/*"]   # arn:aws:s3:::<bucket>/*
  }

  # DynamoDB: list all tables
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:ListTables"]
    resources = ["*"]
  }

  # DynamoDB: CRUD on the books table (managed in books.tf)
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:BatchGetItem"
    ]
    resources = [aws_dynamodb_table.books.arn]
  }
}

# Materialize the policy
resource "aws_iam_policy" "policy_example" {
  name   = "${local.name_prefix}-policy-example"
  policy = data.aws_iam_policy_document.policy_example.json
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_example" {
  role       = aws_iam_role.role_example.name
  policy_arn = aws_iam_policy.policy_example.arn
}

# Instance profile (this is what EC2 attaches)
resource "aws_iam_instance_profile" "profile_example" {
  name = "${local.name_prefix}-profile-example"
  role = aws_iam_role.role_example.name
}
