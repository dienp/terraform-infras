cd ../infra/core

# Create S3 Bucket for Terraform backend
TF_BACKEND_S3_BUCKET=c8d3f7f6-4a9e-4c05-9ec3-f0612f81bb19 ./create-s3-bucket.sh

terraform init
terraform apply --auto-approve -var-file="core.tfvars"