# Aula 03 — Entrar na instância

## 🎯 Nesta aula
- **EC2 Instance Connect**: um terminal **dentro do navegador**, sem configurar nada.
- **Key pair** + **SSH** pelo seu terminal do Ubuntu (WSL).
- Comandos básicos dentro da instância.

Custo: **centavos** (a instância fica ligada uns 30 minutos). Termine no fim!

---

## 📖 Aprenda: dois jeitos de entrar

| Jeito | Como | Precisa de |
|-------|------|------------|
| **EC2 Instance Connect** (navegador) | Botão **Connect** no console | Só o navegador. O console conversa com a instância pela porta **443** (HTTPS) |
| **SSH** (seu terminal) | `ssh -i chave.pem ec2-user@IP` | Um **key pair** e a porta **22** liberada no security group |

> 🏢 **Rede corporativa:** muitas redes corporativas **bloqueiam a saída na porta 22**. Se o SSH pelo terminal não
> conectar (`Connection timed out`), não é você: use o **Instance Connect** do navegador, que usa a porta 443.

O usuário padrão do **Amazon Linux** é **`ec2-user`** (no Ubuntu da AWS seria `ubuntu`).

---

## 🛠️ Parte 1: lançar com key pair

**1.** **EC2** → **Launch instance**:
- **Name**: `lab-conectar`
- AMI: **Amazon Linux 2023 AMI** (**Free tier eligible**)
- **Instance type**: um **Free tier eligible** (ex.: `t3.micro`)

**2. Key pair (login)** → **Create new key pair**. Na janela:
- **Key pair name**: `lab-chave`
- **Key pair type**: **ED25519** (mais moderna; RSA também funciona)
- **Private key file format**: **.pem** (é o formato do `ssh` do Linux; o `.ppk` é para o PuTTY no Windows)
- **Create key pair**. O navegador **baixa** o arquivo `lab-chave.pem`.

> 🔒 Esse arquivo é a **chave privada**. A AWS **não guarda cópia**: se perder, não tem como baixar de novo.
> E não compartilhe com ninguém.

**3. Network settings**: deixe o padrão. Ele cria um security group com a regra **Allow SSH traffic from** →
**Anywhere (0.0.0.0/0)**, ou seja, SSH aberto para o mundo todo. Para um teste rápido que você vai apagar, a AWS considera
aceitável. Na aula 05 você vai fechar isso direito.

**4.** **Launch instance**. Espere **Running** e **3/3 checks passed**.

---

## 🛠️ Parte 2: pelo navegador (EC2 Instance Connect)

**5.** Selecione a instância → botão **Connect** (topo).

**6.** Aba **EC2 Instance Connect** → **Connect using a Public IP** → confira **Username**: `ec2-user` → **Connect**.

Abre um terminal numa nova aba. Você está **dentro** da instância! 🎉

**7.** Explore (os comandos que você já conhece do Docker Lab, e alguns novos):
```bash
$ whoami                  # ec2-user
$ hostname                # nome interno (ip-172-31-...)
$ cat /etc/os-release     # Amazon Linux 2023
$ df -h /                 # tamanho do disco (~8 GB)
$ free -h                 # memória (~1 GB numa t3.micro)
$ nproc                   # quantos processadores (vCPUs)
$ uptime                  # há quanto tempo está ligada
```
| Comando novo | Mostra |
|--------------|--------|
| `whoami` | O usuário atual |
| `df -h` | Espaço em disco (`-h` = tamanhos legíveis, em GB) |
| `free -h` | Memória RAM |
| `nproc` | Número de processadores |
| `uptime` | Tempo ligado e carga |

Para sair: `exit` (ou feche a aba).

---

## 🛠️ Parte 3: pelo seu terminal (SSH)

**8. Leve a chave para o WSL.** O navegador baixou na pasta **Downloads** do Windows. No terminal do Ubuntu:
```bash
$ cp /mnt/c/Users/<seu-usuario>/Downloads/lab-chave.pem ~/.ssh/
$ chmod 400 ~/.ssh/lab-chave.pem
```
| Comando | Por quê |
|---------|---------|
| `cp origem destino` | Copia o arquivo (`/mnt/c/` é o disco C: do Windows visto de dentro do WSL) |
| `chmod 400 arquivo` | Deixa a chave **só leitura, só para você**. O `ssh` **se recusa** a usar uma chave que outros podem ler |

**9. Conecte.** Copie o **Public IPv4 address** da instância e:
```bash
$ ssh -i ~/.ssh/lab-chave.pem ec2-user@<IP-PÚBLICO>
```
Na primeira vez, o SSH pergunta `Are you sure you want to continue connecting (yes/no/[fingerprint])?`. É o mesmo
"aceitar a impressão digital" da missão do GitLab: responda `yes`.

| Se aparecer | Significa |
|-------------|-----------|
| `Permission denied (publickey)` | Chave errada, usuário errado (é `ec2-user`) ou faltou o `-i` |
| `UNPROTECTED PRIVATE KEY FILE!` | Faltou o `chmod 400` |
| `Connection timed out` | A porta 22 está bloqueada: pela **rede corporativa** ou pelo security group. Use o navegador |

**10.** Rode `hostname` e `exit`.

---

## 🧹 Limpeza (obrigatória)
**11.** Termine a `lab-conectar` (**Instance state** → **Terminate (delete) instance**).

**12.** Guarde o key pair `lab-chave`: ele não cobra nada e será usado nas próximas aulas. (Quando quiser apagar:
**EC2** → **Network & Security** → **Key Pairs** → selecione → **Actions** → **Delete**.)

---

## ✍️ Pratique
1. Lance uma instância nova **usando o key pair `lab-chave` que já existe** (não crie outro).
2. Entre pelo navegador e descubra quanta memória ela tem.
3. Tente entrar por SSH. Funcionou? Se não, qual mensagem apareceu e por quê?
4. Termine a instância.

## 🧠 Memorize
1. Qual o usuário padrão do Amazon Linux?
2. Por que o Instance Connect costuma funcionar na rede corporativa e o SSH às vezes não?
3. O que faz o `chmod 400` e por que ele é necessário?
4. Perdi o arquivo `.pem`. Consigo baixar de novo?
5. Qual o comando SSH para entrar com a chave `minha.pem` no IP `3.3.3.3`?

<details><summary>👀 Ver respostas</summary>

1. `ec2-user`.
2. O Instance Connect usa a porta 443 (HTTPS), quase sempre liberada. O SSH usa a 22, que redes corporativas costumam bloquear.
3. Deixa a chave só leitura e só para o dono; o `ssh` recusa chaves que outros podem ler.
4. Não. A AWS não guarda a chave privada. Crie outro key pair.
5. `ssh -i minha.pem ec2-user@3.3.3.3`
</details>

➡️ Próxima: [Aula 04 — Um site no ar](04-servidor-web.md)
