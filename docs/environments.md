# Ambientes Terraform

Os ambientes `dev` e `prod` reutilizam o módulo `ec2-instance` com parâmetros específicos. Cada diretório contém o arquivo `main.tf`, variáveis locais (`variables.tf`) e um exemplo de `tfvars` para aplicação.

## Estrutura dos diretórios

```
terraform/ec2/dev/
├── main.tf
├── variables.tf
├── dev.tfvars
└── README-CMD-TERRAFORM.txt

terraform/ec2/prod/
├── main.tf
├── variables.tf
├── prod.tfvars
└── README-CMD-TERRAFORM.txt
```

### `main.tf`

- Define os providers `hashicorp/aws` (`~> 6.10`) e `hashicorp/random` (`~> 3.7`).
- Configura o provider AWS usando `var.aws_region`.
- Instancia o módulo `ec2-instance`, propagando todas as variáveis necessárias.

### `variables.tf`

Cada ambiente declara as variáveis consumidas pelo módulo, definindo apenas descrições para orientar o preenchimento nos arquivos `tfvars`.

### Arquivos `tfvars`

| Ambiente | Nome do arquivo | Destaques |
| --- | --- | --- |
| `dev` | `dev.tfvars` | Volume raiz deletado na terminação (`root_data_volume_delete_on_termination = true`). |
| `prod` | `prod.tfvars` | Volume raiz preservado ao terminar a instância (`root_data_volume_delete_on_termination = false`). |

> **Nota:** Os IDs de VPC, Security Group e a chave SSH presentes nos exemplos são valores fictícios e devem ser atualizados para o ambiente real antes da execução.

## Runbook por Ambiente

1. **Preparação**
   - Ajuste o arquivo `*.tfvars` com IDs válidos, AMI compatível (Amazon Linux 2023) e nome da chave SSH existente.
   - Opcional: configure backends remotos ou Workspaces Terraform se necessário para equipes maiores.

2. **Execução**
   ```bash
   terraform init
   terraform fmt
   terraform validate
   terraform plan -var-file="<ambiente>.tfvars"
   terraform apply -var-file="<ambiente>.tfvars"
   ```

3. **Destroy**
   ```bash
   terraform destroy -var-file="<ambiente>.tfvars"
   ```

## Checklist antes do `apply`

- [ ] `tfvars` revisado com IDs corretos de VPC, Security Group e Subnet (se aplicável).
- [ ] Chave SSH (`key_pair_name`) existente na conta/região.
- [ ] Limites de custo avaliados para o `instance_type` escolhido.
- [ ] Variáveis de hardening (como `ENABLE_PURGE` e `ALSO_REMOVE_COMPILERS`) ajustadas conforme necessidade via `tfvars` ou variáveis de ambiente exportadas antes do `apply`.
- [ ] Equipe alinhada sobre o comportamento do volume raiz (deleção ou retenção em caso de destroy/terminate).

## Boas práticas adicionais

- Versione arquivos `*.tfvars` sensíveis utilizando mecanismos seguros (ex.: armazenar apenas templates e manter valores reais em secret managers ou pipelines).
- Utilize workspaces (`terraform workspace select`) quando o mesmo diretório servir a múltiplos conjuntos de variáveis.
- Considere habilitar `terraform apply -target` apenas em casos de incidentes; para rollbacks completos prefira `terraform destroy` ou `terraform taint` em recursos específicos.
