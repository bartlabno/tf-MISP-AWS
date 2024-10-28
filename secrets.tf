terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}
data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}

resource "random_password" "db_username" {
  length  = 12
  special = false
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "_!%^"
}

resource "random_password" "smtp_username" {
  length  = 12
  special = false
}

resource "random_password" "smtp_password" {
  length           = 32
  special          = true
  override_special = "_!%^"
}

resource "random_password" "misp_salt" {
  length  = 32
  special = false
}

resource "random_password" "encryption_key" {
  length  = 32
  special = false
}

resource "random_uuid" "misp_uuid" {
}

resource "aws_secretsmanager_secret" "security_extras" {
  name        = "${var.environment}/${var.project}/security_extras"
  description = "Security salts required for MISP"
  kms_key_id  = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret" "api_users" {
  name        = "${var.environment}/${var.project}/api_users"
  description = "MISP API users"
  kms_key_id  = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "${var.environment}/${var.project}/db_password"
  description = "Database misp user credentials"
  kms_key_id  = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret" "smtp" {
  name        = "${var.environment}/${var.project}/smtp"
  description = "SMTP credentials"
  kms_key_id  = data.aws_kms_key.secretsmanager.arn
}

resource "aws_secretsmanager_secret_version" "security_extras" {
  secret_id     = aws_secretsmanager_secret.security_extras.id
  secret_string = <<EOF
{
"MISP_UUID": "${random_uuid.misp_uuid.result}"
"SECURITY_SALT": "${random_password.misp_salt.result}"
"SECURITY_ENCRYPTION_KEY": "${random_password.encryption_key.result}"
}
EOF
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = <<EOF
{
"username": "${random_password.db_username.result}
"password": "${random_password.db_password.result}
}
EOF
}

resource "aws_secretsmanager_secret_version" "smtp" {
  secret_id     = aws_secretsmanager_secret.smtp.id
  secret_string = <<EOF
{
"username": "${random_password.smtp_username.result}
"password": "${random_password.smtp_password.result}
}
EOF
}