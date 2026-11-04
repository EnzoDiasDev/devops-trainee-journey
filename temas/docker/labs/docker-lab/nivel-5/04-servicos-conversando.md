# Aula 04 — Serviços conversando

## 🎯 Nesta aula
- O mínimo de rede que você precisa (o assunto do nível 4, resumido).
- O **nome do serviço** é o **endereço** dele.
- `depends_on`: a ordem de subida.
- Montar uma aplicação web que guarda as visitas no Postgres.

---

## 📖 Aprenda: o mínimo de rede

### 1. O Compose cria uma rede para o projeto
Lembra da `Network aula-01_default` que aparecia no `up`? É uma **rede**: uma "sala" onde todos os serviços do
`compose.yaml` ficam juntos e podem conversar.

### 2. O nome do serviço vira endereço
Dentro dessa sala, cada serviço é encontrado **pelo nome que você deu a ele** no `compose.yaml`.
Se o serviço se chama `banco`, os outros serviços falam com ele no endereço **`banco`**.

```
           rede "aula-04_default" (criada pelo Compose)
 ┌───────────────────────────────────────────────────┐
 │  ┌──────────┐   "banco", porta 5432   ┌─────────┐  │
 │  │   web    │ ──────────────────────► │  banco  │  │
 │  └──────────┘                         └─────────┘  │
 └───────────────────────────────────────────────────┘
```

### 3. ⚠️ `localhost` dentro do container é **ele mesmo**
No seu computador, `localhost` é o seu computador. **Dentro de um container, `localhost` é o próprio container.**
Se a aplicação `web` procurar o banco em `localhost`, ela procura **dentro dela mesma** e não encontra nada
(`Connection refused`). Use sempre **o nome do serviço**.

### 4. Entre serviços não precisa de `ports`
O `ports:` é a porta de entrada **do seu computador** para o container (para o navegador).
Entre serviços da mesma rede, eles já se alcançam direto, na **porta do próprio container**. Por isso o banco
**não precisa** de `ports`, e é mais seguro sem.

| Quem acessa | Endereço | Precisa de `ports`? |
|-------------|----------|---------------------|
| Seu navegador | `localhost:<porta do lado esquerdo>` | ✅ Sim |
| Outro serviço do compose | `<nome-do-serviço>:<porta do container>` | ❌ Não |

---

## 📖 Aprenda: `depends_on`

```yaml
  web:
    depends_on:
      - banco
```
"Suba o `banco` **antes** da `web`." Ele garante a **ordem de subida**, mas **não espera o banco ficar pronto**
(o Postgres leva alguns segundos para aceitar conexões depois de ligado). Se você acessar a aplicação logo
depois do `up`, pode ver um erro. Espere uns segundos e atualize.

---

## 📖 Mão na massa: contador de visitas web

```bash
$ cd ~/Projects/docker-lab/nivel-5/pratica
$ mkdir aula-04
$ cd aula-04
$ code .
```
`app.py` (pronto, é só copiar). É uma página web feita com **Flask** (biblioteca para sites em Python). A cada
acesso, ela registra uma visita no Postgres e mostra o total:
```python
import os

import psycopg
from flask import Flask

app = Flask(__name__)


@app.route("/")
def inicio():
    with psycopg.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user="postgres",
        password=os.getenv("DB_SENHA", ""),
        connect_timeout=3,
    ) as conexao:
        conexao.execute("CREATE TABLE IF NOT EXISTS visitas (quando TIMESTAMP DEFAULT now())")
        conexao.execute("INSERT INTO visitas DEFAULT VALUES")
        total = conexao.execute("SELECT count(*) FROM visitas").fetchone()[0]
    return f"<h1>Olá do Docker Compose! 🐳</h1><p>Você é a visita número {total}.</p>"
```
Repare: ela descobre **onde está o banco** pela variável `DB_HOST`.

`Dockerfile`:
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install flask "psycopg[binary]"
COPY . .
CMD ["flask", "--app", "app", "run", "--host", "0.0.0.0", "--port", "5000"]
```
> O `CMD` liga o servidor do Flask na **porta 5000**. O `--host 0.0.0.0` faz ele aceitar conexões vindas de fora
> do container. Sem isso, ele só atenderia o `localhost` dele mesmo, e nem o navegador conseguiria acessar.

`compose.yaml`:
```yaml
services:
  web:
    build: .
    image: claude/contador-web:1.0
    ports:
      - "8081:5000"
    environment:
      DB_HOST: banco
      DB_SENHA: lab123
    depends_on:
      - banco

  banco:
    image: claude/postgres:18-alpine
    environment:
      POSTGRES_PASSWORD: lab123
    volumes:
      - banco-dados:/var/lib/postgresql

volumes:
  banco-dados:
```
Leia com calma: tudo aqui você já conhece.
- `DB_HOST: banco` → a `web` acha o banco **pelo nome do serviço**.
- `DB_SENHA` (web) e `POSTGRES_PASSWORD` (banco) → a **mesma** senha dos dois lados.
- O `banco` **não tem `ports`**: só a `web` fala com ele.

```bash
$ docker compose up -d
```
Espere uns 5 segundos e abra **http://localhost:8081**. Atualize a página várias vezes e veja o número subir. 🎉

> Se aparecer **Internal Server Error** logo no começo, o banco ainda estava ligando (lembre do `depends_on`).
> Espere e atualize.

Para ver o que a aplicação está fazendo:
```bash
$ docker compose logs web
```

---

## ✍️ Pratique

1. Faça `docker compose down` (sem `-v`) e `docker compose up -d`. O contador continuou de onde parou? Por quê?
2. Confira o total direto no banco:
   `docker compose exec banco psql -U postgres -c "SELECT count(*) FROM visitas;"`
3. **Provoque o erro do `localhost`:** troque `DB_HOST: banco` por `DB_HOST: localhost`, rode `docker compose up -d` e
   acesse a página. Que erro aparece no `docker compose logs web`? Desfaça a mudança e suba de novo.
4. **Provoque o erro de senha:** troque só o `DB_SENHA` para `errada`. O que aparece no log? Desfaça.
5. Mude a frase `Olá do Docker Compose!` no `app.py` para `Contador da Enzo Store` e coloque no ar. Que comando foi necessário?

<details><summary>👀 Ver respostas</summary>

1. Sim. Os dados estão no volume `aula-04_banco-dados`, e o `down` sem `-v` não apaga volumes.
2. O número bate com o último mostrado na página.
3. No log aparece `connection to server at "127.0.0.1", port 5432 failed: Connection refused`. A `web` procurou o banco
   **nela mesma**. Volte para `DB_HOST: banco` e rode `docker compose up -d`.
4. `password authentication failed for user "postgres"`. Repare que a conexão chegou ao banco; o problema é só a senha.
5. `docker compose up -d --build`: o código vai para a imagem, então precisa reconstruir.
</details>

> Guarde a pasta `aula-04`: ela será usada na próxima aula.

---

## 🧠 Memorize

1. Como a `web` encontra o serviço `banco`?
2. Dentro de um container, quem é o `localhost`?
3. O banco precisa de `ports` para a `web` falar com ele?
4. O `depends_on` espera o banco ficar pronto?
5. Qual erro aparece no log quando a aplicação procura o banco em `localhost`?
6. Para que serve o `--host 0.0.0.0` no comando do Flask?

<details><summary>👀 Ver respostas</summary>

1. Pelo nome do serviço: `banco`.
2. O próprio container.
3. Não.
4. Não. Só garante que ele sobe antes.
5. `Connection refused`
6. Fazer o Flask aceitar conexões vindas de fora do próprio container.
</details>

➡️ Próxima: [Aula 05 — Comandos do dia a dia e o arquivo .env](05-dia-a-dia.md)
