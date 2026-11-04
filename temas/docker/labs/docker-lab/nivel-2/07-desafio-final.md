# Aula 07 — Desafio do nível 2

Nada novo: só o que você viu nas aulas 00 a 06 (e os comandos do nível 1). Desta vez **você escreve
os Dockerfiles do zero**. Se travar, consulte a [COLA.md](COLA.md) antes de abrir a resposta.

Trabalhe em `~/Projects/docker-lab/nivel-2/pratica/desafio/`.

---

## 🪪 Parte 1 — Cartão de visitas

Crie a pasta `desafio/cartao` com o arquivo `cartao.py` abaixo (é só copiar: ele lê três variáveis de
ambiente e monta um cartão):
```python
import os

nome = os.getenv("NOME", "Sem nome")
cargo = os.getenv("CARGO", "Sem cargo")
empresa = os.getenv("EMPRESA", "Sem empresa")

print("+" + "-" * 40 + "+")
print(f"| {nome:<38} |")
print(f"| {cargo:<38} |")
print(f"| {empresa:<38} |")
print("+" + "-" * 40 + "+")
```

1. Escreva um Dockerfile que:
   - parta da imagem com Python;
   - use `/app` como pasta de trabalho;
   - copie a pasta inteira;
   - tenha os valores padrão `NOME="Enzo"`, `CARGO="Trainee DevOps"` e `EMPRESA="Acme"`;
   - rode o `cartao.py` ao iniciar.
2. Construa como `claude/cartao:1.0` e rode.
3. Rode de novo, gerando o cartão de um colega (troque **as três** variáveis) **sem reconstruir**.
4. Confira, entrando na imagem com um terminal, que o `cartao.py` está em `/app`.

<details><summary>👀 Ver respostas da parte 1</summary>

```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
COPY . .
ENV NOME="Enzo"
ENV CARGO="Trainee DevOps"
ENV EMPRESA="Acme"
CMD ["python", "cartao.py"]
```
```bash
$ docker build -t claude/cartao:1.0 .
$ docker run --rm claude/cartao:1.0
$ docker run --rm -e NOME="Maria Silva" -e CARGO="Tech Lead" -e EMPRESA="Acme" claude/cartao:1.0
$ docker run -it --rm claude/cartao:1.0 sh
# ls
# exit
```
</details>

---

## 🐄 Parte 2 — Cartão falante (versão 2.0)

Troque o `cartao.py` por esta versão, que usa o `cowsay` para a vaquinha "falar" o cartão:
```python
import os

import cowsay

nome = os.getenv("NOME", "Sem nome")
cargo = os.getenv("CARGO", "Sem cargo")
empresa = os.getenv("EMPRESA", "Sem empresa")

cowsay.cow(f"{nome} - {cargo} na {empresa}")
```

5. Construa como `claude/cartao:2.0` **sem mudar o Dockerfile**. Rode. O que acontece? Por quê?
   (Leia a última linha do erro.)
6. Corrija o Dockerfile para **instalar o cowsay durante o build**. Construa a `2.0` de novo e rode.
7. Rode a `1.0` e a `2.0`, uma depois da outra. As duas funcionam?

<details><summary>👀 Ver respostas da parte 2</summary>

5. Erro `ModuleNotFoundError: No module named 'cowsay'`. O script precisa do cowsay, mas ele não está
   instalado na imagem.
6. Adicione um `RUN` (antes do `CMD`):
   ```dockerfile
   FROM claude/python:3.13-alpine
   WORKDIR /app
   RUN pip install cowsay
   COPY . .
   ENV NOME="Enzo"
   ENV CARGO="Trainee DevOps"
   ENV EMPRESA="Acme"
   CMD ["python", "cartao.py"]
   ```
   ```bash
   $ docker build -t claude/cartao:2.0 .
   $ docker run --rm claude/cartao:2.0
   ```
7. Sim. Cada versão é uma imagem separada: a `1.0` com o cartão simples e a `2.0` com a vaquinha.
</details>

---

## 🌐 Parte 3 — Portfólio

Crie a pasta `desafio/portfolio` com uma pasta `site` dentro, contendo:
- `index.html`: título com o seu nome e um link para `projetos.html`;
- `projetos.html`: título "Meus projetos", uma frase sobre o Docker Lab e um link de volta.

(Use os HTMLs da aula 05 como modelo.)

8. Escreva um Dockerfile que parta do nginx, copie a pasta `site` inteira para o lugar certo e avise
   que a porta é a 80.
9. Construa como `claude/portfolio:1.0` e rode em segundo plano, com o nome `portfolio`, na porta 8086.
   Navegue entre as páginas.
10. Acrescente uma frase nova ao `projetos.html`. Crie a `claude/portfolio:2.0` e rode-a **ao mesmo tempo**
    que a 1.0, num container chamado `portfolio-novo`, na porta 8087. Compare as duas no navegador.
11. Veja no log do `portfolio-novo` as visitas que você fez.

<details><summary>👀 Ver respostas da parte 3</summary>

```dockerfile
FROM claude/nginx:alpine
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```
```bash
$ docker build -t claude/portfolio:1.0 .
$ docker run -d --name portfolio -p 8086:80 claude/portfolio:1.0
# edite o projetos.html
$ docker build -t claude/portfolio:2.0 .
$ docker run -d --name portfolio-novo -p 8087:80 claude/portfolio:2.0
$ docker logs portfolio-novo
```
</details>

---

## 🧹 Parte 4 — Arrumando a casa

12. Apague os containers `portfolio` e `portfolio-novo` com um único comando.
13. Apague as versões **1.0** do cartão e do portfólio.
14. Liste as imagens e confira que as versões 2.0 continuam lá.

<details><summary>👀 Ver respostas da parte 4</summary>

```bash
$ docker rm -f portfolio portfolio-novo
$ docker rmi claude/cartao:1.0 claude/portfolio:1.0
$ docker images
```
</details>

---

## ⚡ Prova relâmpago

Responda de memória e depois confira. 12 ou mais acertos = nível 2 dominado. 🏆

| # | Pergunta |
|---|----------|
| 1 | Qual o nome exato do arquivo de receita da imagem? |
| 2 | Qual instrução escolhe a imagem de partida? |
| 3 | Escreva a linha que define o comando padrão `python main.py` |
| 4 | Escreva a linha que copia `main.py` para `/app/main.py` |
| 5 | Escreva a linha que usa `/app` como pasta de trabalho |
| 6 | Escreva a linha que copia a pasta inteira para a pasta de trabalho |
| 7 | Escreva a linha que instala o pacote `requests` com o pip durante o build |
| 8 | Qual a diferença entre `RUN` e `CMD`? |
| 9 | Escreva a linha que define a variável `AMBIENTE` com valor `teste` |
| 10 | Escreva a linha que avisa que a aplicação usa a porta 3000 |
| 11 | `EXPOSE` dispensa o `-p`? |
| 12 | Comando para construir a imagem `claude/api:1.0` a partir da pasta atual |
| 13 | Comando para rodar `claude/api:1.0` com `AMBIENTE=producao` |
| 14 | Mudei o código. O que preciso fazer para o container usar a mudança? |
| 15 | O que significa `CACHED` no build? |

<details><summary>👀 Ver respostas da prova</summary>

| # | Resposta |
|---|----------|
| 1 | `Dockerfile` |
| 2 | `FROM` |
| 3 | `CMD ["python", "main.py"]` |
| 4 | `COPY main.py /app/main.py` |
| 5 | `WORKDIR /app` |
| 6 | `COPY . .` |
| 7 | `RUN pip install requests` |
| 8 | `RUN` executa no build (uma vez, resultado guardado na imagem); `CMD` executa a cada `docker run` |
| 9 | `ENV AMBIENTE="teste"` |
| 10 | `EXPOSE 3000` |
| 11 | Não |
| 12 | `docker build -t claude/api:1.0 .` |
| 13 | `docker run -e AMBIENTE=producao claude/api:1.0` |
| 14 | Reconstruir a imagem (`docker build`) e criar um container novo |
| 15 | O Docker reaproveitou o resultado de um build anterior |
</details>

---

## 🎉 Terminou?

Marque tudo no [PROGRESSO.md](PROGRESSO.md) e avise o Claude: **"terminei o nível 2"**.
No nível 3 você aprende a **guardar dados** que sobrevivem mesmo quando o container é apagado (volumes).
