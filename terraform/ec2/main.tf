# --- Bloco para selecionar sub-rede aleatória ---
# Este bloco gera um número aleatório
resource "random_integer" "random_subnet_index" {
  min = 0
  max = length(data.aws_subnets.all_public_subnets.ids) - 1
}

# --- Bloco para usar todas as sub-redes ---
# Este bloco obtém todas as sub-redes públicas na sua VPC
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
# --- Fim do bloco de sub-redes ---

# O resto do seu código
data "aws_vpc" "existing_vpc" {
  id = "vpc-018a1426cd5d1bc71"
}

data "aws_security_group" "existing_sg" {
  id = "sg-03d77403a66206ac1"
}

resource "aws_instance" "lamp_server" {
  ami           = "ami-0a232144cf20a27a5"
  instance_type = "t3.micro"
  key_name      = var.key_pair_name
  
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  
  # Agora, selecionamos uma sub-rede aleatória da lista de IDs
  subnet_id = element(data.aws_subnets.all_public_subnets.ids, random_integer.random_subnet_index.result)
  
  tags = {
    Name = "Servidor-LAMP-Managed-by-Terraform"
  }

  user_data = file("${path.module}/user_data.sh")
}
