cd ../infra/adguard

# Destroy Adguard EC2 Instance

terraform destroy --auto-approve -var-file=$(realpath ../core/core.tfvars)