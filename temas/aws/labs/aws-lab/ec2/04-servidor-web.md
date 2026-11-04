# Aula 04 — Um site no ar com *User data*

## 🎯 Nesta aula
- **User data**: um script que **configura a instância sozinha** ao ligar.
- Liberar a porta **80 (HTTP)** no security group.
- Ver o seu site pelo navegador.

Custo: **centavos**. Termine no fim!

---

## 📖 Aprenda: *User data*

É um script que a instância executa **uma única vez**, na **primeira inicialização**, como **root**. Serve para instalar
e configurar tudo automaticamente, sem você entrar na máquina.

```bash
#!/bin/bash
dnf install -y nginx
echo "<h1>Olá da EC2! 🚀</h1><p>Servidor: $(hostname)</p>" > /usr/share/nginx/html/index.html
systemctl enable --now nginx
```
| Linha | O que faz |
|-------|-----------|
| `#!/bin/bash` | Diz que é um script do bash (obrigatório na primeira linha) |
| `dnf install -y nginx` | Instala o nginx. O **`dnf`** é o instalador de programas do Amazon Linux 2023 (`-y` = sem perguntar) |
| `echo "..." > arquivo` | Escreve a página inicial (igual ao nível 1 do Docker Lab). O `$(hostname)` vira o nome da máquina |
| `systemctl enable --now nginx` | Liga o nginx **agora** e configura para ligar **toda vez** que a máquina reiniciar |

> 💡 É o equivalente ao `RUN` + `CMD` de um Dockerfile, só que para uma máquina inteira.

---

## 🛠️ Passo a passo

**1.** **Launch instance**:
- **Name**: `lab-site`
- AMI: **Amazon Linux 2023 AMI** · **Instance type**: **Free tier eligible**
- **Key pair**: `lab-chave`

**2. Network settings**: deixe **Create security group** e marque também **Allow HTTP traffic from the internet**
(libera a porta 80 para qualquer um, o que é o normal para um site).

**3. Advanced details** → role até o fim → no campo **User data**, cole o script acima.

**4.** **Launch instance**. Espere **Running** e **3/3 checks passed**, e mais **1 ou 2 minutos** (o script está instalando o nginx).

**5.** Copie o **Public IPv4 address** e abra no navegador: **`http://<IP-PÚBLICO>`** 🎉

> ⚠️ Use **`http://`**, não `https://`. O navegador às vezes completa para `https` sozinho, e aí não abre: o site só
> atende na porta 80 (HTTP).

---

## 🔎 Investigando quando não funciona

Entre na instância (**Connect** → **EC2 Instance Connect**) e:
```bash
$ sudo systemctl status nginx              # o nginx está "active (running)"?
$ sudo cat /var/log/cloud-init-output.log  # a saída do seu script de user data
$ curl localhost                           # o site responde de dentro da máquina?
```
| Comando novo | O que faz |
|--------------|-----------|
| `sudo` | Roda o comando como **administrador** (o `ec2-user` não é root) |
| `systemctl status nginx` | Mostra se o serviço está rodando (sai com `q`) |
| `/var/log/cloud-init-output.log` | Log de tudo que o *user data* fez |
| `curl localhost` | Acessa o site de dentro da própria máquina |

| Sintoma | Causa provável |
|---------|----------------|
| O navegador fica carregando e dá *timeout* | A porta 80 não está liberada no security group |
| `curl localhost` funciona, o navegador não | Security group, ou você usou `https://` |
| O nginx não existe | O script falhou: leia o `cloud-init-output.log` (faltou o `#!/bin/bash`?) |
| Página **"Access Blocked (firewall corporativo)"** (*Category: Unrated*) | A AWS está certa: quem bloqueou foi o **firewall corporativo**, que barra sites "sem categoria", como um IP solto. Teste pelo **Public DNS** (`http://ec2-...amazonaws.com`) ou pelo celular **fora do Wi-Fi da empresa** |

### Liberando a porta 80 depois que a instância já existe
A regra **não** fica na instância, e sim no **security group** dela. Por isso a aba **Security** da instância só mostra
as regras, sem botão para editar:
1. Na aba **Security** da instância, clique no link azul do grupo, em **Security groups** (`sg-... (launch-wizard-N)`).
2. Na página do grupo, abra a aba **Inbound rules** → **Edit inbound rules** → **Add rule**.
3. **Type**: `HTTP` · **Source**: `Anywhere-IPv4` (`0.0.0.0/0`) → **Save rules**.

Vale na hora: não precisa reiniciar a instância. (Na [aula 05](05-security-groups.md) você vai aprender security groups a fundo.)

---

## ✍️ Pratique
1. Entre na instância e mude a página para `<h1>Editado na mão</h1>` (dica: `sudo` + `echo` + o caminho do arquivo... ou
   `sudo nano /usr/share/nginx/html/index.html`; no nano, salve com `Ctrl + O`, `Enter` e saia com `Ctrl + X`).
   Atualize o navegador.
2. **Reinicie** a instância (**Instance state** → **Reboot instance**). O site volta sozinho? Por quê?
3. Lance uma **segunda** instância, `lab-site-2`, com um user data que mostre `<h1>Servidor 2</h1>`. Use o
   **mesmo security group** da primeira (em **Network settings** → **Select existing security group**). Abra as duas no navegador.

<details><summary>👀 Ver respostas do Pratique</summary>

1. `sudo sh -c 'echo "<h1>Editado na mão</h1>" > /usr/share/nginx/html/index.html'` (o `sh -c` faz o `>` também rodar
   como administrador) ou edite com `sudo nano`.
2. Volta sim: o `systemctl enable` configurou o nginx para ligar a cada reinício. (O *user data* **não** roda de novo; nem
   precisa.) E o IP público **não muda** num reboot.
3. User data igual ao da aula, trocando o texto do `echo`. Em **Network settings** → **Edit** (se necessário) →
   **Select existing security group** → o grupo da `lab-site`.
</details>

## 🧹 Limpeza (obrigatória)
Termine `lab-site` e `lab-site-2`. Confira no **EC2 Global View**.

## 🧠 Memorize
1. Quando o *user data* roda?
2. Qual o instalador de programas do Amazon Linux 2023?
3. O que faz `systemctl enable --now`?
4. Onde ver o que o *user data* fez?
5. O site não abre no navegador, mas `curl localhost` funciona. O que verificar?

<details><summary>👀 Ver respostas</summary>

1. Uma vez, na primeira inicialização, como root.
2. `dnf`.
3. Liga o serviço agora e configura para ligar a cada reinício.
4. `/var/log/cloud-init-output.log`.
5. Se o security group libera a porta 80 e se você está usando `http://` (e não `https://`).
</details>

➡️ Próxima: [Aula 05 — Security groups](05-security-groups.md)
