# Aula 01 — Sua primeira rede

## 🎯 Nesta aula
- `docker network create`, `ls`, `inspect` e `rm`: gerenciar redes.
- `--network`: colocar um container numa rede.
- O **nome do container** vira o **endereço** dele dentro da rede.

---

## 📖 Aprenda: os comandos de rede

Seguem o mesmo padrão dos volumes (nível 3):

| Comando | O que faz |
|---------|-----------|
| `docker network create minha-rede` | Cria uma rede |
| `docker network ls` | Lista as redes |
| `docker network inspect minha-rede` | Mostra detalhes (inclusive quais containers estão nela) |
| `docker network rm minha-rede` | Apaga a rede |

```bash
$ docker network create minha-rede
$ docker network ls
```
Além da sua, aparecem três redes que **já vêm com o Docker**: `bridge` (a padrão, da aula 00), `host` e `none`.
**Não apague** essas três.

---

## 📖 Aprenda: `--network`

No `docker run`, `--network` diz em que rede o container vai nascer:
```
docker  run  -d  --name site  --network minha-rede  claude/nginx:alpine
                                └───────┬────────┘
                                 rede onde ele entra
```

### A mágica: o nome vira endereço
Numa rede criada por você, o Docker mantém uma **agenda** (DNS) com o nome de cada container. Quem está na
mesma rede chama o outro **pelo nome**.

```bash
$ docker run -d --name site --network minha-rede claude/nginx:alpine
$ docker run --rm --network minha-rede claude/alpine:3.22 ping -c 1 site
```
```
PING site (172.18.0.2): 56 data bytes
64 bytes from 172.18.0.2: seq=0 ...
```
Agora o IP é `172.18.0.x`, um endereço da sua rede Docker. É o **seu** container (compare com o `198.51.100.x` da aula 00). 🎉

Baixe a página do site pelo nome:
```bash
$ docker run --rm --network minha-rede claude/alpine:3.22 wget -qO- http://site
```
Aparece o HTML do "Welcome to nginx!". Um container falou com o outro.

```
          rede "minha-rede"
 ┌─────────────────────────────────────┐
 │  ┌─────────┐    "site"   ┌────────┐ │
 │  │ alpine  │ ──────────► │  site  │ │
 │  └─────────┘             └────────┘ │
 └─────────────────────────────────────┘
```

> 📌 **Regra do nível:** para um container achar outro pelo nome, os dois precisam estar **na mesma rede
> criada por você**.

---

## 📖 Aprenda: o nome não muda, o IP sim

```bash
$ docker network inspect minha-rede
```
Na parte `Containers` aparece o `site` com o IP dele (`IPv4Address`). Agora recrie o container:
```bash
$ docker rm -f site
$ docker run -d --name site --network minha-rede claude/nginx:alpine
$ docker run --rm --network minha-rede claude/alpine:3.22 ping -c 1 site
```
O IP pode ter mudado, mas o **nome** continua funcionando. Por isso, **sempre use nomes, nunca IPs**.

---

## 📖 Aprenda: apagar uma rede

Não dá para apagar uma rede com containers dentro (`has active endpoints`). Apague os containers antes:
```bash
$ docker rm -f site
$ docker network rm minha-rede
```

---

## ✍️ Pratique

1. Crie uma rede chamada `escritorio`.
2. Suba dois nginx em segundo plano nessa rede: `recepcao` e `financeiro`.
3. De dentro do `recepcao`, faça um `ping` no `financeiro` (use o `docker exec`, sem `-it`, passando o comando direto).
4. De dentro do `financeiro`, baixe a página do `recepcao` com o `wget`.
5. Mostre os detalhes da rede `escritorio` e anote o IP de cada container.
6. Rode um alpine temporário **sem** `--network` e tente o `ping` no `recepcao`. Que IP aparece? Por quê?
7. Tente apagar a rede `escritorio`. Depois resolva e apague.

<details><summary>👀 Ver respostas</summary>

1. `docker network create escritorio`
2. ```bash
   $ docker run -d --name recepcao --network escritorio claude/nginx:alpine
   $ docker run -d --name financeiro --network escritorio claude/nginx:alpine
   ```
3. `docker exec recepcao ping -c 1 financeiro`
4. `docker exec financeiro wget -qO- http://recepcao`
5. `docker network inspect escritorio`
6. `docker run --rm claude/alpine:3.22 ping -c 1 recepcao` → aparece `198.51.100.25` (um servidor externo), ou
   `bad address` em redes sem esse comportamento. O alpine ficou na rede padrão, sem a agenda da rede `escritorio`.
7. ```bash
   $ docker network rm escritorio              # erro: has active endpoints
   $ docker rm -f recepcao financeiro
   $ docker network rm escritorio
   ```
</details>

---

## 🧠 Memorize

1. Como criar a rede `loja`?
2. Como rodar um container chamado `api` na rede `loja`?
3. Dentro da rede `loja`, como outro container chama o `api`?
4. Por que usar o nome em vez do IP?
5. Por que não consigo apagar uma rede?
6. Quais três redes vêm com o Docker e não devem ser apagadas?

<details><summary>👀 Ver respostas</summary>

1. `docker network create loja`
2. `docker run --name api --network loja <imagem>`
3. Pelo nome: `api` (ex.: `http://api`).
4. O IP muda quando o container é recriado; o nome não.
5. Ainda há containers nela. Apague-os antes.
6. `bridge`, `host` e `none`.
</details>

➡️ Próxima: [Aula 02 — Portas: dentro da rede × para fora](02-portas.md)
