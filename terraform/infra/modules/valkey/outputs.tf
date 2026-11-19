output "valkey_endpoint_arn" {
  value = aws_ssm_parameter.valkey_endpoint.arn
}