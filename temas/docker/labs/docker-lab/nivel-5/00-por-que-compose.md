# Aula 00 — Por que Compose + o formato YAML

## 🎯 Nesta aula
- O problema que o Compose resolve.
- As regras do **YAML**, o formato do arquivo do Compose.

---

## 📖 Aprenda: o problema

Lembra do desafio do nível 3? Para subir um banco com volume você digitava algo assim:
```bash
$ docker run -d --name banco -e POSTGRES_PASSWORD=lab123 -v banco-dados:/var/lib/postgresql claude/postgres:18-alpine
```
Agora imagine um sistema real: site + aplicação + banco + cache... São vários comandos enormes, que
precisam ser digitados **na ordem certa** e **sem erro**, toda vez. E como você passa isso para um colega?
Mandando um bloco de notas com comandos? 😅

## 📖 Aprenda: a solução

Com o Compose, você **descreve** o sistema num arquivo chamado **`compose.yaml`**:
```yaml
services:
  banco:
    image: claude/postgres:18-alpine
    environment:
      POSTGRES_PASSWORD: lab123
    volumes:
      - banco-dados:/var/lib/postgresql

volumes:
  banco-dados:
```
E sobe tudo com:
```bash
$ docker compose up -d
```

| Sem Compose | Com Compose |
|-------------|-------------|
| Vários `docker run` compridos | Um arquivo + `docker compose up -d` |
| A configuração fica na sua cabeça (ou no histórico do terminal) | A configuração fica **num arquivo**, que vai para o git |
| Colega precisa copiar seus comandos | Colega roda o mesmo arquivo e tem o mesmo sistema |

> O Compose **não substitui** o que você aprendeu: por baixo, ele faz os mesmos `docker run`, `-v`, `-p`
> e `-e`. Você só escreve tudo uma vez, de forma organizada.

Confira se o Compose está instalado:
```bash
$ docker compose version
```

---

## 📖 Aprenda: YAML em 5 regras

YAML é um formato de texto para organizar informações. Ele é **muito chato com espaços**, então preste atenção.

### Regra 1: `chave: valor`
```yaml
image: claude/nginx:alpine
```
Sempre com **espaço depois dos dois-pontos**. `image:claude/nginx` (sem espaço) está errado.

### Regra 2: a indentação (espaços no começo da linha) mostra quem pertence a quem
```yaml
services:
  site:
    image: claude/nginx:alpine
```
Lê-se: "dentro de `services` tem o `site`; dentro do `site` tem a `image`". Use **2 espaços** por nível.

### Regra 3: só espaços, nunca TAB
O YAML não aceita a tecla `Tab` para indentar. O VS Code costuma converter o `Tab` em espaços automaticamente
nos arquivos `.yaml`, mas se aparecer um erro estranho, desconfie disso.

### Regra 4: listas começam com `-`
```yaml
ports:
  - "8081:80"
  - "8082:443"
```
Cada `- ` (traço + espaço) é um item da lista.

### Regra 5: textos com `:` vão entre aspas
```yaml
ports:
  - "8081:80"        # com aspas, por causa dos dois-pontos
```
Na dúvida, use aspas duplas. E o `#` começa um **comentário**: tudo depois dele é ignorado.

---

## ✍️ Pratique

Encontre o erro de cada trecho (não precisa rodar nada):

**A.**
```yaml
services:
  site:
    image:claude/nginx:alpine
```
**B.**
```yaml
services:
site:
  image: claude/nginx:alpine
```
**C.**
```yaml
services:
  site:
    image: claude/nginx:alpine
    ports:
      "8081:80"
```

<details><summary>👀 Ver respostas</summary>

- **A.** Falta o espaço depois de `image:`. O certo é `image: claude/nginx:alpine`.
- **B.** O `site` não está indentado, então não ficou "dentro" de `services`. Faltam 2 espaços antes de `site:`
  e mais 2 antes de `image:`.
- **C.** `ports` é uma lista: faltou o `- ` antes de `"8081:80"`.
</details>

---

## 🧠 Memorize

1. Qual o nome do arquivo do Compose?
2. Qual comando sobe tudo que está nele?
3. Por baixo dos panos, o Compose faz algo diferente do `docker run`?
4. O que indica, no YAML, que uma coisa está "dentro" da outra?
5. Como se escreve um item de lista em YAML?
6. Pode usar `Tab` para indentar?

<details><summary>👀 Ver respostas</summary>

1. `compose.yaml`
2. `docker compose up -d`
3. Não. Faz o mesmo, a partir do arquivo.
4. A indentação (espaços no começo da linha).
5. Com `- ` (traço e espaço) no começo.
6. Não, só espaços.
</details>

➡️ Próxima: [Aula 01 — Seu primeiro compose.yaml](01-primeiro-compose.md)
