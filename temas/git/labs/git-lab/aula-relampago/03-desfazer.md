# Bloco 03 — Desfazer coisas (sem pânico)

## 🎯 Neste bloco
- `git restore`: jogar fora uma mudança que você **não salvou** num commit.
- `git restore --staged`: tirar um arquivo da área de preparação.
- `git commit --amend`: consertar o **último** commit.
- `git revert`: desfazer um commit antigo **com segurança**.
- `.gitignore`: dizer ao Git o que ignorar.

---

## 🗺️ Mapa: "fiz besteira, e agora?"

| Situação | Comando |
|----------|---------|
| Mexi num arquivo e quero **voltar ao último commit** | `git restore arquivo` |
| Dei `git add` sem querer | `git restore --staged arquivo` |
| Errei a **mensagem** ou **esqueci um arquivo** no último commit | `git commit --amend` |
| Um commit antigo estragou algo e quero **desfazer** | `git revert <código>` |
| Não quero que o Git veja certos arquivos | `.gitignore` |

---

## 📖 Aprenda: `git restore arquivo`

Bagunce o `bolo.md` de propósito (apague metade das linhas) e salve.
```bash
$ git status                # modified: bolo.md
$ git restore bolo.md
$ git status                # working tree clean
```
O arquivo voltou a ser **igual ao último commit**. 🪄

> ⚠️ Isso **apaga** as mudanças que você não salvou num commit. Não tem como recuperar. Use quando
> tiver certeza.

## 📖 Aprenda: `git restore --staged arquivo`

Crie um arquivo `senha.txt` com qualquer texto e coloque na preparação **por engano**:
```bash
$ git add .
$ git status                # new file: senha.txt   ← opa!
$ git restore --staged senha.txt
$ git status                # senha.txt voltou para Untracked
```
O `--staged` **só tira da preparação**. O arquivo continua na pasta, intacto.

| Comando | Mexe em |
|---------|---------|
| `git restore arquivo` | O **conteúdo** do arquivo (descarta mudanças) ⚠️ |
| `git restore --staged arquivo` | Só a **preparação** (o conteúdo fica igual) |

---

## 📖 Aprenda: `.gitignore`

Alguns arquivos **nunca** devem ir para o Git: senhas, arquivos `.env` (lembra do Docker?), logs, arquivos temporários.
Crie um arquivo chamado **`.gitignore`** (com o ponto) na raiz do repositório, um padrão por linha:
```
senha.txt
.env
*.log
```
| Padrão | Ignora |
|--------|--------|
| `senha.txt` | Esse arquivo |
| `*.log` | Todo arquivo terminado em `.log` (o `*` significa "qualquer coisa") |
| `temp/` | A pasta `temp` inteira |

```bash
$ git status
```
O `senha.txt` **sumiu** da lista. Mas o `.gitignore` aparece: ele **deve** ir para o repositório, para valer para toda a equipe.
```bash
$ git add .gitignore
$ git commit -m "Adiciona .gitignore"
```
> ⚠️ O `.gitignore` não "esconde" um arquivo que **já foi** commitado. Por isso coloque os arquivos sensíveis
> nele **antes** do primeiro `git add`.

---

## 📖 Aprenda: `git commit --amend`

Conserta o **último** commit. Dois usos:

**Mensagem errada:**
```bash
$ echo "# Brigadeiro" > brigadeiro.md
$ git add brigadeiro.md
$ git commit -m "Adiciona brigadero"         # erro de digitação!
$ git commit --amend -m "Adiciona brigadeiro"
$ git log --oneline
```
O commit errado foi **substituído** (repare que o código mudou).

**Esqueci um arquivo:**
```bash
$ echo "# Beijinho" > beijinho.md
$ git add beijinho.md
$ git commit --amend -m "Adiciona brigadeiro e beijinho"
```
> 💡 O `echo "texto" > arquivo` (do nível 1 do Docker Lab) cria um arquivo com aquele texto. É só um atalho para não
> precisar abrir o VS Code.

> ⚠️ **Só use `--amend` em commits que você ainda não enviou para o servidor** (bloco 06). Reescrever um commit
> que os colegas já têm causa confusão.

## 📖 Aprenda: `git revert`

E se o commit errado for **antigo**, ou já estiver no servidor? O `revert` cria um **commit novo que faz o contrário**
do commit escolhido. Nada é apagado da história, e por isso ele é seguro.

```bash
$ git log --oneline                     # ache o código do commit "Adiciona brigadeiro e beijinho"
$ git revert <código-desse-commit>
```
O Git abre o **VS Code** com uma mensagem pronta (`Revert "..."`). **Salve e feche a aba** para concluir.
```bash
$ git log --oneline
$ ls                                    # brigadeiro.md e beijinho.md sumiram
```
```
2a48747 Revert "Adiciona brigadeiro e beijinho"
9384909 Adiciona brigadeiro e beijinho
...
```
O commit original **continua no histórico**, e o novo commit desfaz o efeito dele.

| | `--amend` | `revert` |
|---|---|---|
| Serve para | O **último** commit | **Qualquer** commit |
| O que faz | **Substitui** o commit | Cria um commit **novo** que desfaz |
| Seguro depois de enviar ao servidor? | ❌ Não | ✅ Sim |

---

## ✍️ Pratique

1. Escreva qualquer coisa no `suco.md`, salve e jogue a mudança fora.
2. Crie um arquivo `debug.log` e uma pasta `temp/` com um arquivo dentro. Faça o Git ignorar **todos** os `.log` e a pasta
   `temp`. Faça o commit do `.gitignore` atualizado.
3. Crie `mousse.md`, faça o commit com a mensagem `mouse` (errada) e conserte a mensagem para `Adiciona receita de mousse`.
4. Desfaça o commit da **mousse** usando o comando seguro. O `mousse.md` ainda existe?
5. Veja no histórico: o commit original da mousse sumiu?

<details><summary>👀 Ver respostas</summary>

1. `git restore suco.md`
2. No `.gitignore`, acrescente:
   ```
   *.log
   temp/
   ```
   ```bash
   $ git status          # debug.log e temp/ não aparecem
   $ git add .gitignore
   $ git commit -m "Ignora logs e pasta temp"
   ```
3. ```bash
   $ git add mousse.md
   $ git commit -m "mouse"
   $ git commit --amend -m "Adiciona receita de mousse"
   ```
4. `git log --oneline` → `git revert <código-do-commit-da-mousse>` → salve e feche a aba do VS Code. O `mousse.md` sumiu.
5. Não sumiu: continua lá, com um commit `Revert "..."` depois dele.
</details>

---

## 🧠 Memorize

1. Como descartar as mudanças não salvas do `index.html`?
2. Como tirar o `index.html` da preparação sem perder o que você mudou?
3. Como corrigir a mensagem do último commit?
4. Como desfazer um commit antigo de forma segura?
5. Qual a diferença entre `--amend` e `revert`?
6. Como fazer o Git ignorar todos os arquivos `.tmp`?
7. Coloquei um arquivo no `.gitignore` depois de já ter commitado ele. Ele sai do Git?

<details><summary>👀 Ver respostas</summary>

1. `git restore index.html`
2. `git restore --staged index.html`
3. `git commit --amend -m "nova mensagem"`
4. `git revert <código>`
5. `--amend` substitui o último commit (não usar depois de enviar); `revert` cria um commit novo que desfaz qualquer commit (seguro).
6. Uma linha `*.tmp` no `.gitignore`.
7. Não. O `.gitignore` só vale para arquivos que ainda não estão no Git.
</details>

☕ **Pausa de 10 minutos!**

➡️ Próximo: [Bloco 04 — Branches](04-branches.md)
