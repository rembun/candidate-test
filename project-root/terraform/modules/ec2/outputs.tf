output "jumpbox_public_ip" {
  description = "Public IP of the jumpbox instance"
  value       = aws_instance.jumpbox.public_ip
}

output "worker_private_ips" {
  description = "Private IPs of worker nodes"
  value       = aws_instance.nodes[*].private_ip
}

