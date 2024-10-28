data "aws_kms_key" "ecr" {
  key_id = "alias/aws/ecr"
}

resource "aws_ecr_repository" "misp" {
  name                 = "misp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = data.aws_kms_key.ecr.arn
  }
}