variable "aws_region" {
  description = "A região da AWS para provisionar os recursos."
  type        = string
  default     = "us-east-1"
}

variable "key_pair_name" {
  description = "O nome da chaves SSH para a instância EC2."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC existente onde a instância será criada"
  type        = string
}

variable "security_group_id" {
  description = "ID do Security Group existente"
  type        = string
}

variable "subnet_id" {
  description = "Sub-rede específica (opcional). Se nula, escolhe aleatória entre as públicas da VPC"
  type        = string
  default     = null
}

variable "ami_id" {
  description = "AMI da instância (ex.: Amazon Linux 2023)"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância"
  type        = string
}

variable "name" {
  description = "Tag Name da instância"
  type        = string
}

variable "environment" {
  description = "Tag Environment"
  type        = string
}

variable "root_volume_size" {
  description = "Tamanho do volume raiz (GiB)"
  type        = number
  default     = 16
}

variable "root_volume_type" {
  description = "Tipo do volume raiz"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Criptografar volume raiz"
  type        = bool
  default     = true
}

variable "root_data_volume_delete_on_termination" {
    description = "Deletar volume no momento da exclusao da EC2"
    type        = bool
    default	= true
}
