# Aula 01 — Sua primeira imagem

## 🎯 Nesta aula
- `FROM`: escolher a imagem de partida.
- `CMD`: definir o comando padrão da imagem.
- `docker build`: construir a imagem.

---

## 📖 Aprenda: o arquivo `Dockerfile`

O Dockerfile é um arquivo de texto com **instruções**, uma por linha. Regras do nome:
- Exatamente **`Dockerfile`**, com **D maiúsculo**.
- **Sem extensão**: nada de `Dockerfile.txt`.

Cada linha começa com uma **instrução** em MAIÚSCULAS, seguida dos detalhes:
```
INSTRUÇÃO  detalhes
```

---

## 📖 Aprenda: `FROM`

Toda imagem começa a partir de **outra imagem**. O `FROM` diz qual é ela. É sempre a **primeira** linha.

```dockerfile
FROM claude/alpine:3.22
```
"Comece com tudo o que existe na imagem `claude/alpine:3.22`: um Linux Alpine pequeno."

> Analogia: em vez de fazer a massa do zero, você parte de uma massa pronta e só acrescenta
> o que é seu.

---

## 📖 Aprenda: `CMD`

Lembra do **comando padrão** da imagem, que aparecia na coluna `COMMAND` do `docker ps -a`?
É o `CMD` que define ele: o que o container executa quando nasce.

```dockerfile
CMD ["echo", "Olá! Esta é a minha primeira imagem."]
```

### O formato do `CMD`
É uma **lista** entre colchetes `[ ]`: cada palavra do comando **entre aspas duplas**, separada por **vírgula**.

| Comando no terminal | Como fica no `CMD` |
|---------------------|--------------------|
| `echo "olá mundo"` | `CMD ["echo", "olá mundo"]` |
| `hostname` | `CMD ["hostname"]` |
| `python ola.py` | `CMD ["python", "ola.py"]` |

> ⚠️ Use **aspas duplas** `"` (não simples `'`) e não esqueça as **vírgulas**.

---

## 📖 Aprenda: `docker build`

```
docker  build  -t claude/primeira:1.0  .
               └─────────┬─────────┘  │
          nome:versão da nova imagem   │
                                       └─ a pasta onde está o Dockerfile
                                          ("." = esta pasta)
```
- `-t` vem de *tag*: é o nome que a imagem vai ter.
- O `.` no final é **obrigatório**. É fácil esquecer!

### Mão na massa
```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir aula-01
$ cd aula-01
$ code .
```
No VS Code, crie o arquivo `Dockerfile` com este conteúdo e salve:
```dockerfile
FROM claude/alpine:3.22
CMD ["echo", "Olá! Esta é a minha primeira imagem."]
```
No terminal:
```bash
$ docker build -t claude/primeira:1.0 .
```
O Docker mostra as etapas e termina com algo como `naming to docker.io/claude/primeira:1.0`. Pronto! 🎉

```bash
$ docker images
```
A `claude/primeira:1.0` está na lista. Agora use-a como qualquer imagem do nível 1:
```bash
$ docker run --rm claude/primeira:1.0
```
Aparece `Olá! Esta é a minha primeira imagem.`, que é o seu `CMD` em ação.

### O `CMD` é só o padrão
Como no nível 1, o que você escreve depois do nome da imagem **substitui** o `CMD`:
```bash
$ docker run --rm claude/primeira:1.0 echo "Outra mensagem"
```

---

## ⚠️ Erros comuns

| Erro | Causa |
|------|-------|
| `'docker buildx build' requires 1 argument` | Esqueceu o `.` no final |
| `failed to read dockerfile: open Dockerfile: no such file or directory` | Você não está na pasta do Dockerfile, o nome está errado (`dockerfile`, `Dockerfile.txt`) ou o arquivo não foi salvo |
| `unknown instruction: FORM (did you mean FROM?)` | Instrução escrita errada |

---

## ✍️ Pratique

1. Mude a mensagem do `CMD` da `aula-01` para `Construí isso sozinho!`, construa de novo com o mesmo
   nome e rode. A mensagem nova aparece?
2. Ainda na `aula-01`, rode a imagem trocando o comando por `hostname`.
3. Crie a pasta `aula-01-extra` (dentro de `pratica`) com um Dockerfile que parte do `claude/alpine:3.22`
   e tem como comando padrão o `hostname`. Construa como `claude/quem-sou-eu:1.0`.
4. Rode a `claude/quem-sou-eu:1.0` duas vezes. O resultado é igual? Por quê?
5. Confira na lista de imagens que suas duas imagens existem.

<details><summary>👀 Ver respostas</summary>

1. Dockerfile:
   ```dockerfile
   FROM claude/alpine:3.22
   CMD ["echo", "Construí isso sozinho!"]
   ```
   ```bash
   $ docker build -t claude/primeira:1.0 .
   $ docker run --rm claude/primeira:1.0
   ```
   Sim. **Sem construir de novo, nada muda**: a imagem é uma cópia feita no momento do build.
2. `docker run --rm claude/primeira:1.0 hostname`
3. ```bash
   $ cd ~/Projects/docker-lab/nivel-2/pratica
   $ mkdir aula-01-extra
   $ cd aula-01-extra
   $ code .
   ```
   Dockerfile:
   ```dockerfile
   FROM claude/alpine:3.22
   CMD ["hostname"]
   ```
   ```bash
   $ docker build -t claude/quem-sou-eu:1.0 .
   ```
4. `docker run --rm claude/quem-sou-eu:1.0` (duas vezes) → nomes **diferentes**. Cada `docker run` cria
   um container novo, e cada container tem o próprio ID (que é o hostname dele).
5. `docker images`
</details>

---

## 🧠 Memorize

1. Qual o nome exato do arquivo de receita?
2. Qual instrução vem sempre na primeira linha e para que serve?
3. Para que serve o `CMD`?
4. Como fica `python app.py` dentro de um `CMD`?
5. Qual comando constrói a imagem `claude/teste:2.0` a partir da pasta atual?
6. Mudei o Dockerfile. O que preciso fazer para a imagem mudar?

<details><summary>👀 Ver respostas</summary>

1. `Dockerfile`
2. `FROM`: escolhe a imagem de partida.
3. Define o comando que o container executa quando é criado (o comando padrão).
4. `CMD ["python", "app.py"]`
5. `docker build -t claude/teste:2.0 .`
6. Rodar o `docker build` de novo.
</details>

➡️ Próxima: [Aula 02 — Colocar seus arquivos na imagem](02-copy.md)
