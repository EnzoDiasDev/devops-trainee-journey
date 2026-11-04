# Aula 09 — Docker na EC2

## 🎯 Nesta aula
Juntar o que você aprendeu no **Docker Lab** com a EC2: instalar o Docker numa instância via *user data* e rodar containers
na nuvem.

Custo: **centavos**.

---

## 📖 Aprenda

Na sua máquina, o Docker roda no WSL. Numa EC2, ele roda **numa máquina na nuvem**, acessível pela internet.
Esse é, de forma simplificada, o começo de como muitas empresas rodam aplicações.

*User data* para instalar e ligar o Docker no Amazon Linux 2023:
```bash
#!/bin/bash
dnf install -y docker
systemctl enable --now docker
usermod -aG docker ec2-user
docker run -d --name site --restart unless-stopped -p 80:80 nginx:alpine
```
| Linha | O que faz |
|-------|-----------|
| `dnf install -y docker` | Instala o Docker |
| `systemctl enable --now docker` | Liga o Docker agora e a cada reinício |
| `usermod -aG docker ec2-user` | Deixa o `ec2-user` usar o Docker sem `sudo` (vale a partir do próximo login) |
| `docker run -d ... -p 80:80 nginx:alpine` | Sobe um nginx em container, publicado na porta **80** da instância |
| `--restart unless-stopped` | Religa o container sozinho se a máquina reiniciar |

> Aqui o Docker **não é rootless** como no seu WSL, então dá para publicar na porta **80**. E a imagem vem direto do
> Docker Hub (a instância tem internet).

---

## 🛠️ Passo a passo

**1.** Lance a `lab-docker` (Amazon Linux 2023, Free tier eligible, `lab-chave`, HTTP liberado) com o *user data* acima.

**2.** Espere ~2 minutos e abra `http://<IP-PÚBLICO>`: **Welcome to nginx!** vindo de um **container na nuvem**. 🐳☁️

**3.** Entre pelo **Instance Connect** e use os comandos que você já conhece:
```bash
$ docker ps
$ docker logs site
$ docker exec -it site sh
# echo "<h1>Container na EC2!</h1>" > /usr/share/nginx/html/index.html
# exit
```
Atualize o navegador.

> Se o `docker ps` disser *permission denied*, é porque o grupo `docker` só vale num **novo login**: saia (`exit`) e
> conecte de novo, ou use `sudo docker ps`.

---

## ✍️ Pratique (com o que você aprendeu no Docker Lab)
1. Suba um **segundo** container nginx na porta **8080** da instância. Libere a porta 8080 no security group
   (**Custom TCP**, porta `8080`, **My IP**) e abra `http://<IP>:8080`.
2. Reinicie a instância (**Reboot instance**). O container `site` volta sozinho? E o da 8080?
3. Rode `docker run --rm hello-world` na instância.

<details><summary>👀 Ver respostas</summary>

1. `docker run -d --name site2 -p 8080:80 nginx:alpine` + regra **Custom TCP / 8080 / My IP** em **Edit inbound rules**.
2. O `site` volta (tem `--restart unless-stopped`). O `site2` não, a menos que você tenha usado `--restart`.
3. Baixa a imagem do Docker Hub e mostra a mensagem, como no nível 1.
</details>

## 🧹 Limpeza (obrigatória)
Termine a `lab-docker`. Se criou regras extras num security group que vai continuar usando, tudo bem; se não, apague os
`launch-wizard-*` que sobraram.

## 🧠 Memorize
1. Que linha do *user data* instala o Docker no Amazon Linux 2023?
2. Por que aqui dá para usar a porta 80 e no seu WSL não?
3. Abri uma porta nova num container. O que mais preciso liberar para acessar de fora?

<details><summary>👀 Ver respostas</summary>

1. `dnf install -y docker`.
2. No WSL o Docker é rootless (sem portas abaixo de 1024); na EC2 ele roda como root.
3. A porta no **security group** da instância.
</details>

➡️ Próxima: [Aula 10 — Desafio final](10-desafio-final.md)
