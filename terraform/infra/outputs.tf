output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "http_tg_arn" {
  value       = module.nlb.http_tg_arn
}

output "https_tg_arn" {
  value       = module.nlb.https_tg_arn
}