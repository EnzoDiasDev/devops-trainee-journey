# Bloco 06 — Servidor: enviar e receber

## 🎯 Neste bloco
- O que é um **remoto** (o GitLab, por exemplo).
- `git clone`: baixar um repositório do servidor.
- `git push`: enviar seus commits. `git pull`: receber os commits dos outros.
- `git fetch` e `git status`: saber se você está atrás ou à frente.
- O erro mais comum de equipe: **push rejeitado**, e como resolver.

---

## 📖 Aprenda: o que é um remoto

Até agora tudo ficou **no seu computador**. Para trabalhar em equipe, existe uma cópia do repositório num
**servidor** (o seu GitLab). Essa cópia se chama **remoto**, e o apelido padrão dela é **`origin`**.

```
                       ┌──────────────────────┐
                       │  SERVIDOR (GitLab)   │
                       │      "origin"        │
                       └──────────────────────┘
               push ▲   │ pull          push ▲   │ pull
                    │   ▼                    │   ▼
          ┌──────────────────┐        ┌──────────────────┐
          │  seu computador  │        │ pc do colega     │
          └──────────────────┘        └──────────────────┘
```
| Comando | Direção |
|---------|---------|
| `git push` | **Envia** seus commits para o servidor ⬆️ |
| `git pull` | **Traz** os commits novos do servidor ⬇️ |
| `git clone` | Baixa o repositório inteiro **pela primeira vez** |

---

## 📖 Preparação: um "GitLab de mentira" no seu computador

Para treinar sem depender do GitLab de verdade, crie um **servidor de treino** numa pasta. O Git trata essa
pasta exatamente como trataria o GitLab:
```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica
$ mkdir servidor
$ git init --bare servidor/cardapio.git
```
> O `--bare` cria um repositório "de servidor": ele só guarda o histórico e não tem pasta de trabalho.
> É o que o GitLab tem lá dentro. Você **não** vai trabalhar dentro dessa pasta: só enviar e receber.

---

## 📖 Aprenda: `git clone`

`git clone <endereço> <nome-da-pasta>` baixa o repositório e já deixa o `origin` configurado:
```bash
$ git clone servidor/cardapio.git eu
$ cd eu
$ git remote -v
```
```
origin	.../servidor/cardapio.git (fetch)
origin	.../servidor/cardapio.git (push)
```
`git remote -v` mostra para onde o `origin` aponta. Com o GitLab de verdade, seria algo como
`http://gitlab.example.com/grupo/projeto.git`.

> O Git avisa `You appear to have cloned an empty repository`, porque o servidor ainda está vazio. Normal.

---

## 📖 Aprenda: `git push`

Faça um commit e envie:
```bash
$ echo "# Cardápio do restaurante" > README.md
$ git add README.md
$ git commit -m "Cria o cardápio"
$ git push -u origin main
```
```
To .../servidor/cardapio.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```
- `origin main` = "envie para o `origin` a branch `main`".
- `-u` = "**lembre** dessa ligação". Depois do primeiro push com `-u`, basta digitar **`git push`**.

---

## 📖 Mão na massa: simulando um colega

Abra **outro terminal** (ou volte uma pasta) e clone o mesmo servidor numa pasta `colega`. É como se fosse o
computador de outra pessoa:
```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica
$ git clone servidor/cardapio.git colega
$ cd colega
$ ls                        # o README.md que você enviou está aqui
```
O colega adiciona um prato e envia:
```bash
$ echo "# Feijoada" > feijoada.md
$ git add feijoada.md
$ git commit -m "Adiciona feijoada"
$ git push
```

---

## 📖 Aprenda: `git pull`

Volte para a **sua** pasta (`eu`) e traga o trabalho do colega:
```bash
$ cd ~/Projects/git-lab/aula-relampago/pratica/eu
$ git pull
$ ls                        # a feijoada chegou!
```

## 📖 Aprenda: `git fetch` + `git status`

`git fetch` **só pergunta** ao servidor o que há de novo, **sem mexer** nos seus arquivos. Depois, o `git status` conta a novidade:
```bash
$ git fetch
$ git status
```
| Mensagem | Significa | Fazer |
|----------|-----------|-------|
| `Your branch is up to date with 'origin/main'` | Igual ao servidor | Nada |
| `Your branch is ahead of 'origin/main' by 2 commits` | Você tem 2 commits que o servidor não tem | `git push` |
| `Your branch is behind 'origin/main' by 1 commit` | O servidor tem 1 commit que você não tem | `git pull` |
| `have diverged` | Os dois lados têm commits novos | `git pull`, depois `git push` |

---

## 🔬 O erro mais comum: push rejeitado

Faça os **dois** trabalharem ao mesmo tempo, sem sincronizar:

**Colega** (pasta `colega`):
```bash
$ echo "# Moqueca" > moqueca.md
$ git add moqueca.md
$ git commit -m "Adiciona moqueca"
$ git push
```
**Você** (pasta `eu`), **sem** dar pull antes:
```bash
$ echo "# Lasanha" > lasanha.md
$ git add lasanha.md
$ git commit -m "Adiciona lasanha"
$ git push
```
```
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to '.../servidor/cardapio.git'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. ... use 'git pull' before pushing again.
```
"Rejeitado: o servidor tem trabalho que você não tem. Dê `git pull` antes de enviar de novo."

O Git **protege** o trabalho do colega: ele não deixa você sobrescrever. A solução é a de sempre:
```bash
$ git pull                  # traz a moqueca e junta com a sua lasanha
```
O Git abre o VS Code com a mensagem de merge (`Merge branch 'main' of ...`): **salve e feche a aba**.
```bash
$ git push                  # agora vai
$ git log --oneline --graph
```
> Se o colega tivesse mexido **na mesma linha** que você, o `git pull` daria **conflito**. Você resolve exatamente
> como no bloco 05 (editar → `git add` → `git commit`) e depois dá `git push`.

> 📌 **Hábito de ouro:** comece o dia (e toda tarefa nova) com **`git pull`**.

---

## ✍️ Pratique

1. Na pasta `colega`, traga as novidades do servidor (a sua lasanha).
2. No `colega`, crie `pizza.md` e envie. Na pasta `eu`, **antes** de puxar, descubra (sem mexer nos arquivos)
   se você está atrás do servidor.
3. Traga a pizza para a pasta `eu`.
4. Provoque um push rejeitado de novo (cada lado com um commit diferente) e resolva.
5. Provoque um **conflito** via servidor: os dois mudam a **primeira linha** do `README.md` de jeitos diferentes. O
   colega envia primeiro. Você dá `pull`, resolve o conflito e envia.
6. Confira nas duas pastas, com `git log --oneline`, que os históricos ficaram iguais (dê `git pull` no `colega`).

<details><summary>👀 Ver respostas</summary>

1. `cd ../colega` e `git pull`
2. ```bash
   $ echo "# Pizza" > pizza.md
   $ git add pizza.md
   $ git commit -m "Adiciona pizza"
   $ git push
   $ cd ../eu
   $ git fetch
   $ git status          # behind 'origin/main' by 1 commit
   ```
3. `git pull`
4. Um commit em cada pasta, push no `colega`, push na `eu` (rejeitado) → `git pull` (salve e feche a aba) → `git push`.
5. ```bash
   # colega: edite a 1ª linha do README.md
   $ git commit -am "Muda título (colega)"
   $ git push
   # eu: edite a 1ª linha do README.md de outro jeito
   $ git commit -am "Muda título (eu)"
   $ git pull            # CONFLICT
   # resolva no editor, apague os marcadores, salve
   $ git add README.md
   $ git commit          # salve e feche a aba
   $ git push
   ```
6. `git pull` no `colega` e `git log --oneline` nas duas pastas: mesmos commits.
</details>

---

## 🧠 Memorize

1. O que é o `origin`?
2. Como baixar um repositório do servidor pela primeira vez?
3. Como enviar a branch `main` pela primeira vez, deixando a ligação lembrada?
4. Depois disso, como enviar e como receber?
5. Qual a diferença entre `git fetch` e `git pull`?
6. O push foi `rejected (fetch first)`. O que fazer?
7. Qual o hábito de ouro antes de começar a trabalhar?

<details><summary>👀 Ver respostas</summary>

1. O apelido do repositório remoto (o servidor, como o GitLab).
2. `git clone <endereço>`
3. `git push -u origin main`
4. `git push` e `git pull`.
5. `fetch` só consulta o servidor; `pull` consulta **e traz** as mudanças para os seus arquivos.
6. `git pull` (resolver conflito, se houver) e depois `git push`.
7. `git pull`
</details>

➡️ Próximo: [Bloco 07 — O fluxo de trabalho real](07-dia-a-dia.md)
