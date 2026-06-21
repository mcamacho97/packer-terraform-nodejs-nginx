packer {
  required_plugins {
    azure = {
      version = ">= 2.3.0"
      source  = "github.com/hashicorp/azure"
    }
  }
}

source "azure-arm" "ubuntu" {

  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  managed_image_resource_group_name = "packer-images-rg"
  managed_image_name                = "node-nginx-image-{{timestamp}}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "server"
  location        = "East US"

  vm_size = "Standard_B1s"
}

build {

  name = "azure-ubuntu"

  sources = [
    "source.azure-arm.ubuntu"
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
    output = "manifest-azure.json"
  }

}