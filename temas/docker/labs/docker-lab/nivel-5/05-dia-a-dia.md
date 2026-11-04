# Aula 05 — Comandos do dia a dia e o arquivo `.env`

## 🎯 Nesta aula
- `stop`, `start` e `restart`: desligar e ligar sem apagar.
- Comandos para **um serviço só**.
- `docker compose config`: conferir o arquivo.
- O arquivo **`.env`**: tirar a senha de dentro do `compose.yaml`.

Use a pasta **`aula-04`** (o contador de visitas).

---

## 📖 Aprenda: ligar, desligar, reiniciar

| Comando | O que faz | Parecido com |
|---------|-----------|--------------|
| `docker compose stop` | **Desliga** os containers (não apaga) | `docker stop` |
| `docker compose start` | **Liga** de novo os containers desligados | `docker start` |
| `docker compose restart` | Desliga e liga | — |
| `docker compose down` | Desliga **e apaga** (aula 01) | `docker rm -f` |

```bash
$ docker compose stop
$ docker compose ps -a        # -a mostra também os desligados (Exited)
$ docker compose start
```

## 📖 Aprenda: um serviço só

Quase todo comando aceita o **nome de um serviço** no final:
```bash
$ docker compose logs web           # log só da web
$ docker compose logs -f web        # ao vivo, só da web
$ docker compose restart web        # reinicia só a web
$ docker compose stop banco         # desliga só o banco
$ docker compose up -d banco        # sobe só o banco (e o que ele precisar)
```
Teste: desligue só o banco, acesse a página (erro!) e veja o log da `web`. Depois ligue o banco de novo:
```bash
$ docker compose stop banco
$ docker compose logs --tail 5 web
$ docker compose start banco
```
No log aparece `failed to resolve host 'banco'`: um serviço **desligado sai da rede**, e o nome dele deixa de existir.

## 📖 Aprenda: `docker compose config`

Mostra o `compose.yaml` **como o Compose entendeu**, já arrumado. Se houver erro de YAML, ele aponta onde:
```bash
$ docker compose config
```
> 💡 **Hábito de ouro:** editou o `compose.yaml`? Rode `docker compose config` antes do `up`.

---

## 📖 Aprenda: o arquivo `.env`

Hoje a senha `lab123` está escrita **duas vezes** dentro do `compose.yaml`. Problemas:
- O `compose.yaml` vai para o git, e a **senha iria junto**. 😬
- Para trocar a senha, você precisa lembrar de mudar nos dois lugares.

A solução é um arquivo chamado **`.env`** (com ponto no começo, sem nada antes), **na mesma pasta** do
`compose.yaml`. O Compose lê ele sozinho.

**1.** Crie o arquivo `.env`:
```
SENHA_DO_BANCO=lab123
```
> No `.env` o formato é `NOME=valor`, **sem espaços** em volta do `=`.

**2.** No `compose.yaml`, troque a senha por **`${SENHA_DO_BANCO}`** nos dois lugares:
```yaml
services:
  web:
    ...
    environment:
      DB_HOST: banco
      DB_SENHA: ${SENHA_DO_BANCO}

  banco:
    ...
    environment:
      POSTGRES_PASSWORD: ${SENHA_DO_BANCO}
```
`${NOME}` significa "coloque aqui o valor de `NOME`, que está no `.env`".

**3.** Confira se o Compose leu certo:
```bash
$ docker compose config
```
No lugar de `${SENHA_DO_BANCO}` aparece `lab123`. ✅

**4.** Suba:
```bash
$ docker compose up -d
```

> 📌 Na vida real, o `.env` **não** vai para o git (ele entra num arquivo chamado `.gitignore`, a lista do que o
> git deve ignorar). No lugar, versiona-se um `.env.example` com nomes, mas sem valores reais, só para mostrar quais
> variáveis precisam existir.

> ⚠️ A senha do Postgres só é definida na **primeira vez** que o banco liga com o volume vazio (aula 02).
> Se você mudar a senha no `.env` com o volume antigo, o banco continua com a senha velha e a `web` dá
> `password authentication failed`. Para valer uma senha nova num lab: `docker compose down -v` e `up -d`.

---

## ✍️ Pratique

1. Desligue tudo sem apagar, confira com `docker compose ps -a` e ligue de novo.
2. Reinicie **só** a `web`.
3. Acompanhe ao vivo o log **só** da `web`, acesse a página 3 vezes e saia.
4. Quebre o `compose.yaml` de propósito (tire 2 espaços da frente de `image:` em algum serviço) e rode `docker compose config`.
   O que acontece? Conserte.
5. Coloque também a **porta** no `.env`: crie `PORTA_WEB=8085` e use `${PORTA_WEB}` no `ports` da `web`
   (`- "${PORTA_WEB}:5000"`). Suba e acesse http://localhost:8085.
6. Derrube tudo, apagando os dados.

<details><summary>👀 Ver respostas</summary>

1. `docker compose stop`, `docker compose ps -a` (status `Exited`) e `docker compose start`.
2. `docker compose restart web`
3. `docker compose logs -f web` → acesse a página → `Ctrl + C`
4. O `config` mostra um erro como `go-yaml load error ... at L15.C16: mapping values are not allowed in this context`
   (`L15` = linha 15). Devolva os espaços e rode `docker compose config` de novo.
   ⚠️ Com o arquivo quebrado, **nenhum** comando do Compose funciona, nem o `down`. Conserte antes de tudo.
5. `.env`:
   ```
   SENHA_DO_BANCO=lab123
   PORTA_WEB=8085
   ```
   `compose.yaml`:
   ```yaml
       ports:
         - "${PORTA_WEB}:5000"
   ```
   `docker compose config` (aparece `8085`) e `docker compose up -d`.
6. `docker compose down -v`
</details>

---

## 🧠 Memorize

1. Qual a diferença entre `docker compose stop` e `docker compose down`?
2. Como reiniciar só o serviço `web`?
3. Como ver o log só do `banco`?
4. Para que serve o `docker compose config`?
5. Onde fica e como se escreve o arquivo `.env`?
6. Como usar a variável `SENHA` do `.env` dentro do `compose.yaml`?
7. Por que tirar a senha do `compose.yaml`?

<details><summary>👀 Ver respostas</summary>

1. `stop` desliga (dá para ligar com `start`); `down` desliga e apaga os containers.
2. `docker compose restart web`
3. `docker compose logs banco`
4. Mostrar como o Compose entendeu o arquivo (com as variáveis já trocadas) e apontar erros.
5. Na mesma pasta do `compose.yaml`, com linhas `NOME=valor`.
6. `${SENHA}`
7. Porque o `compose.yaml` vai para o git e a senha não deve ir junto. Também fica num lugar só.
</details>

➡️ Próxima: [Aula 06 — Desafio do nível 5](06-desafio-final.md)
