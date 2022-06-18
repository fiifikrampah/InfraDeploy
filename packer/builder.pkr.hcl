packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

build {
  name = "pace-server"
  source "source.amazon-ebs.paceserver" {
    ssh_username = "ubuntu"
  }
  provisioner "ansible" {
    playbook_file = "ansible/playbook.yml"
    user = "ubuntu"
  }

}