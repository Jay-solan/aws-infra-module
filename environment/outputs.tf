# alb
output "ALB_DNS" {
  description = "DNS of the ALB"
  value = module.alb.lb_dns_name
}

# vpc

output "private_subnets" {
  description = "List of private subnets"
  value = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnets"
  value = module.vpc.public_subnets
}