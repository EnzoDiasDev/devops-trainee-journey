# Aula 04 — Ver o que o container está fazendo

## 🎯 Nesta aula
- `docker logs`: ler as mensagens que o programa do container escreveu.
- `--tail` e `-f`: ver só o final e acompanhar ao vivo.

---

## 📖 Aprenda: `docker logs`

Quando o container roda com `-d`, você não vê as mensagens dele na tela. Mas o Docker **guarda tudo**.
Para ler, use `docker logs` com o nome do container:

```
docker  logs  site
              └─┬┘
       nome (ou ID) do container
```

Prepare um site para observar:
```bash
$ docker run -d --name site -p 8081:80 claude/nginx:alpine
$ docker logs site
```
Você vê as mensagens de inicialização do nginx.

Agora abra **http://localhost:8081** no navegador, atualize a página umas 3 vezes e rode de novo:
```bash
$ docker logs site
```
No final apareceram linhas novas, uma por visita, parecidas com:
```
172.17.0.1 - - [14/Oct/2026:10:49:45 +0000] "GET / HTTP/1.1" 200 896 "-" "Mozilla/5.0 ..."
```
Isso é o nginx registrando cada acesso: `GET /` é a página pedida e `200` significa "deu certo".

> 💡 O log também funciona com containers **parados**. É assim que você descobre por que um
> container parou: lendo o que ele escreveu antes de parar.

---

## 📖 Aprenda: `--tail` (só o final)

Logs podem ficar enormes. `--tail` mostra só as **últimas** linhas:

```bash
$ docker logs --tail 3 site
```
Mostra só as 3 últimas linhas.

## 📖 Aprenda: `-f` (acompanhar ao vivo)

`-f` vem de *follow* (seguir). O terminal fica mostrando as linhas novas **conforme acontecem**:

```bash
$ docker logs -f site
```
Agora atualize o navegador algumas vezes e veja as linhas aparecendo na hora. 👀

Para sair, aperte **`Ctrl + C`**.
> Fique tranquilo: o `Ctrl + C` aqui para só a **leitura do log**. O container continua ligado
> (confira com `docker ps`).

Dá para juntar os dois: `docker logs -f --tail 5 site` mostra as 5 últimas linhas e continua acompanhando.

---

## ✍️ Pratique

1. Se o container `site` não existir, crie-o (nginx, segundo plano, porta 8081).
2. Visite http://localhost:8081 cinco vezes e mostre **só as 2 últimas** linhas do log.
3. Deixe o log sendo acompanhado ao vivo. Visite a página e veja a linha aparecer. Saia do acompanhamento.
4. Confirme que o container continua ligado depois de sair do acompanhamento.
5. Desligue o `site` e tente ler o log dele. Funciona com o container desligado?
6. Apague o `site`.

<details><summary>👀 Ver respostas</summary>

1. `docker run -d --name site -p 8081:80 claude/nginx:alpine`
2. `docker logs --tail 2 site`
3. `docker logs -f site` → visite a página → `Ctrl + C`
4. `docker ps` → status `Up`.
5. `docker stop site` e `docker logs site` → funciona sim. O log fica guardado enquanto o container existir.
6. `docker rm site`
</details>

---

## 🧠 Memorize

1. Como ver tudo que o container `api` escreveu?
2. Como ver só as últimas 10 linhas?
3. Como acompanhar o log ao vivo? E como sair?
4. Sair do `docker logs -f` desliga o container?
5. Dá para ler o log de um container parado? E de um container apagado?

<details><summary>👀 Ver respostas</summary>

1. `docker logs api`
2. `docker logs --tail 10 api`
3. `docker logs -f api`. Para sair, `Ctrl + C`.
4. Não.
5. Parado, sim. Apagado, não: o log é apagado junto com o container.
</details>

➡️ Próxima: [Aula 05 — Entrar dentro do container](05-entrar-no-container.md)
