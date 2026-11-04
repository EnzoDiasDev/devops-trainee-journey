# Aula 03 — Pasta de trabalho e comandos no build

## 🎯 Nesta aula
- `WORKDIR`: escolher a pasta onde as coisas acontecem dentro da imagem.
- `COPY . .`: copiar a pasta inteira.
- `RUN`: executar comandos **durante o build** (por exemplo, para instalar programas).
- A diferença mais importante do nível: **`RUN` × `CMD`**.

---

## 📖 Aprenda: `WORKDIR`

Na aula 02 tudo foi parar na raiz (`/`), misturado com as pastas do sistema. O normal é usar uma
pasta só para a aplicação, como `/app`.

```dockerfile
WORKDIR /app
```
Significa: "a partir daqui, **trabalhe na pasta `/app`**" (e crie a pasta, se ela não existir).
Funciona como um `cd` que vale para todas as linhas seguintes **e** para o container.

Com isso, o `COPY` e o `CMD` ficam mais simples, porque o `.` passa a significar "a pasta `/app`":
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
COPY ola.py .
CMD ["python", "ola.py"]
```
- `COPY ola.py .` → copia para a pasta atual da imagem, ou seja, `/app/ola.py`.
- `CMD ["python", "ola.py"]` → roda dentro de `/app`, por isso não precisa escrever o caminho completo.

## 📖 Aprenda: `COPY . .`

Esta linha aparece em quase todo Dockerfile:
```dockerfile
COPY . .
     │ └─ destino: a pasta atual da imagem (o WORKDIR)
     └─── origem: TUDO da pasta onde você rodou o docker build
```
"Copie todos os arquivos desta pasta para a pasta de trabalho da imagem."

> O próprio `Dockerfile` também é copiado. Não faz mal nenhum. Mais adiante você vai aprender a
> escolher o que fica de fora.

---

## 📖 Aprenda: `RUN`

`RUN` executa um comando **durante o build** e **guarda o resultado na imagem**.
O uso mais comum é **instalar programas** que a aplicação precisa.

Exemplo: o programa `cowsay` (uma vaquinha que fala 🐄), instalado com o `pip`, o instalador de
pacotes do Python:
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install cowsay
CMD ["cowsay", "-t", "Olá, Docker!"]
```
- `RUN pip install cowsay` → no **build**, baixa e instala o cowsay **dentro da imagem**.
- `CMD [...]` → no **run**, cada container usa o cowsay que já está instalado.

> O `RUN` é escrito como um comando normal de terminal, **sem** colchetes e aspas.

```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir aula-03
$ cd aula-03
$ code .
```
Crie o Dockerfile acima e:
```bash
$ docker build -t claude/vaca:1.0 .
$ docker run --rm claude/vaca:1.0
```
```
  ____________
| Olá, Docker! |
  ============
            \
             \
               ^__^
               (oo)\_______
               (__)\       )\/\
                   ||----w |
                   ||     ||
```
> O `pip install` baixa da internet (pypi.org). Se aparecer `WARNING: Running pip as the 'root' user`,
> pode ignorar. Se aparecer `CERTIFICATE_VERIFY_FAILED` ou `timeout`, é a rede corporativa: avise o Claude.

---

## 📖 Aprenda: `RUN` × `CMD` (a diferença mais importante do nível)

| | `RUN` | `CMD` |
|---|---|---|
| **Quando executa** | No `docker build` | No `docker run` |
| **Quantas vezes** | **Uma vez**, ao construir a imagem | **Toda vez** que um container nasce |
| **O resultado** | Fica **guardado na imagem** | Acontece no container |
| **Quantos pode ter** | Vários | Só vale o **último** |
| **Usado para** | Preparar a imagem (instalar, criar pastas) | Dizer o que o container faz |

Analogia da marmita:
- `RUN` = **cozinhar** o arroz na hora de montar a marmita. Acontece uma vez, na cozinha.
- `CMD` = o bilhete "**esquente 2 minutos e coma**". É seguido toda vez que alguém pega a marmita.

### Vendo com os próprios olhos
Adicione esta linha **antes** do `CMD` no Dockerfile da `aula-03`:
```dockerfile
RUN echo "Estou rodando DURANTE o build!"
```
Construa com `--progress=plain`, uma opção que mostra **tudo** que acontece no build:
```bash
$ docker build --progress=plain -t claude/vaca:1.1 .
```
No meio do texto aparece `Estou rodando DURANTE o build!`. Agora rode:
```bash
$ docker run --rm claude/vaca:1.1
```
Só a vaquinha. A mensagem do `RUN` **não** aparece no run: ela já aconteceu, lá no build.

---

## ✍️ Pratique

1. Rode a `claude/vaca:1.0` trocando o comando para `pwd` (mostra a pasta atual). Qual pasta aparece? Por quê?
2. Crie a pasta `aula-03-extra` com:
   - um `ola.py` com `print("Olá da pasta /app!")`;
   - um `tchau.py` com `print("Tchau da pasta /app!")`;
   - um Dockerfile que parte da `claude/python:3.13-alpine`, usa `/app` como pasta de trabalho,
     copia **a pasta inteira** com uma linha só e roda o `ola.py`.

   Construa como `claude/app-python:1.0` e rode.
3. Rode a mesma imagem executando o `tchau.py`. Repare que não precisa escrever `/app/`.
4. Entre na imagem com um terminal e liste os arquivos. Em que pasta você "caiu"? Quais arquivos estão lá?
5. Responda sem testar: um Dockerfile com `RUN echo "A"` e `CMD ["echo", "B"]`. Ao construir e depois
   rodar 3 containers, quantas vezes aparece "A"? E "B"?

<details><summary>👀 Ver respostas</summary>

1. `docker run --rm claude/vaca:1.0 pwd` → `/app`. O `WORKDIR` também vale para o container.
2. Dockerfile:
   ```dockerfile
   FROM claude/python:3.13-alpine
   WORKDIR /app
   COPY . .
   CMD ["python", "ola.py"]
   ```
   ```bash
   $ docker build -t claude/app-python:1.0 .
   $ docker run --rm claude/app-python:1.0
   ```
3. `docker run --rm claude/app-python:1.0 python tchau.py`
4. ```bash
   $ docker run -it --rm claude/app-python:1.0 sh
   # pwd
   # ls
   # exit
   ```
   Você cai em `/app`, com `Dockerfile`, `ola.py` e `tchau.py`.
5. "A" aparece **1 vez** (no build). "B" aparece **3 vezes** (uma por container).
</details>

---

## 🧠 Memorize

1. O que faz `WORKDIR /app`?
2. O que significa cada `.` em `COPY . .`?
3. Quando o `RUN` executa? E o `CMD`?
4. Preciso instalar um programa na imagem. Uso `RUN` ou `CMD`?
5. Qual a diferença na forma de escrever `RUN` e `CMD`?
6. Qual opção do `docker build` mostra todos os detalhes da construção?

<details><summary>👀 Ver respostas</summary>

1. Define `/app` como pasta de trabalho (cria se não existir) para as linhas seguintes e para o container.
2. O primeiro é "tudo da pasta do seu computador"; o segundo é "a pasta de trabalho da imagem".
3. `RUN` no build (uma vez); `CMD` em cada `docker run`.
4. `RUN`.
5. `RUN` é escrito como comando normal (`RUN pip install cowsay`); `CMD` em lista (`CMD ["cowsay", "-t", "oi"]`).
6. `--progress=plain`
</details>

➡️ Próxima: [Aula 04 — Mudou o código? Nova versão](04-versoes.md)
