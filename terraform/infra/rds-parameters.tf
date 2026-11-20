# resource "aws_secretsmanager_secret" "rds_connection" {
#   name = "defectdojo/rds-connection"
# }

# resource "aws_secretsmanager_secret_version" "rds_connection" {
#   secret_id = aws_secretsmanager_secret.rds_connection.id

#   secret_string = jsonencode({
#     host     = module.rds.db_address
#     port     = module.rds.db_port
#     database = module.rds.db_name
#   })
# }