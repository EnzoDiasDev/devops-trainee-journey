# 🧾 Cola do Git — aula relâmpago

## Configurar (uma vez)
```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@empresa.com.br"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"     # mensagens abrem no VS Code: salve e feche a aba
git config --global pull.rebase false
```

## As três áreas
```
 pasta de trabalho ──git add──► preparação (staging) ──git commit──► repositório
        └──── git diff ────────────┘    └──── git diff --staged ─────────┘
```

## Salvar e ver
| Quero... | Comando |
|----------|---------|
| Criar repositório | `git init` |
| Ver o estado | `git status` |
| Preparar um arquivo / tudo | `git add arquivo` · `git add .` |
| Commit | `git commit -m "Mensagem no presente"` |
| Commit de tudo que já é rastreado | `git commit -am "Mensagem"` (não pega arquivos novos) |
| Histórico | `git log --oneline` · `git log --oneline --graph --all` |
| O que mudou (não preparado / preparado) | `git diff` · `git diff --staged` |
| O que um commit mudou | `git show <código>` |
| Sair de tela com `(END)` ou `:` | `q` |

## Desfazer
| Situação | Comando |
|----------|---------|
| Descartar mudanças de um arquivo ⚠️ | `git restore arquivo` |
| Tirar da preparação | `git restore --staged arquivo` |
| Consertar o último commit (não enviado) | `git commit --amend -m "msg"` |
| Desfazer qualquer commit (seguro) | `git revert <código>` |
| Ignorar arquivos | `.gitignore` com `senha.txt`, `*.log`, `pasta/` |

## Branches
| Quero... | Comando |
|----------|---------|
| Listar (as do servidor também) | `git branch` · `git branch -a` |
| Criar e ir | `git switch -c nome` |
| Trocar | `git switch nome` |
| Juntar `nome` na atual | `git merge nome` |
| Apagar (já juntada) | `git branch -d nome` |
| Guardar / recuperar mudanças | `git stash` · `git stash pop` · `git stash list` |

## Conflito
1. Edite o arquivo: escolha o conteúdo e **apague** `<<<<<<<`, `=======` e `>>>>>>>`
2. `git add arquivo`
3. `git commit` (salve e feche a aba)

Desistir: `git merge --abort`

## Servidor (GitLab)
| Quero... | Comando |
|----------|---------|
| Baixar pela 1ª vez | `git clone <endereço>` |
| Ver o remoto | `git remote -v` |
| Enviar uma branch pela 1ª vez | `git push -u origin nome` |
| Enviar / receber | `git push` · `git pull` |
| Consultar sem mexer nos arquivos | `git fetch` + `git status` |
| Apagar branch no servidor | `git push origin --delete nome` |
| Esquecer branches apagadas no servidor | `git fetch --prune` |

## Fluxo de trabalho diário
```
git switch main && git pull           # 1. comece atualizado
git switch -c minha-tarefa            # 2. uma branch por tarefa
git add . && git commit -m "..."      # 3. commits
git push -u origin minha-tarefa       # 4. envie a branch
                                      # 5. abra o Merge Request no GitLab → revisão → merge
git switch main && git pull           # 6. traga a main atualizada
git branch -d minha-tarefa            # 7. limpe
```

## Mensagens do Git traduzidas
| Mensagem | Significa |
|----------|-----------|
| `Untracked files` | Arquivos novos, ainda não rastreados |
| `Changes not staged for commit` | Arquivos mudados, fora da preparação |
| `Changes to be committed` | Preparados para o próximo commit |
| `nothing to commit, working tree clean` | Tudo salvo |
| `Your branch is ahead of 'origin/main' by N commits` | Você tem commits para enviar → `git push` |
| `Your branch is behind 'origin/main' by N commits` | O servidor tem novidades → `git pull` |
| `rejected ... (fetch first)` | O servidor tem algo que você não tem → `git pull` e depois `git push` |
| `CONFLICT (content): Merge conflict in X` | Conflito em X → resolva (3 passos) |
| `Your local changes ... would be overwritten` | Commit ou `git stash` antes de trocar de branch |
| `Fast-forward` | Merge simples: a branch só avançou |
