cd ../infra/adguard

# Create Adguard EC2 Instance

terraform init
terraform apply --auto-approve -var-file=$(realpath ../core/core.tfvars)