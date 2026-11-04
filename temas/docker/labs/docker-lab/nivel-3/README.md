# Nível 3 — Guardar dados (volumes)

Até aqui, tudo que um container gravava **sumia** quando ele era apagado. Neste nível você aprende
a guardar dados **fora** do container, para que sobrevivam a qualquer `docker rm`.

| Aula | Assunto | Novidades | Tempo |
|------|---------|-----------|-------|
| [00](00-o-problema.md) | O problema: dados que somem | o conceito de volume | 15 min |
| [01](01-volumes.md) | Seu primeiro volume | `docker volume create/ls/inspect/rm`, `-v` | 25 min |
| [02](02-volume-na-sua-app.md) | Volume numa aplicação sua | `-v` com imagem própria | 25 min |
| [03](03-bind-mount.md) | Ligar uma pasta do seu computador | bind mount, `:ro` | 25 min |
| [04](04-banco-de-dados.md) | Um banco de dados que não perde nada | Postgres com volume | 30 min |
| [05](05-cuidados.md) | Cuidados e limpeza | volumes anônimos, `docker rm -v` | 15 min |
| [06](06-desafio-final.md) | Desafio do nível 3 | (nada novo) | 40 min |
| [07](07-exercicios-extras.md) | ⭐ Exercícios extras | detetive, vitrine, backup e restauração | 60 min |

📄 **[COLA.md](COLA.md)** · 📈 **[PROGRESSO.md](PROGRESSO.md)**

## O que você precisa lembrar dos níveis anteriores
- **Nível 1:** `docker run` (`--rm`, `--name`, `-d`, `-p`, `-it`), `docker ps -a`, `docker rm -f`, `docker logs`, `docker exec -it`.
- **Nível 2:** `FROM`, `WORKDIR`, `COPY`, `RUN`, `CMD`, `docker build -t`.

Colas: [nível 1](../nivel-1/COLA.md) · [nível 2](../nivel-2/COLA.md)

## Imagens deste nível
Nova: **`claude/postgres:18-alpine`**, um banco de dados de verdade (aula 04).

## Onde trabalhar
Em **`nivel-3/pratica/`**, uma pasta por aula, como no nível 2.
