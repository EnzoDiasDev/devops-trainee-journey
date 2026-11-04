# Aula 04 — Um banco de dados que não perde nada

## 🎯 Nesta aula
- Rodar um **banco de dados de verdade** (PostgreSQL) num container.
- Guardar os dados dele num volume.
- Provar que os dados sobrevivem a apagar o container e até a **trocar** o container.

> Você não precisa saber banco de dados nem SQL. Os comandos SQL vêm prontos e explicados.
> O foco é o **Docker**.

---

## 📖 Aprenda: o Postgres em container

O PostgreSQL ("Postgres") é um dos bancos de dados mais usados no mundo. Para rodar:

```bash
$ docker run -d --name banco \
    -e POSTGRES_PASSWORD=lab123 \
    -v banco-dados:/var/lib/postgresql \
    claude/postgres:18-alpine
```
> A `\` no fim da linha só serve para **quebrar um comando comprido** em várias linhas. É o mesmo que
> escrever tudo numa linha só. Se preferir, digite numa linha só, sem as `\`.

| Parte | Por quê |
|-------|---------|
| `-d --name banco` | Em segundo plano, com nome (nível 1) |
| `-e POSTGRES_PASSWORD=lab123` | A imagem **exige** uma senha para o usuário principal. É uma variável de ambiente (nível 2) |
| `-v banco-dados:/var/lib/postgresql` | **O mais importante:** o Postgres guarda tudo em `/var/lib/postgresql`. Encaixamos o volume ali |

> Como saber em que pasta cada programa guarda os dados? Está na página da imagem no Docker Hub
> (hub.docker.com). Toda imagem de banco documenta isso.

Espere uns 5 segundos (o banco demora um pouco para ligar) e confira:
```bash
$ docker logs banco
```
A última linha deve dizer `database system is ready to accept connections` (pronto para receber conexões).

---

## 📖 Aprenda: conversando com o banco

O Postgres vem com um programa chamado **`psql`**, um terminal para falar com o banco. Entre nele com
o `docker exec` do nível 1:
```bash
$ docker exec -it banco psql -U postgres
```
(`-U postgres` = entrar com o usuário `postgres`, o usuário principal.)

O começo da linha muda para **`postgres=#`**. Agora você está falando **com o banco**. Digite os comandos
abaixo, **um por vez**, com `Enter` no final de cada um:

```sql
CREATE TABLE tarefas (titulo TEXT);
```
→ cria uma **tabela** (pense numa planilha) chamada `tarefas`, com uma coluna `titulo`. Resposta: `CREATE TABLE`.

```sql
INSERT INTO tarefas VALUES ('aprender volumes');
INSERT INTO tarefas VALUES ('não perder dados');
```
→ acrescenta duas linhas na planilha. Resposta: `INSERT 0 1` (cada um).

```sql
SELECT * FROM tarefas;
```
→ mostra tudo que tem na planilha:
```
      titulo
------------------
 aprender volumes
 não perder dados
(2 rows)
```
Para sair do `psql`:
```
\q
```

> Os comandos SQL **terminam com `;`**. Se esquecer, o `psql` fica esperando o resto do comando (o começo
> da linha vira `postgres-#`). É só digitar `;` e dar `Enter`.

---

## 🔬 A prova: apagar o container do banco

```bash
$ docker rm -f banco
```
O container foi apagado. Crie um **novo**, com o **mesmo volume**:
```bash
$ docker run -d --name banco -e POSTGRES_PASSWORD=lab123 -v banco-dados:/var/lib/postgresql claude/postgres:18-alpine
```
Espere uns segundos e consulte. Agora sem entrar no `psql`: a opção `-c` passa o comando SQL direto:
```bash
$ docker exec -it banco psql -U postgres -c "SELECT * FROM tarefas;"
```
**As duas tarefas estão lá!** 🎉 Banco novo, dados antigos.

---

## ✍️ Pratique

1. Acrescente a tarefa `estudar docker todo dia` usando `psql -c` (sem entrar no `psql`).
2. Mostre todas as tarefas.
3. Apague o container `banco` e crie outro, chamado `banco-novo`, com o mesmo volume. As 3 tarefas continuam lá?
4. Crie um terceiro container, `banco-vazio`, com um volume **diferente** chamado `outro-banco`.
   Tente consultar as tarefas nele. O que acontece? Por quê?
5. Apague os containers `banco-novo` e `banco-vazio` e o volume `outro-banco`.
   **Guarde** o volume `banco-dados`: ele será usado no desafio.

<details><summary>👀 Ver respostas</summary>

1. `docker exec -it banco psql -U postgres -c "INSERT INTO tarefas VALUES ('estudar docker todo dia');"`
2. `docker exec -it banco psql -U postgres -c "SELECT * FROM tarefas;"`
3. ```bash
   $ docker rm -f banco
   $ docker run -d --name banco-novo -e POSTGRES_PASSWORD=lab123 -v banco-dados:/var/lib/postgresql claude/postgres:18-alpine
   $ docker exec -it banco-novo psql -U postgres -c "SELECT * FROM tarefas;"
   ```
   Sim, as 3 continuam lá.
4. ```bash
   $ docker run -d --name banco-vazio -e POSTGRES_PASSWORD=lab123 -v outro-banco:/var/lib/postgresql claude/postgres:18-alpine
   $ docker exec -it banco-vazio psql -U postgres -c "SELECT * FROM tarefas;"
   ```
   Erro `relation "tarefas" does not exist` (a tabela não existe). É um volume novo, um banco vazio.
5. ```bash
   $ docker rm -f banco-novo banco-vazio
   $ docker volume rm outro-banco
   ```
</details>

---

## 🧠 Memorize

1. Em que pasta o Postgres guarda os dados?
2. Por que o `-e POSTGRES_PASSWORD=...` é obrigatório?
3. Como entrar no terminal do banco dentro do container `banco`? E como sair?
4. Como rodar um comando SQL sem entrar no `psql`?
5. Apaguei o container do banco. Como recuperar os dados?
6. Para que serve a `\` no fim de uma linha de comando?

<details><summary>👀 Ver respostas</summary>

1. `/var/lib/postgresql`
2. A imagem exige uma senha para o usuário principal; sem ela, o container nem liga.
3. `docker exec -it banco psql -U postgres`. Para sair, `\q`.
4. `docker exec -it banco psql -U postgres -c "COMANDO;"`
5. Criando um container novo com o mesmo volume (`-v banco-dados:/var/lib/postgresql`).
6. Quebrar um comando comprido em várias linhas.
</details>

➡️ Próxima: [Aula 05 — Cuidados e limpeza](05-cuidados.md)
