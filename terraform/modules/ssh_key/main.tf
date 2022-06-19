// Generate the SSH keypair to be used in configuring the EC2 instance. 
// Write the private key to a local file and upload the public key to AWS

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

// Generate random uid based on timestamp
locals {
  uid = formatdate("YYYYMMDDhhmmss", timestamp())
}

resource "local_sensitive_file" "private_key" {
  filename        = "${var.namespace}-${local.uid}-key.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.namespace}-${local.uid}-key"
  public_key = tls_private_key.key.public_key_openssh
}