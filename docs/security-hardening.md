# Hardening e Pós-Provisionamento

O script `user_data.sh` do módulo `ec2-instance` aplica hardening extensivo na instância durante o primeiro boot. Esta seção documenta as ações realizadas e como personalizá-las.

## Sequência de Ações

1. **Atualização de pacotes** – Executa `yum update -y` para garantir que o sistema esteja atualizado.
2. **Endurecimento do SSH**
   - Desabilita login root e autenticação por senha.
   - Restringe `AllowTcpForwarding`, `AllowAgentForwarding`, `X11Forwarding`, `Compression` e `TCPKeepAlive`.
   - Reduz `MaxAuthTries` para 3 tentativas.
   - Reinicia `sshd` para aplicar as mudanças.
3. **Desativação de serviços** – Desabilita serviços considerados desnecessários (ex.: `acpid`, `getty@tty1`, `irqbalance`, `systemd-homed`).
4. **Ajustes de Kernel** – Configurações `sysctl` para `rp_filter` e desabilitação de `ip_forward` são aplicadas e carregadas com `sysctl -p`.
5. **Rotina de Hardening Amazon Linux 2023**
   - Valida que o sistema é Amazon Linux (`ID=amzn`).
   - Gera inventário de pacotes instalados e define listas de preservação (`ALLOWLIST_COMMON`, `ALLOWLIST_AMAZON2023`, `PROTECT`).
   - Resolve dependências das listas permitidas usando `repoquery` para evitar remoção de pacotes críticos.
   - Calcula candidatos à remoção e gera `/root/hardening/purge-candidates.txt` com o resultado.
6. **Execução condicional de remoções**
   - Por padrão (`ENABLE_PURGE=0`), apenas gera a lista de candidatos (modo _dry-run_).
   - Quando `ENABLE_PURGE=1`, remove pacotes listados, executa `dnf autoremove` e limpa caches.
   - Se `ALSO_REMOVE_COMPILERS=1` (default), inclui toolchains/compiladores e aplica `dnf versionlock` para impedir reinstalação.
7. **Hardening complementar**
   - Desabilita/máscara serviços adicionais (`avahi-daemon`, `cups`, `rpcbind`, `postfix`, entre outros).
   - Define `umask 027` via `/etc/profile.d/99-hardening-umask.sh`.
   - Executa script auxiliar que invoca `dnf remove --skip-broken` para cada candidato listado quando o arquivo não está vazio.

## Personalização via Variáveis de Ambiente

Antes de executar `terraform apply`, é possível exportar variáveis de ambiente para ajustar o comportamento do `user_data`:

```bash
export ENABLE_PURGE=1              # Executa remoção de pacotes em vez de apenas listar
export ALSO_REMOVE_COMPILERS=0     # Mantém compiladores/toolchains instalados
```

Essas variáveis são lidas pelo script no momento do boot. Ajuste-as conforme requisitos de compliance ou troubleshooting.

## Logs e Artefatos

- Diretório de trabalho: `/root/hardening/`.
- Log principal: `/root/hardening/purge.log`.
- Inventários e listas geradas (`_installed.txt`, `_keep.txt`, `purge-candidates.txt`).
- Script temporário de remoção: `/tmp/purge-candidates.sh`.

Revise `purge.log` e `purge-candidates.txt` após o boot para validar o resultado da rotina.

## Impactos e Cuidados

- A rotina remove pacotes não presentes nas allowlists; valide se aplicações futuras não dependem de ferramentas removidas.
- `ENABLE_PURGE=1` pode aumentar o tempo de provisionamento e requer conectividade com repositórios Yum.
- O script é específico para Amazon Linux 2023. Alterar a AMI pode interromper o processo (o script aborta se `ID != amzn`).
- Desativar serviços pode impactar fluxos que dependam, por exemplo, de `postfix` ou `rpcbind`. Ajuste a lista conforme necessidade.

## Validações Pós-Boot

- Verifique conectividade SSH usando o usuário e chave esperados.
- Confirme que os serviços essenciais permaneceram ativos (`systemctl status <serviço>`).
- Consulte `cloud-init` (`/var/log/cloud-init.log`) e `purge.log` para identificar possíveis falhas no hardening.
