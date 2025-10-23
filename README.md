# IAC Repo

Repositório de infraestrutura como código focado em provisionar uma instância Amazon EC2 endurecida utilizando Terraform. O módulo principal reutiliza recursos existentes (VPC, Security Group e sub-redes públicas) e aplica uma rotina de hardening via `user_data`.

## Documentação

- [Visão Geral da Arquitetura](docs/overview.md)
- [Catálogo do Módulo `ec2-instance`](docs/modules/ec2-instance.md)
- [Ambientes Terraform (`dev` e `prod`)](docs/environments.md)
- [Hardening e Pós-Provisionamento](docs/security-hardening.md)
- [Operações e Troubleshooting](docs/operations/troubleshooting.md)

## Estrutura Principal

- `terraform/ec2/modules/ec2-instance`: módulo reutilizável da instância.
- `terraform/ec2/dev` e `terraform/ec2/prod`: ambientes que consomem o módulo com variáveis e exemplos de `tfvars`.
- `docs/`: guias de arquitetura, operação e segurança.
