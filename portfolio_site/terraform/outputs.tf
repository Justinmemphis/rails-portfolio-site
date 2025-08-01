output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.portfolio_server.public_ip
}