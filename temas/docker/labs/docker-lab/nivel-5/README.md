# Nível 5 — Vários containers juntos (Docker Compose)

Até aqui, para subir um sistema você digitava vários `docker run` compridos, um para cada container.
O **Docker Compose** junta tudo num **arquivo só** e sobe o sistema inteiro com **um comando**.

| Aula | Assunto | Novidades | Tempo |
|------|---------|-----------|-------|
| [00](00-por-que-compose.md) | Por que Compose + o formato YAML | `docker compose version`, regras do YAML | 15 min |
| [01](01-primeiro-compose.md) | Seu primeiro `compose.yaml` | `services`, `image`, `ports`, `up`, `ps`, `logs`, `down` | 25 min |
| [02](02-variaveis-e-volumes.md) | Banco com senha e volume | `environment`, `volumes`, `exec`, `down -v` | 25 min |
| [03](03-build.md) | Construindo a sua imagem | `build`, `up --build` | 20 min |
| [04](04-servicos-conversando.md) | Serviços conversando | o nome do serviço como endereço, `depends_on` | 30 min |
| [05](05-dia-a-dia.md) | Comandos do dia a dia e o arquivo `.env` | `stop`, `start`, `restart`, `config`, `.env` | 25 min |
| [06](06-desafio-final.md) | Desafio do nível 5 | (nada novo) | 45 min |

📄 **[COLA.md](COLA.md)** · 📈 **[PROGRESSO.md](PROGRESSO.md)**

## O que você precisa lembrar dos níveis anteriores
- **Nível 1:** imagem × container, `-d`, `-p 8081:80`, `docker logs`, `docker exec -it`.
- **Nível 2:** Dockerfile (`FROM`, `WORKDIR`, `RUN`, `COPY`, `ENV`, `CMD`), `docker build -t`.
- **Nível 3:** volumes (`-v nome:/pasta`), Postgres com volume em `/var/lib/postgresql`, `psql`.
- **Nível 4** (você pulou): o que o Compose precisa de redes é ensinado aqui, na aula 04. Se quiser se
  aprofundar depois, o [nível 4](../nivel-4/README.md) continua lá.

## Imagens deste nível
As que você já tem: `claude/nginx:alpine`, `claude/postgres:18-alpine`, `claude/python:3.13-alpine`.

## Onde trabalhar
Em **`nivel-5/pratica/`**, uma pasta por aula. **Atenção:** no Compose, a pasta importa (aula 01).
