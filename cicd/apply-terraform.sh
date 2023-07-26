#!/bin/bash

# fail on any error
set -eu

# go back to the previous directory
cd ../terraform-infrastructure/

# initialize terraform
terraform init

# # apply terraform
# terraform apply -auto-approve
terraform plan

# destroy terraform
# terraform destroy -auto-approve