# Aula 02 — Volume numa aplicação sua

## 🎯 Nesta aula
- Construir uma imagem (nível 2) de uma aplicação que **guarda dados**.
- Ver a diferença entre rodar **com** e **sem** volume.

---

## 📖 Aprenda: a aplicação "diário de visitas"

Toda vez que roda, ela:
1. acrescenta uma linha com a data e a hora no arquivo `/dados/diario.txt`;
2. mostra o diário inteiro.

```bash
$ cd ~/Projects/docker-lab/nivel-3/pratica
$ mkdir aula-02
$ cd aula-02
$ code .
```

`diario.py` (pronto, é só copiar):
```python
from datetime import datetime

agora = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
with open("/dados/diario.txt", "a") as arquivo:
    arquivo.write(f"Visita em {agora}\n")

print("=== Diário de visitas ===")
print(open("/dados/diario.txt").read())
```

`Dockerfile`:
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN mkdir /dados
COPY . .
CMD ["python", "diario.py"]
```
> O `RUN mkdir /dados` cria a pasta `/dados` dentro da imagem, porque o script grava nela.

```bash
$ docker build -t claude/diario:1.0 .
```
> O horário pode aparecer diferente do seu relógio: o container usa o fuso UTC por padrão. Normal.

---

## 🔬 Experimento 1: sem volume

```bash
$ docker run --rm claude/diario:1.0
$ docker run --rm claude/diario:1.0
$ docker run --rm claude/diario:1.0
```
Toda vez aparece **uma linha só**. Cada `docker run` cria um container novo, com a folha de rascunho
em branco, e o diário anterior foi para o lixo com o container antigo.

## 🔬 Experimento 2: com volume

```bash
$ docker run --rm -v diario-dados:/dados claude/diario:1.0
$ docker run --rm -v diario-dados:/dados claude/diario:1.0
$ docker run --rm -v diario-dados:/dados claude/diario:1.0
```
Agora o diário **cresce**: 1, 2, 3 linhas. 📈 Os containers são apagados (`--rm`), mas o arquivo está na gaveta.

> Repare: nem criamos o volume com `docker volume create`. O `-v` criou o `diario-dados` sozinho
> (aula 01).

> ⚠️ **O volume tem que ser encaixado exatamente na pasta onde o programa grava.** O script grava em
> `/dados/diario.txt`, então o `-v` aponta para `/dados`. Um caminho que começa com `/` sempre parte da
> **raiz** do Linux, e o `WORKDIR /app` não muda isso. Se você encaixar o volume em `/app/dados`, o Docker
> cria essa pasta só para o volume, mas o script continua gravando em `/dados`, fora do volume, e os dados
> se perdem.

## 🔬 Experimento 3: a imagem nova lê os dados velhos

Mude o título no `diario.py` para `=== Diário de visitas (versão 2) ===`, construa a versão 2 e rode
com o **mesmo volume**:
```bash
$ docker build -t claude/diario:2.0 .
$ docker run --rm -v diario-dados:/dados claude/diario:2.0
```
O título novo aparece **com todas as visitas antigas**. É assim que se atualiza uma aplicação sem perder
dados: **imagem nova + mesmo volume**.

```
 claude/diario:1.0 ──┐
                     ├──► volume diario-dados (os dados ficam aqui)
 claude/diario:2.0 ──┘
```

---

## ✍️ Pratique

1. Rode a `claude/diario:2.0` com um volume **novo** chamado `diario-teste`. Quantas linhas aparecem? Por quê?
2. Rode mais duas vezes com o `diario-teste`.
3. Rode uma vez com o `diario-dados`. O `diario-teste` interfere nele?
4. Mostre o conteúdo do `/dados/diario.txt` do volume `diario-dados` **sem** acrescentar uma visita nova.
   (Dica: troque o comando padrão por um `cat`.)
5. Apague o volume `diario-teste`.

<details><summary>👀 Ver respostas</summary>

1. `docker run --rm -v diario-teste:/dados claude/diario:2.0` → **1 linha**. É uma gaveta nova, vazia.
2. Repita o comando duas vezes → 2 e 3 linhas.
3. `docker run --rm -v diario-dados:/dados claude/diario:2.0` → continua o diário dele. Cada volume é independente.
4. `docker run --rm -v diario-dados:/dados claude/diario:2.0 cat /dados/diario.txt`
5. `docker volume rm diario-teste`
</details>

---

## 🧠 Memorize

1. Por que, sem volume, o diário sempre tem uma linha só?
2. Como atualizar a aplicação para uma versão nova sem perder os dados?
3. Dois volumes diferentes compartilham dados entre si?
4. Para que servia o `RUN mkdir /dados` no Dockerfile?

<details><summary>👀 Ver respostas</summary>

1. Cada `docker run` cria um container novo, e o arquivo do anterior foi apagado junto com ele.
2. Construir a imagem nova e rodar com o **mesmo volume**.
3. Não. Cada volume é uma gaveta separada.
4. Criar a pasta onde o script grava o arquivo. Sem ela, o script dá erro quando roda sem volume.
</details>

➡️ Próxima: [Aula 03 — Ligar uma pasta do seu computador](03-bind-mount.md)
