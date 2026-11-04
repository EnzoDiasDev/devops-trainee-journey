# Aula 06 — Configurar sem reconstruir

## 🎯 Nesta aula
- **Variáveis de ambiente**: configurações que o programa lê ao rodar.
- `ENV`: definir um valor padrão no Dockerfile.
- `-e`: trocar o valor no `docker run`, **sem reconstruir** a imagem.

---

## 📖 Aprenda: o problema

Imagine uma aplicação que precisa saber o nome da empresa. Se o nome estiver escrito **no código**,
cada empresa precisaria de uma imagem diferente: um build para cada uma. 😩

A solução é o programa **ler a configuração de fora**, de uma **variável de ambiente**: um par
`NOME=valor` que o Docker entrega ao programa quando o container nasce.

---

## 📖 Aprenda: `ENV`

Define uma variável de ambiente com um **valor padrão**, que fica gravado na imagem:
```dockerfile
ENV NOME="Docker"
```

## 📖 Aprenda: `-e` no `docker run`

Troca (ou cria) uma variável **só para aquele container**:
```bash
$ docker run --rm -e NOME=Enzo minha-imagem
```
O `-e` **vence** o `ENV` do Dockerfile. A imagem continua a mesma; só aquele container recebe o valor diferente.

```
         mesma imagem
       ┌──────┴──────┐
 -e NOME=Ana    -e NOME=Bia      (sem -e)
 "Olá, Ana!"    "Olá, Bia!"     "Olá, Docker!"  ← usa o ENV
```

---

## 📖 Mão na massa

```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir aula-06
$ cd aula-06
$ code .
```
`ola.py` (pronto, não precisa entender o Python: ele lê a variável `NOME` e mostra uma saudação):
```python
import os

nome = os.getenv("NOME", "mundo")
print(f"Olá, {nome}!")
```
`Dockerfile`:
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
COPY . .
ENV NOME="Docker"
CMD ["python", "ola.py"]
```
```bash
$ docker build -t claude/saudacao:1.0 .
$ docker run --rm claude/saudacao:1.0
$ docker run --rm -e NOME=Enzo claude/saudacao:1.0
$ docker run --rm -e NOME="Time DevOps" claude/saudacao:1.0
```
> Se o valor tem **espaço**, coloque entre aspas: `-e NOME="Time DevOps"`.

### Vendo as variáveis de dentro do container
O comando `env` lista todas as variáveis de ambiente:
```bash
$ docker run --rm claude/saudacao:1.0 env
$ docker run --rm -e NOME=Enzo claude/saudacao:1.0 env
```
Procure a linha `NOME=` em cada resultado.

---

## ✍️ Pratique

1. Rode a `claude/saudacao:1.0` cumprimentando a sua equipe, sem reconstruir.
2. Mude o valor padrão no Dockerfile para `"pessoa visitante"` e construa como `claude/saudacao:2.0`.
   Rode sem `-e`.
3. Na `2.0`, rode com `-e NOME=Enzo`. Quem vence: o `ENV` ou o `-e`?
4. Crie um container em segundo plano chamado `saudacao` a partir da `2.0` com `NOME=Mentor`.
   Como você vê a mensagem, se ele rodou em segundo plano? Apague-o depois.
5. Liste as variáveis de ambiente de um container da `2.0` e encontre o `NOME`.

<details><summary>👀 Ver respostas</summary>

1. `docker run --rm -e NOME="Time DevOps" claude/saudacao:1.0` (ou o nome da sua equipe)
2. Dockerfile com `ENV NOME="pessoa visitante"`, depois:
   ```bash
   $ docker build -t claude/saudacao:2.0 .
   $ docker run --rm claude/saudacao:2.0
   ```
3. `docker run --rm -e NOME=Enzo claude/saudacao:2.0` → `Olá, Enzo!`. O `-e` vence.
4. ```bash
   $ docker run -d --name saudacao -e NOME=Mentor claude/saudacao:2.0
   $ docker logs saudacao
   $ docker rm saudacao
   ```
5. `docker run --rm claude/saudacao:2.0 env`
</details>

---

## 🧠 Memorize

1. Para que servem as variáveis de ambiente?
2. Como definir no Dockerfile a variável `COR` com valor padrão `azul`?
3. Como rodar um container trocando `COR` para `verde`?
4. Quem vence: `ENV` ou `-e`?
5. Precisa reconstruir a imagem para usar um valor diferente com `-e`?
6. Qual comando lista as variáveis de ambiente?

<details><summary>👀 Ver respostas</summary>

1. Para configurar o programa de fora, sem mudar o código nem a imagem.
2. `ENV COR="azul"`
3. `docker run -e COR=verde <imagem>`
4. `-e`
5. Não.
6. `env`
</details>

➡️ Próxima: [Aula 07 — Desafio do nível 2](07-desafio-final.md)
