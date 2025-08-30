# Existing networking
variable "vpc_id" {
  description = "Existing VPC ID (for the security group)"
  type        = string
}
variable "subnet_id" {
  description = "Existing PUBLIC subnet ID (where the EC2 will live)"
  type        = string
}

# EC2 specifics
variable "ami_id" {
  description = "AMI ID to use (must exist in aws_region)"
  type        = string
}
variable "key_name" {
  description = "Existing EC2 key pair name (optional)"
  type        = string
  default     = null
}

# State storage resources (created by Terraform)
variable "s3_bucket_name" {
  description = "S3 bucket name to hold Terraform state (must be globally unique, lowercase)"
  type        = string
}

variable "books_table_name" {
  description = "DynamoDB table name for books (must be unique in your account/region)"
  type        = string
  default     = "books-table"
}
