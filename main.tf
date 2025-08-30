locals {
  name_prefix = "angeline-iam"
}

# ---------- Security Group (SSH from anywhere) ----------
resource "aws_security_group" "ec2_ssh" {
  name        = "${local.name_prefix}-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name_prefix}-sg" }
}

# ---------- EC2 instance ----------
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_ssh.id]
  associate_public_ip_address = true  # requires the subnet to be public

  # Attach the instance profile created in iam.tf
  iam_instance_profile = aws_iam_instance_profile.profile_example.name

  key_name = var.key_name

  tags = { Name = "${local.name_prefix}-ec2-public" }
}

