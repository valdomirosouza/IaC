variable "aws_region" {
  description = "A região da AWS para provisionar os recursos."
  type        = string
  default     = "us-east-1"
}

variable "key_pair_name" {
  description = "O nome do par de chaves SSH para a instância EC2."
  type        = string
  default     = "EC2S"
}
