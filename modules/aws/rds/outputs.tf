output "sg_id" {
  value = aws_security_group.sg.id
}

output "arn" {
  value = aws_db_instance.rds.arn
}

output "parameter_group_name" {
  value = aws_db_parameter_group.rds-parameters.name
}


output "address" {
  value = aws_db_instance.rds.address
}

output "kms_key_arn" {
  value = try(aws_kms_key.rds[0].arn, null)
}
