# Aula 07 — Desafio do nível 1

Nada novo aqui: só os comandos das aulas 00 a 06. Tente fazer **sem consultar**. Se travar,
consulte a [COLA.md](COLA.md) antes de abrir a resposta.

---

## 🏪 Parte 1 — A feira de sites

Você vai montar dois sites para comerciantes do bairro.

1. Confira se o Docker está funcionando.
2. Liste **todos** os containers. Se sobrou algum das aulas anteriores (nomes como `site`, `loja`,
   `blog`, `vitrine`...), apague.
3. Crie um site chamado `padaria`, em segundo plano, na porta **8086** do seu computador.
4. Crie um site chamado `oficina`, em segundo plano, na porta **8087**.
5. Abra os dois no navegador.
6. Troque a página da `padaria` para `<h1>Padaria do Bairro</h1>`.
7. Troque a página da `oficina` para `<h1>Oficina do Zé</h1>`.
8. Confira as duas páginas no navegador.

<details><summary>👀 Ver respostas da parte 1</summary>

```bash
$ docker version
$ docker ps -a
$ docker rm -f <nomes-que-sobraram>
$ docker run -d --name padaria -p 8086:80 claude/nginx:alpine
$ docker run -d --name oficina -p 8087:80 claude/nginx:alpine
# navegador: http://localhost:8086 e http://localhost:8087
$ docker exec -it padaria sh
# echo "<h1>Padaria do Bairro</h1>" > /usr/share/nginx/html/index.html
# exit
$ docker exec -it oficina sh
# echo "<h1>Oficina do Zé</h1>" > /usr/share/nginx/html/index.html
# exit
```
</details>

---

## 🔍 Parte 2 — Investigando

9. Visite a página da padaria 3 vezes e mostre **só as 3 últimas linhas** do log dela.
10. Acompanhe o log da oficina **ao vivo**, visite a página e veja a linha aparecer. Saia do acompanhamento.
11. A oficina fechou para o almoço: **desligue** o container dela (sem apagar).
12. Mostre só os containers **ligados**. A oficina aparece?
13. Mostre **todos** os containers. Qual o STATUS da oficina?
14. A oficina reabriu: **ligue** o container dela de novo. A página continua mostrando
    "Oficina do Zé"? Por quê?
15. Tente criar **outro** container chamado `padaria`. O que acontece? Por quê?

<details><summary>👀 Ver respostas da parte 2</summary>

```bash
$ docker logs --tail 3 padaria
$ docker logs -f oficina          # visite a página, depois Ctrl + C
$ docker stop oficina
$ docker ps                       # a oficina não aparece
$ docker ps -a                    # STATUS: Exited
$ docker start oficina
$ docker run -d --name padaria -p 8088:80 claude/nginx:alpine
```
- 14: Sim. `stop`/`start` desliga e liga o **mesmo** container, então a mudança continua.
  Ela só se perderia se o container fosse **apagado**.
- 15: Erro `Conflict ... name "/padaria" is already in use`. Não podem existir dois containers com o mesmo nome.
</details>

---

## 🧪 Parte 3 — Explorando

16. Rode um container do `claude/alpine:3.22` com um terminal dentro, que se apague sozinho ao sair.
    Lá dentro, mostre o conteúdo do arquivo `/etc/os-release` e o nome da máquina. Saia.
17. Baixe a imagem `busybox:1.37` e deixe-a no padrão do lab (`claude/busybox:1.37`, sem o nome original).
18. Use o `claude/busybox:1.37` para mostrar o texto `nível 1 concluído`, sem sobrar container.

<details><summary>👀 Ver respostas da parte 3</summary>

```bash
$ docker run -it --rm claude/alpine:3.22 sh
# cat /etc/os-release
# hostname
# exit
$ docker pull busybox:1.37
$ docker tag busybox:1.37 claude/busybox:1.37
$ docker rmi busybox:1.37
$ docker run --rm claude/busybox:1.37 echo "nível 1 concluído"
```
</details>

---

## 🧹 Parte 4 — Fechando a feira

19. Apague a `padaria` e a `oficina` com **um único comando** (elas estão ligadas).
20. Apague a imagem `claude/busybox:1.37`.
21. Confirme que não sobrou nenhum container do lab e que as imagens `claude/alpine`,
    `claude/hello-world` e `claude/nginx` continuam no computador.

<details><summary>👀 Ver respostas da parte 4</summary>

```bash
$ docker rm -f padaria oficina
$ docker rmi claude/busybox:1.37
$ docker ps -a
$ docker images
```
</details>

---

## ⚡ Prova relâmpago

Escreva o comando de cada linha **de memória**, num papel ou num arquivo. Depois confira.
Se acertar 12 ou mais, você domina o nível 1. 🏆

| # | O que fazer | Seu comando |
|---|-------------|-------------|
| 1 | Ver os containers ligados | |
| 2 | Ver todos os containers | |
| 3 | Rodar `claude/hello-world` sem sobrar container | |
| 4 | Criar um nginx chamado `web`, em segundo plano, na porta 9000 | |
| 5 | Desligar o `web` | |
| 6 | Ligar o `web` de novo | |
| 7 | Ver as últimas 20 linhas do log do `web` | |
| 8 | Acompanhar o log do `web` ao vivo | |
| 9 | Entrar no `web`, que está ligado | |
| 10 | Rodar um alpine com um terminal dentro | |
| 11 | Apagar o `web` estando ele ligado | |
| 12 | Listar as imagens | |
| 13 | Baixar a imagem `nginx:alpine` | |
| 14 | Dar o nome `claude/meu-nginx:1` para a imagem `nginx:alpine` | |
| 15 | Apagar a imagem `nginx:alpine` | |

<details><summary>👀 Ver respostas da prova</summary>

| # | Comando |
|---|---------|
| 1 | `docker ps` |
| 2 | `docker ps -a` |
| 3 | `docker run --rm claude/hello-world` |
| 4 | `docker run -d --name web -p 9000:80 claude/nginx:alpine` |
| 5 | `docker stop web` |
| 6 | `docker start web` |
| 7 | `docker logs --tail 20 web` |
| 8 | `docker logs -f web` |
| 9 | `docker exec -it web sh` |
| 10 | `docker run -it --rm claude/alpine:3.22 sh` |
| 11 | `docker rm -f web` |
| 12 | `docker images` |
| 13 | `docker pull nginx:alpine` |
| 14 | `docker tag nginx:alpine claude/meu-nginx:1` |
| 15 | `docker rmi nginx:alpine` |
</details>

---

## 🎉 Terminou?

Marque tudo no [PROGRESSO.md](PROGRESSO.md) e avise o Claude:
**"terminei o nível 1"**. No nível 2 você vai criar as suas próprias imagens com um **Dockerfile**.

Antes, se quiser, repita a prova relâmpago amanhã: lembrar depois de um dia é o que fixa de verdade.
