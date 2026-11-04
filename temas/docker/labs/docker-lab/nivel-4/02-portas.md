# Aula 02 — Portas: dentro da rede × para fora

## 🎯 Nesta aula
- Entre containers da mesma rede **não precisa de `-p`**.
- Dentro da rede usa-se a **porta do container**, e não a do seu computador.
- `-p 127.0.0.1:8081:80`: publicar uma porta **só para o seu computador**.

---

## 📖 Aprenda: duas portas, dois públicos

Lembra do `-p 8081:80` do nível 1? Ele existe para quem está **fora** do Docker (o seu navegador).
Containers na **mesma rede** já se enxergam, sem nenhum `-p`.

```
 navegador (fora do Docker)
      │  localhost:8081      ← porta do SEU COMPUTADOR (o lado esquerdo do -p)
      ▼
 ┌──────────── rede "loja" ─────────────────┐
 │  ┌───────┐    http://site:80    ┌──────┐ │
 │  │ outro │ ───────────────────► │ site │ │   ← porta DO CONTAINER (o lado direito)
 │  └───────┘                      └──────┘ │
 └──────────────────────────────────────────┘
```

| Quem acessa | Precisa de `-p`? | Endereço |
|-------------|------------------|----------|
| Seu navegador | ✅ Sim | `localhost:<porta-do-computador>` |
| Outro container na mesma rede | ❌ Não | `<nome-do-container>:<porta-do-container>` |

> O `:80` pode ser omitido em `http://site:80`, porque 80 é a porta padrão do HTTP. Por isso, na aula 01,
> `http://site` funcionou.

### Veja na prática
```bash
$ docker network create loja
$ docker run -d --name site --network loja claude/nginx:alpine
```
**Sem `-p`**. Do navegador não dá para acessar. Mas de outro container na rede, sim:
```bash
$ docker run --rm --network loja claude/alpine:3.22 wget -qO- http://site:80
```

### A porta certa é a do container
Agora publique a porta e veja a confusão mais comum:
```bash
$ docker rm -f site
$ docker run -d --name site --network loja -p 8081:80 claude/nginx:alpine
$ docker run --rm --network loja claude/alpine:3.22 wget -qO- -T 3 http://site:8081
```
`Connection refused`! A 8081 é a porta do **seu computador**. Dentro da rede, o nginx continua atendendo
na **80**: use `http://site:80` (ou só `http://site`).

---

## 📖 Aprenda: `-p 127.0.0.1:...` (só para você)

Um `-p 8081:80` comum deixa a porta aberta em **todas** as conexões do seu computador. Em redes compartilhadas (corporativas, Wi-Fi público),
isso pode deixar o seu container acessível para **outras pessoas da rede**.

Para abrir **só para o seu computador**, coloque `127.0.0.1:` na frente (`127.0.0.1` é o número do `localhost`):
```
-p 127.0.0.1:8081:80
   └───┬───┘ └─┬┘ └┬┘
  só o meu PC  meu PC container
```
```bash
$ docker rm -f site
$ docker run -d --name site --network loja -p 127.0.0.1:8081:80 claude/nginx:alpine
$ docker ps
```
Na coluna `PORTS` aparece `127.0.0.1:8081->80/tcp` em vez de `0.0.0.0:8081->80/tcp`
(`0.0.0.0` = "aberta para todos"). No seu navegador, `localhost:8081` funciona igual.

> 📌 **Boa prática a partir de agora:** use `-p 127.0.0.1:...` nos seus testes.

```bash
$ docker rm -f site
$ docker network rm loja
```

---

## ✍️ Pratique

1. Crie a rede `cinema`. Suba um nginx `bilheteria` nela, **sem** publicar porta.
2. Prove que outro container da rede consegue baixar a página da `bilheteria`.
3. Tente abrir a `bilheteria` no navegador. Dá? Por quê?
4. Recrie a `bilheteria` publicando a porta 8082 **só para o seu computador**. Abra no navegador.
5. De outro container da rede, tente acessar `http://bilheteria:8082`. Funciona? Qual endereço funciona?
6. Apague tudo (container e rede).

<details><summary>👀 Ver respostas</summary>

1. ```bash
   $ docker network create cinema
   $ docker run -d --name bilheteria --network cinema claude/nginx:alpine
   ```
2. `docker run --rm --network cinema claude/alpine:3.22 wget -qO- http://bilheteria`
3. Não. Sem `-p`, nenhuma porta do seu computador leva ao container.
4. ```bash
   $ docker rm -f bilheteria
   $ docker run -d --name bilheteria --network cinema -p 127.0.0.1:8082:80 claude/nginx:alpine
   ```
   http://localhost:8082
5. `docker run --rm --network cinema claude/alpine:3.22 wget -qO- -T 3 http://bilheteria:8082` → `Connection refused`.
   Funciona `http://bilheteria` (ou `:80`), a porta do container.
6. `docker rm -f bilheteria` e `docker network rm cinema`
</details>

---

## 🧠 Memorize

1. Dois containers na mesma rede precisam de `-p` para conversar?
2. Com `-p 9000:3000`, que porta outro container da rede usa? E o navegador?
3. Por que `http://site` funciona sem escrever a porta?
4. O que muda com `-p 127.0.0.1:8081:80`?
5. No `docker ps`, o que significa `0.0.0.0` na coluna PORTS?

<details><summary>👀 Ver respostas</summary>

1. Não.
2. Outro container: `3000` (a do container). Navegador: `9000` (a do computador).
3. Porque 80 é a porta padrão do HTTP.
4. A porta fica acessível só no seu computador, e não para outras máquinas da rede.
5. Que a porta está aberta para todas as conexões.
</details>

➡️ Próxima: [Aula 03 — Uma aplicação falando com o banco](03-app-e-banco.md)
