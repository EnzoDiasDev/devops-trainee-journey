# Aula 03 — Um site rodando em container

## 🎯 Nesta aula
- `-d`: rodar o container "em segundo plano".
- `-p`: abrir uma porta para acessar o container pelo navegador.
- `docker stop` e `docker start`: desligar e ligar de novo.
- `docker rm -f`: apagar um container que está ligado.

Até agora o container rodava e terminava. Agora vamos rodar um **servidor de site** (nginx),
que fica ligado esperando visitas.

---

## 📖 Aprenda: rodando sem `-d` (para entender o problema)

```bash
$ docker run --name site claude/nginx:alpine
```
O terminal fica "preso", mostrando mensagens do nginx. Ele está rodando, mas você não consegue digitar
mais nada. Aperte **`Ctrl + C`** para parar.

Ao apertar `Ctrl + C`, o nginx desligou e o container ficou parado. Apague-o:
```bash
$ docker rm site
```

## 📖 Aprenda: `-d`

`-d` vem de *detached* (desacoplado): o container roda **em segundo plano** e o terminal fica livre.

```bash
$ docker run -d --name site claude/nginx:alpine
```
Aparece só um código comprido (o ID completo) e o terminal volta para você. Confira:
```bash
$ docker ps
```
Status: `Up` = ligado. ✅

Mas como acessar esse site? Ele está **dentro** do container, isolado. Precisamos abrir uma porta.
Apague esse container para refazer do jeito certo (o próximo assunto ensina o `-f`):
```bash
$ docker rm -f site
```

---

## 📖 Aprenda: `-p` (portas)

Pense no container como um **apartamento** dentro de um prédio (o seu computador). O nginx atende
na **porta 80** do apartamento. Quem está na rua (o seu navegador) não chega lá, a não ser que você
**ligue uma porta do prédio a uma porta do apartamento**.

```
docker  run  -d  --name site  -p 8081:80  claude/nginx:alpine
                              └───┬────┘
                    porta do seu   :  porta dentro
                    computador         do container
```

```bash
$ docker run -d --name site -p 8081:80 claude/nginx:alpine
$ docker ps
```
Na coluna `PORTS` aparece `0.0.0.0:8081->80/tcp`, que quer dizer "a porta 8081 do computador leva à porta 80 do container".

🌐 Agora abra o navegador do Windows em **http://localhost:8081**.
Você verá **"Welcome to nginx!"**. Esse site está vindo de dentro do container. 🎉

### A porta do computador pode ser qualquer uma (livre)
O lado **direito** (`80`) é fixo: é onde o nginx atende. O lado **esquerdo** você escolhe.
Dá até para ter vários sites ao mesmo tempo, cada um numa porta:
```bash
$ docker run -d --name site2 -p 8082:80 claude/nginx:alpine
```
Abra **http://localhost:8082**. É outro container, da mesma imagem.

> ⚠️ **Erro `port is already allocated` ou `address already in use`?** Alguma coisa já usa essa porta
> do seu computador. Escolha outro número para o lado esquerdo (ex.: `-p 8085:80`).
> Na sua máquina a **8080** costuma estar ocupada, então o lab usa 8081, 8082...

---

## 📖 Aprenda: `docker stop` e `docker start`

| Comando | O que faz |
|---------|-----------|
| `docker stop site` | **Desliga** o container (ele continua existindo, só fica parado) |
| `docker start site` | **Liga de novo** um container parado, com as mesmas configurações (nome, porta...) |

```bash
$ docker stop site
```
Atualize o navegador em `localhost:8081` → não carrega mais. E no `docker ps -a` o status é `Exited`.

```bash
$ docker start site
```
Atualize o navegador → voltou! 

> `docker run` = **cria** um container novo e liga.
> `docker start` = **liga** um container que já existe.

---

## 📖 Aprenda: `docker rm -f`

O `docker rm` normal **se recusa** a apagar um container ligado:
```bash
$ docker rm site2
```
Erro: `cannot remove container ... container is running`. Você tem duas opções:

| Jeito | Comandos |
|-------|----------|
| Desligar e depois apagar | `docker stop site2` e depois `docker rm site2` |
| Forçar (desliga e apaga de uma vez) | `docker rm -f site2` |

`-f` vem de *force* (forçar).

```bash
$ docker rm -f site2
$ docker rm -f site
$ docker ps -a
```

---

## ✍️ Pratique

1. Crie um container do `claude/nginx:alpine` em segundo plano, chamado `loja`, acessível na
   porta **8083** do seu computador. Abra no navegador.
2. Crie outro chamado `blog`, na porta **8084**. Abra no navegador.
3. Desligue o `loja`. Confira no navegador e com `docker ps -a`.
4. Ligue o `loja` de novo e confira que ele voltou **na mesma porta**.
5. Tente criar um container `teste` na porta **8084**. O que acontece? Por quê?
   (Se o Docker tiver criado o container `teste` mesmo com o erro, apague-o.)
6. Apague o `blog` **sem** usar `-f`.
7. Apague o `loja` usando `-f`.

<details><summary>👀 Ver respostas</summary>

1. `docker run -d --name loja -p 8083:80 claude/nginx:alpine` → http://localhost:8083
2. `docker run -d --name blog -p 8084:80 claude/nginx:alpine` → http://localhost:8084
3. `docker stop loja` → o navegador não carrega e o status fica `Exited`.
4. `docker start loja` → http://localhost:8083 volta a funcionar.
5. `docker run -d --name teste -p 8084:80 claude/nginx:alpine` → erro de porta, porque a 8084 já
   está sendo usada pelo `blog`. O container `teste` é criado mas não liga. Apague com `docker rm teste`.
6. `docker stop blog` e depois `docker rm blog`
7. `docker rm -f loja`
</details>

---

## 🧠 Memorize

1. O que o `-d` faz?
2. Em `-p 9000:80`, qual número é do seu computador e qual é do container?
3. Qual a diferença entre `docker stop` e `docker rm`?
4. Qual a diferença entre `docker run` e `docker start`?
5. Como apagar um container que está ligado, num comando só?
6. Apareceu `port is already allocated`. O que fazer?

<details><summary>👀 Ver respostas</summary>

1. Roda o container em segundo plano e deixa o terminal livre.
2. `9000` é do seu computador; `80` é do container.
3. `stop` desliga (o container continua existindo); `rm` apaga.
4. `run` cria um container novo; `start` liga um que já existe.
5. `docker rm -f <nome>`
6. Usar outra porta do lado esquerdo do `-p`.
</details>

➡️ Próxima: [Aula 04 — Ver o que o container está fazendo](04-logs.md)
