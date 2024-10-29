output "misp_helper_id" {
  description = "MISP helper ID to access via SSM agent"
  value = aws_instance.misp_helper.id
}

output "misp_helper_ip" {
  value = aws_eip.misp_helper.public_ip
}