# Provisionamento de Servidor EC2 com Terraform

Este projeto utiliza Terraform para provisionar e gerenciar uma instância EC2 na AWS.

---

### Comandos do Terraform

Para provisionar o servidor e todos os recursos necessários, execute o comando abaixo. Ele usará o plano de execução e o aprovará automaticamente.

```bash
terraform apply -auto-approve
````

Para destruir todos os recursos gerenciados por este projeto, use o seguinte comando. Ele também aprovará a operação de forma automática.

```bash
terraform destroy -auto-approve
```

-----

### Acesso ao Servidor

Para acessar a instância EC2 via SSH, utilize o seu par de chaves e o endereço IP público do servidor.

```bash
ssh -i ~/.ssh/[nome da chave].pem [USER]@[X.Y.Z.W]
```
