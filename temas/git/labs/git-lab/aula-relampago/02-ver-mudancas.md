# Bloco 02 — Ver o que mudou

## 🎯 Neste bloco
- `git diff`: o que mudou e **ainda não** foi para a preparação.
- `git diff --staged`: o que **já está** na preparação.
- `git show`: o que um commit mudou.
- Ver as mudanças pelo VS Code.

Continue no repositório `receitas`.

---

## 📖 Aprenda: `git diff`

Edite o `bolo.md`: troque `- 2 ovos` por `- 3 ovos` e acrescente `- 1 xícara de óleo`. Salve.
```bash
$ git diff
```
```diff
diff --git a/bolo.md b/bolo.md
--- a/bolo.md
+++ b/bolo.md
@@ -1,3 +1,4 @@
 # Bolo de cenoura
 - 3 cenouras
-- 2 ovos
+- 3 ovos
+- 1 xícara de óleo
```
Como ler:
| Linha começa com | Significa |
|------------------|-----------|
| `-` (vermelho) | Linha **removida** |
| `+` (verde) | Linha **adicionada** |
| espaço | Linha que não mudou (aparece só para dar contexto) |
| `--- a/` e `+++ b/` | "antes" (`a`) e "depois" (`b`) do arquivo |
| `@@ -1,3 +1,4 @@` | Em que linhas a mudança está (pode ignorar) |

> Uma linha **alterada** aparece como uma removida (`-`) seguida de uma adicionada (`+`).

## 📖 Aprenda: `git diff --staged`

```bash
$ git add bolo.md
$ git diff
```
Não mostra nada! O `git diff` sozinho mostra só o que **não** está na preparação. Para ver o que **está**:
```bash
$ git diff --staged
```
```
  ① Pasta de trabalho        ② Preparação           ③ Repositório
          └──── git diff ────────┘
                                 └── git diff --staged ──┘
```
> 💡 **Hábito de ouro:** antes de todo commit, rode `git diff --staged` para conferir o que vai entrar.

Faça o commit:
```bash
$ git commit -m "Ajusta ovos e adiciona óleo ao bolo"
```

## 📖 Aprenda: `git show`

Mostra **o que um commit mudou**:
```bash
$ git show                  # o último commit
$ git log --oneline         # copie o código de um commit antigo
$ git show 8fb72ac          # troque pelo código que apareceu para você
```
Assim como no Docker, basta o começo do código (os 7 caracteres do `--oneline` são suficientes).

---

## 📖 Aprenda: pelo VS Code

O VS Code entende Git. Na barra lateral esquerda, clique no ícone **Source Control** (o de "galhos", ou `Ctrl + Shift + G`):
- arquivos modificados aparecem com **M**, novos com **U** (*untracked*);
- clicando num arquivo, abre a comparação **antes × depois**, lado a lado.

> Use o VS Code para **visualizar**, mas continue fazendo os comandos no terminal durante a aula: é o que fixa.

---

## ✍️ Pratique

1. No `suco.md`, acrescente `- 4 laranjas` e `- gelo a gosto`. Veja a diferença no terminal.
2. Coloque na preparação. Prove que o `git diff` sozinho fica vazio e veja a diferença com a opção certa.
3. Faça o commit.
4. Mostre o que mudou no commit **anterior ao último** (use o `git log --oneline` para achar o código).
5. Mude uma linha do `pao.md` e abra a comparação pelo VS Code. Depois faça o commit.

<details><summary>👀 Ver respostas</summary>

1. `git diff`
2. ```bash
   $ git add suco.md
   $ git diff               # vazio
   $ git diff --staged
   ```
3. `git commit -m "Adiciona ingredientes do suco"`
4. `git log --oneline` → copie o código da segunda linha → `git show <código>`
5. `Ctrl + Shift + G` no VS Code → clique no `pao.md`. Depois `git add pao.md` e `git commit -m "..."`.
</details>

---

## 🧠 Memorize

1. O que mostra o `git diff`?
2. E o `git diff --staged`?
3. No diff, o que significam as linhas com `-` e `+`?
4. Como ver o que mudou no commit `a1b2c3d`?
5. Qual o hábito de ouro antes de cada commit?

<details><summary>👀 Ver respostas</summary>

1. As mudanças que ainda **não** estão na área de preparação.
2. As mudanças que **estão** na preparação (vão entrar no próximo commit).
3. `-` linha removida; `+` linha adicionada.
4. `git show a1b2c3d`
5. Conferir com `git diff --staged`.
</details>

➡️ Próximo: [Bloco 03 — Desfazer coisas](03-desfazer.md)
