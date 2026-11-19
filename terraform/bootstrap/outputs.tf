output "state_bucket_name" {
  description = "Name of the Terraform remote state bucket"
  value       = module.s3.state_bucket_name
}