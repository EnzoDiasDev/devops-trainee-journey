# Bloco 04 — Branches: trabalhar sem atrapalhar

## 🎯 Neste bloco
- O que é uma branch e por que usar.
- `git branch`, `git switch`, `git switch -c`: listar, trocar e criar branches.
- `git merge`: juntar uma branch na outra.
- `git log --oneline --graph --all`: ver o "mapa" das branches.
- `git branch -d`: apagar uma branch.

---

## 📖 Aprenda: o que é uma branch

Uma **branch** é uma **linha do tempo paralela**. Você cria uma, faz commits nela à vontade, e a `main` (a versão
"oficial") **não é afetada** até você decidir juntar.

```
main:      A ── B ── C ─────────────── M     ← a versão oficial segue intacta
                      \               /
nova-receita:          D ── E ── F ──┘      ← você trabalha aqui com calma
```
Por que isso importa no trabalho:
- Cada tarefa (um recurso novo, uma correção) ganha a **sua** branch.
- Se a ideia não der certo, é só apagar a branch. A `main` nem ficou sabendo.
- Várias pessoas trabalham ao mesmo tempo, cada uma na sua branch, sem se atropelar.

---

## 📖 Aprenda: listar, criar e trocar

| Comando | O que faz |
|---------|-----------|
| `git branch` | Lista as branches. A atual aparece com `*` |
| `git switch -c nome` | **Cria** uma branch nova e já **troca** para ela (`-c` = *create*) |
| `git switch nome` | **Troca** para uma branch que já existe |

```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica/receitas
$ git branch
$ git switch -c sobremesas
$ git branch
```
```
  main
* sobremesas
```
Agora faça commits **nesta branch**:
```bash
$ echo "# Pudim" > pudim.md
$ git add pudim.md
$ git commit -m "Adiciona receita de pudim"
$ ls
```
Agora volte para a `main` e olhe de novo:
```bash
$ git switch main
$ ls
```
**O `pudim.md` sumiu!** 😮 Calma: ele existe só na linha do tempo `sobremesas`. Trocar de branch muda os arquivos da
pasta para o estado daquela branch. Volte e confira:
```bash
$ git switch sobremesas
$ ls                        # o pudim voltou
```

> ⚠️ Antes de trocar de branch, faça commit (ou guarde) as mudanças pendentes. Se houver mudanças que
> conflitam, o Git **recusa** a troca para não perder nada (o bloco 07 mostra como "guardar" mudanças).

---

## 📖 Aprenda: `git log --oneline --graph --all`

O "mapa" de todas as branches:
```bash
$ git log --oneline --graph --all
```
```
* 7c1d9e2 (HEAD -> sobremesas) Adiciona receita de pudim
* 0dd2bff (main) Adiciona .gitignore
* ...
```
- `(HEAD -> sobremesas)` = **você está aqui**. `HEAD` é o "você está aqui" do Git.
- `(main)` = onde a branch `main` está.

> 💡 É um comando comprido, mas vale a pena decorar. É o melhor jeito de entender onde você está.

---

## 📖 Aprenda: `git merge`

Para **trazer** os commits de uma branch para outra: vá para a branch que vai **receber** e chame o merge da outra.
```bash
$ git switch main               # 1) vá para quem RECEBE
$ git merge sobremesas          # 2) traga as mudanças da sobremesas
```
```
Updating 0dd2bff..7c1d9e2
Fast-forward
 pudim.md | 1 +
```
`Fast-forward` = "avanço rápido": a `main` não tinha nada de novo, então o Git só **adiantou** ela até o último commit
da `sobremesas`. Agora o `pudim.md` existe na `main`.

### Merge com as duas branches andando
Quando **as duas** branches têm commits novos, o Git cria um **commit de merge** que junta as duas linhas:
```bash
$ git switch -c salgados
$ echo "# Coxinha" > coxinha.md
$ git add coxinha.md
$ git commit -m "Adiciona receita de coxinha"

$ git switch main
$ echo "# Limonada" > limonada.md
$ git add limonada.md
$ git commit -m "Adiciona receita de limonada"

$ git merge salgados
```
O Git abre o **VS Code** com a mensagem `Merge branch 'salgados'`. **Salve e feche a aba.**
```bash
$ git log --oneline --graph --all
```
```
*   19dc25f (HEAD -> main) Merge branch 'salgados'
|\
| * 4c7f4a7 (salgados) Adiciona receita de coxinha
* | 5ec6e79 Adiciona receita de limonada
|/
* 7c1d9e2 (sobremesas) Adiciona receita de pudim
```
As duas linhas se juntaram no commit de merge. 🎉

| Resultado do merge | Quando acontece |
|--------------------|-----------------|
| `Fast-forward` | Só a outra branch andou; a sua só "avança" |
| `Merge made by the 'ort' strategy` | As duas andaram; o Git cria um commit de merge |
| `CONFLICT` | As duas mexeram **no mesmo lugar** do mesmo arquivo → bloco 05 |

---

## 📖 Aprenda: apagar branch

Depois do merge, a branch já cumpriu o papel:
```bash
$ git branch -d sobremesas
$ git branch -d salgados
```
O `-d` só apaga se a branch **já foi juntada**. Se não foi, o Git recusa (para você não perder trabalho).

---

## ✍️ Pratique

1. Crie a branch `bebidas`, adicione `cafe.md` e `cha.md` em **dois commits** separados.
2. Volte para a `main`. Os arquivos existem? Por quê?
3. Veja o mapa das branches. Onde está a `main`? E a `bebidas`?
4. Junte a `bebidas` na `main`. Foi `Fast-forward` ou commit de merge? Por quê?
5. Crie a branch `massas`, faça um commit com `lasanha.md`. Volte para a `main` e faça um commit com `sopa.md`.
   Junte a `massas` na `main`. E agora, que tipo de merge foi?
6. Veja o mapa e apague as branches `bebidas` e `massas`.

<details><summary>👀 Ver respostas</summary>

1. ```bash
   $ git switch -c bebidas
   $ echo "# Café" > cafe.md
   $ git add cafe.md
   $ git commit -m "Adiciona receita de café"
   $ echo "# Chá" > cha.md
   $ git add cha.md
   $ git commit -m "Adiciona receita de chá"
   ```
2. `git switch main` → `ls` → não existem. Eles estão só na linha do tempo `bebidas`.
3. `git log --oneline --graph --all` → a `main` está dois commits atrás da `bebidas`.
4. `git merge bebidas` → `Fast-forward`, porque a `main` não teve commits novos desde que a `bebidas` foi criada.
5. ```bash
   $ git switch -c massas
   $ echo "# Lasanha" > lasanha.md
   $ git add lasanha.md
   $ git commit -m "Adiciona receita de lasanha"
   $ git switch main
   $ echo "# Sopa" > sopa.md
   $ git add sopa.md
   $ git commit -m "Adiciona receita de sopa"
   $ git merge massas            # salve e feche a aba do VS Code
   ```
   Commit de merge, porque as duas branches tinham commits novos.
6. `git log --oneline --graph --all`, `git branch -d bebidas` e `git branch -d massas`
</details>

---

## 🧠 Memorize

1. O que é uma branch?
2. Como criar a branch `login` e já ir para ela?
3. Como voltar para a `main`?
4. Como listar as branches? Como saber em qual você está?
5. Quero trazer a `login` para a `main`. Em qual branch eu preciso estar e qual comando rodo?
6. Qual a diferença entre `Fast-forward` e commit de merge?
7. O que significa `HEAD`?
8. Como apagar a branch `login` depois do merge?

<details><summary>👀 Ver respostas</summary>

1. Uma linha do tempo paralela do projeto.
2. `git switch -c login`
3. `git switch main`
4. `git branch`. A atual tem `*`.
5. Na `main` (quem recebe): `git switch main` e depois `git merge login`.
6. Fast-forward: só a outra branch andou, então a sua só avança. Commit de merge: as duas andaram, então o Git cria um commit que junta.
7. "Você está aqui": o commit/branch em que você está.
8. `git branch -d login`
</details>

➡️ Próximo: [Bloco 05 — Conflitos](05-conflitos.md)
