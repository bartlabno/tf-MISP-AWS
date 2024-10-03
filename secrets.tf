data "aws_kms_key" "secretsmanager" {
    key_id = "alias/aws/secretsmanager"
}

resource "aws_secretsmanager_secret" "security_extras" {
    name = "${var.environment}/${var.project}/security_extras"
    description = "Security salts required for MISP"
    kms_key_id = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret" "api_users" {
    name = "${var.environment}/${var.project}/api_users"
    description = "MISP API users"
    kms_key_id = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret" "smtp_credentials" {
    name = "${var.environment}/${var.project}/smtp_credentials"
    description = "Credentials for MISP SMTP server"
    kms_key_id = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret" "redis_admin" {
    name = "${var.environment}/${var.project}/redis_admin"
    description = "Redis misp user credentials"
    kms_key_id = data.aws_kms_key.secretsmanager.arn
}