# Aula 04 — Mudou o código? Nova versão

## 🎯 Nesta aula
- Por que o container **não muda sozinho** quando você altera o código.
- Usar **versões** (tags) para ter a imagem antiga e a nova ao mesmo tempo.
- Por que o segundo build é tão rápido (o **cache**).

---

## 📖 Aprenda: o container não "atualiza"

A imagem é uma **cópia** feita no momento do build. Mudou um arquivo? O fluxo é sempre:

```
editar o arquivo ──► docker build (nova imagem) ──► docker run (novo container)
```

Se o container estiver ligado (como um site com `-d`), ele também precisa ser **recriado**: apague o
antigo e rode de novo a partir da imagem nova.

---

## 📖 Aprenda: versões com tags

Lembra que o nome da imagem tem uma **tag** depois dos dois-pontos? Use-a como **número de versão**:

```
claude/contador:1.0   ← versão antiga
claude/contador:2.0   ← versão nova
```
Cada tag é uma imagem **separada**. Construir a `2.0` não apaga a `1.0`, então dá para comparar ou
voltar para a antiga se a nova der problema.

> Se você construir usando a **mesma** tag de antes, a tag passa a apontar para a imagem nova e a antiga
> deixa de ter nome. Para guardar as duas, use tags diferentes.

### Mão na massa
```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir aula-04
$ cd aula-04
$ code .
```
`app.py`:
```python
print("Versão 1: olá!")
```
`Dockerfile`:
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
COPY . .
CMD ["python", "app.py"]
```
```bash
$ docker build -t claude/contador:1.0 .
$ docker run --rm claude/contador:1.0
```
Agora mude o `app.py` para:
```python
print("Versão 2: olá, agora melhorado!")
```
Salve e, **antes** de construir, rode de novo a `1.0`:
```bash
$ docker run --rm claude/contador:1.0
```
Continua "Versão 1". A imagem não sabe que você mudou o arquivo. Construa a nova versão:
```bash
$ docker build -t claude/contador:2.0 .
$ docker run --rm claude/contador:2.0
$ docker run --rm claude/contador:1.0
$ docker images
```
As duas versões existem e funcionam, cada uma com o seu código.

---

## 📖 Aprenda: o cache (por que o build às vezes é instantâneo)

Construa a `2.0` de novo, **sem mudar nada**:
```bash
$ docker build -t claude/contador:2.0 .
```
Foi quase instantâneo, e aparecem várias linhas com **`CACHED`**. O Docker percebeu que nada mudou e
**reaproveitou** o trabalho do build anterior.

Na prática: se você muda só o código, linhas como o `RUN pip install` (que vêm antes do `COPY`) não
precisam rodar de novo. Lembre da aula 03: na segunda vez que construiu a vaquinha, o `pip install`
não baixou nada de novo.

---

## ✍️ Pratique

1. Mude o `app.py` para imprimir `Versão 3: a melhor de todas!`. Construa como `claude/contador:3.0`.
2. Rode as três versões, uma depois da outra.
3. Apague a imagem `claude/contador:1.0`. As outras continuam funcionando?
4. Construa a `3.0` de novo sem mudar nada. Encontre a palavra que mostra que o Docker reaproveitou o trabalho.
5. **Site ligado:** crie um container em segundo plano chamado `contador` a partir da `claude/contador:3.0`.
   Ele aparece no `docker ps`? Por quê?
   (Dica: lembre da regra de ouro do nível 1. Use `docker ps -a` e `docker logs contador`.) Apague-o depois.

<details><summary>👀 Ver respostas</summary>

1. `docker build -t claude/contador:3.0 .`
2. ```bash
   $ docker run --rm claude/contador:1.0
   $ docker run --rm claude/contador:2.0
   $ docker run --rm claude/contador:3.0
   ```
3. `docker rmi claude/contador:1.0` → a `2.0` e a `3.0` continuam funcionando. Cada tag é independente.
4. `CACHED`.
5. ```bash
   $ docker run -d --name contador claude/contador:3.0
   $ docker ps          # não aparece
   $ docker ps -a       # Exited (0)
   $ docker logs contador
   $ docker rm contador
   ```
   Não aparece porque o script imprime a mensagem e **termina**. O container vive enquanto o programa
   vive. O `-d` não muda isso, e a mensagem ficou guardada no log.
</details>

---

## 🧠 Memorize

1. Mudei o código. O container que já existe passa a usar o código novo?
2. Qual é a sequência depois de alterar um arquivo?
3. Como ter a versão antiga e a nova ao mesmo tempo?
4. O que significa `CACHED` no build?
5. Apagar a imagem `:1.0` afeta a `:2.0`?

<details><summary>👀 Ver respostas</summary>

1. Não.
2. Editar → `docker build` → `docker run` (e apagar o container antigo, se houver).
3. Construindo com tags diferentes (`:1.0`, `:2.0`).
4. Que o Docker reaproveitou o resultado de um build anterior, porque nada mudou naquela etapa.
5. Não.
</details>

➡️ Próxima: [Aula 05 — Seu site dentro de uma imagem](05-site-na-imagem.md)
