#!/bin/bash

## --------------------------------------
## Atualizacao de pacotes
## --------------------------------------

sudo yum update -y

## --------------------------------------
## Hardening
## --------------------------------------

sudo yum remove -y telnetd rsh-server
sudo su -c 'rpm -qa | grep -Ev "ssh|sudo|yum|kernel|tcsh|bash|ec2|procps|amazon|aws|awscli|basesystem|bind|binutils|bzip2|coreutils|crontabs|curl|dbus|device|diffutils|dosfstools|e2fsprogs|elfutils|ethtool|file|filesystem|findutils|policycoreutils|rootfiles|rpcbind|rpm|rsync|sed|selinux|setup|sysctl|sysstat|system|systemd|systemtap"' | awk -F"-" '{ print "yum remove -y "$1 }' | sort | uniq > /tmp/yum-remove.sh
sudo su -c '/bin/bash /tmp/yum-remove.sh'
sudo su -c 'chmod 600 /etc/ssh/*_key'

# Proteger SSH
echo "Protegendo o acesso SSH..."
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd

# Aplicar configurações de segurança do kernel
echo "Aplicando configurações do kernel..."
echo "net.ipv4.conf.all.rp_filter = 1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.ip_forward = 0" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

## --------------------------------------
## Instalacao do APACHE
## --------------------------------------

yum install -y httpd.x86_64
systemctl start  httpd.service
systemctl enable httpd.service
echo "<html><body><h1>Hello from EC2!</h1></body></html>" > /var/www/html/index.html

## --------------------------------------
## Instalacao do POSTGRESQL
## --------------------------------------

yum install -y postgresql17-server.x86_64
/usr/bin/postgresql-setup --initdb
systemctl start  postgresql.service
systemctl status postgresql.service
systemctl enable postgresql.service
