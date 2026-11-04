# Nível 1 — Primeiros passos

Neste nível você aprende **11 comandos**. Só isso. A ideia é repetir até ficarem automáticos.

| Aula | Assunto | Comandos novos | Tempo |
|------|---------|----------------|-------|
| [00](00-antes-de-comecar.md) | O mínimo de terminal e o que é Docker | `cd`, `ls`, `clear` | 15 min |
| [01](01-primeiro-container.md) | Rodar seu primeiro container | `docker run`, `docker ps` | 15 min |
| [02](02-nomear-e-apagar.md) | Dar nome e apagar containers | `--name`, `docker rm`, `--rm` | 15 min |
| [03](03-servidor-web.md) | Um site rodando em container | `-d`, `-p`, `docker stop`, `docker start` | 25 min |
| [04](04-logs.md) | Ver o que o container está fazendo | `docker logs` | 10 min |
| [05](05-entrar-no-container.md) | Entrar dentro do container | `-it`, `docker exec` | 25 min |
| [06](06-imagens.md) | Baixar, renomear e apagar imagens | `docker images`, `docker pull`, `docker tag`, `docker rmi` | 20 min |
| [07](07-desafio-final.md) | Desafio do nível 1 | (nada novo — só o que você aprendeu) | 30 min |

📄 **[COLA.md](COLA.md)**: todos os comandos do nível numa página só.
📈 **[PROGRESSO.md](PROGRESSO.md)**: marque o que já fez.

## Como estudar cada aula

Toda aula tem as mesmas partes:

1. **📖 Aprenda**: o comando explicado pedaço por pedaço, com exemplo.
2. **✍️ Pratique**: exercícios que usam **só** o que foi explicado até ali.
3. **🧠 Memorize**: perguntas rápidas. Tente responder **sem olhar** antes de abrir a resposta.

As respostas ficam escondidas em blocos assim. Clique para abrir:

<details><summary>👀 Ver resposta</summary>

Você achou! Só abra depois de tentar 😉
</details>

> 💡 Para ver os blocos de resposta formatados, abra os arquivos `.md` no VS Code e use a
> pré-visualização (`Ctrl+Shift+V`) ou abra no GitLab/GitHub.

## Imagens deste nível

Já estão no seu computador:

| Imagem | O que é |
|--------|---------|
| `claude/hello-world` | Mostra uma mensagem e termina. Serve para testar o Docker. |
| `claude/nginx:alpine` | Um servidor de sites (nginx). |
| `claude/alpine:3.22` | Um Linux bem pequeno, para você explorar por dentro. |

Confira com o comando abaixo (você vai aprendê-lo na aula 06). Procure as linhas que começam com `claude/`:
```bash
$ docker images
```
