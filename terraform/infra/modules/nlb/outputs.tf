output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
}

output "nlb_zone_id" {
  value = aws_lb.nlb.zone_id
}

output "http_tg_arn" {
  value = aws_lb_target_group.nlb_http_tg.arn
}

output "https_tg_arn" {
  value = aws_lb_target_group.nlb_tg_https.arn
}