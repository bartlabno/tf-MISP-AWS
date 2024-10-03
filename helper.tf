data "aws_ami" "helper" {
    most_recent = "true"
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["al2023-ami-2023.*-x86_64"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}

resource "aws_instance" "misp_helper" {
    ami           = "ami-01f10c2d6bce70d90"
    # ami           = data.aws_ami.helper.id
    instance_type = "c5.2xlarge"

    tags = {
        Name = "misp-helper"
    }
}

# resource "aws_eip" "helper" {
#   associate_with_private_ip = "10.30.2.28"
#   network_interface = ""
#   instance = aws_instance.misp_helper.id
#   domain   = "vpc"
# }

