# Database outputs
output "database_private_ip" {
  description = "Private IP of the database instance"
  value       = aws_instance.database.private_ip
}

output "database_instance_id" {
  description = "Instance ID of the database"
  value       = aws_instance.database.id
}

# Backend outputs
output "backend_private_ip" {
  description = "Private IP of the backend instance"
  value       = aws_instance.backend.private_ip
}

output "backend_instance_id" {
  description = "Instance ID of the backend"
  value       = aws_instance.backend.id
}

# Frontend outputs
output "frontend_public_ip" {
  description = "Public IP of the frontend instance"
  value       = aws_instance.frontend.public_ip
}

output "frontend_instance_id" {
  description = "Instance ID of the frontend"
  value       = aws_instance.frontend.id
}

