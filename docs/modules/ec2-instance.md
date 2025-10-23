# Módulo `ec2-instance`

Catálogo técnico do módulo reutilizável localizado em `terraform/ec2/modules/ec2-instance`.

## Objetivo

Provisionar uma instância EC2 em uma sub-rede pública existente, reutilizando VPC e Security Group já provisionados e aplicando hardening via `user_data.sh` durante o boot.

## Variáveis de Entrada

| Variável | Tipo | Default | Obrigatória? | Descrição |
| --- | --- | --- | --- | --- |
| `aws_region` | `string` | `"us-east-1"` | Não | Região alvo da AWS utilizada para validar dados e recursos. |
| `key_pair_name` | `string` | — | Sim | Nome do par de chaves SSH que será associado à instância. |
| `vpc_id` | `string` | — | Sim | ID da VPC onde a instância será criada. |
| `security_group_id` | `string` | — | Sim | ID do Security Group existente anexado à instância. |
| `subnet_id` | `string` | `null` | Não | Sub-rede específica para a instância. Se `null`, o módulo seleciona automaticamente uma sub-rede pública da VPC. |
| `ami_id` | `string` | — | Sim | AMI utilizada na instância (recomenda-se Amazon Linux 2023 para compatibilidade com o hardening). |
| `instance_type` | `string` | — | Sim | Tipo da instância EC2 (ex.: `t3.micro`). |
| `name` | `string` | — | Sim | Valor da tag `Name` aplicada à instância. |
| `environment` | `string` | — | Sim | Valor da tag `Environment` aplicada à instância. |
| `root_volume_size` | `number` | `16` | Não | Tamanho (GiB) do volume raiz configurado na instância. |
| `root_volume_type` | `string` | `"gp3"` | Não | Tipo do volume raiz (gp2, gp3 etc.). |
| `root_volume_encrypted` | `bool` | `true` | Não | Define se o volume raiz é criptografado. |
| `root_data_volume_delete_on_termination` | `bool` | `true` | Não | Controla se o volume raiz é destruído quando a instância é terminada. |

## Comportamento

- Quando `subnet_id` não é fornecido, o módulo descobre todas as sub-redes públicas (`map-public-ip-on-launch=true`) na VPC e seleciona uma aleatoriamente por meio do recurso `random_integer`.
- O Security Group informado é aplicado diretamente via `vpc_security_group_ids`, mantendo controles de rede centralizados.
- O bloco `root_block_device` expõe opções de tamanho, tipo, criptografia e política de deleção do volume raiz.
- O script `user_data.sh` faz parte do módulo e será enviado automaticamente para a instância; não é necessário referenciá-lo externamente.

## Outputs

| Output | Descrição |
| --- | --- |
| `instance_id` | ID (AWS) da instância EC2 criada. |
| `public_ip` | Endereço IPv4 público atribuído à instância. |
| `private_ip` | Endereço IPv4 privado na sub-rede selecionada. |

### Consumo dos outputs

Após um `terraform apply`, execute `terraform output -json` no diretório do ambiente para integrar os outputs em pipelines ou scripts adicionais (por exemplo, inventário de configuração ou pipelines de deploy).

## Considerações

- Certifique-se de que a AMI utilizada é compatível com a rotina de hardening (Amazon Linux 2023). AMIs diferentes podem falhar durante a execução do `user_data`.
- Configure previamente o par de chaves mencionado em `key_pair_name`, garantindo que operadores tenham acesso SSH à instância após o provisionamento.
