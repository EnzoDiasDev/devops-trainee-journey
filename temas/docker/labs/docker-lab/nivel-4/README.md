# Nível 4 — Containers conversando (redes)

Até aqui cada container vivia sozinho. Na vida real, uma aplicação precisa falar com um banco, um site
precisa falar com uma API... Neste nível você aprende a **ligar containers entre si**.

| Aula | Assunto | Novidades | Tempo |
|------|---------|-----------|-------|
| [00](00-o-problema.md) | O problema: containers isolados | `ping`, `wget`, o `localhost` do container | 20 min |
| [01](01-primeira-rede.md) | Sua primeira rede | `docker network create/ls/inspect/rm`, `--network` | 25 min |
| [02](02-portas.md) | Portas: dentro da rede × para fora | porta interna, `-p 127.0.0.1:...` | 20 min |
| [03](03-app-e-banco.md) | Uma aplicação falando com o banco | app Python + Postgres na mesma rede | 30 min |
| [04](04-varias-redes.md) | Várias redes e isolamento | `docker network connect/disconnect` | 25 min |
| [05](05-desafio-final.md) | Desafio do nível 4 | (nada novo) | 45 min |

📄 **[COLA.md](COLA.md)** · 📈 **[PROGRESSO.md](PROGRESSO.md)**

## O que você precisa lembrar dos níveis anteriores
- **Nível 1:** `docker run` (`--rm`, `--name`, `-d`, `-p`, `-it`), `docker exec -it`, `docker logs`, `docker rm -f`.
- **Nível 2:** Dockerfile (`FROM`, `WORKDIR`, `RUN`, `COPY`, `ENV`, `CMD`), `docker build -t`, `-e`.
- **Nível 3:** `-v volume:/pasta`, Postgres com volume (`/var/lib/postgresql`).

Colas: [nível 1](../nivel-1/COLA.md) · [nível 2](../nivel-2/COLA.md) · [nível 3](../nivel-3/COLA.md)

## Imagens deste nível
Nenhuma nova: `claude/alpine:3.22`, `claude/nginx:alpine`, `claude/python:3.13-alpine` e `claude/postgres:18-alpine`.

## Onde trabalhar
Em **`nivel-4/pratica/`**, uma pasta por aula.
