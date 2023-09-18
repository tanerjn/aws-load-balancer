packer {
  required_plugins {
    amazon = {
      version = "~> v1.1.4"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "app" {
  ami_name      = "app-{{ timestamp }}"
  instance_type = "t2.small"
  region        = "us-east-1"
  subnet_id     = aws_subnet.public_us_east_1a.id

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"

  tags = {
    Name = "app"
  }
}

build {
  sources = ["source.amazon-ebs.app"]

  provisioner "file" {
    destination = "/tmp"
    source      = "files"
  }

  provisioner "shell" {
    script = "scripts/bootstrap.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/files/app.service /etc/systemd/system/app.service",
      "sudo systemctl start app",
      "sudo systemctl enable app"
    ]
  }

  # Requires inspec to be installed on the host system: https://github.com/inspec/inspec
  # For mac, run "brew install chef/chef/inspec"
  provisioner "inspec" {
    inspec_env_vars = ["CHEF_LICENSE=accept"]
    profile         = "inspec"
    extra_arguments = ["--sudo", "--reporter", "html:/tmp/app-index.html"]
  }
}

