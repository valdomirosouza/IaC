# Operações e Troubleshooting

Guia rápido para equipes de operação investigarem incidentes e executarem tarefas de suporte relacionadas à instância provisionada pelo módulo `ec2-instance`.

## Acesso a Outputs e Inventário

```bash
terraform output
terraform output -json > outputs.json
```

- `public_ip`: utilizado para acesso remoto/monitoramento.
- `private_ip`: útil para integrar com VPC endpoints ou bastion hosts.
- `instance_id`: empregado em automações AWS CLI (ex.: `aws ec2 describe-instance-status`).

## Conexão SSH

```bash
ssh -i ~/.ssh/<chave>.pem ec2-user@<public_ip>
```

- Garanta que o Security Group permita conexões SSH a partir do seu IP.
- O hardening desabilita login por senha; apenas autenticação por chave é aceita.

## Logs Relevantes

| Componente | Caminho |
| --- | --- |
| CloudInit | `/var/log/cloud-init.log`, `/var/log/cloud-init-output.log` |
| Hardening | `/root/hardening/purge.log`, `/root/hardening/purge-candidates.txt` |
| SSH | `/var/log/secure` |
| Systemd | `journalctl -xeu <serviço>` |

## Rollback e Recriação

- **Reprovisionamento completo**: `terraform destroy -var-file="<ambiente>.tfvars"` seguido de `terraform apply`.
- **Recursos específicos**: utilize `terraform taint module.ec2_server_dev.aws_instance.lamp_server` antes do próximo `apply` para forçar recriação.
- **Snapshots de volume**: se `root_data_volume_delete_on_termination = false` (como em produção), lembre-se de eliminar volumes órfãos manualmente após `destroy`.

## Monitoramento e Saúde

- Verifique o status da instância com `aws ec2 describe-instance-status --instance-id <id>`.
- Configure alarmes do CloudWatch para CPU, status checks e disponibilidade da instância.
- Considere habilitar AWS Systems Manager (SSM) – o agente é mantido na allowlist do hardening (`amazon-ssm-agent`).

## Incidentes Comuns

1. **Falha no hardening**
   - Revisar `purge.log` e `cloud-init-output.log` para identificar pacotes bloqueando o processo.
   - Ajustar variáveis de ambiente (`ENABLE_PURGE`, `ALSO_REMOVE_COMPILERS`) e reprovisionar.
2. **Perda de acesso SSH**
   - Confirmar IP público atual (a instância recebe IP público automaticamente ao entrar em uma subnet pública).
   - Validar regras do Security Group e rota/NACL da subnet.
   - Certificar-se de que a chave SSH correta foi usada (apenas `ec2-user` com chave pública registrada).
3. **Serviços essenciais desativados**
   - Verifique se o serviço aparece nas listas `DISABLE_LIST` ou de hardening complementar no `user_data`.
   - Caso necessário, edite o script ou crie sobreposição via `cloud-init` adicional.
4. **Remoção indesejada de pacotes**
   - No modo _dry-run_ (`ENABLE_PURGE=0`), revise `purge-candidates.txt` e promova a lista desejada para `ALLOWLIST_*` antes de habilitar a remoção.
   - Se o pacote já foi removido, utilize `dnf install <pacote>` manualmente ou reprovisione com parâmetros ajustados.

## Boas Práticas Operacionais

- Execute `terraform plan` antes de qualquer `apply` em produção e submeta o plano para revisão.
- Utilize pipelines CI/CD para aplicar mudanças, garantindo `terraform fmt` e `terraform validate` automáticos.
- Documente exceções ao hardening em tickets ou playbooks específicos para manter rastreabilidade.
