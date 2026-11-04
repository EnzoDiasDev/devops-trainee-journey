# Aula 05 — Desafio do nível 4

Só o que você viu nas aulas 00 a 04 (mais os níveis 1 a 3). Se travar, consulte a [COLA.md](COLA.md)
antes de abrir a resposta. Trabalhe em `~/Projects/docker-lab/nivel-4/pratica/desafio/`.

Você vai montar um pequeno **sistema de pedidos**:
```
            rede "frente"                         rede "dados"
 ┌──────────────────────────────┐      ┌──────────────────────────────────┐
 │ navegador ─► vitrine (nginx) │      │ pedidos (app) ──► pedidos-db     │
 │              monitor (alpine)│      │                   (Postgres+vol) │
 └──────────────────────────────┘      └──────────────────────────────────┘
```

---

## 🗄️ Parte 1 — Redes e banco

1. Crie as redes `frente` e `dados`.
2. Suba o Postgres `pedidos-db` **só** na rede `dados`, com senha `pedidos123` e volume `pedidos-dados`.
   Sem publicar porta. Confira no log que ele está pronto.

<details><summary>👀 Ver respostas da parte 1</summary>

```bash
$ docker network create frente
$ docker network create dados
$ docker run -d --name pedidos-db --network dados -e POSTGRES_PASSWORD=pedidos123 -v pedidos-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker logs pedidos-db
```
</details>

---

## 🐍 Parte 2 — A aplicação de pedidos

Crie a pasta `desafio/app` com o `pedidos.py` (pronto). Se a variável `PRODUTO` estiver preenchida, ele
registra um pedido. Em todos os casos, mostra a lista de pedidos:
```python
import os

import psycopg

host = os.getenv("DB_HOST", "localhost")
senha = os.getenv("DB_SENHA", "")
produto = os.getenv("PRODUTO")

with psycopg.connect(host=host, user="postgres", password=senha, connect_timeout=3) as conexao:
    conexao.execute("CREATE TABLE IF NOT EXISTS pedidos (produto TEXT)")
    if produto:
        conexao.execute("INSERT INTO pedidos VALUES (%s)", (produto,))
        print(f"Pedido registrado: {produto}")
    pedidos = conexao.execute("SELECT produto FROM pedidos").fetchall()

print(f"Total de pedidos: {len(pedidos)}")
for (nome,) in pedidos:
    print(f" - {nome}")
```

3. Escreva o Dockerfile: Python, pasta `/app`, instale `"psycopg[binary]"`, copie a pasta e use
   `DB_HOST="pedidos-db"` como **valor padrão**. Construa como `claude/pedidos:1.0`.
4. Registre três pedidos (`pizza`, `hamburguer`, `sorvete`), um por `docker run`, sem sobrar container.
   (Repare: com o valor padrão no Dockerfile, você só precisa passar a senha e o produto.)
5. Mostre a lista de pedidos sem registrar um novo.

<details><summary>👀 Ver respostas da parte 2</summary>

```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install "psycopg[binary]"
COPY . .
ENV DB_HOST="pedidos-db"
CMD ["python", "pedidos.py"]
```
```bash
$ docker build -t claude/pedidos:1.0 .
$ docker run --rm --network dados -e DB_SENHA=pedidos123 -e PRODUTO=pizza claude/pedidos:1.0
$ docker run --rm --network dados -e DB_SENHA=pedidos123 -e PRODUTO=hamburguer claude/pedidos:1.0
$ docker run --rm --network dados -e DB_SENHA=pedidos123 -e PRODUTO=sorvete claude/pedidos:1.0
$ docker run --rm --network dados -e DB_SENHA=pedidos123 claude/pedidos:1.0
```
</details>

---

## 🌐 Parte 3 — Vitrine e monitor

6. Suba um nginx `vitrine` na rede `frente`, publicado na porta 8086 **só para o seu computador**. Abra no navegador.
7. Suba um alpine `monitor` (com `sleep 3600`) na rede `frente`.
8. Prove que o `monitor` consegue baixar a página da `vitrine` **pelo nome**. Qual porta ele usa: 8086 ou 80?
9. Prove que o `monitor` **não** alcança o `pedidos-db`.
10. A equipe de suporte precisa que o `monitor` verifique se o banco está vivo. Coloque o `monitor` **também**
    na rede `dados` e faça o `ping` no banco. Depois **tire** o acesso de novo.

<details><summary>👀 Ver respostas da parte 3</summary>

```bash
$ docker run -d --name vitrine --network frente -p 127.0.0.1:8086:80 claude/nginx:alpine
$ docker run -d --name monitor --network frente claude/alpine:3.22 sleep 3600
$ docker exec monitor wget -qO- http://vitrine        # porta 80 (a do container); a 8086 é do seu computador
$ docker exec monitor ping -c 1 pedidos-db            # bad address
$ docker network connect dados monitor
$ docker exec monitor ping -c 1 pedidos-db            # responde
$ docker network disconnect dados monitor
```
</details>

---

## 🔧 Parte 4 — Conserte os comandos

Cada comando abaixo tem **um** problema. Rode, leia o erro, descubra a causa e corrija.

**11.**
```bash
$ docker run --rm -e DB_SENHA=pedidos123 -e DB_HOST=localhost --network dados claude/pedidos:1.0
```
**12.**
```bash
$ docker run --rm -e DB_SENHA=pedidos123 --network frente claude/pedidos:1.0
```
**13.**
```bash
$ docker exec monitor wget -qO- -T 3 http://vitrine:8086
```
**14.**
```bash
$ docker run --rm -e DB_SENHA=pedido123 --network dados claude/pedidos:1.0
```

<details><summary>👀 Ver respostas da parte 4</summary>

11. `Connection refused` em `127.0.0.1`: `localhost` é o próprio container da aplicação. Tire o `-e DB_HOST=localhost`
    (o padrão já é `pedidos-db`) ou use `-e DB_HOST=pedidos-db`.
12. `failed to resolve host 'pedidos-db'`: a aplicação está na rede `frente`, e o banco na `dados`. Use `--network dados`.
13. `Connection refused`: a 8086 é a porta do seu computador. Dentro da rede, use a do container: `http://vitrine` (porta 80).
14. `password authentication failed`: a senha está errada (`pedido123`, faltou o "s"). Use `pedidos123`.
</details>

---

## 🧹 Parte 5 — Arrumando a casa

15. Apague os containers `pedidos-db`, `vitrine` e `monitor` com um único comando.
16. Apague as redes `frente` e `dados` e o volume `pedidos-dados`.
17. Confira que sobraram só as redes padrão (`bridge`, `host`, `none`).

<details><summary>👀 Ver respostas da parte 5</summary>

```bash
$ docker rm -f pedidos-db vitrine monitor
$ docker network rm frente dados
$ docker volume rm pedidos-dados
$ docker network ls
```
</details>

---

## ⚡ Prova relâmpago

12 ou mais acertos = nível 4 dominado. 🏆

| # | Pergunta |
|---|----------|
| 1 | Dentro de um container, quem é o `localhost`? |
| 2 | Na rede padrão (`bridge`), um container acha o outro pelo nome? |
| 3 | Comando para criar a rede `app-rede` |
| 4 | Comando para listar as redes |
| 5 | Como rodar o container `api` na rede `app-rede`? |
| 6 | Na mesma rede, como outro container chama o `api` na porta 3000? |
| 7 | Containers na mesma rede precisam de `-p` para conversar? |
| 8 | Com `-p 9000:80`, que porta outro container da rede usa? |
| 9 | Como publicar a porta 8081→80 só para o seu computador? |
| 10 | Como colocar o container `api` também na rede `banco-rede`? |
| 11 | Como tirar o `api` da rede `banco-rede`? |
| 12 | Como ver quais containers estão numa rede? |
| 13 | O que indica `failed to resolve host`? |
| 14 | O que indica `Connection refused`? |
| 15 | Por que o banco de dados não deve ter `-p` nem ficar na mesma rede de tudo? |

<details><summary>👀 Ver respostas da prova</summary>

| # | Resposta |
|---|----------|
| 1 | O próprio container |
| 2 | Não |
| 3 | `docker network create app-rede` |
| 4 | `docker network ls` |
| 5 | `docker run --name api --network app-rede <imagem>` |
| 6 | `http://api:3000` |
| 7 | Não |
| 8 | 80 (a do container) |
| 9 | `-p 127.0.0.1:8081:80` |
| 10 | `docker network connect banco-rede api` |
| 11 | `docker network disconnect banco-rede api` |
| 12 | `docker network inspect <rede>` |
| 13 | O nome não foi encontrado (digitação, rede diferente ou container desligado) |
| 14 | Chegou no endereço, mas ninguém atende ali (`localhost` errado, porta errada ou serviço desligado) |
| 15 | Segurança: só quem precisa deve alcançar o banco |
</details>

---

## 🎉 Terminou?

Marque tudo no [PROGRESSO.md](PROGRESSO.md) e avise o Claude: **"terminei o nível 4"**.

No nível 5 vem o **Docker Compose**. Repare quantos comandos você digitou neste desafio (redes, banco, app,
vitrine...). O Compose junta **tudo isso num arquivo só** e sobe o sistema inteiro com **um comando**. 🚀
