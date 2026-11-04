# Bloco 08 — Desafio final + prova relâmpago

Nada novo: só os blocos 00 a 07. Se travar, consulte a [COLA.md](COLA.md) antes de abrir a resposta.

---

## 🏗️ O projeto: "lista de compras" da equipe

### Parte 1 — Montando o servidor e o repositório

1. Em `pratica/`, crie um servidor de treino `servidor/compras.git`.
2. Clone-o numa pasta `ana` (você) e numa pasta `bruno` (colega).
3. Em `ana`: crie um `.gitignore` que ignore todos os `.log` e um arquivo `lista.md` com o título `# Lista de compras`.
   Faça **um commit com os dois** e envie a `main` para o servidor.
4. Em `bruno`: traga as novidades.

<details><summary>👀 Ver respostas da parte 1</summary>

```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica
$ mkdir -p servidor
$ git init --bare servidor/compras.git
$ git clone servidor/compras.git ana
$ git clone servidor/compras.git bruno
$ cd ana
# crie .gitignore (com *.log) e lista.md (com # Lista de compras)
$ git add .gitignore lista.md
$ git commit -m "Cria lista de compras"
$ git push -u origin main
$ cd ../bruno
$ git pull
```
</details>

---

### Parte 2 — Trabalhando em paralelo

5. **Ana:** numa branch `frutas`, acrescente ao `lista.md` as linhas `- banana` e `- maçã` (um commit) e envie a branch.
6. **Bruno:** numa branch `limpeza`, crie `limpeza.md` com `- sabão` (um commit) e envie a branch.
7. **Bruno** faz o papel do GitLab: junta a `frutas` na `main`, envia a `main` e apaga a branch `frutas` no servidor.
8. **Ana** faz o papel do GitLab para o Bruno: atualiza a `main`, junta a `limpeza`, envia e apaga a branch `limpeza`
   no servidor.
9. Nas duas pastas, atualize a `main`, apague as branches locais e confira com `git log --oneline --graph` que os
   históricos ficaram iguais.

<details><summary>👀 Ver respostas da parte 2</summary>

```bash
# Ana
$ git switch -c frutas
# acrescente as linhas no lista.md
$ git commit -am "Adiciona frutas"
$ git push -u origin frutas

# Bruno
$ cd ../bruno
$ git switch -c limpeza
$ echo "- sabão" > limpeza.md
$ git add limpeza.md
$ git commit -m "Adiciona lista de limpeza"
$ git push -u origin limpeza
$ git switch main
$ git fetch
$ git merge origin/frutas         # (ou: git switch frutas; git switch main; git merge frutas)
$ git push
$ git push origin --delete frutas

# Ana
$ cd ../ana
$ git switch main
$ git pull
$ git fetch
$ git merge origin/limpeza        # salve e feche a aba, se abrir
$ git push
$ git push origin --delete limpeza

# Nas duas pastas
$ git switch main
$ git pull
$ git branch -d frutas            # na Ana
$ git branch -d limpeza           # no Bruno
$ git fetch --prune
$ git log --oneline --graph
```
> `git merge origin/frutas` junta direto a branch do servidor, sem criar a local. É um atalho válido; o caminho com
> `git switch frutas` (do bloco 07) também funciona.
</details>

---

### Parte 3 — O conflito

10. **Ana** e **Bruno**, cada um na sua `main` atualizada, trocam a linha `- banana` do `lista.md`: a Ana para
    `- 6 bananas`, o Bruno para `- 1 cacho de banana`. Os dois fazem commit.
11. O **Bruno** envia primeiro. A **Ana** tenta enviar. O que acontece?
12. A **Ana** resolve: traz as mudanças, resolve o conflito ficando com `- 1 cacho de banana (umas 6)`, termina e envia.
13. O **Bruno** atualiza. Os dois veem o mesmo resultado?

<details><summary>👀 Ver respostas da parte 3</summary>

```bash
# Ana e Bruno: editam a linha e
$ git commit -am "..."
# Bruno
$ git push
# Ana
$ git push               # rejected (fetch first)
$ git pull               # CONFLICT (content): Merge conflict in lista.md
# edite: deixe "- 1 cacho de banana (umas 6)" e apague <<<<<<< ======= >>>>>>>
$ git add lista.md
$ git commit             # salve e feche a aba
$ git push
# Bruno
$ git pull
$ cat lista.md
```
</details>

---

### Parte 4 — Desfazendo

14. **Ana:** crie `debug.log` e `rascunho.md`. Rode `git status`: qual dos dois aparece? Por quê?
15. **Ana:** dê `git add .` e faça o commit com a mensagem `rascunh`. Conserte a mensagem para `Adiciona rascunho`
    (ainda não enviou, então pode).
16. **Ana:** envie. Depois, descobre que o rascunho não deveria existir. Desfaça o commit **de forma segura** e envie.
17. **Ana:** bagunce o `lista.md` sem salvar num commit e volte ele ao normal.

<details><summary>👀 Ver respostas da parte 4</summary>

```bash
$ git status                 # só rascunho.md: o debug.log é ignorado pelo .gitignore (*.log)
$ git add .
$ git commit -m "rascunh"
$ git commit --amend -m "Adiciona rascunho"
$ git push
$ git log --oneline
$ git revert <código-do-commit-do-rascunho>    # salve e feche a aba
$ git push
# bagunce o lista.md e salve
$ git restore lista.md
```
> Usamos `revert` (e não `--amend`) no item 16 porque o commit **já estava no servidor**.
</details>

---

## ⚡ Prova relâmpago

Responda de memória. **16 ou mais acertos (de 20) = fluente no Git do dia a dia.** 🏆

| # | O que fazer |
|---|-------------|
| 1 | Transformar a pasta atual em repositório |
| 2 | Ver o estado atual (o comando mais usado) |
| 3 | Colocar todas as mudanças na área de preparação |
| 4 | Fazer um commit com a mensagem "Corrige login" |
| 5 | Ver o histórico resumido, com o mapa de todas as branches |
| 6 | Ver as mudanças que **já** estão na preparação |
| 7 | Descartar as mudanças não commitadas do `app.py` |
| 8 | Tirar o `app.py` da preparação, sem perder as mudanças |
| 9 | Corrigir a mensagem do último commit (ainda não enviado) |
| 10 | Desfazer com segurança o commit `a1b2c3d` (já enviado) |
| 11 | Criar a branch `cadastro` e já ir para ela |
| 12 | Voltar para a `main` |
| 13 | Trazer a branch `cadastro` para a branch atual |
| 14 | Desistir de um merge com conflito |
| 15 | Os 3 passos para resolver um conflito |
| 16 | Baixar um repositório do servidor pela primeira vez |
| 17 | Enviar a branch `cadastro` para o servidor pela primeira vez |
| 18 | O push foi rejeitado (`fetch first`). O que fazer? |
| 19 | Guardar mudanças não commitadas temporariamente, e depois pegar de volta |
| 20 | Depois que o seu MR foi aceito no GitLab, como atualizar sua `main` e limpar a branch? |

<details><summary>👀 Ver respostas da prova</summary>

| # | Resposta |
|---|----------|
| 1 | `git init` |
| 2 | `git status` |
| 3 | `git add .` |
| 4 | `git commit -m "Corrige login"` |
| 5 | `git log --oneline --graph --all` |
| 6 | `git diff --staged` |
| 7 | `git restore app.py` |
| 8 | `git restore --staged app.py` |
| 9 | `git commit --amend -m "nova mensagem"` |
| 10 | `git revert a1b2c3d` |
| 11 | `git switch -c cadastro` |
| 12 | `git switch main` |
| 13 | `git merge cadastro` |
| 14 | `git merge --abort` |
| 15 | Editar o arquivo (apagar os marcadores) → `git add` → `git commit` |
| 16 | `git clone <endereço>` |
| 17 | `git push -u origin cadastro` |
| 18 | `git pull` (resolver conflito, se houver) e depois `git push` |
| 19 | `git stash` e `git stash pop` |
| 20 | `git switch main`, `git pull`, `git branch -d <branch>` |
</details>

---

## 🎉 Terminou?

Marque o [PROGRESSO.md](PROGRESSO.md). Para fixar:
- **Amanhã**, refaça a prova relâmpago sem olhar.
- **Esta semana**, use o fluxo do bloco 07 num projeto de verdade (o `docker-lab` é um ótimo candidato para virar um repositório!).

Quando quiser aprofundar, avise o Claude: **"bora para o próximo módulo de git"** (veja as [próximas aulas](../proximas-aulas/README.md)).

Pode apagar a pasta `pratica` quando quiser: nada ali é importante.
