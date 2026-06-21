#!/usr/bin/env bash

set -e

echo "Building AMI..."

cd packer

packer init templates/aws.pkr.hcl
packer build -force templates/aws.pkr.hcl

cd ../terraform

terraform init
terraform apply -auto-approve