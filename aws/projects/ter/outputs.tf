output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "load_balancer_dns" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.cyber_lb.dns_name
}

output "jenkins_url" {
  description = "The URL to access Jenkins"
  value       = "http://${aws_lb.cyber_lb.dns_name}:8080"
} 