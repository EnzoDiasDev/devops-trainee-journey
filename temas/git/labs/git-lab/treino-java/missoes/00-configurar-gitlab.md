# Missão 00 — Configurar o acesso ao GitLab 🟢

## 🎯 Nesta missão
- Fazer o seu computador falar com o GitLab por **SSH**, sem digitar senha.
- Criar um **projeto vazio** seu no GitLab.
- Enviar o Enzo Bank para lá com o `preparar.sh`.

> Os nomes dos menus do GitLab podem variar um pouco conforme a versão. Se não achar algo, procure pelo ícone ou
> use a busca do próprio GitLab.

---

## 📖 Aprenda: por que SSH?

O seu GitLab (`http://gitlab.example.com`) aceita duas formas de `clone`/`push`:

| Forma | Endereço | Como se identifica |
|-------|----------|--------------------|
| HTTP | `http://gitlab.example.com/usuario/projeto.git` | Usuário + senha/token **a cada push** (ou salvos no PC) |
| **SSH** ✅ | `ssh://git@gitlab.example.com:2222/usuario/projeto.git` | Uma **chave SSH**, configurada uma vez |

> ⚠️ **Porta 2222!** Neste exemplo, o GitLab roda num container, e o SSH dele atende na porta **2222**. A porta 22 (a padrão)
> é o SSH do **servidor que hospeda o container**, e não o do GitLab. Por isso a URL usa o formato `ssh://...:2222/...`.
> Se o seu GitLab usa a porta padrão (como o `gitlab.com`), ignore o `:2222` em todas as URLs e comandos desta missão.

Uma chave SSH é um **par de arquivos**:
- **chave privada** (`~/.ssh/id_ed25519`): fica **só** no seu computador. 🔒 **Nunca compartilhe.**
- **chave pública** (`~/.ssh/id_ed25519.pub`): você **cadastra no GitLab**. Ela não é secreta.

Quando você dá `push`, o GitLab confere se a sua chave privada "combina" com a pública cadastrada. Se combinar, é você.

> Você **já tem** uma chave (`~/.ssh/id_ed25519`). Não precisa criar outra.

---

## 🛠️ Passo 1: cadastrar a chave pública no GitLab

**1.** Mostre a sua chave **pública** e copie a linha inteira (começa com `ssh-ed25519`):
```bash
$ cat ~/.ssh/id_ed25519.pub
```
> ⚠️ Confira que é o arquivo **`.pub`**. A chave sem `.pub` é a privada e não deve ser copiada para lugar nenhum.

**2.** No GitLab: clique na sua **foto** (canto superior) → **Edit profile** (ou *Preferences*) → **SSH Keys** → **Add new key**.
Cole a chave, dê um título (ex.: `Notebook WSL`) e salve.
Se aparecer que a chave **já existe**, ótimo: ela já está cadastrada.

## 🛠️ Passo 2: testar a conexão
```bash
$ ssh -T -p 2222 git@gitlab.example.com
```
(`-p 2222` = usar a porta 2222; `-T` = só testar, sem abrir um terminal.)

Na **primeira vez**, aparece:
```
The authenticity of host '[gitlab.example.com]:2222 ([10.0.0.10]:2222)' can't be established.
ED25519 key fingerprint is SHA256:KMeZ10k/d6J5sCNz+ZHQdX+0FinWQIp5EzUSlRg07zU.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
É o seu computador dizendo "nunca falei com esse servidor; confirma que é ele mesmo?". O jeito mais seguro é comparar
essa *fingerprint* com a que a equipe de infra divulga. Se estiver tudo certo, digite **`yes`** e `Enter`.
O computador guarda isso em `~/.ssh/known_hosts` e não pergunta mais.

Resultado esperado:
```
Welcome to GitLab, @seu.usuario!
```
🎉 Funcionou.

| Se aparecer | Significa |
|-------------|-----------|
| `Permission denied (publickey)` | A chave não está cadastrada no GitLab (ou você colou a errada). Refaça o passo 1 |
| `Permission denied (publickey,gssapi-keyex,gssapi-with-mic)` | Você caiu na **porta 22** (o servidor, e não o GitLab). Faltou o `-p 2222` ou a URL está no formato errado |
| `Connection timed out` | O GitLab não está acessível: está na rede corporativa ou na VPN? |

---

## 🛠️ Passo 3: criar o projeto vazio

No GitLab: **New project** → **Create blank project**:
- **Project name:** `enzo-bank`
- **Visibility:** `Private`
- ❗ **DESMARQUE** *"Initialize repository with a README"*. O projeto precisa nascer **vazio**.
- **Create project**.

O GitLab mostra uma página com instruções. Procure o botão **Clone** (ou a seção de comandos) e copie a URL
**SSH**. Ela deve ficar assim (com `ssh://` e a porta 2222):
```
ssh://git@gitlab.example.com:2222/seu.usuario/enzo-bank.git
```
> ⚠️ **Não** use `git@gitlab.example.com:2222/...` (sem o `ssh://`). Nesse formato o Git entende `2222` como o
> nome de uma pasta, ignora a porta e conecta na 22. O `preparar.sh` avisa se você usar esse formato.

## 🛠️ Passo 4: preparar o treino
```bash
$ cd ~/Projects/git-lab/treino-java
$ ./preparar.sh ssh://git@gitlab.example.com:2222/seu.usuario/enzo-bank.git
```
(Use a URL que **você** copiou.) O script:
1. confere o acesso ao projeto (e se ele está vazio);
2. monta o histórico da equipe (Ana e Bruno) e envia para o GitLab;
3. liga a **produção local** em http://localhost:8090.

**Atualize a página do projeto no GitLab:** os arquivos e os commits apareceram! 🦊

---

## ✅ Pronto quando
- [ ] `ssh -T -p 2222 git@gitlab.example.com` responde `Welcome to GitLab`.
- [ ] O projeto `enzo-bank` no GitLab mostra os arquivos (`src/`, `Dockerfile`, `compose.yaml`, `README.md`).
- [ ] http://localhost:8090 mostra o Enzo Bank.

## 🧠 Memorize
1. Qual chave vai para o GitLab: a pública ou a privada?
2. Qual a diferença entre as URLs HTTP e SSH de um projeto?
3. O que significa a pergunta `Are you sure you want to continue connecting`?

<details><summary>👀 Respostas</summary>

1. A **pública** (`.pub`). A privada nunca sai do seu computador.
2. HTTP (`http://servidor/usuario/projeto.git`) pede usuário e senha/token; SSH
   (`ssh://git@servidor:2222/usuario/projeto.git`) usa a chave SSH.
3. É a primeira conexão com aquele servidor: o computador pede para você confirmar que é o servidor certo.
</details>

➡️ [Missão 01](01-primeiro-dia.md)
