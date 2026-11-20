output "db_address" {
  value       = aws_db_instance.postgresql.address
}

output "master_secret_arn" {
  value       = aws_db_instance.postgresql.master_user_secret[0].secret_arn
}

output "db_name" {
  value = aws_db_instance.postgresql.db_name
}
