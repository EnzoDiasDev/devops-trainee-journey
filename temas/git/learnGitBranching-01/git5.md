# Git: histórico, branches e merge

> **Tema:** Git/GitHub
> **Origem:** próprio
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->
> **Nível:** iniciante, mas assume que você já usou `git add`, `git commit` e `git push`.
> **Material de apoio:** [Learn Git Branching](https://learngitbranching.js.org/?locale=pt_BR), um jogo interativo que desenha os commits e as branches na tela.

## Em resumo

Esta nota cobre três ideias: (1) como **ler o histórico** de um repositório com `git log --graph`, (2) o que é uma **branch** e (3) como **juntar** o trabalho de duas branches com `git merge`. Começa com um caso real: um merge que fiz entre dois históricos que não tinham nada em comum.

## 1. Lendo o histórico em forma de grafo

O comando abaixo mostra os commits como um desenho, incluindo as bifurcações:

```bash
git log --oneline --graph --all
```

| Parte | O que faz |
|---|---|
| `--oneline` | Mostra cada commit em uma linha (hash curto + mensagem) |
| `--graph` | Desenha as linhas de ligação entre os commits |
| `--all` | Inclui todas as branches, locais e remotas (não só a atual) |

Exemplo de saída do repositório deste estudo:

```text
*   (HEAD -> main, origin/main) Adiciona estudos do dia 2 de Linux
*   Adiciona estudos do dia 1 de Linux
*   Merge branch 'main' of https://github.com/<usuario>/devops-trainee-journey
|\
| * Add entries to .gitignore for system and secrets
| * Revise README for DevOps Trainee Journey
| * Initial commit
* Dia 1: fundamentos de Linux
```

**Como ler:** cada `*` é um commit. Onde há `|\`, o histórico se divide em duas linhas paralelas; mais abaixo, elas se juntam de novo no commit de merge. `HEAD -> main` indica onde estou agora, e `origin/main` é a posição da `main` no GitHub.

### Por que esse desenho tem duas linhas?

O repositório **local** e o **remoto** (no GitHub) foram criados separadamente, cada um com o seu próprio primeiro commit. Por isso não tinham nenhum histórico em comum.

Quando tentei juntá-los, o Git recusou, porque normalmente só se faz merge de históricos que partem de um ancestral comum. A flag `--allow-unrelated-histories` libera a junção:

```bash
git pull origin main --allow-unrelated-histories
```

> ✏️ **Correção do que eu tinha entendido:** achava que o merge tinha sido necessário "para evitar conflitos". Não é isso. O `--allow-unrelated-histories` **não evita conflitos**: ele só destrava a junção. Neste caso não houve conflito simplesmente porque os arquivos dos dois lados eram diferentes.

## 2. Branches

Uma **branch** é só uma **referência a um commit específico**, e nada mais. Não é uma cópia dos arquivos. Por isso criar uma branch é praticamente instantâneo e não gasta espaço, e daí vem o mantra dos usuários de Git:

> *"Ramifique cedo, ramifique sempre."*

Como é barato, vale dividir o trabalho em várias branches pequenas (uma por funcionalidade ou correção) em vez de manter uma única branch grande.

### Comandos

| Comando | O que faz |
|---|---|
| `git branch` | Lista as branches |
| `git checkout <branch>` | Troca para outra branch |
| `git checkout -b <branch>` | Cria uma branch nova **e** troca para ela |
| `git switch <branch>` | Faz o mesmo que `checkout`, só para trocar de branch |
| `git switch -c <branch>` | Cria e troca (equivalente a `checkout -b`) |

> O `git checkout` faz coisas demais: troca de branch **e** restaura arquivos (`git checkout -- arquivo`). Por isso o Git criou o `git switch` (só troca de branch) e o `git restore` (só restaura arquivos), que são mais claros. Os dois jeitos funcionam.

## 3. Merge: juntando o trabalho de duas branches

Depois de ramificar e desenvolver uma funcionalidade, é preciso trazer o resultado de volta. O primeiro método é o `git merge`.

O merge cria um **commit especial com dois pais**. Isso significa: "quero incluir todo o trabalho deste pai e também o do outro pai, com todos os seus ancestrais".

```bash
git checkout main            # 1. vá para a branch que vai RECEBER as mudanças
git merge feature-login      # 2. traga o trabalho de feature-login para a main
```

> ⚠️ **Regra:** o `git merge` é executado na **branch de destino**, isto é, na que vai receber as mudanças. No exemplo, os commits de `feature-login` passam a fazer parte da `main`, e a `feature-login` continua como estava.

## Resumo rápido

| Quero... | Comando |
|---|---|
| Ver o histórico desenhado | `git log --oneline --graph --all` |
| Criar uma branch e entrar nela | `git switch -c nome` |
| Trocar de branch | `git switch nome` |
| Juntar `nome` na branch atual | `git merge nome` |
| Juntar históricos sem ancestral comum | `git merge <remoto>/<branch> --allow-unrelated-histories` |

## Próximos passos

- [ ] Concluir os próximos níveis do Learn Git Branching (rebase e referências relativas).
- [ ] Comparar as estratégias de merge: merge commit, squash e rebase (ver [ROADMAP](../../../ROADMAP.md)).
