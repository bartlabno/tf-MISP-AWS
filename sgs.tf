resource "aws_security_group" "misp_helper" {
  name   = "${var.project}-${var.environment}-helper-ssh-allow"
  vpc_id = data.aws_vpc.misp.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface_sg_attachment" "misp_helper" {
  network_interface_id = aws_instance.misp_helper.primary_network_interface_id
  security_group_id    = aws_security_group.misp_helper.id
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