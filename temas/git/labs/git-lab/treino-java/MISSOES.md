# 🎫 Fila de missões

Faça na ordem. Os **comandos ficam escondidos**: tente lembrar primeiro e só abra o bloco 👀 se travar.

| # | Ticket | Git | GitLab | Docker | Nível |
|---|--------|-----|--------|--------|-------|
| [00](missoes/00-configurar-gitlab.md) | Configurar o acesso | — | chave SSH, projeto novo | — | 🟢 |
| [01](missoes/01-primeiro-dia.md) | Primeiro dia | `clone`, `log`, `show` | Commits, Graph, Files | `compose up` | 🟢 |
| [02](missoes/02-primeiro-mr.md) | Seu primeiro Merge Request | ciclo completo | **criar MR, Merge** | `.dockerignore` | 🟢 |
| [03](missoes/03-issue-bug-saque.md) | 🐛 Bug reportado numa Issue | `fix/` | **Issues, `Closes #1`** | testes no container | 🟢 |
| [04](missoes/04-revisao.md) | Depósito negativo + revisão | 2 commits, `diff --staged` | **revisar o diff, comentar linhas** | — | 🟢 |
| [05](missoes/05-mensagem-ruim.md) | MR reprovado por mensagem ruim | `--amend`, `--force-with-lease` | MR se atualiza sozinho | `up --build` | 🟡 |
| [06](missoes/06-urgente.md) | 🚨 Urgente no meio de outra tarefa | `stash`, hotfix | 2 MRs abertos | — | 🟡 |
| [07](missoes/07-dois-na-branch.md) | O tech lead mexeu na sua branch | push rejeitado → `pull` | commits de outra pessoa no MR | — | 🟡 |
| [08](missoes/08-conflito.md) | MR com conflito no `compose.yaml` | `pull origin main` | **"Merge blocked"** | `compose config` | 🟠 |
| [09](missoes/09-deploy-quebrado.md) | 🔥 A estagiária quebrou o deploy | investigar | **botão Revert** | Dockerfile quebrado | 🟠 |
| [10](missoes/10-proteger-main.md) | Nunca mais commit direto na main | push recusado | **Protected branches** | — | 🟠 |
| [11](missoes/11-segredo.md) | O token está no `compose.yaml`! | `rm --cached`, `--amend` | — | `.env`, `${VAR}` | 🟠 |
| [12](missoes/12-detetive.md) | Detetive: quem mudou isso? | `blame`, `log -S` | **Blame e History** | — | 🟠 |
| [13](missoes/13-pipeline.md) | Um robô revisor: pipeline de CI | — | **`.gitlab-ci.yml`, Pipelines** | imagem no CI | 🔴 |
| [14](missoes/14-pix.md) | Funcionalidade nova: Pix | sem roteiro | **MR direto pelo `git push -o`** | rota nova | 🔴 |
| [15](missoes/15-sem-roteiro.md) | Três tickets, zero ajuda | o fluxo sozinho | | porta no compose | 🔴 |
| [16](missoes/16-treino-infinito.md) | Treino infinito | repetir contra o relógio | projeto novo | | 🏆 |

## O ciclo que você vai repetir em quase toda missão

```
 1. git switch main  +  git pull                                       ← começa atualizado
 2. git switch -c tipo/nome-da-tarefa                                  ← branch da tarefa
 3. (edita) → docker compose run --rm --build api java src/Testes.java ← testa no container
 4. git status → git diff → git add → git commit
 5. git push -u origin tipo/nome-da-tarefa                             ← envia a branch
 6. 🦊 GitLab: abre o MR (link que o push mostra)
 7. ../../revisor.sh tipo/nome-da-tarefa                               ← o Bruno revisa
 8. 🦊 GitLab: Merge  (com "Delete source branch")
 9. ../../deploy.sh                                                    ← produção! 🚀
10. git switch main  +  git pull  +  git branch -d ...  +  git fetch --prune
```
> 🎯 **Meta:** chegar na missão 15 fazendo esse ciclo **sem consultar nada**.

Anote seu progresso em [PROGRESSO.md](PROGRESSO.md).
