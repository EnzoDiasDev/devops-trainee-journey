# Aula 02 — Dar nome e apagar containers

## 🎯 Nesta aula
- `--name`: escolher o nome do container.
- `docker rm`: apagar containers.
- `--rm`: criar um container que se apaga sozinho ao terminar.

---

## 📖 Aprenda: `--name`

Os nomes inventados pelo Docker (`eager_turing`) são difíceis de lembrar. Use `--name` para escolher:

```
docker  run  --name meu-teste  claude/hello-world
             └──────┬───────┘  └──────┬─────────┘
               nome que eu quero    imagem
```

> ⚠️ A ordem importa: as **opções** (como `--name`) vêm **antes** da imagem.

```bash
$ docker run --name meu-teste claude/hello-world
$ docker ps -a
```
Agora a coluna `NAMES` mostra `meu-teste`.

Não podem existir dois containers com o mesmo nome. Tente rodar o mesmo comando de novo:
```bash
$ docker run --name meu-teste claude/hello-world
```
Erro: `Conflict. The container name "/meu-teste" is already in use`. Para reaproveitar o nome,
primeiro apague o container antigo. É o próximo assunto.

---

## 📖 Aprenda: `docker rm`

`rm` vem de *remove* (remover). Apaga um container que **não está rodando**.

```
docker  rm  meu-teste
            └───┬───┘
       nome (ou ID) do container
```

```bash
$ docker rm meu-teste
$ docker ps -a
```
O `meu-teste` sumiu da lista.

### Apagando pelo ID
Você também pode usar o `CONTAINER ID`. E não precisa digitar o ID inteiro, só o começo
(o suficiente para não confundir com outro):
```bash
$ docker ps -a
# suponha que um container tenha o ID 3ef3a6d9c4dc
$ docker rm 3ef
```

### Apagando vários de uma vez
Coloque vários nomes ou IDs separados por espaço:
```bash
$ docker rm eager_turing 3ef a71
```

---

## 📖 Aprenda: `--rm`

Quando você só quer testar algo e não quer guardar o container, use `--rm` no `docker run`.
O container é apagado **sozinho** assim que terminar:

```bash
$ docker run --rm claude/hello-world
$ docker ps -a
```
A mensagem apareceu, mas o container não ficou na lista. 🧹

> Não confunda:
> - `docker rm` → **comando** para apagar um container que já existe.
> - `--rm` → **opção** do `docker run` para o container se apagar sozinho no final.

---

## ✍️ Pratique

1. Apague **todos** os containers do `claude/hello-world` que sobraram da aula 01
   (use `docker ps -a` para ver os nomes ou IDs).
2. Crie um container do `claude/hello-world` chamado `primeiro`.
3. Crie outro chamado `segundo`.
4. Apague os dois **com um único comando**.
5. Rode o `claude/hello-world` de um jeito que **não sobre** nenhum container depois.
6. Confira que a lista de containers ficou sem nenhum hello-world.

<details><summary>👀 Ver respostas</summary>

1. ```bash
   $ docker ps -a
   $ docker rm <nome-ou-id-1> <nome-ou-id-2> <nome-ou-id-3>
   ```
   (troque `<nome-ou-id>` pelos nomes ou IDs que apareceram na sua tela)
2. `docker run --name primeiro claude/hello-world`
3. `docker run --name segundo claude/hello-world`
4. `docker rm primeiro segundo`
5. `docker run --rm claude/hello-world`
6. `docker ps -a`
</details>

---

## 🧠 Memorize

1. Como criar um container com o nome `banana`?
2. Como apagar o container `banana`?
3. Posso ter dois containers chamados `banana`?
4. Qual a diferença entre `docker rm` e `--rm`?
5. Preciso digitar o ID inteiro para apagar um container?

<details><summary>👀 Ver respostas</summary>

1. `docker run --name banana <imagem>`
2. `docker rm banana`
3. Não. O nome precisa ser único.
4. `docker rm` apaga um container que já existe. `--rm` faz o container se apagar sozinho quando terminar.
5. Não, só o começo, desde que não seja igual ao começo de outro ID.
</details>

➡️ Próxima: [Aula 03 — Um site rodando em container](03-servidor-web.md)
