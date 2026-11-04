# Bloco 01 — Salvar versões (commits)

## 🎯 Neste bloco
- `git init`: transformar uma pasta em repositório.
- `git status`: "o que está acontecendo?" (o comando mais importante do Git).
- `git add` e `git commit`: tirar uma fotografia.
- `git log`: ver o histórico.
- As **três áreas** do Git.

---

## 📖 Aprenda: `git init`

```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica
$ mkdir receitas
$ cd receitas
$ git init
```
```
Initialized empty Git repository in .../receitas/.git/
```
"Repositório vazio criado". O Git criou uma pasta **escondida** chamada `.git`, onde guarda todo o histórico.
Veja com `ls -a` (o `-a` mostra arquivos escondidos, que começam com ponto).

> ⚠️ **Nunca mexa na pasta `.git`.** Apagar ela = apagar todo o histórico.

---

## 📖 Aprenda: `git status`

Pergunta ao Git: "como estão as coisas?". **Use o tempo todo.**
```bash
$ git status
```
```
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```
| Mensagem | Tradução |
|----------|----------|
| `On branch main` | Você está na branch `main` |
| `No commits yet` | Ainda não há nenhuma fotografia |
| `nothing to commit` | Nada para salvar |

Abra a pasta no VS Code (`code .`), crie o arquivo **`bolo.md`** com o texto `# Bolo de cenoura`, salve e rode de novo:
```bash
$ git status
```
```
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	bolo.md
```
`Untracked files` = **arquivos não rastreados**: o Git viu o arquivo, mas ainda não está cuidando dele.

---

## 📖 Aprenda: as três áreas

Esta é a ideia mais importante do bloco. Pense numa **sessão de fotos**:

```
  ① Pasta de trabalho       ② Área de preparação         ③ Repositório
     (o "palco")               (staging: "quem vai          (o "álbum de
                                sair na foto")               fotos": commits)
  ┌───────────────┐  git add  ┌───────────────┐  git commit  ┌───────────────┐
  │ seus arquivos │ ────────► │ mudanças      │ ───────────► │ fotografias   │
  │ como estão    │           │ escolhidas    │              │ guardadas     │
  └───────────────┘           └───────────────┘              └───────────────┘
```
- **① Pasta de trabalho**: seus arquivos, do jeito que estão agora.
- **② Área de preparação (staging)**: você escolhe **o que vai entrar** na próxima foto.
- **③ Repositório**: as fotos tiradas (commits), guardadas para sempre.

Por que existe o passo ②? Porque às vezes você mexeu em 5 arquivos, mas quer fazer **uma foto só com 2 deles**
(por exemplo, separar "correção do bug" de "novo recurso").

---

## 📖 Aprenda: `git add` (colocar na área de preparação)

```bash
$ git add bolo.md
$ git status
```
```
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   bolo.md
```
`Changes to be committed` = "mudanças que **vão entrar** na próxima foto". `new file` = arquivo novo.

| Comando | O que adiciona |
|---------|----------------|
| `git add bolo.md` | Só esse arquivo |
| `git add bolo.md suco.md` | Esses dois |
| `git add .` | **Tudo** que mudou nesta pasta (e subpastas) |

## 📖 Aprenda: `git commit` (tirar a foto)

```bash
$ git commit -m "Adiciona receita de bolo de cenoura"
```
```
[main (root-commit) 8fb72ac] Adiciona receita de bolo de cenoura
 1 file changed, 1 insertion(+)
 create mode 100644 bolo.md
```
- `-m "..."` = a **mensagem** do commit (*message*). Ela diz **o que** a foto contém.
- `8fb72ac` = o **código** (hash) do commit. Cada commit tem um código único.

```bash
$ git status
```
`nothing to commit, working tree clean` = tudo salvo, nada pendente. ✨

### Boas mensagens de commit
| ❌ Ruim | ✅ Boa |
|--------|-------|
| `ajustes` | `Corrige quantidade de açúcar do bolo` |
| `teste` | `Adiciona receita de suco de laranja` |
| `asdasd` | `Remove receita duplicada de pão` |

Regra prática: complete a frase **"Este commit..."** → "...adiciona receita de suco". Use o verbo no presente.

---

## 📖 Aprenda: `git log` (o histórico)

```bash
$ git log
```
Mostra cada commit com código completo, autor, data e mensagem. Se a lista for grande, aperte **`q`** para sair.

A versão resumida, uma linha por commit, é a que você vai usar mais:
```bash
$ git log --oneline
```
```
8fb72ac Adiciona receita de bolo de cenoura
```

---

## ✍️ Pratique

1. Edite o `bolo.md` acrescentando duas linhas: `- 3 cenouras` e `- 2 ovos`. Salve e rode `git status`.
   Qual mensagem aparece? (Dica: é diferente de `Untracked`.)
2. Faça o commit dessa mudança com uma boa mensagem.
3. Crie dois arquivos novos: `suco.md` (`# Suco de laranja`) e `pao.md` (`# Pão caseiro`).
4. Faça **um commit só com o `suco.md`**. Confira com `git status` que o `pao.md` ficou de fora.
5. Agora faça o commit do `pao.md`.
6. Mostre o histórico resumido. Quantos commits existem?

<details><summary>👀 Ver respostas</summary>

1. `git status` → `Changes not staged for commit: modified: bolo.md`, ou seja, "mudanças que **ainda não foram** para a
   área de preparação". O arquivo já é rastreado; só mudou.
2. ```bash
   $ git add bolo.md
   $ git commit -m "Adiciona ingredientes do bolo"
   ```
3. Crie os arquivos no VS Code e salve.
4. ```bash
   $ git add suco.md
   $ git commit -m "Adiciona receita de suco de laranja"
   $ git status          # pao.md aparece em Untracked files
   ```
5. ```bash
   $ git add pao.md
   $ git commit -m "Adiciona receita de pão caseiro"
   ```
6. `git log --oneline` → 4 commits.
</details>

---

## 🧠 Memorize

1. Como criar um repositório na pasta atual?
2. Qual comando mostra o que está acontecendo?
3. Quais são as três áreas do Git?
4. Como colocar **todas** as mudanças na área de preparação?
5. Como fazer um commit com a mensagem "Adiciona README"?
6. Como ver o histórico resumido?
7. `Untracked files`, `Changes not staged for commit` e `Changes to be committed`: o que significa cada um?

<details><summary>👀 Ver respostas</summary>

1. `git init`
2. `git status`
3. Pasta de trabalho → área de preparação (staging) → repositório.
4. `git add .`
5. `git commit -m "Adiciona README"`
6. `git log --oneline`
7. Arquivo novo que o Git ainda não rastreia · arquivo rastreado que mudou, mas não foi para a preparação · mudanças prontas para entrar no próximo commit.
</details>

➡️ Próximo: [Bloco 02 — Ver o que mudou](02-ver-mudancas.md)
