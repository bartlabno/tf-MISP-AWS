data "aws_ami" "helper" {
  most_recent = "true"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_iam_role" "misp_ec2_role" {
  name = "${var.project}-${var.environment}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "misp_helper" {
  role       = aws_iam_role.misp_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "misp_profile" {
  name = "${var.project}-${var.environment}-profile"
  role = aws_iam_role.misp_ec2_role.name
}

resource "aws_network_interface" "misp_helper" {
  subnet_id = module.vpc-misp.private_subnets[0]
}

resource "aws_instance" "misp_helper" {
  ami                  = var.environment != "prod" ? data.aws_ami.helper.id : "ami-01f10c2d6bce70d90"
  instance_type        = var.environment != "prod" ? "t2.micro" : "c5.2xlarge"
  iam_instance_profile = aws_iam_instance_profile.misp_profile.id

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.misp_helper.id
  }

  user_data = <<EOF
#!/bin/bash
EOF

  tags = {
    Name = "${var.project}-${var.environment}-misp-helper"
  }
}

resource "aws_eip" "misp_helper" {
  instance = aws_instance.misp_helper.id
}

resource "aws_network_interface_sg_attachment" "misp_helper" {
  network_interface_id = aws_instance.misp_helper.primary_network_interface_id
  security_group_id    = aws_security_group.misp_allow_internal.id
}