# Bloco 07 — O fluxo de trabalho real

## 🎯 Neste bloco
- `git stash`: guardar mudanças "na gaveta" para trocar de branch.
- O fluxo usado nas empresas: **branch → commits → push da branch → Merge Request → atualizar a `main`**.
- `git branch -a`, `git push origin --delete` e `git fetch --prune`: arrumar branches.

Use as pastas `eu` e `colega` do bloco 06.

---

## 📖 Aprenda: `git stash`

Você está no meio de uma mudança e precisa trocar de branch às pressas (um bug urgente, por exemplo). Se a mudança
atrapalhar a troca, o Git recusa:
```
error: Your local changes to the following files would be overwritten by checkout:
	prato.md
Please commit your changes or stash them before you switch branches.
```
"Suas mudanças seriam sobrescritas. Faça commit ou guarde-as (*stash*) antes de trocar."

Quando o trabalho ainda não está pronto para virar commit, use o **stash** (a "gaveta"):

| Comando | O que faz |
|---------|-----------|
| `git stash` | Guarda as mudanças não commitadas na gaveta e deixa a pasta **limpa** |
| `git stash list` | Lista o que está guardado |
| `git stash pop` | Tira da gaveta e **aplica de volta** |

```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica/eu
$ echo "rascunho que não está pronto" >> README.md
$ git status                 # modified: README.md
$ git stash
$ git status                 # working tree clean
$ git stash list
$ git stash pop
$ git status                 # modified: README.md de volta
$ git restore README.md      # (só para limpar o exemplo)
```

---

## 📖 Aprenda: o fluxo de trabalho com Merge Request

Nas equipes, **ninguém faz commit direto na `main`**. O fluxo é:

```
 1. git switch main && git pull          ← começa atualizado
 2. git switch -c minha-tarefa           ← uma branch por tarefa
 3. (trabalha) git add / git commit      ← quantos commits precisar
 4. git push -u origin minha-tarefa      ← envia A BRANCH (não a main)
 5. No GitLab: abre um Merge Request     ← pede para juntar na main
 6. Colega revisa e aprova → merge       ← feito no GitLab
 7. git switch main && git pull          ← traz a main atualizada
 8. git branch -d minha-tarefa           ← limpa a branch local
```

### O que é um Merge Request (MR)?
É um **pedido** feito no site do GitLab: "por favor, junte a minha branch na `main`". Nele a equipe:
- vê o **diff** (como no `git diff`) de tudo que você mudou;
- **comenta** linhas e pede ajustes. Você corrige, faz novos commits na mesma branch e dá `git push`, e o MR atualiza sozinho;
- **aprova** e clica em **Merge**. O GitLab faz o `git merge` lá no servidor.

> No GitHub, o mesmo recurso se chama **Pull Request (PR)**.

### Simulando o fluxo completo

O servidor de treino não tem site, então o **colega** vai fazer o papel do GitLab (revisar e juntar).

**Você** (pasta `eu`), passos 1 a 4:
```bash
$ git switch main
$ git pull
$ git switch -c nova-sobremesa
$ echo "# Sorvete" > sorvete.md
$ git add sorvete.md
$ git commit -m "Adiciona receita de sorvete"
$ git push -u origin nova-sobremesa
```
```
 * [new branch]      nova-sobremesa -> nova-sobremesa
```
A branch agora existe no servidor.

**Colega** (pasta `colega`), revisando e fazendo o "merge do MR":
```bash
$ cd ../colega
$ git fetch
$ git branch -a
```
```
* main
  remotes/origin/main
  remotes/origin/nova-sobremesa
```
`git branch -a` mostra também as branches **do servidor** (as que começam com `remotes/origin/`).
```bash
$ git switch nova-sobremesa          # cria a branch local a partir da do servidor
$ git log --oneline                  # revisa o que foi feito
$ git switch main
$ git merge nova-sobremesa           # "aprova" e junta
$ git push                           # envia a main atualizada
$ git push origin --delete nova-sobremesa   # apaga a branch no servidor (o GitLab faz isso num checkbox)
$ git branch -d nova-sobremesa       # apaga a branch local do colega
```

**Você** (pasta `eu`), passos 7 e 8:
```bash
$ cd ../eu
$ git switch main
$ git pull                           # o sorvete chega na sua main
$ git branch -d nova-sobremesa
$ git fetch --prune                  # esquece branches que foram apagadas no servidor
$ git branch -a
```
Ciclo completo! 🔁 É isso que você vai fazer dezenas de vezes por semana.

---

## 📖 Aprenda: com o GitLab de verdade

É igual. Só muda o endereço no `clone`:
```bash
$ git clone http://gitlab.example.com/grupo/projeto.git
```
- O GitLab pede **usuário e senha** (ou um *token de acesso*, dependendo da configuração). Veja na documentação do seu GitLab
  qual é o jeito padrão.
- Depois do `git push` de uma branch, o próprio terminal costuma mostrar um link **"To create a merge request, visit..."**.
  Abra esse link para criar o MR.

---

## ✍️ Pratique

Faça o ciclo completo **duas vezes**, uma para cada tarefa, sem olhar o roteiro acima:

**Tarefa A (você):** adicionar `brownie.md`.
**Tarefa B (você):** corrigir o título do `README.md` para `# Cardápio do Restaurante da Enzo`.

Para cada uma: branch própria → commit → push da branch → colega revisa, junta e apaga a branch no servidor →
você atualiza a `main` e limpa a branch local.

**Bônus:** no meio da tarefa B, antes do commit, guarde a mudança na gaveta, volte para a `main`, dê `git pull`, volte
para a branch e tire a mudança da gaveta.

<details><summary>👀 Ver resposta (tarefa A)</summary>

```bash
# você (eu)
$ git switch main
$ git pull
$ git switch -c brownie
$ echo "# Brownie" > brownie.md
$ git add brownie.md
$ git commit -m "Adiciona receita de brownie"
$ git push -u origin brownie

# colega
$ cd ../colega
$ git fetch
$ git switch brownie
$ git log --oneline
$ git switch main
$ git pull
$ git merge brownie
$ git push
$ git push origin --delete brownie
$ git branch -d brownie

# você (eu)
$ cd ../eu
$ git switch main
$ git pull
$ git branch -d brownie
$ git fetch --prune
```
A tarefa B é igual, trocando a branch e a mudança. O bônus é `git stash` → `git switch main` → `git pull` →
`git switch <branch>` → `git stash pop`.
</details>

---

## 🧠 Memorize

1. Para que serve o `git stash`? Como pegar de volta?
2. Por que não fazer commit direto na `main`?
3. Como enviar a branch `correcao-login` para o servidor pela primeira vez?
4. O que é um Merge Request?
5. Depois que o MR foi aceito, quais os comandos para atualizar sua `main` e limpar a branch?
6. Como ver também as branches que existem no servidor?
7. Como apagar uma branch no servidor?

<details><summary>👀 Ver respostas</summary>

1. Guardar mudanças não commitadas temporariamente (para trocar de branch, por exemplo). `git stash pop`.
2. Para que toda mudança passe por revisão (MR) e a `main` fique sempre estável.
3. `git push -u origin correcao-login`
4. Um pedido, feito no GitLab, para juntar a sua branch na `main`, com revisão da equipe.
5. `git switch main`, `git pull`, `git branch -d <branch>` (e `git fetch --prune`).
6. `git branch -a`
7. `git push origin --delete <branch>`
</details>

➡️ Próximo: [Bloco 08 — Desafio final](08-desafio-final.md)
