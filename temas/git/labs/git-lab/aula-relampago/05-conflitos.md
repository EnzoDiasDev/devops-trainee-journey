# Bloco 05 — Conflitos: quando duas mudanças brigam

## 🎯 Neste bloco
- Por que conflitos acontecem (e por que não são o fim do mundo).
- Como ler os marcadores `<<<<<<<`, `=======` e `>>>>>>>`.
- Resolver no editor e terminar o merge.
- `git merge --abort`: desistir do merge.

---

## 📖 Aprenda: por que acontece

O Git junta mudanças sozinho quando elas estão em **lugares diferentes**. Mas se duas branches mudaram **a mesma
linha** do mesmo arquivo, ele não tem como adivinhar qual está certa e **pergunta para você**. Isso é um **conflito**.

```
             bolo.md: "- 1 xícara de açúcar"
                 /                        \
 main:  "- meia xícara de açúcar"    doce: "- 2 xícaras de açúcar"
                 \                        /
                   git merge doce → ❓ qual das duas?
```
> Conflito **não é erro**: é o Git sendo honesto e pedindo para um humano decidir. Acontece todo dia em equipes.

---

## 📖 Mão na massa: provocando um conflito

```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica/receitas
$ git switch main
```
No `bolo.md`, acrescente a linha `- 1 xícara de açúcar` logo depois de `- 3 cenouras`, salve e faça o commit:
```bash
$ git add bolo.md
$ git commit -m "Adiciona açúcar ao bolo"
```

**Na branch `doce`**, mude para 2 xícaras:
```bash
$ git switch -c doce
```
No VS Code, troque a linha por `- 2 xícaras de açúcar` e salve.
```bash
$ git commit -am "Aumenta o açúcar do bolo"
```
> O `-am` junta duas coisas: `-a` adiciona **todos os arquivos já rastreados** que mudaram (sem precisar do `git add`) e
> `-m` é a mensagem. Atenção: o `-a` não pega arquivos **novos** (`Untracked`). Para esses, continue usando `git add`.

**Na `main`**, mude a mesma linha para meia xícara:
```bash
$ git switch main
```
Troque a linha por `- meia xícara de açúcar` e salve.
```bash
$ git commit -am "Diminui o açúcar do bolo"
```
**O merge:**
```bash
$ git merge doce
```
```
Auto-merging bolo.md
CONFLICT (content): Merge conflict in bolo.md
Automatic merge failed; fix conflicts and then commit the result.
```
"Conflito no `bolo.md`. O merge automático falhou: resolva os conflitos e faça o commit do resultado."

```bash
$ git status
```
```
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
	both modified:   bolo.md
```
`both modified` = os **dois lados** mexeram nesse arquivo.

---

## 📖 Aprenda: lendo o conflito

Abra o `bolo.md`:
```
# Bolo de cenoura
- 3 cenouras
<<<<<<< HEAD
- meia xícara de açúcar
=======
- 2 xícaras de açúcar
>>>>>>> doce
- 3 ovos
```
| Marcador | Significa |
|----------|-----------|
| `<<<<<<< HEAD` | Começo da **sua** versão (a da branch onde você está, a `main`) |
| `=======` | Divisória |
| `>>>>>>> doce` | Fim da versão **que está chegando** (da branch `doce`) |

## 📖 Aprenda: resolvendo

**1. Edite o arquivo** deixando do jeito que deve ficar e **apague os três marcadores**. Pode escolher uma versão,
a outra, ou uma mistura:
```
# Bolo de cenoura
- 3 cenouras
- 1 xícara e meia de açúcar
- 3 ovos
```
> 💡 O VS Code mostra botões em cima do conflito: **Accept Current Change** (a sua), **Accept Incoming Change** (a
> que chega) e **Accept Both Changes** (as duas). Eles ajudam, mas confira o resultado e **salve**.

**2. Avise o Git que resolveu** com o `git add`:
```bash
$ git add bolo.md
```
**3. Termine o merge** com um commit (o VS Code abre com a mensagem pronta: salve e feche a aba):
```bash
$ git commit
```
```bash
$ git log --oneline --graph --all
```
Conflito resolvido. ✅

> ⚠️ Antes do `git add`, confira que **nenhum marcador** (`<<<<<<<`, `=======`, `>>>>>>>`) sobrou no arquivo.
> Esquecer um marcador é o erro mais comum, e ele vai parar no commit.

---

## 📖 Aprenda: `git merge --abort`

Começou o merge, deu conflito e você quer **desistir** e voltar para como estava antes?
```bash
$ git merge --abort
```
Tudo volta ao estado de antes do `git merge`. Útil quando o conflito é grande e você quer conversar com a equipe antes.

---

## ✍️ Pratique

1. Crie um conflito no `suco.md` (ou em qualquer receita): na branch `gelado`, mude uma linha; na `main`, mude **a
   mesma linha** de outro jeito. Faça o merge.
2. Rode `git status` e identifique o arquivo em conflito.
3. Desista do merge. Confira com `git status` que voltou ao normal.
4. Faça o merge de novo e, desta vez, resolva ficando com **as duas** versões (uma linha embaixo da outra).
5. Termine o merge e confira o mapa das branches.
6. Apague as branches `doce` e `gelado`.

<details><summary>👀 Ver respostas</summary>

1. ```bash
   $ git switch -c gelado
   # edite uma linha do suco.md e salve
   $ git commit -am "Suco gelado"
   $ git switch main
   # edite a MESMA linha de outro jeito e salve
   $ git commit -am "Suco natural"
   $ git merge gelado
   ```
2. `git status` → `both modified: suco.md`
3. `git merge --abort` e `git status` (`working tree clean`).
4. `git merge gelado` → no `suco.md`, deixe as duas linhas e apague `<<<<<<<`, `=======` e `>>>>>>>`. Salve.
5. ```bash
   $ git add suco.md
   $ git commit            # salve e feche a aba
   $ git log --oneline --graph --all
   ```
6. `git branch -d doce gelado`
</details>

---

## 🧠 Memorize

1. Quando acontece um conflito?
2. O que fica entre `<<<<<<< HEAD` e `=======`? E entre `=======` e `>>>>>>>`?
3. Quais são os 3 passos para resolver um conflito?
4. Como desistir de um merge com conflito?
5. O que faz o `git commit -am "msg"`? Ele pega arquivos novos?
6. Qual o erro mais comum ao resolver conflitos?

<details><summary>👀 Ver respostas</summary>

1. Quando duas branches mudaram a mesma parte do mesmo arquivo.
2. A sua versão (branch atual) · a versão que está chegando (a outra branch).
3. Editar o arquivo (e apagar os marcadores) → `git add arquivo` → `git commit`.
4. `git merge --abort`
5. Adiciona todos os arquivos já rastreados que mudaram e faz o commit. Não pega arquivos novos (`Untracked`).
6. Esquecer marcadores (`<<<<<<<`...) no arquivo.
</details>

☕ **Pausa de 10 minutos!** A segunda metade é sobre trabalhar com o servidor (GitLab).

➡️ Próximo: [Bloco 06 — Servidor: enviar e receber](06-remoto.md)
