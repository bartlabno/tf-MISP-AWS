resource "aws_security_group" "misp_helper" {
  name   = "${var.project}-${var.environment}-helper-ssh-allow"
  vpc_id = data.aws_vpc.misp.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.misp_helper.public_ip}/32"]
  }
}

resource "aws_security_group" "misp_allow_https" {
  name   = "${var.project}-${var.environment}-allow-https"
  vpc_id = data.aws_vpc.misp.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }
}

resource "aws_security_group" "misp_allow_internal" {
  name   = "${var.project}-${var.environment}-allow-internal"
  vpc_id = data.aws_vpc.misp.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.misp.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.misp.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}