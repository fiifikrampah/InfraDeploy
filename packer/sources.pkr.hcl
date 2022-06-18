locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "paceserver" {
  region        = "${var.region}"
  ami_name      = "pace-server-${local.timestamp}"
  instance_type = "${var.instance_type}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  associate_public_ip_address = true
}