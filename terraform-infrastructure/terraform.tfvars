# environment variables
region       = "us-east-1"
project_name = "Rib-Demo"
environment  = "dev"

# vpc environment
vpc_cidr                     = "192.168.0.0/20"
public_subnet_az1_cidr       = "192.168.1.0/24"
public_subnet_az2_cidr       = "192.168.2.0/24"
private_app_subnet_az1_cidr  = "192.168.3.0/24"
private_app_subnet_az2_cidr  = "192.168.4.0/24"


# ssh environment
ssh_ip = "0.0.0.0/0"

# acm variables
domain_name       = "fredbitenyo.link"
alternative_names = "*.fredbitenyo.link"

# s3 variables
env_file_bucket_name = "s3-terraform-for-dynamic-web-test-drive"
env_filename         = "rentzone.env"

# ecs variables
container_image  = "763544978374.dkr.ecr.us-east-1.amazonaws.com/angular"
cpu_architecture = "X86_64"

# route-53 variables
record_name = "www"