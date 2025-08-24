
variable "aws_region" { description = "Região da AWS" }
variable "vpc_id" { description = "ID da VPC" }
variable "security_group_id" { description = "ID do Security Group" }
variable "ami_id" { description = "AMI da instância" }
variable "instance_type" { description = "Tipo da instância" }
variable "key_pair_name" { description = "Nome da chave SSH" }
variable "name" { description = "Tag Name da instância" }
variable "environment" { description = "Tag de ambiente" }
variable "root_volume_size" { description = "Tamanho do volume raiz" }
variable "root_volume_type" { description = "Tipo do volume raiz" }
variable "root_volume_encrypted" { description = "Criptografar volume raiz" }
variable "root_data_volume_delete_on_termination" { description = "Deletar volume ao terminar a instância" }
