# Aula 03 — Uma aplicação falando com o banco

## 🎯 Nesta aula
- Juntar tudo: **sua imagem** (nível 2) + **banco com volume** (nível 3) + **rede** (nível 4).
- Configurar o endereço do banco por **variável de ambiente**.
- Reconhecer as mensagens de erro de conexão mais comuns.

---

## 📖 Aprenda: a aplicação "contador de visitas"

Toda vez que roda, ela se conecta ao Postgres, registra uma visita e mostra o total.
Ela descobre **onde está o banco** pela variável `DB_HOST` e a senha pela `DB_SENHA`.

```bash
$ cd ~/Projects/docker-lab/nivel-4/pratica
$ mkdir aula-03
$ cd aula-03
$ code .
```

`visitas.py` (pronto, é só copiar):
```python
import os

import psycopg

host = os.getenv("DB_HOST", "localhost")
senha = os.getenv("DB_SENHA", "")

print(f"Conectando ao banco em '{host}'...")
with psycopg.connect(host=host, user="postgres", password=senha, connect_timeout=3) as conexao:
    conexao.execute("CREATE TABLE IF NOT EXISTS visitas (quando TIMESTAMP DEFAULT now())")
    conexao.execute("INSERT INTO visitas DEFAULT VALUES")
    total = conexao.execute("SELECT count(*) FROM visitas").fetchone()[0]

print(f"Conectado! Esta é a visita número {total}.")
```
> O `psycopg` é a biblioteca que o Python usa para falar com o Postgres. Por isso o Dockerfile instala ela.

`Dockerfile`:
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install "psycopg[binary]"
COPY . .
ENV DB_HOST="localhost"
CMD ["python", "visitas.py"]
```
> As aspas em `"psycopg[binary]"` são necessárias por causa dos colchetes.

```bash
$ docker build -t claude/visitas:1.0 .
```

---

## 📖 Mão na massa: montando o sistema

**1. A rede**
```bash
$ docker network create sistema
```

**2. O banco, na rede, com volume (nível 3)**
```bash
$ docker run -d --name banco --network sistema \
    -e POSTGRES_PASSWORD=lab123 \
    -v visitas-dados:/var/lib/postgresql \
    claude/postgres:18-alpine
```
Espere uns 5 segundos e confira com `docker logs banco` (`ready to accept connections`).

**3. A aplicação, na mesma rede, apontando para o banco pelo nome**
```bash
$ docker run --rm --network sistema -e DB_HOST=banco -e DB_SENHA=lab123 claude/visitas:1.0
```
```
Conectando ao banco em 'banco'...
Conectado! Esta é a visita número 1.
```
Rode mais algumas vezes e veja o número subir. 📈

```
 ┌──────────────── rede "sistema" ────────────────┐
 │  ┌──────────────┐   banco:5432   ┌──────────┐  │
 │  │ visitas (app)│ ─────────────► │  banco   │──┼──► volume visitas-dados
 │  └──────────────┘                └──────────┘  │
 └────────────────────────────────────────────────┘
```
Repare: o banco **não tem `-p`**. Só a aplicação precisa falar com ele, e ela está na mesma rede. Banco
com porta aberta sem necessidade é risco de segurança.

---

## 🔬 Os três erros mais comuns

Provoque cada um de propósito. Reconhecer essas mensagens economiza horas.

**Erro 1: `localhost`**
```bash
$ docker run --rm --network sistema -e DB_SENHA=lab123 claude/visitas:1.0
```
(Sem `-e DB_HOST`, vale o padrão do Dockerfile: `localhost`.)
```
connection to server at "127.0.0.1", port 5432 failed: Connection refused
	Is the server running on that host and accepting TCP/IP connections?
```
➡️ A aplicação procurou o banco **nela mesma**. Solução: `DB_HOST` com o **nome do container do banco**.

**Erro 2: nome que não existe na rede**
```bash
$ docker run --rm --network sistema -e DB_HOST=bnaco -e DB_SENHA=lab123 claude/visitas:1.0
```
```
failed to resolve host 'bnaco'
```
➡️ O nome não está na agenda da rede: erro de digitação, ou o banco está em **outra rede**.

**Erro 3: senha errada**
```bash
$ docker run --rm --network sistema -e DB_HOST=banco -e DB_SENHA=errada claude/visitas:1.0
```
```
FATAL:  password authentication failed for user "postgres"
```
➡️ Repare que **a conexão funcionou** (chegou até o banco). O problema é só a senha.

| Mensagem | Significa |
|----------|-----------|
| `Connection refused` | Chegou no endereço, mas ninguém atende ali (`localhost` errado, porta errada, banco desligado) |
| `failed to resolve host` | O **nome** não foi encontrado (digitação ou rede diferente) |
| `password authentication failed` | Conectou, mas a senha está errada |

---

## ✍️ Pratique

1. Rode a aplicação 3 vezes e anote o total de visitas.
2. Apague o container `banco` e crie de novo (mesmo comando, mesmo volume). Rode a aplicação. O total continuou de onde parou? Por quê?
3. Desligue o banco (`docker stop banco`) e rode a aplicação. Qual erro aparece? Ligue o banco de novo.
4. Crie uma rede chamada `outra` e rode a aplicação **nela** (com `DB_HOST=banco`). O que acontece? Por quê?
5. Construa a `claude/visitas:2.0` com o valor padrão `DB_HOST="banco"` no Dockerfile. Agora rode **sem** `-e DB_HOST`.
6. Confira com `psql` quantas linhas tem a tabela `visitas`:
   `docker exec -it banco psql -U postgres -c "SELECT count(*) FROM visitas;"`

<details><summary>👀 Ver respostas</summary>

1. `docker run --rm --network sistema -e DB_HOST=banco -e DB_SENHA=lab123 claude/visitas:1.0` (3 vezes)
2. ```bash
   $ docker rm -f banco
   $ docker run -d --name banco --network sistema -e POSTGRES_PASSWORD=lab123 -v visitas-dados:/var/lib/postgresql claude/postgres:18-alpine
   ```
   Sim: os dados estão no volume (nível 3), e o nome `banco` volta a funcionar na rede.
3. `docker stop banco` → a aplicação mostra `failed to resolve host 'banco'`: um container **desligado sai da
   agenda** da rede. Depois `docker start banco`.
4. ```bash
   $ docker network create outra
   $ docker run --rm --network outra -e DB_HOST=banco -e DB_SENHA=lab123 claude/visitas:1.0
   $ docker network rm outra
   ```
   `failed to resolve host 'banco'`: o banco está na rede `sistema`, e a agenda da rede `outra` não conhece ele.
   (Evite rodar a aplicação **sem** `--network`: na rede padrão, por causa da pegadinha da aula 00, ela tentaria
   conectar num servidor externo.)
5. No Dockerfile: `ENV DB_HOST="banco"`. Depois:
   ```bash
   $ docker build -t claude/visitas:2.0 .
   $ docker run --rm --network sistema -e DB_SENHA=lab123 claude/visitas:2.0
   ```
6. Mostra o total, igual ao último número que a aplicação mostrou.
</details>

> **Guarde** a rede `sistema`, o `banco` e o volume `visitas-dados` para a próxima aula.

---

## 🧠 Memorize

1. Que três coisas a aplicação e o banco precisam para conversar?
2. O que colocar no `DB_HOST` para a aplicação achar o banco?
3. O banco precisa de `-p` para a aplicação falar com ele?
4. `Connection refused` × `failed to resolve host` × `password authentication failed`: o que cada um indica?
5. Apaguei e recriei o container do banco. A aplicação perde os dados?

<details><summary>👀 Ver respostas</summary>

1. Estar na mesma rede, a aplicação usar o nome certo do banco e a senha certa.
2. O nome do container do banco.
3. Não.
4. Ninguém atendendo no endereço · nome não encontrado · senha errada.
5. Não, se o banco usar o mesmo volume.
</details>

➡️ Próxima: [Aula 04 — Várias redes e isolamento](04-varias-redes.md)
