# Missão 02 — Seu primeiro Merge Request 🟢

## 🎫 Ticket
> **De:** Bruno
> Dois problemas:
> 1. Quando alguém compila com `javac`, os `.class` aparecem no `git status`.
> 2. O `COPY . .` do Dockerfile leva **tudo** para dentro da imagem, inclusive a pasta `.git` com o histórico inteiro! 😱
>
> Resolve os dois numa branch e abre um MR.

## 🎯 Você vai treinar
**Git:** `.gitignore`, o ciclo completo · **GitLab:** criar um MR, acompanhar, clicar em Merge · **Docker:** `.dockerignore`

---

## 📖 Novo: `.dockerignore` e `docker compose run`

O **`.dockerignore`** é o `.gitignore` do Docker: lista o que **não** deve ir para a imagem no `COPY`.

| Arquivo | Protege |
|---------|---------|
| `.gitignore` | O que **não vai para o Git** |
| `.dockerignore` | O que **não vai para a imagem Docker** |

O **`docker compose run --rm api <comando>`** cria um container temporário do serviço `api` e roda o comando no lugar
do `CMD`. Com `--build`, reconstrói a imagem antes.

---

## 🛠️ Parte 1: o código

Dentro de `area/enzo-bank`:

**1. Veja os problemas:**
```bash
$ javac -d out src/*.java              # compila (gera out/ com os .class)
$ git status                           # problema 1
$ docker compose run --rm api ls -a    # problema 2: procure o .git
```
**2.** Comece atualizado e crie a branch **`chore/ignorar-arquivos`**.

**3.** Crie o **`.gitignore`**:
```
out/
*.class
dados/
```
E o **`.dockerignore`**:
```
.git
out/
dados/
.env
```
**4.** Confira que o `out/` sumiu do `git status` e o `.git` sumiu da imagem (`docker compose run --rm --build api ls -a`).

**5.** Faça **um commit** com os dois arquivos e envie a branch. **Leia a resposta do `git push`:**
```
remote: To create a merge request for chore/ignorar-arquivos, visit:
remote:   http://gitlab.example.com/seu.usuario/enzo-bank/-/merge_requests/new?merge_request%5Bsource_branch%5D=chore%2Fignorar-arquivos
```
O GitLab mandou o link para abrir o MR! 🦊

<details><summary>👀 Comandos da parte 1</summary>

```bash
$ git switch main && git pull
$ git switch -c chore/ignorar-arquivos
# crie .gitignore e .dockerignore
$ git status
$ docker compose run --rm --build api ls -a
$ git add .gitignore .dockerignore
$ git commit -m "Ignora arquivos compilados e dados locais no Git e no Docker"
$ git push -u origin chore/ignorar-arquivos
```
</details>

---

## 🛠️ Parte 2: o Merge Request no GitLab

**6. Abra o MR.** Clique no link do push (no terminal, `Ctrl + clique`) ou, no GitLab, vá em **Merge requests → New
merge request**, escolha a branch `chore/ignorar-arquivos` como origem e a `main` como destino.

**7. Preencha:**
- **Title:** o GitLab sugere a mensagem do commit. Pode manter.
- **Description:** explique em 1 ou 2 frases **o que** e **por que**. Ex.:
  > Ignora `out/`, `*.class` e `dados/` no Git, e tira `.git`, `out/`, `dados/` e `.env` da imagem Docker, que estava levando o histórico inteiro.
- Confirme que **Delete source branch when merge request is accepted** está marcado.
- **Create merge request**.

**8. Explore a página do MR** (as abas podem estar no topo):
| Aba | Mostra |
|-----|--------|
| **Overview** | Descrição, status, botão de Merge, comentários |
| **Commits** | Os commits da branch |
| **Changes** | O diff de tudo que muda (igual a um `git diff main...branch`) |

**9. Peça a revisão do Bruno:**
```bash
$ ../../revisor.sh chore/ignorar-arquivos
```
Ele confere as mensagens, os arquivos, se há conflito, **constrói a imagem** e **roda os testes no container**.

**10. Aprovado?** Volte ao MR no GitLab e clique em **Merge**. 🎉 A página mostra **Merged**, e a branch foi apagada no GitLab.

**11. Publique e atualize o seu computador:**
```bash
$ ../../deploy.sh
$ git switch main
$ git pull
$ git branch -d chore/ignorar-arquivos
$ git fetch --prune
```
No GitLab, em **Code → Repository graph**, aparece o seu merge na `main`. 🚀

---

## ✅ Pronto quando
- [ ] O MR aparece como **Merged** no GitLab (em **Merge requests → Merged**).
- [ ] `git branch -a` não mostra mais a `chore/ignorar-arquivos` (nem a local nem a `remotes/origin/...`).
- [ ] O deploy foi feito.

## 🧠 Reflexão
Num time de verdade, quem clicaria em Merge: você ou o revisor?
<details><summary>👀 Resposta</summary>
Depende da equipe. Muitas vezes quem revisa aprova (botão <b>Approve</b>) e quem abriu faz o Merge; em outras o revisor faz
tudo. O importante é que <b>alguém além de você</b> olhou o código. Aqui o "alguém" é o <code>revisor.sh</code>.
</details>

➡️ [Missão 03](03-issue-bug-saque.md)
