# Output VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}


# Output public subnets (IDs and availability zones)
output "public_subnets" {
  description = "The IDs and Availability Zones of the public subnets"
  value       = local.public_subnet
}

# Output private subnets (IDs and availability zones)
output "private_subnets" {
  description = "The IDs and Availability Zones of the private subnets"
  value       = local.private_subnet
}
