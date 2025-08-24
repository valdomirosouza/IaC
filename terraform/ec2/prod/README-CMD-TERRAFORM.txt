terraform init
terraform plan    -var-file="prod.tfvars"
terraform apply   -var-file="prod.tfvars" -auto-approve
terraform destroy -var-file="prod.tfvars" -auto-approve
