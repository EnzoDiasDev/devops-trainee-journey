# 🧾 Cola do EC2

## Free Tier
| | Legado (conta antes de 15/07/2025) | Free plan (a partir de 15/07/2025) |
|---|---|---|
| Modelo | 750 h/mês por 12 meses | Créditos: US$ 100 + até US$ 100 (atividades do **Explore AWS**) |
| Instâncias elegíveis | t2.micro, t3.micro | t3.micro, t3.small, t4g.micro, t4g.small, c7i-flex.large, m7i-flex.large |
| Excedeu | Cobra no cartão | Não excede; após 6 meses a conta é suspensa (90 dias para migrar) |

Sempre confira a etiqueta **Free tier eligible** na AMI e no tipo de instância. Região do lab: **US East (N. Virginia)**.

## Caminhos do console
| Quero... | Onde |
|----------|------|
| Lançar instância | **EC2** → **Launch instance** |
| Ligar / desligar / reiniciar / apagar | **Instances** → selecione → **Instance state** → **Start** / **Stop** / **Reboot** / **Terminate (delete) instance** |
| Entrar pelo navegador | Selecione → **Connect** → **EC2 Instance Connect** → **Connect using a Public IP** → **Connect** |
| Firewall | **Network & Security** → **Security Groups** → **Inbound rules** → **Edit inbound rules** |
| IP fixo | **Network & Security** → **Elastic IPs** → **Allocate** / **Associate** / **Disassociate** / **Release** |
| Discos | **Elastic Block Store** → **Volumes** → **Create volume** / **Attach** / **Detach** / **Delete** |
| Backup de disco | **Volumes** → **Actions** → **Create snapshot** · **Snapshots** → **Create volume from snapshot** |
| Imagem própria | Instância → **Actions** → **Image and templates** → **Create image** · **Images** → **AMIs** → **Deregister AMI** |
| Chaves SSH | **Network & Security** → **Key Pairs** |
| Tudo de todas as regiões | Busca do topo → **EC2 Global View** |
| Alerta de gastos | Busca → **Budgets** → **Create budget** → **Use a template (simplified)** → **Zero spend budget** |

## Assistente de lançamento (de cima para baixo)
**Name and tags** → **Application and OS Images** → **Instance type** → **Key pair (login)** → **Network settings** →
**Configure storage** → **Advanced details** (**User data** no fim) → **Summary** → **Launch instance**

## Terminal
```bash
# do WSL
cp /mnt/c/Users/<seu-usuario>/Downloads/chave.pem ~/.ssh/ && chmod 400 ~/.ssh/chave.pem
ssh -i ~/.ssh/chave.pem ec2-user@<IP>

# dentro da instância (Amazon Linux 2023)
sudo dnf install -y <pacote>            # instalar
sudo systemctl enable --now <serviço>   # ligar agora e no boot
sudo systemctl status <serviço>         # estado (sair: q)
sudo cat /var/log/cloud-init-output.log # o que o user data fez
lsblk                                   # discos
sudo mkfs -t xfs /dev/nvme1n1           # formatar (SÓ disco novo!)
sudo mount /dev/nvme1n1 /dados          # montar
df -h · free -h · nproc · uptime        # disco, memória, CPUs, tempo ligado
```

## User data prontos
```bash
#!/bin/bash
dnf install -y nginx
echo "<h1>Olá da EC2!</h1>" > /usr/share/nginx/html/index.html
systemctl enable --now nginx
```
```bash
#!/bin/bash
dnf install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user
docker run -d --name site --restart unless-stopped -p 80:80 nginx:alpine
```

## O que cobra mesmo "parado"
| Recurso | Cobra quando |
|---------|--------------|
| Instância | Só ligada (`running`) |
| Volume EBS | Sempre que existir (inclusive instância parada e volume solto) |
| Snapshot | Sempre que existir |
| AMI | Pelo snapshot dela |
| Elastic IP | Sempre que existir (associado ou não) |
| IP público normal | Enquanto a instância estiver ligada |
| Security group, key pair | Nunca |

## Erros comuns
| Sintoma | Causa |
|---------|-------|
| Site não abre, `curl localhost` funciona | Porta não liberada no security group, ou usou `https://` |
| `Connection timed out` no SSH | Porta 22 bloqueada (rede corporativa ou security group) → use o Instance Connect |
| `Permission denied (publickey)` | Usuário errado (`ec2-user`), chave errada ou sem `-i` |
| `UNPROTECTED PRIVATE KEY FILE!` | Faltou `chmod 400` |
| Instance Connect falha, SSH funciona | O security group só libera o seu IP: falta a prefix list do Instance Connect |
| "Minha instância sumiu" | Você está em outra região → **EC2 Global View** |
| Não consigo apagar o security group | Ainda em uso (espere a instância terminada sumir) ou é o `default` |
| Volume não aparece para anexar | Está em outra AZ |
