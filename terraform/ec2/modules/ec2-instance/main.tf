############################################
# EC2 LAMP (exemplo) em sub-rede pública
# Usa VPC e Security Group existentes
# Seleciona uma subnet pública aleatória
############################################

# --- Dados da VPC existente ---
# Observação: garanta que este ID exista na região configurada no provider
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id 
}

# --- Security Group existente ---
# Deve permitir pelo menos SSH (22) da sua origem e portas da aplicação (se houver)
data "aws_security_group" "existing_sg" {
  id = var.security_group_id
}

# --- Descoberta de sub-redes públicas da VPC ---
# Filtro por VPC e pela flag "map-public-ip-on-launch=true" (subnets públicas)
# Se não retornar nada, confira essa flag nas subnets ou troque por um filtro por tag (ex: tag:Tier = public)
data "aws_subnets" "all_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

# --- Seleção aleatória da subnet ---
# Gera um índice aleatório entre 0 e (N-1) com base na lista de subnets públicas
# Dica: se a quantidade de subnets mudar, o Terraform pode recalcular este recurso
resource "random_integer" "random_subnet_index" {
  min = 0
  max = length(data.aws_subnets.all_public_subnets.ids) - 1
}

# --- Instância EC2 ---
# Usa uma AMI específica e um tipo t3.micro
# Associa o Security Group existente
# Usa uma subnet pública aleatória
# Injeta o script de user_data para provisionamento do servidor

resource "aws_instance" "lamp_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name 

  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  # Seleciona uma das subnets públicas de forma aleatória
  subnet_id = element(
    data.aws_subnets.all_public_subnets.ids,
    random_integer.random_subnet_index.result
  )

  # --- Boas práticas opcionais ---

  root_block_device {
     volume_size           = var.root_volume_size
     volume_type           = var.root_volume_type
     encrypted             = var.root_volume_encrypted
     delete_on_termination = var.root_data_volume_delete_on_termination 
  }

  tags = {
    Name       = var.name 
    Environment= var.environment
  }

  # Script de inicialização (ex.: instalar Apache/PHP/MySQL, ajustar hardening, etc.)
  user_data = file("${path.module}/user_data.sh")
}
