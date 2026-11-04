# Aula 10 — Desafio final

Monte tudo **sem olhar as aulas** (use a [COLA.md](COLA.md) se travar) e, no fim, **limpe tudo** com o
[checklist de limpeza](LIMPEZA.md). Custo: centavos, **se você limpar**.

---

## 🏗️ O desafio: "Vitrine na nuvem"

1. **Security group** `desafio-sg`, criado antes da instância, com:
   - HTTP (80) de qualquer lugar;
   - SSH (22) **só** do seu IP **e** da prefix list do EC2 Instance Connect.
2. **Instância** `desafio-web`: Amazon Linux 2023, tipo **Free tier eligible**, key pair `lab-chave`, security group
   `desafio-sg`, e um *user data* que instale o **Docker** e suba um container `nginx:alpine` na porta 80 com
   `--restart unless-stopped`.
3. Um **volume EBS** de 1 GiB, na mesma AZ, anexado, formatado e montado em `/dados`, com um arquivo `/dados/vitrine.html`
   contendo `<h1>Minha vitrine</h1>`.
4. Faça o container servir **o arquivo do volume**: recrie o container montando `/dados` dentro dele (bind mount do Docker
   Lab, nível 3!):
   ```bash
   $ docker rm -f site
   $ docker run -d --name site --restart unless-stopped -p 80:80 -v /dados:/usr/share/nginx/html:ro nginx:alpine
   ```
   e abra `http://<IP>/vitrine.html`.
5. Um **Elastic IP** associado à instância. Prove que o site continua no mesmo endereço depois de **Stop** + **Start**.
   (Dica: depois do start, o volume extra precisa ser **montado de novo**: `sudo mount /dev/nvme1n1 /dados`, e o container
   reiniciado: `docker restart site`.)
6. Um **snapshot** do volume de 1 GiB.

<details><summary>👀 Ver o user data do item 2</summary>

```bash
#!/bin/bash
dnf install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user
docker run -d --name site --restart unless-stopped -p 80:80 nginx:alpine
```
</details>

---

## 🧹 A parte mais importante: limpar TUDO
Siga o [LIMPEZA.md](LIMPEZA.md) de cima para baixo. No fim, todos estes devem estar **vazios**:
**Instances**, **Elastic IPs**, **Volumes**, **Snapshots**, **AMIs** (Owned by me) e os security groups `desafio-sg` e
`launch-wizard-*`. Confirme no **EC2 Global View** e, no dia seguinte, no **Billing and Cost Management**.

---

## ⚡ Prova relâmpago

12 ou mais acertos (de 15) = EC2 dominado. 🏆

| # | Pergunta |
|---|----------|
| 1 | Qual a diferença entre o Free Tier legado e o Free plan, e qual é o seu? |
| 2 | Quais tipos de instância são Free tier eligible na sua conta? |
| 3 | O que é uma AMI? |
| 4 | Em qual seção do assistente fica o *User data*? |
| 5 | Qual o usuário padrão do Amazon Linux? |
| 6 | Por que o SSH pode falhar na rede corporativa, e qual a alternativa? |
| 7 | Qual a prefix list a liberar para o EC2 Instance Connect em `us-east-1`? |
| 8 | Uma instância parada cobra o quê? |
| 9 | O que acontece com o IP público num stop/start? E com um Elastic IP? |
| 10 | Terminei a instância. Que recursos de EC2 podem ter ficado para trás, cobrando? |
| 11 | Volume em `us-east-1a`, instância em `us-east-1b`. Consigo anexar? |
| 12 | Quando NÃO usar o `mkfs`? |
| 13 | O *Deregister AMI* apaga tudo da AMI? |
| 14 | Onde vejo recursos de EC2 em todas as regiões? |
| 15 | Qual alerta avisa por e-mail se você gastar qualquer centavo além do gratuito? |

<details><summary>👀 Ver respostas</summary>

| # | Resposta |
|---|----------|
| 1 | Legado (antes de 15/07/2025): limites mensais por 12 meses, excesso cobrado. Free plan: créditos (até US$ 200), 6 meses, sem exceder |
| 2 | Free plan: t3.micro, t3.small, t4g.micro, t4g.small, c7i-flex.large, m7i-flex.large. Legado: t2.micro, t3.micro. (Confira a etiqueta **Free tier eligible**) |
| 3 | O molde do disco da instância (sistema + programas) |
| 4 | **Advanced details** |
| 5 | `ec2-user` |
| 6 | A rede bloqueia a porta 22; use o EC2 Instance Connect do navegador (porta 443) |
| 7 | `com.amazonaws.us-east-1.ec2-instance-connect` |
| 8 | Os discos EBS (e Elastic IPs, se houver) |
| 9 | O IP normal muda; o Elastic IP fica fixo |
| 10 | Elastic IPs, volumes EBS extras, snapshots e AMIs |
| 11 | Não: precisam estar na mesma AZ |
| 12 | Num disco que já tem dados (ou foi restaurado de snapshot) e no disco principal |
| 13 | Não: o snapshot da AMI fica e precisa ser apagado à parte |
| 14 | **EC2 Global View** |
| 15 | **Zero spend budget** (AWS Budgets) |
</details>

---

## 🎉 Terminou?
Marque o [PROGRESSO.md](PROGRESSO.md) e avise o Claude: **"terminei o módulo de EC2"**. O próximo é **IAM**: você vai criar
um usuário próprio, parar de usar a conta root e entender permissões.
