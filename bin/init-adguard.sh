cd ../infra/adguard

# Create Adguard EC2 Instance

echo $VAR_FILE_PATH

terraform init
terraform apply --auto-approve -var-file=$(realpath ../core/core.tfvars)