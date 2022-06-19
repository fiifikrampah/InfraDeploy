output "public_connection_string" {
  description = "Public Server Connection"
  value       = "ssh -i ${module.ssh_key.key_name}.pem ubuntu@${module.ec2.public_ip}"
}

output "private_connection_string" {
  description = "Private Server Connection"
  value       = "ssh -i ~/.ssh/${module.ssh_key.key_name}.pem ubuntu@${module.ec2.private_ip}"
}