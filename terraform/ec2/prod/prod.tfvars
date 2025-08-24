
# -----------------
# AWS REGION
# -----------------
aws_region         = "us-east-1"

# -----------------
# VPC & SECURITY GROUP (Exemplo: poderiam ser IDs de produção)
# -----------------
vpc_id             = "vpc-018a1426cd5d1bc71"
security_group_id  = "sg-03d77403a66206ac1"

# -----------------
# EC2 Instance (Exemplo: tipo de instância maior para prod)
# -----------------
ami_id             = "ami-0a232144cf20a27a5"
instance_type      = "t3.micro" 
key_pair_name      = "EC2S"

# -----------------
# TAGS
# -----------------
name               = "Server-P000001" 
environment        = "prod" 

# -----------------
# STORAGE
# -----------------
root_volume_size                       = 20
root_volume_type                       = "gp3"
root_volume_encrypted                  = true
root_data_volume_delete_on_termination = false
