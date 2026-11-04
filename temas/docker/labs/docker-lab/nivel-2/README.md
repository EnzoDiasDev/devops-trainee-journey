# Nível 2 — Criando suas próprias imagens

No nível 1 você usou imagens prontas. Agora você vai **construir as suas**, escrevendo um
arquivo chamado **Dockerfile**.

| Aula | Assunto | Novidades | Tempo |
|------|---------|-----------|-------|
| [00](00-preparacao.md) | Preparação: criar pastas e arquivos | `mkdir`, `code` | 15 min |
| [01](01-primeira-imagem.md) | Sua primeira imagem | `FROM`, `CMD`, `docker build` | 25 min |
| [02](02-copy.md) | Colocar seus arquivos na imagem | `COPY` | 25 min |
| [03](03-workdir-e-run.md) | Pasta de trabalho e comandos no build | `WORKDIR`, `RUN` | 30 min |
| [04](04-versoes.md) | Mudou o código? Nova versão | tags, reconstruir | 20 min |
| [05](05-site-na-imagem.md) | Seu site dentro de uma imagem | `COPY` de pastas, `EXPOSE` | 25 min |
| [06](06-env.md) | Configurar sem reconstruir | `ENV`, `-e` | 20 min |
| [07](07-desafio-final.md) | Desafio do nível 2 | (nada novo) | 40 min |

📄 **[COLA.md](COLA.md)**: tudo do nível numa página.
📈 **[PROGRESSO.md](PROGRESSO.md)**: marque o que já fez.

## O que você precisa lembrar do nível 1
`docker run` (com `--rm`, `--name`, `-d`, `-p`, `-it`), `docker ps -a`, `docker rm -f`,
`docker logs`, `docker exec -it`, `docker images` e `docker rmi`. Se esqueceu algum,
dê uma olhada na [cola do nível 1](../nivel-1/COLA.md).

## Imagens deste nível
Além das do nível 1, agora você tem a **`claude/python:3.13-alpine`**: um Linux pequeno com o Python instalado.

> 📌 **Regra do lab:** as imagens que **você** construir também seguem o padrão `claude/<nome>:<versão>`.
> Por exemplo: `claude/primeira:1.0`.

## Onde trabalhar
Cada aula pede para você criar uma pasta dentro de **`nivel-2/pratica/`**. Assim tudo fica organizado
e fácil de achar depois.
