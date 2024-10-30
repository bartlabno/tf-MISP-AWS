resource "aws_security_group" "misp_helper" {
  name   = "${var.project}-${var.environment}-helper-allow"
  vpc_id = module.vpc-misp.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.misp_helper.public_ip}/32"]
  }
}

resource "aws_security_group" "misp_allow_https" {
  name   = "${var.project}-${var.environment}-allow-https"
  vpc_id = module.vpc-misp.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }
}

resource "aws_security_group" "misp_allow_internal" {
  name   = "${var.project}-${var.environment}-allow-internal"
  vpc_id = module.vpc-misp.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.block_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.block_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}