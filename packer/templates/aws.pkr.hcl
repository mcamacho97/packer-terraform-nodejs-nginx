packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {

  region = "us-east-1"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners      = ["099720109477"]
  }

  instance_type = "t2.micro"

  ssh_username = "ubuntu"

  ami_name = "packer-node-nginx-{{timestamp}}"

  subnet_id = "subnet-02d0c9e2dbc3d0ba1"
}

build {

  name = "aws-ubuntu"

  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    script = "scripts/install-nodejs.sh"
  }

  provisioner "shell" {
    script = "scripts/install-nginx.sh"
  }

  provisioner "file" {
    source      = "app"
    destination = "/tmp"
  }

  provisioner "file" {
    source      = "systemd/nodeapp.service"
    destination = "/tmp/nodeapp.service"
  }

  provisioner "file" {
    source      = "nginx/default.conf"
    destination = "/tmp/default.conf"
  }

  provisioner "shell" {

    inline = [

      "sudo mkdir -p /opt/nodeapp",

      "sudo cp -R /tmp/app/* /opt/nodeapp/",

      "sudo cp /tmp/nodeapp.service /etc/systemd/system/nodeapp.service",

      "sudo cp /tmp/default.conf /etc/nginx/sites-available/default",

      "sudo systemctl daemon-reload",

      "sudo systemctl enable nodeapp",

      "sudo systemctl start nodeapp",

      "sudo nginx -t",

      "sudo systemctl restart nginx"

    ]
  }

  provisioner "shell" {
    script = "scripts/validate-installation.sh"
  }

  post-processor "manifest" {
    output = "manifest.json"
  }


}