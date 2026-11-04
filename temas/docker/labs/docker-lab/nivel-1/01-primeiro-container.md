# Aula 01 — Primeiro container

## 🎯 Nesta aula
- `docker run`: criar e rodar um container.
- `docker ps` e `docker ps -a`: ver os containers.

---

## 📖 Aprenda: `docker run`

`docker run` pega uma imagem e cria um container a partir dela.

```
docker  run  claude/hello-world
              └──────┬────────┘
               qual imagem usar
```

Rode:
```bash
$ docker run claude/hello-world
```

Você vai ver uma mensagem começando com **`Hello from Docker!`**. Isso foi o programa que estava
dentro da imagem rodando. Ele mostrou a mensagem e **terminou**.

---

## 📖 Aprenda: `docker ps`

`ps` vem de *process status*. Mostra os containers.

| Comando | Mostra |
|---------|--------|
| `docker ps` | Só os containers **rodando agora** |
| `docker ps -a` | **Todos** os containers, inclusive os que já terminaram (`-a` = *all*, todos) |

Rode os dois:
```bash
$ docker ps
$ docker ps -a
```

O `docker ps` provavelmente veio vazio (ou só com containers que não são do lab). O seu hello-world
**terminou**, por isso só aparece no `docker ps -a`.

### Lendo a tabela do `docker ps -a`
```
CONTAINER ID   IMAGE                COMMAND    CREATED         STATUS                     PORTS   NAMES
3ef3a6d9c4dc   claude/hello-world   "/hello"   4 seconds ago   Exited (0) 3 seconds ago           eager_turing
```

| Coluna | Significado |
|--------|-------------|
| `CONTAINER ID` | Código único do container |
| `IMAGE` | De qual imagem ele foi criado |
| `COMMAND` | O programa que ele roda |
| `CREATED` | Quando foi criado |
| `STATUS` | `Up ...` = rodando · `Exited (0)` = terminou normalmente · `Exited (1)` ou outro número = terminou com erro |
| `PORTS` | Portas abertas (aula 03) |
| `NAMES` | Nome do container. Se você não der um nome, o Docker inventa um (tipo `eager_turing`) |

### Regra de ouro 🥇
> **Um container fica ligado enquanto o programa dele estiver rodando.**
> O hello-world mostra a mensagem e acaba → o container para (`Exited`).

---

## ✍️ Pratique

1. Rode o `claude/hello-world` mais **duas** vezes.
2. Liste **todos** os containers. Quantos containers do `claude/hello-world` existem agora?
3. Os nomes deles são iguais ou diferentes?
4. Rode `docker ps` (sem `-a`). Algum hello-world aparece? Por quê?

<details><summary>👀 Ver respostas</summary>

1. ```bash
   $ docker run claude/hello-world
   $ docker run claude/hello-world
   ```
2. `docker ps -a` → **3** containers (um da explicação + dois agora). Cada `docker run` cria um container **novo**.
3. Diferentes. Cada container tem nome e ID próprios.
4. Não aparece, porque todos já terminaram (`Exited`). O `docker ps` só mostra os que estão rodando.
</details>

> Não se preocupe com os containers acumulando. Na próxima aula você aprende a apagá-los.

---

## 🧠 Memorize

1. Qual comando cria e roda um container?
2. Qual comando mostra só os containers rodando?
3. Qual comando mostra todos os containers?
4. O que significa `Exited (0)` na coluna STATUS?
5. Rodei `docker run` 5 vezes com a mesma imagem. Quantos containers foram criados?

<details><summary>👀 Ver respostas</summary>

1. `docker run <imagem>`
2. `docker ps`
3. `docker ps -a`
4. O container terminou, sem erro.
5. Cinco.
</details>

➡️ Próxima: [Aula 02 — Dar nome e apagar containers](02-nomear-e-apagar.md)
