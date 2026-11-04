# Aula 06 — Desafio do nível 5

Só o que você viu nas aulas 00 a 05 (mais os níveis 1 a 3). Desta vez **você escreve o `compose.yaml` do zero**.
Se travar, consulte a [COLA.md](COLA.md) antes de abrir a resposta.

Trabalhe em `~/Projects/docker-lab/nivel-5/pratica/biblioteca/`. Você vai montar uma **biblioteca online**:

```
 navegador ──► localhost:8086 ──► portal (nginx com a sua página)
 navegador ──► localhost:8087 ──► api (Flask) ──► banco (Postgres + volume)
```

---

## 📁 Parte 1 — Os arquivos

Crie esta estrutura:
```
biblioteca/
├── compose.yaml        ← você escreve (parte 2)
├── .env                ← você escreve (parte 2)
├── portal/
│   ├── Dockerfile
│   └── site/
│       └── index.html
└── api/
    ├── Dockerfile
    └── app.py
```

**`portal/site/index.html`**:
```html
<h1>📚 Biblioteca da Enzo</h1>
<p>Veja nosso acervo em <a href="http://localhost:8087">localhost:8087</a></p>
```

**`portal/Dockerfile`**: escreva você (nginx, copiando a pasta `site`, avisando a porta 80).

**`api/app.py`** (pronto):
```python
import os

import psycopg
from flask import Flask

app = Flask(__name__)


@app.route("/")
def acervo():
    with psycopg.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user="postgres",
        password=os.getenv("DB_SENHA", ""),
        connect_timeout=3,
    ) as conexao:
        conexao.execute("CREATE TABLE IF NOT EXISTS livros (titulo TEXT)")
        titulos = conexao.execute("SELECT titulo FROM livros").fetchall()
    itens = "".join(f"<li>{titulo}</li>" for (titulo,) in titulos)
    return f"<h1>📚 Acervo</h1><p>{len(titulos)} livro(s)</p><ul>{itens}</ul>"
```

**`api/Dockerfile`**: escreva você (Python, `/app`, instale `flask "psycopg[binary]"`, copie, rode o Flask na porta 5000
aceitando conexões de fora). Dica: é igual ao da aula 04.

<details><summary>👀 Ver os Dockerfiles</summary>

`portal/Dockerfile`:
```dockerfile
FROM claude/nginx:alpine
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```
`api/Dockerfile`:
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install flask "psycopg[binary]"
COPY . .
CMD ["flask", "--app", "app", "run", "--host", "0.0.0.0", "--port", "5000"]
```
</details>

---

## 🧩 Parte 2 — O `compose.yaml` e o `.env`

1. Crie o `.env` com a senha do banco (`SENHA_DO_BANCO=livros123`).
2. Escreva o `compose.yaml` com três serviços:
   - **`portal`**: construído a partir da pasta `portal` (dica: `build: ./portal`), imagem `claude/portal:1.0`, porta **8086** → 80.
   - **`api`**: construído a partir da pasta `api`, imagem `claude/acervo-api:1.0`, porta **8087** → 5000, variáveis
     `DB_HOST` (apontando para o banco) e `DB_SENHA` (vinda do `.env`), subindo **depois** do banco.
   - **`banco`**: Postgres, senha vinda do `.env`, volume `acervo-dados` no lugar certo, **sem** porta publicada.
3. Confira com `docker compose config` que a senha foi lida do `.env`.
4. Suba tudo e confira com `docker compose ps`.
5. Abra http://localhost:8086 e clique no link. O acervo mostra 0 livros.

<details><summary>👀 Ver resposta da parte 2</summary>

`.env`:
```
SENHA_DO_BANCO=livros123
```
`compose.yaml`:
```yaml
services:
  portal:
    build: ./portal
    image: claude/portal:1.0
    ports:
      - "8086:80"

  api:
    build: ./api
    image: claude/acervo-api:1.0
    ports:
      - "8087:5000"
    environment:
      DB_HOST: banco
      DB_SENHA: ${SENHA_DO_BANCO}
    depends_on:
      - banco

  banco:
    image: claude/postgres:18-alpine
    environment:
      POSTGRES_PASSWORD: ${SENHA_DO_BANCO}
    volumes:
      - acervo-dados:/var/lib/postgresql

volumes:
  acervo-dados:
```
```bash
$ docker compose config
$ docker compose up -d
$ docker compose ps
```
> O `build: ./portal` funciona como o `build: .`, mas usando o Dockerfile da pasta `portal`.
</details>

---

## 📚 Parte 3 — Operando a biblioteca

6. Cadastre três livros direto no banco, com `docker compose exec` e `psql -c` (um `INSERT` por livro).
   Atualize o acervo no navegador.
7. Mostre o log **só** da `api` e encontre os acessos que você fez.
8. Mude o título do `portal` para `📚 Biblioteca da Enzo, agora com Compose!` e coloque no ar.
9. Derrube tudo **sem** perder os livros, suba de novo e confira o acervo.
10. Reinicie **só** a `api`.

<details><summary>👀 Ver respostas da parte 3</summary>

```bash
$ docker compose exec banco psql -U postgres -c "INSERT INTO livros VALUES ('Duna');"
$ docker compose exec banco psql -U postgres -c "INSERT INTO livros VALUES ('O Hobbit');"
$ docker compose exec banco psql -U postgres -c "INSERT INTO livros VALUES ('Docker na Prática');"
$ docker compose logs api
# edite portal/site/index.html
$ docker compose up -d --build
$ docker compose down
$ docker compose up -d
$ docker compose restart api
```
> No item 6, a tabela `livros` só existe depois que a página do acervo foi aberta pelo menos uma vez (é o `app.py`
> que cria a tabela). Se aparecer `relation "livros" does not exist`, abra http://localhost:8087 e tente de novo.
</details>

---

## 🔧 Parte 4 — Conserte os arquivos

Cada `compose.yaml` abaixo tem **um** erro. Para cada um: crie numa pasta separada (ex.: `conserto-a/compose.yaml`),
rode `docker compose config`, leia o erro e conserte.

**A.**
```yaml
services:
  banco:
    image: claude/postgres:18-alpine
    environment:
      POSTGRES_PASSWORD: x
    volumes:
      - dados:/var/lib/postgresql
```
**B.**
```yaml
services:
  site:
    image: claude/nginx:alpine
    ports:
      "8081:80"
```
**C.**
```yaml
services:
  site:
    imagem: claude/nginx:alpine
```
**D.** Este não dá erro no `config`, mas a `api` não consegue falar com o banco. Por quê?
```yaml
services:
  api:
    image: claude/acervo-api:1.0
    environment:
      DB_HOST: localhost
      DB_SENHA: x
  banco:
    image: claude/postgres:18-alpine
    environment:
      POSTGRES_PASSWORD: x
```

<details><summary>👀 Ver respostas da parte 4</summary>

- **A.** `service "banco" refers to undefined volume dados`: faltou declarar o volume no final do arquivo:
  ```yaml
  volumes:
    dados:
  ```
- **B.** `services.site.ports must be a array`: o `ports` é uma lista e faltou o `- ` antes de `"8081:80"`.
- **C.** `services.site.imagem ...`: a palavra certa é `image` (em inglês). O Compose não conhece `imagem`.
- **D.** `DB_HOST: localhost` faz a `api` procurar o banco **nela mesma**. O certo é `DB_HOST: banco`, o nome do serviço.
</details>

---

## 🧹 Parte 5 — Fechando

11. Volte para a pasta `biblioteca` e derrube tudo **apagando os dados**.
12. Apague as imagens `claude/portal:1.0` e `claude/acervo-api:1.0`.
13. Confira que não sobrou nenhum container nem volume da biblioteca.

<details><summary>👀 Ver respostas da parte 5</summary>

```bash
$ docker compose down -v
$ docker rmi claude/portal:1.0 claude/acervo-api:1.0
$ docker compose ps -a
$ docker volume ls
```
</details>

---

## ⚡ Prova relâmpago

12 ou mais acertos = nível 5 dominado. 🏆

| # | Pergunta |
|---|----------|
| 1 | Qual o nome do arquivo do Compose? |
| 2 | Comando para subir tudo em segundo plano |
| 3 | Comando para derrubar tudo **mantendo** os dados |
| 4 | Comando para derrubar tudo **apagando** os dados |
| 5 | Como fica `-p 9000:80` no `compose.yaml`? |
| 6 | Como fica `-e MODO=teste` no `compose.yaml`? |
| 7 | O que precisa existir no final do arquivo quando um serviço usa o volume `dados`? |
| 8 | O que significa `build: .`? |
| 9 | Mudei o código da aplicação. Qual comando coloca a versão nova no ar? |
| 10 | Como o serviço `api` acessa o serviço `banco`? |
| 11 | Por que `DB_HOST: localhost` não funciona? |
| 12 | Como entrar no `psql` do serviço `banco`? |
| 13 | Como ver o log só do serviço `api`, ao vivo? |
| 14 | Como usar a variável `SENHA` do arquivo `.env` no `compose.yaml`? |
| 15 | Qual comando mostra o arquivo como o Compose entendeu (e aponta erros)? |

<details><summary>👀 Ver respostas da prova</summary>

| # | Resposta |
|---|----------|
| 1 | `compose.yaml` |
| 2 | `docker compose up -d` |
| 3 | `docker compose down` |
| 4 | `docker compose down -v` |
| 5 | `ports:` com `- "9000:80"` |
| 6 | `environment:` com `MODO: teste` |
| 7 | `volumes:` (sem indentação) com `dados:` |
| 8 | Construir a imagem com o Dockerfile da pasta atual |
| 9 | `docker compose up -d --build` |
| 10 | Pelo nome do serviço: `banco` |
| 11 | Dentro do container, `localhost` é o próprio container |
| 12 | `docker compose exec banco psql -U postgres` |
| 13 | `docker compose logs -f api` |
| 14 | `${SENHA}` |
| 15 | `docker compose config` |
</details>

---

## 🎉 Terminou?

Marque tudo no [PROGRESSO.md](PROGRESSO.md) e avise o Claude: **"terminei o nível 5"**.
Daqui para frente dá para seguir para tópicos como **healthchecks** (esperar o banco ficar pronto de verdade),
voltar ao **nível 4** de redes, ou partir para **publicar imagens** num registry.
