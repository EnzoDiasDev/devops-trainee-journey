# Aula 01 — Seu primeiro `compose.yaml`

## 🎯 Nesta aula
- `services`, `image` e `ports`: descrever um container no arquivo.
- `docker compose up -d`, `ps`, `logs` e `down`: os quatro comandos básicos.
- Por que **a pasta** do `compose.yaml` importa.

---

## 📖 Aprenda: do `docker run` para o arquivo

Lembra deste comando do nível 1?
```bash
$ docker run -d --name site -p 8081:80 claude/nginx:alpine
```
No Compose, ele vira:
```yaml
services:
  site:
    image: claude/nginx:alpine
    ports:
      - "8081:80"
```
| No `docker run` | No `compose.yaml` |
|-----------------|-------------------|
| `--name site` | O nome do **serviço** (`site:`) |
| `claude/nginx:alpine` | `image: claude/nginx:alpine` |
| `-p 8081:80` | `ports:` com `- "8081:80"` |
| `-d` | Vai no comando: `docker compose up -d` |

- **`services:`** é a lista de containers do sistema. Cada um é um **serviço**.
- Um **serviço** é a "receita" de um container: qual imagem, quais portas etc.

---

## 📖 Mão na massa

```bash
$ cd ~/Projects/docker-lab/nivel-5/pratica
$ mkdir aula-01
$ cd aula-01
$ code .
```
Crie o arquivo **`compose.yaml`** (exatamente esse nome) com o conteúdo de cima e salve.

### `docker compose up -d`: subir
```bash
$ docker compose up -d
```
```
 ✔ Network aula-01_default   Created
 ✔ Container aula-01-site-1  Started
```
Abra **http://localhost:8081**: "Welcome to nginx!". 🎉

> Repare: todo comando do Compose é `docker compose <algo>` e deve ser rodado **na pasta do `compose.yaml`**.

### `docker compose ps`: ver os containers do sistema
```bash
$ docker compose ps
```
Parecido com o `docker ps`, mas mostra **só** os containers deste `compose.yaml`.

### O nome do container
O container se chama **`aula-01-site-1`**:
```
aula-01  -  site  -  1
└──┬──┘     └─┬┘    └┬┘
 projeto   serviço  número
(nome da pasta)
```
O Compose usa o **nome da pasta** como **nome do projeto**. Por isso a pasta importa: se você rodar o mesmo
arquivo em outra pasta, é **outro projeto**, com outros containers.

Os comandos do nível 1 continuam funcionando com esse nome:
```bash
$ docker ps
$ docker logs aula-01-site-1
```

### `docker compose logs`: ver os logs
```bash
$ docker compose logs
```
Mostra o log de **todos** os serviços, com o nome de cada um no começo da linha (`site-1 | ...`).
Visite a página algumas vezes e rode de novo. As mesmas opções do nível 1 funcionam:
```bash
$ docker compose logs --tail 3
$ docker compose logs -f          # ao vivo (sair: Ctrl + C)
```

### `docker compose down`: derrubar
```bash
$ docker compose down
```
```
 ✔ Container aula-01-site-1  Removed
 ✔ Network aula-01_default   Removed
```
O `down` **para e apaga** os containers do projeto (é o `docker rm -f` de tudo de uma vez).
A imagem **não** é apagada. E aquela `Network ... default`? Ela é explicada na aula 04.

> 💡 `up` sobe tudo, `down` derruba tudo. Pode subir e derrubar quantas vezes quiser: o arquivo continua lá.

---

## ✍️ Pratique

1. Na pasta `aula-01`, mude a porta para **8082**, suba e abra no navegador.
2. Acrescente um **segundo** serviço chamado `blog`, também do `claude/nginx:alpine`, na porta **8083**.
   (Ele fica no mesmo nível do `site`, dentro de `services`.) Suba de novo **sem** derrubar antes. O que o Compose fez com o `site`?
3. Veja os containers do projeto. Quais os nomes deles?
4. Mostre só as 2 últimas linhas de log.
5. Derrube tudo e confirme com `docker compose ps` que não sobrou nada.

<details><summary>👀 Ver respostas</summary>

1. No arquivo, troque para `- "8082:80"`. Depois `docker compose up -d` e abra http://localhost:8082.
2. ```yaml
   services:
     site:
       image: claude/nginx:alpine
       ports:
         - "8082:80"

     blog:
       image: claude/nginx:alpine
       ports:
         - "8083:80"
   ```
   `docker compose up -d` → o `site` aparece como `Running` (não mudou, então foi deixado como estava) e o `blog`
   é criado. O Compose só mexe no que mudou.
3. `docker compose ps` → `aula-01-site-1` e `aula-01-blog-1`.
4. `docker compose logs --tail 2`
5. `docker compose down` e `docker compose ps` (lista vazia).
</details>

---

## 🧠 Memorize

1. Como fica `docker run -d --name api -p 9000:3000 claude/minha-api:1.0` num `compose.yaml`?
2. Qual comando sobe tudo? E qual derruba?
3. Como ver só os containers do projeto?
4. Numa pasta `loja`, com um serviço `banco`, qual será o nome do container?
5. O `docker compose down` apaga as imagens?
6. De qual pasta é preciso rodar os comandos do Compose?

<details><summary>👀 Ver respostas</summary>

1. ```yaml
   services:
     api:
       image: claude/minha-api:1.0
       ports:
         - "9000:3000"
   ```
2. `docker compose up -d` · `docker compose down`
3. `docker compose ps`
4. `loja-banco-1`
5. Não.
6. Da pasta onde está o `compose.yaml`.
</details>

➡️ Próxima: [Aula 02 — Banco com senha e volume](02-variaveis-e-volumes.md)
