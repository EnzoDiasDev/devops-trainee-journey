# Aula 06 — Imagens

## 🎯 Nesta aula
- `docker images`: ver as imagens que estão no seu computador.
- `docker pull`: baixar uma imagem da internet.
- `docker tag`: dar outro nome a uma imagem (para seguir o padrão `claude/`).
- `docker rmi`: apagar uma imagem.

---

## 📖 Aprenda: o nome de uma imagem

```
claude/nginx : alpine
└─────┬────┘   └──┬─┘
     nome       tag (a "versão" ou variação)
```
- A **tag** vem depois dos dois-pontos. Ela diz qual versão/variação da imagem você quer.
- Se você não escrever a tag, o Docker usa **`latest`**. Por isso `claude/hello-world` é o mesmo
  que `claude/hello-world:latest`.

---

## 📖 Aprenda: `docker images`

Lista as imagens que já estão no seu computador:
```bash
$ docker images
```
| Coluna | Significado |
|--------|-------------|
| `IMAGE` | Nome e tag |
| `ID` | Código único da imagem |
| `DISK USAGE` | Espaço ocupado no disco |

> Você também verá imagens que não são do lab (de outros projetos seus). **Não apague** essas.

---

## 📖 Aprenda: `docker pull`

Baixa uma imagem do **Docker Hub**, um "repositório de imagens" na internet com milhares de imagens prontas.

```bash
$ docker pull busybox:1.37
$ docker images
```
Agora `busybox:1.37` aparece na lista. (O busybox é um Linux minúsculo, parecido com o alpine.)

> 🏢 Se o download falhar com `timeout` ou `x509: certificate`, é a rede corporativa bloqueando.
> Avise o Claude ou o time de infra. As imagens `claude/` deste nível já estão no seu computador e
> funcionam sem internet.

---

## 📖 Aprenda: `docker tag` e o padrão `claude/`

`docker tag` dá **um nome a mais** para uma imagem que já existe. Não copia nada nem ocupa espaço extra.

```
docker  tag  busybox:1.37  claude/busybox:1.37
             └────┬─────┘  └───────┬─────────┘
           nome que existe    nome novo
```

```bash
$ docker tag busybox:1.37 claude/busybox:1.37
$ docker images
```
As duas linhas têm o **mesmo ID**: é a mesma imagem com dois nomes.

> 📌 **Regra do lab:** toda imagem que você baixar para o lab ganha um nome no padrão
> `claude/<nome>:<tag>`, e o nome original é apagado. Assim fica fácil saber o que é do lab.

---

## 📖 Aprenda: `docker rmi`

`rmi` = *remove image* (apagar imagem).

```bash
$ docker rmi busybox:1.37
```
Repare que apareceu só **`Untagged`**: como a imagem ainda tem outro nome (`claude/busybox:1.37`),
o Docker apagou **só o nome**. A imagem continua lá:
```bash
$ docker run --rm claude/busybox:1.37 echo "funcionou"
```

### Não dá para apagar uma imagem que um container está usando
Mesmo que o container esteja **parado**:
```bash
$ docker run --name usa-busybox claude/busybox:1.37 echo "oi"
$ docker rmi claude/busybox:1.37
```
Erro: `unable to delete ... container ... is using its referenced image`.
Solução: apague o container primeiro, depois a imagem:
```bash
$ docker rm usa-busybox
$ docker rmi claude/busybox:1.37
```
Agora apareceu **`Deleted`**: era o último nome, então a imagem foi apagada de verdade.

| Comando | Apaga |
|---------|-------|
| `docker rm` | **container** |
| `docker rmi` | **imagem** (o "i" é de *image*) |

### ⚠️ E se eu apagar uma imagem `claude/` e tentar usar?
```bash
$ docker run --rm claude/busybox:1.37 echo "oi"
```
Erro: `pull access denied for claude/busybox, repository does not exist`.
Quando a imagem não está no seu computador, o Docker tenta baixar do Docker Hub, e lá não existe
nenhuma `claude/busybox`. Para recuperar, refaça o caminho: `pull` do nome original → `tag` →
`rmi` do original.

---

## ✍️ Pratique

1. Liste suas imagens e anote quantas começam com `claude/`.
2. Baixe a imagem `busybox:1.37`.
3. Dê a ela o nome `claude/busybox:1.37`.
4. Apague o nome original (`busybox:1.37`). Apareceu `Untagged` ou `Deleted`? Por quê?
5. Rode `claude/busybox:1.37` mostrando o texto `estou no busybox`, sem sobrar container.
6. Rode um container chamado `bb` da mesma imagem com o comando `echo "oi"` (sem `--rm`).
   Tente apagar a imagem. O que acontece? Resolva e apague a imagem.
7. Liste as imagens e confirme que `claude/busybox` sumiu e que as outras `claude/` continuam lá.

<details><summary>👀 Ver respostas</summary>

1. `docker images` → 3 (`claude/alpine`, `claude/hello-world`, `claude/nginx`).
2. `docker pull busybox:1.37`
3. `docker tag busybox:1.37 claude/busybox:1.37`
4. `docker rmi busybox:1.37` → `Untagged`, porque a imagem ainda tem o nome `claude/busybox:1.37`.
5. `docker run --rm claude/busybox:1.37 echo "estou no busybox"`
6. ```bash
   $ docker run --name bb claude/busybox:1.37 echo "oi"
   $ docker rmi claude/busybox:1.37      # erro: o container bb usa a imagem
   $ docker rm bb
   $ docker rmi claude/busybox:1.37      # Deleted
   ```
7. `docker images`
</details>

---

## 🧠 Memorize

1. Como listar as imagens do computador?
2. Como baixar a imagem `redis:8`?
3. Qual a tag usada quando eu não escrevo nenhuma?
4. Como dar o nome `claude/redis:8` para a imagem `redis:8`?
5. Como apagar a imagem `redis:8`?
6. Qual a diferença entre `docker rm` e `docker rmi`?
7. Por que não consigo apagar uma imagem mesmo sem nenhum container ligado?
8. `pull access denied ... repository does not exist` ao rodar uma imagem `claude/`. O que aconteceu?

<details><summary>👀 Ver respostas</summary>

1. `docker images`
2. `docker pull redis:8`
3. `latest`
4. `docker tag redis:8 claude/redis:8`
5. `docker rmi redis:8`
6. `rm` apaga container; `rmi` apaga imagem.
7. Porque existe um container **parado** que usa essa imagem. Apague o container primeiro.
8. A imagem foi apagada do computador e o Docker tentou baixar do Docker Hub, onde ela não existe.
</details>

➡️ Próxima: [Aula 07 — Desafio do nível 1](07-desafio-final.md)
