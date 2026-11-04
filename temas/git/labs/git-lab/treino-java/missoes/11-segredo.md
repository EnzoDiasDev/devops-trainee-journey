# Missão 11 — O token está no `compose.yaml`! 🟠

## 🎫 Ticket (crie como Issue)
> **Título:** Token de administrador exposto no repositório
> **Descrição:** O token da rota `/admin/contas` (`segredo123`) está escrito direto no `compose.yaml`. Mover para um
> `.env` fora do Git, com um `.env.example` de modelo.

Teste antes: http://localhost:8070/admin/contas?token=segredo123 lista as contas do seu ambiente.

## 🎯 Você vai treinar
**Git:** `restore --staged`, `.gitignore`, `rm --cached` (novo), `--amend --no-edit` (novo) · **Docker:** `.env` + `${VAR}`

---

## 🛠️ Parte A: pegando o erro **antes** do commit

**1.** Crie a Issue. Atualize a `main` e crie **`chore/token-no-env`**.

**2.** No `compose.yaml`, troque `TOKEN_ADMIN: segredo123` por:
```yaml
      TOKEN_ADMIN: ${TOKEN_ADMIN}
```
Crie o **`.env`** (o real, secreto): `TOKEN_ADMIN=meu-token-local`
E o **`.env.example`** (o modelo, vai para o Git): `TOKEN_ADMIN=troque-por-um-token`

**3.** Distraído, você dá `git add .`. Rode `git status`: **o `.env` está na preparação!** 😱

**4.** Tire **só** o `.env` da preparação, faça o Git ignorá-lo (no `.gitignore`) e faça o commit do `compose.yaml`,
`.env.example` e `.gitignore`.

**5.** Confira e teste:
```bash
$ docker compose config          # procure TOKEN_ADMIN: meu-token-local
$ docker compose up -d
```
http://localhost:8070/admin/contas?token=meu-token-local ✅ · ...?token=segredo123 ❌

<details><summary>👀 Comandos da parte A</summary>

```bash
$ git switch main && git pull
$ git switch -c chore/token-no-env
# edite o compose.yaml, crie .env e .env.example
$ git add .
$ git status                                   # new file: .env 😱
$ git restore --staged .env
# acrescente a linha  .env  no .gitignore
$ git add .gitignore .env.example compose.yaml
$ git commit -m "Move o token de administrador para o arquivo .env"
$ docker compose config
$ docker compose up -d
```
</details>

---

## 🛠️ Parte B: pegando o erro **depois** do commit (antes do push)

**6.** O Bruno te mandou o token de produção no chat e você salvou num arquivo **`token-producao.txt`** na pasta do
projeto, "para não perder". Crie esse arquivo com qualquer texto.

**7.** Acrescente no final do `README.md`:
```markdown

## Token de administrador
O token fica no arquivo `.env` (veja o `.env.example`).
```
**8.** `git add .` e commit `Documenta onde fica o token de administrador`. Confira **o que entrou**:
```bash
$ git show --stat
```
> 📖 `--stat` mostra só a **lista de arquivos** do commit.

O `token-producao.txt` entrou! 😱 Ainda não foi enviado, então dá para consertar sem deixar rastro.

## 📖 Novo: `git rm --cached` e `--amend --no-edit`
| Comando | O que faz |
|---------|-----------|
| `git rm --cached arquivo` | Tira o arquivo **do Git**, mas **mantém** ele na sua pasta |
| `git commit --amend --no-edit` | Refaz o último commit com o que está na preparação, **mantendo a mensagem** |

> `git restore --staged` (parte A) é para um arquivo **ainda não commitado**. Depois do commit: `rm --cached` + `--amend`.

**9.** Conserte: tire o arquivo do Git, coloque-o no `.gitignore`, prepare o `.gitignore`, refaça o commit mantendo a
mensagem e confira com `git show --stat` e `ls`.

**10.** Push, MR com `Closes #N`, revisor, Merge, deploy, limpar. Teste a produção:
- http://localhost:8090/admin/contas?token=segredo123 → recusado ✅
- http://localhost:8090/admin/contas?token=token-de-producao → funciona (é o `.env` da produção)

<details><summary>👀 Comandos da parte B</summary>

```bash
$ git add .
$ git commit -m "Documenta onde fica o token de administrador"
$ git show --stat                            # token-producao.txt 😱
$ git rm --cached token-producao.txt
# acrescente a linha  token-producao.txt  no .gitignore
$ git add .gitignore
$ git commit --amend --no-edit
$ git show --stat                            # só .gitignore e README.md
$ git push -u origin chore/token-no-env
# MR → ../../revisor.sh chore/token-no-env → Merge → ../../deploy.sh
$ git switch main && git pull
$ git branch -d chore/token-no-env && git fetch --prune
```
</details>

---

## ⚠️ O `segredo123` continua no histórico
Abra no GitLab o commit em que o Bruno criou o `compose.yaml`: o token está lá, para quem tiver acesso ao projeto.
**O que entra no histórico fica no histórico.** Por isso, segredo que vazou precisa ser **trocado**, e não só apagado.

## ✅ Pronto quando
- [ ] O token antigo não funciona mais em produção e a Issue fechou.
- [ ] `git status` não mostra `.env` nem `token-producao.txt`, mas os dois existem na sua pasta.

➡️ [Missão 12](12-detetive.md)
