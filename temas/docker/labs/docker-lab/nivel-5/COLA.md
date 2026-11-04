# 🧾 Cola do nível 5

## YAML em 5 regras
1. `chave: valor`, com **espaço** depois dos `:`
2. A indentação (2 espaços) mostra quem está dentro de quem
3. Só espaços, **nunca Tab**
4. Itens de lista começam com `- `
5. Texto com `:` vai entre aspas: `"8081:80"`

## Modelo completo
```yaml
services:
  web:
    build: .                          # constrói com o Dockerfile desta pasta
    image: claude/minha-app:1.0       # nome da imagem construída
    ports:
      - "8081:5000"                   # computador:container
    environment:
      DB_HOST: banco                  # nome do serviço = endereço
      DB_SENHA: ${SENHA_DO_BANCO}     # vem do arquivo .env
    depends_on:
      - banco                         # sobe depois do banco (não espera ficar pronto)

  banco:
    image: claude/postgres:18-alpine
    environment:
      POSTGRES_PASSWORD: ${SENHA_DO_BANCO}
    volumes:
      - banco-dados:/var/lib/postgresql   # sem ports: só a web fala com ele

volumes:
  banco-dados:                        # todo volume com nome precisa estar aqui
```
`.env` (mesma pasta):
```
SENHA_DO_BANCO=lab123
```

## Do `docker run` para o Compose
| `docker run` | `compose.yaml` |
|--------------|----------------|
| `--name web` | nome do serviço (`web:`) |
| `claude/x:1.0` | `image: claude/x:1.0` |
| `-p 8081:80` | `ports:` `- "8081:80"` |
| `-e A=1` | `environment:` `A: 1` |
| `-v dados:/pasta` | `volumes:` `- dados:/pasta` + `volumes:` no final |
| `docker build -t claude/x:1.0 .` | `build: .` + `image: claude/x:1.0` |

## Comandos (sempre na pasta do `compose.yaml`)
| Quero... | Comando |
|----------|---------|
| Subir tudo | `docker compose up -d` |
| Subir reconstruindo (mudei o código) | `docker compose up -d --build` |
| Ver os containers | `docker compose ps` (`-a` inclui os desligados) |
| Ver logs | `docker compose logs` · `logs web` · `logs -f web` · `logs --tail 5` |
| Entrar num serviço | `docker compose exec banco sh` · `docker compose exec banco psql -U postgres` |
| Desligar / ligar / reiniciar | `docker compose stop` · `start` · `restart` (aceitam nome de serviço) |
| Derrubar (guarda os dados) | `docker compose down` |
| Derrubar apagando os dados | `docker compose down -v` |
| Conferir o arquivo | `docker compose config` |

## Nomes que o Compose cria (pasta `loja`, serviço `banco`, volume `dados`)
| O quê | Nome |
|-------|------|
| Container | `loja-banco-1` |
| Volume | `loja_dados` |
| Rede | `loja_default` |

## Regras de ouro
- Serviços se chamam pelo **nome do serviço**. **Nunca `localhost`** entre containers.
- Entre serviços não precisa de `ports`. Banco **sem** `ports`.
- Mudou código ou Dockerfile → `up -d --build`. Mudou só o `compose.yaml` → `up -d`.
- Editou o `compose.yaml`? Rode `docker compose config` antes.
- Senhas no `.env`, fora do git.

## Erros comuns
| Erro | Causa |
|------|-------|
| `refers to undefined volume` | Faltou declarar o volume no `volumes:` do final |
| `ports must be a array` | Faltou o `- ` antes do item |
| `go-yaml load error ... L15` | Erro de indentação/YAML na linha 15 |
| `... false schema` / palavra desconhecida | Nome de campo errado (ex.: `imagem` em vez de `image`) |
| `variable is not set. Defaulting to a blank string` | A variável não está no `.env` (ou o `.env` está em outra pasta) |
| `Connection refused` em `127.0.0.1` no log | `DB_HOST: localhost` em vez do nome do serviço |
| `failed to resolve host 'banco'` | Nome do serviço errado ou o serviço está desligado |
| `password authentication failed` | Senha diferente dos dois lados (ou o volume foi criado com outra senha) |
| `Internal Server Error` logo após o `up` | O banco ainda estava ligando. Espere e atualize |
| Mudei o código e nada mudou | Faltou o `--build` |
