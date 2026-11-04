# Aula 02 — Banco com senha e volume

## 🎯 Nesta aula
- `environment`: variáveis de ambiente (o `-e` do `docker run`).
- `volumes`: guardar dados (o `-v`).
- `docker compose exec`: entrar num serviço.
- `docker compose down -v`: derrubar **apagando os volumes**.

---

## 📖 Aprenda: `environment` e `volumes`

O comando do nível 3:
```bash
$ docker run -d --name banco -e POSTGRES_PASSWORD=lab123 -v banco-dados:/var/lib/postgresql claude/postgres:18-alpine
```
vira:
```yaml
services:
  banco:
    image: claude/postgres:18-alpine
    environment:
      POSTGRES_PASSWORD: lab123
    volumes:
      - banco-dados:/var/lib/postgresql

volumes:
  banco-dados:
```

| No `docker run` | No `compose.yaml` |
|-----------------|-------------------|
| `-e POSTGRES_PASSWORD=lab123` | `environment:` com `POSTGRES_PASSWORD: lab123` (`:` e espaço em vez de `=`) |
| `-v banco-dados:/var/lib/postgresql` | `volumes:` com `- banco-dados:/var/lib/postgresql` |

### Os dois `volumes:`
Repare que `volumes:` aparece **duas vezes**:
```yaml
services:
  banco:
    volumes:                              # ① DENTRO do serviço: "encaixe o volume nesta pasta"
      - banco-dados:/var/lib/postgresql

volumes:                                  # ② NO FINAL, sem indentação: "crie este volume"
  banco-dados:
```
- **①** é o `-v` de sempre: qual volume vai em qual pasta.
- **②** é a lista dos volumes do projeto, o equivalente ao `docker volume create`. **Todo volume com nome usado em ① precisa aparecer em ②.**

> O `banco-dados:` em ② termina com `:` e não tem nada depois. É assim mesmo: "crie com as configurações padrão".

---

## 📖 Mão na massa

```bash
$ cd ~/Projects/docker-lab/nivel-5/pratica
$ mkdir aula-02
$ cd aula-02
$ code .
```
Crie o `compose.yaml` acima e suba:
```bash
$ docker compose up -d
$ docker compose logs
```
Espere aparecer `database system is ready to accept connections`.

### `docker compose exec`: entrar num serviço
Funciona como o `docker exec -it`, mas usando o **nome do serviço** (`banco`), e não o do container:
```bash
$ docker compose exec banco psql -U postgres
```
```sql
CREATE TABLE tarefas (titulo TEXT);
INSERT INTO tarefas VALUES ('aprender compose');
SELECT * FROM tarefas;
\q
```
> Não precisa do `-it`: o `docker compose exec` já é interativo por padrão.

---

## 📖 Aprenda: `down` × `down -v`

```bash
$ docker compose down
$ docker volume ls
```
O volume **continua lá**, com o nome **`aula-02_banco-dados`**: o Compose coloca o nome do projeto na frente.
Suba de novo e confira:
```bash
$ docker compose up -d
$ docker compose exec banco psql -U postgres -c "SELECT * FROM tarefas;"
```
A tarefa está lá! O `down` apaga os containers, mas **guarda os volumes**.

Para apagar **também** os volumes:
```bash
$ docker compose down -v
$ docker volume ls
```
O `aula-02_banco-dados` sumiu, e os dados junto. ⚠️

| Comando | Containers | Volumes (dados) |
|---------|------------|-----------------|
| `docker compose down` | Apagados | **Guardados** ✅ |
| `docker compose down -v` | Apagados | **Apagados** ⚠️ |

---

## ✍️ Pratique

1. Suba o banco da `aula-02` de novo e crie a tabela `livros (titulo TEXT)` com dois livros, usando `psql -c` (sem entrar no psql).
2. Derrube **sem** apagar os dados, suba de novo e mostre os livros.
3. Acrescente ao serviço `banco` a variável `POSTGRES_DB: biblioteca` (ela pede ao Postgres que crie um banco
   com esse nome). Suba de novo **sem** derrubar. Repare na mensagem: o que o Compose fez com o container?
4. Liste os bancos com `docker compose exec banco psql -U postgres -c "\l"`. O `biblioteca` aparece?
   (Spoiler: provavelmente não. Leia a resposta para entender por quê.)
5. Derrube **apagando** os dados, suba de novo e repita o item 4.
6. Derrube tudo, apagando os dados.

<details><summary>👀 Ver respostas</summary>

1. ```bash
   $ docker compose up -d
   $ docker compose exec banco psql -U postgres -c "CREATE TABLE livros (titulo TEXT);"
   $ docker compose exec banco psql -U postgres -c "INSERT INTO livros VALUES ('Duna');"
   $ docker compose exec banco psql -U postgres -c "INSERT INTO livros VALUES ('O Hobbit');"
   ```
2. `docker compose down`, `docker compose up -d` e `docker compose exec banco psql -U postgres -c "SELECT * FROM livros;"`
3. ```yaml
       environment:
         POSTGRES_PASSWORD: lab123
         POSTGRES_DB: biblioteca
   ```
   `docker compose up -d` → `Recreate`: a configuração mudou, então o Compose **apagou e criou de novo** o container
   do `banco`, sozinho. O volume foi mantido.
4. Não aparece. As variáveis `POSTGRES_*` só são lidas na **primeira vez** que o Postgres liga com um volume
   vazio. Como o volume já tinha dados, ele ignorou.
5. `docker compose down -v`, `docker compose up -d` e o `\l` de novo → agora o `biblioteca` aparece (o volume nasceu vazio).
6. `docker compose down -v`
</details>

---

## 🧠 Memorize

1. Como fica `-e SENHA=123` no `compose.yaml`?
2. Por que `volumes:` aparece duas vezes no arquivo?
3. Como entrar no `psql` do serviço `banco`?
4. Qual a diferença entre `docker compose down` e `docker compose down -v`?
5. Mudei uma variável no `compose.yaml` e rodei `up -d`. O que acontece com o container?
6. Numa pasta `loja`, o volume `dados` vai se chamar como?

<details><summary>👀 Ver respostas</summary>

1. ```yaml
   environment:
     SENHA: 123
   ```
2. Dentro do serviço diz **onde encaixar**; no final do arquivo, diz **quais volumes criar**.
3. `docker compose exec banco psql -U postgres`
4. `down` apaga os containers e guarda os volumes; `down -v` apaga os volumes também.
5. O Compose recria o container com a configuração nova.
6. `loja_dados`
</details>

➡️ Próxima: [Aula 03 — Construindo a sua imagem](03-build.md)
