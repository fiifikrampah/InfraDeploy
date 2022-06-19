// Create aws_ami filter to pick up the most recent packer-generated AMI
data "aws_ami" "custom_ubuntu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["pace-server-*"]
  }
}

// Generate random uid based on timestamp
locals {
  uid = formatdate("YYYYMMDDhhmmss", timestamp())
}

// Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2_public" {
  ami                         = data.aws_ami.custom_ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.vpc.public_subnets[0]
  vpc_security_group_ids      = [var.sg_pub_id]
  tags = {
    "Name" = "${var.namespace}-${local.uid}-EC2-PUBLIC"
  }

  // Copy the ssh key file to home .ssh directory
  provisioner "file" {
    source      = "./${var.key_name}.pem"
    destination = "/home/ubuntu/.ssh/${var.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }
  }
  
  // Set the correct permissions on the ssh key
  provisioner "remote-exec" {
    inline = ["chmod 400 ~/.ssh/${var.key_name}.pem"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }

  }

}

// Configure the EC2 instance in a private subnet
resource "aws_instance" "ec2_private" {
  ami                         = data.aws_ami.custom_ubuntu.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.vpc.private_subnets[1]
  vpc_security_group_ids      = [var.sg_priv_id]

  tags = {
    "Name" = "${var.namespace}-${local.uid}-EC2-PRIVATE"
  }

}