# 🦊 Treino Git + Docker no GitLab: Enzo Bank

Você entra na equipe do **Enzo Bank**, um banco digital cuja API é feita em **Java** e roda em **Docker**. O projeto
fica num **GitLab**, em um projeto **seu**. Você vai abrir Merge Requests de verdade, revisar diffs na
interface, fechar Issues, proteger a `main`, usar o botão de Revert e (se o seu GitLab tiver runners) criar um pipeline.

```
                  ┌───────────────────────────────────────────────┐
                  │ 🦊 GitLab: seu projeto enzo-bank               │
                  │    MRs, Issues, branches protegidas, CI       │
                  └───────────────────────────────────────────────┘
       git push/pull ▲  │        ▲ colegas simulados    │ main
                     │  ▼        │ (colega.sh)          ▼ (deploy.sh)
  ┌───────────────────────────────┐          ┌──────────────────────────────┐
  │ 🧑 area/enzo-bank (VOCÊ)       │          │ 🌍 PRODUÇÃO (no seu PC)       │
  │ 🧪 dev: http://localhost:8070 │          │ http://localhost:8090         │
  └───────────────────────────────┘          └──────────────────────────────┘
```

## O fluxo de cada tarefa
```
 branch → commits → git push → abre o MR no GitLab → ./revisor.sh (o Bruno revisa)
        → clica em Merge no GitLab → ./deploy.sh (produção) → atualiza a main local
```

## Os scripts (ficam aqui em `treino-java/`)
| Script | O que faz |
|--------|-----------|
| `./preparar.sh <url>` | Envia o projeto, com o histórico da equipe, para um projeto **vazio** seu no GitLab, e liga a produção local. Uma vez, na missão 00 |
| `./revisor.sh <branch>` | O **Bruno revisa o seu MR** antes do Merge: mensagens de commit, arquivos proibidos, conflito com a `main`, **build da imagem Docker** e **testes dentro do container**. Diz se pode clicar em Merge |
| `./deploy.sh` | Publica a `main` do GitLab na produção local (http://localhost:8090). Rode depois de cada Merge |
| `./colega.sh <missão>` | Um colega mexe no projeto do GitLab (a missão diz quando) |
| `./desligar.sh` | Desliga a produção e o seu ambiente, **sem apagar dados** |
| `./recomecar.sh <url-nova>` | Limpa tudo no seu PC e recomeça num projeto **novo** do GitLab (missão 16) |

> Você trabalha dentro de `treino-java/area/enzo-bank/`. De lá, os scripts ficam dois níveis acima:
> `../../revisor.sh ...`. A pasta `codigo-inicial/` é a base do `preparar.sh`: **não mexa nela**.

## A equipe (simulada)
| Pessoa | Papel |
|--------|-------|
| 👩‍💻 **Ana Souza** | Desenvolvedora sênior. Criou a API |
| 👨‍💻 **Bruno Lima** | Tech lead. Colocou o projeto em Docker e **revisa os MRs** (`revisor.sh`) |
| 👩‍🎓 **Carla Mendes** | Estagiária. Às vezes faz besteira 😅 |
| 🧑 **Você** | Recém-chegado na equipe |

> Os commits dos colegas aparecem no GitLab com os nomes deles, mas são **enviados pela sua conta** (o GitLab mostra
> quem fez o commit e quem fez o push separadamente). É só uma simulação no **seu** projeto: ninguém é afetado.

## Regras da equipe
1. **Nunca** commit direto na `main`: toda tarefa ganha uma branch (`feature/...`, `fix/...`, `chore/...`).
2. Mensagens de commit **claras**, no presente: `Corrige saque com saldo insuficiente` ✅ · `ajuste` ❌
3. Só clique em **Merge** depois do ✅ do revisor.
4. Nada de arquivos compilados, dados locais ou segredos (`.env`, tokens) no Git.

## Pré-requisitos
| Precisa saber | Onde aprendeu |
|---------------|---------------|
| Git do dia a dia (commit, branch, merge, conflito, push/pull) | [Aula relâmpago](../aula-relampago/README.md) |
| `docker compose up/down/build`, `.env` | [Docker Lab, nível 5](../../../../docker/labs/docker-lab/nivel-5/README.md) |
| Uma conta num GitLab (gitlab.com ou uma instância sua), podendo criar projetos | Veja o [README do Git Lab](../README.md) |
| Java | **Não precisa**: o código vem pronto |

## Começar
Abra **[MISSOES.md](MISSOES.md)** e comece pela **missão 00**.
