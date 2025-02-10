output "aws_instance_public_dns" {
  value       = "http://${aws_lb.nginx.dns_name}"
  description = "public dns value"
}

output "availability_zones_utilized" {
 value = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1]]
 description = "availability zones selected" 
}
