# 🧾 Cola do nível 3

## Volumes
| Quero... | Comando |
|----------|---------|
| Criar um volume | `docker volume create dados` |
| Listar | `docker volume ls` |
| Ver detalhes (onde fica: `Mountpoint`) | `docker volume inspect dados` |
| Apagar (⚠️ sem lixeira) | `docker volume rm dados` |
| Encaixar num container | `docker run -v dados:/pasta <imagem>` |
| Apagar container + volumes anônimos dele | `docker rm -f -v <container>` |
| Ver espaço usado | `docker system df` |

## Bind mount (pasta sua)
| Quero... | Comando |
|----------|---------|
| Espelhar uma pasta minha | `docker run -v ./site:/usr/share/nginx/html <imagem>` |
| ...só leitura | `docker run -v ./site:/usr/share/nginx/html:ro <imagem>` |

## Como ler o `-v`
```
-v  dados:/pasta        → volume chamado "dados"
-v  ./dados:/pasta      → pasta "dados" do SEU computador (bind mount)
-v  ./dados:/pasta:ro   → bind mount somente leitura
     └─fora─┘ └dentro┘
```

## Volume × bind mount
| | Volume | Bind mount |
|---|---|---|
| Quem guarda | O Docker | Uma pasta sua |
| Para | Dados da aplicação (banco, uploads) | Desenvolvimento (editar e ver na hora) |

## Postgres
```bash
$ docker run -d --name banco -e POSTGRES_PASSWORD=senha -v banco-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker logs banco                                         # "ready to accept connections"
$ docker exec -it banco psql -U postgres                    # entrar (sair: \q)
$ docker exec -it banco psql -U postgres -c "SELECT * FROM tabela;"
```
| SQL | O que faz |
|-----|-----------|
| `CREATE TABLE nome (coluna TEXT);` | Cria uma tabela |
| `INSERT INTO nome VALUES ('texto');` | Acrescenta uma linha |
| `SELECT * FROM nome;` | Mostra tudo |

## Regras de ouro
- Só o que está **na pasta do volume** sobrevive ao `docker rm`.
- **Atualizar sem perder dados** = imagem nova + mesmo volume.
- Sempre dê **nome** aos volumes.
- Apague volumes **pelo nome**. Não use `docker volume prune` (apagaria o volume do Girus).
- Comando comprido? Quebre a linha com `\` no final.

## Erros comuns
| Erro / sintoma | Causa |
|----------------|-------|
| `volume is in use` | Um container (mesmo parado) usa o volume. Apague-o antes |
| Meus dados "sumiram" | Nome do volume digitado errado (o `-v` criou outro, vazio) ou gravou fora da pasta do volume |
| Site mostra erro 403 ou a página padrão | Faltou o `./` (virou volume) ou rodou o comando na pasta errada |
| `Read-only file system` | Bind mount com `:ro`. Esperado! |
| `relation "x" does not exist` | A tabela não existe nesse banco (volume diferente?) |
| Postgres não liga | Faltou o `-e POSTGRES_PASSWORD=...` |
