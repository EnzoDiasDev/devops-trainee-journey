# Aula 06 — Desafio do nível 3

Só o que você viu nas aulas 00 a 05 (mais os níveis 1 e 2). Se travar, consulte a [COLA.md](COLA.md)
antes de abrir a resposta. Trabalhe em `~/Projects/docker-lab/nivel-3/pratica/desafio/`.

---

## 📚 Parte 1 — Biblioteca (o banco que sobrevive)

1. Crie um volume chamado `biblioteca-dados`.
2. Suba um Postgres chamado `biblioteca`, em segundo plano, com a senha `livros123`, guardando os dados nesse volume.
3. Confira no log que o banco está pronto.
4. Entre no `psql` e:
   - crie a tabela: `CREATE TABLE livros (titulo TEXT);`
   - cadastre três livros que você gosta (um `INSERT` para cada);
   - mostre todos os livros;
   - saia.
5. Apague o container `biblioteca`.
6. Crie um novo, chamado `biblioteca-v2`, com o mesmo volume, e mostre os livros **sem entrar no `psql`**.

<details><summary>👀 Ver respostas da parte 1</summary>

```bash
$ docker volume create biblioteca-dados
$ docker run -d --name biblioteca -e POSTGRES_PASSWORD=livros123 -v biblioteca-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker logs biblioteca
$ docker exec -it biblioteca psql -U postgres
```
```sql
CREATE TABLE livros (titulo TEXT);
INSERT INTO livros VALUES ('O Hobbit');
INSERT INTO livros VALUES ('Duna');
INSERT INTO livros VALUES ('O Programador Pragmático');
SELECT * FROM livros;
\q
```
```bash
$ docker rm -f biblioteca
$ docker run -d --name biblioteca-v2 -e POSTGRES_PASSWORD=livros123 -v biblioteca-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker exec -it biblioteca-v2 psql -U postgres -c "SELECT * FROM livros;"
```
</details>

---

## 📝 Parte 2 — Mural de recados (volume numa app sua)

Crie a pasta `desafio/mural` com o `mural.py` abaixo. Ele lê a variável `RECADO`, acrescenta o recado
no arquivo `/mural/recados.txt` e mostra o mural inteiro:
```python
import os

recado = os.getenv("RECADO", "(recado em branco)")
with open("/mural/recados.txt", "a") as arquivo:
    arquivo.write(f"- {recado}\n")

print("📌 MURAL DE RECADOS")
print(open("/mural/recados.txt").read())
```

7. Escreva o Dockerfile: imagem com Python, pasta de trabalho `/app`, crie a pasta `/mural` durante o build,
   copie a pasta inteira e rode o `mural.py`. Construa como `claude/mural:1.0`.
8. Deixe três recados diferentes, cada um num `docker run` separado, **sem sobrar container**, de forma que
   o mural guarde todos. Use um volume chamado `mural-dados`.
9. Mostre o mural sem acrescentar recado (troque o comando padrão).
10. Responda: se você rodar a imagem **sem** o `-v`, o recado vai para o mural guardado? Teste.

<details><summary>👀 Ver respostas da parte 2</summary>

```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN mkdir /mural
COPY . .
CMD ["python", "mural.py"]
```
```bash
$ docker build -t claude/mural:1.0 .
$ docker run --rm -v mural-dados:/mural -e RECADO="Bom dia, time!" claude/mural:1.0
$ docker run --rm -v mural-dados:/mural -e RECADO="Reunião às 14h" claude/mural:1.0
$ docker run --rm -v mural-dados:/mural -e RECADO="Terminei o nível 3!" claude/mural:1.0
$ docker run --rm -v mural-dados:/mural claude/mural:1.0 cat /mural/recados.txt
```
10. Não. Sem o volume, o recado vai para a folha de rascunho de um container que é apagado em seguida.
    O mural mostra só aquele recado, e ele se perde. `docker run --rm -e RECADO="sumirei" claude/mural:1.0`
</details>

---

## 🌐 Parte 3 — Site em desenvolvimento (bind mount)

Crie a pasta `desafio/blog` com uma pasta `site` dentro e um `index.html` com o título `Meu blog` e um
parágrafo `Primeiro post: aprendi volumes!`.

11. Suba um nginx chamado `blog-dev`, porta 8086, espelhando a pasta `site` em **somente leitura**.
12. Sem rebuild e sem recriar o container, acrescente um segundo parágrafo `Segundo post: bind mount é demais!`
    e confira no navegador.
13. Prove que o container não consegue alterar a página.

<details><summary>👀 Ver respostas da parte 3</summary>

```bash
$ cd ~/Projects/docker-lab/nivel-3/pratica/desafio/blog
$ docker run -d --name blog-dev -p 8086:80 -v ./site:/usr/share/nginx/html:ro claude/nginx:alpine
# edite site/index.html no VS Code, salve e atualize o navegador
$ docker exec -it blog-dev sh
# echo "hack" > /usr/share/nginx/html/index.html
# exit
```
Erro `Read-only file system`.
</details>

---

## 🧹 Parte 4 — Arrumando a casa

14. Apague os containers `biblioteca-v2` e `blog-dev` com um único comando.
15. Liste os volumes. Apague `biblioteca-dados`, `mural-dados` e, se ainda existir, `banco-dados` (da aula 04).
    **Não** apague o volume de nome enorme do Girus.
16. Confira que não sobrou nenhum volume do lab.

<details><summary>👀 Ver respostas da parte 4</summary>

```bash
$ docker rm -f biblioteca-v2 blog-dev
$ docker volume ls
$ docker volume rm biblioteca-dados mural-dados banco-dados
$ docker volume ls
```
</details>

---

## ⚡ Prova relâmpago

12 ou mais acertos = nível 3 dominado. 🏆

| # | Pergunta |
|---|----------|
| 1 | O que acontece com os arquivos de um container quando ele é apagado? |
| 2 | Comando para criar o volume `uploads` |
| 3 | Comando para listar os volumes |
| 4 | Comando para apagar o volume `uploads` |
| 5 | Como rodar `claude/app:1.0` com o volume `uploads` na pasta `/app/uploads`? |
| 6 | Como ver onde um volume fica de verdade no seu computador? |
| 7 | Por que não consigo apagar um volume? |
| 8 | Como ligar a pasta `./html` do seu computador à `/usr/share/nginx/html` do container? |
| 9 | Como deixar esse bind mount somente leitura? |
| 10 | Volume ou bind mount: banco de dados em produção? E editar um site enquanto desenvolve? |
| 11 | Em que pasta o Postgres guarda os dados? |
| 12 | Comando para entrar no `psql` do container `banco` |
| 13 | O que é um volume anônimo? |
| 14 | Como apagar um container junto com os volumes anônimos dele? |
| 15 | Como atualizar uma aplicação para uma imagem nova sem perder os dados? |

<details><summary>👀 Ver respostas da prova</summary>

| # | Resposta |
|---|----------|
| 1 | São apagados junto com ele (os que não estão num volume) |
| 2 | `docker volume create uploads` |
| 3 | `docker volume ls` |
| 4 | `docker volume rm uploads` |
| 5 | `docker run -v uploads:/app/uploads claude/app:1.0` |
| 6 | `docker volume inspect <nome>` (linha `Mountpoint`) |
| 7 | Algum container (ligado ou parado) está usando ele |
| 8 | `-v ./html:/usr/share/nginx/html` |
| 9 | `-v ./html:/usr/share/nginx/html:ro` |
| 10 | Banco: volume. Desenvolver site: bind mount |
| 11 | `/var/lib/postgresql` |
| 12 | `docker exec -it banco psql -U postgres` |
| 13 | Volume de nome aleatório que o Docker cria quando a imagem pede um volume e você não informa um com `-v` |
| 14 | `docker rm -v <container>` (com `-f` se estiver ligado) |
| 15 | Rodar a imagem nova com o **mesmo volume** |
</details>

---

## 🎉 Terminou?

Marque tudo no [PROGRESSO.md](PROGRESSO.md) e avise o Claude: **"terminei o nível 3"**.
No nível 4 você vai fazer **containers conversarem entre si** (redes), por exemplo uma aplicação Python
falando com esse Postgres.
