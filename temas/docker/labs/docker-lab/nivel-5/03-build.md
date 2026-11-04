# Aula 03 — Construindo a sua imagem

## 🎯 Nesta aula
- `build`: o Compose constrói a imagem a partir do seu Dockerfile.
- `image` junto com `build`: dar nome à imagem construída.
- `docker compose up -d --build`: reconstruir quando o código muda.

---

## 📖 Aprenda: `build`

Até agora os serviços usavam imagens prontas (`image:`). Mas e a **sua** aplicação, que tem um Dockerfile (nível 2)?
Em vez de rodar `docker build` antes, deixe o Compose fazer isso:

```yaml
services:
  site:
    build: .
    image: claude/meu-site:1.0
    ports:
      - "8081:80"
```
| Linha | Significado |
|-------|-------------|
| `build: .` | "Construa a imagem com o **Dockerfile desta pasta**" (o `.` é o mesmo do `docker build ... .`) |
| `image: claude/meu-site:1.0` | O **nome** que a imagem construída vai ter (o `-t` do `docker build`) |

> Sem o `image:`, o Compose inventa um nome (`pasta-servico`). Com ele, você mantém o padrão `claude/` do lab.

---

## 📖 Mão na massa: site do nível 2, agora com Compose

```bash
$ cd ~/Projects/docker-lab/nivel-5/pratica
$ mkdir aula-03
$ cd aula-03
$ mkdir site
$ code .
```
`site/index.html`:
```html
<h1>Site construído pelo Compose</h1>
<p>Versão 1</p>
```
`Dockerfile` (igual ao do nível 2):
```dockerfile
FROM claude/nginx:alpine
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```
`compose.yaml`: o do começo da aula.

```bash
$ docker compose up -d
```
Repare no começo da saída: o Compose **construiu a imagem** (`Built`) antes de subir o container.
```bash
$ docker images
```
A `claude/meu-site:1.0` está lá. Abra **http://localhost:8081**.

---

## 📖 Aprenda: mudou o código? `--build`

Mude `Versão 1` para `Versão 2` no `index.html`, salve e rode:
```bash
$ docker compose up -d
```
Atualize o navegador: **continua Versão 1**! 😮 Como a imagem `claude/meu-site:1.0` **já existe**, o Compose usou a
que estava pronta. (Lembra do nível 2? A imagem é uma cópia feita no momento do build.)

Para mandar reconstruir:
```bash
$ docker compose up -d --build
```
Agora o Compose reconstrói a imagem e **recria** o container. Versão 2 no ar. ✅

| Comando | Quando usar |
|---------|-------------|
| `docker compose up -d` | Subir; constrói a imagem **só se ela ainda não existir** |
| `docker compose up -d --build` | Você **mudou o código ou o Dockerfile** e quer a versão nova |

> 📌 **Regra prática:** mexeu num arquivo que vai para a imagem? Use `--build`.
> Mexeu só no `compose.yaml` (porta, variável)? `up -d` basta.

---

## ✍️ Pratique

1. Acrescente uma página `site/sobre.html` (com qualquer conteúdo) e faça ela aparecer em
   **http://localhost:8081/sobre.html**. Que comando foi necessário?
2. Mude **só a porta** no `compose.yaml` para 8084. Precisa do `--build`? Teste.
3. Mude a versão da imagem no `compose.yaml` para `claude/meu-site:2.0` e suba com `--build`. Liste as imagens: quantas versões do `meu-site` existem?
4. Derrube tudo. As imagens `claude/meu-site` foram apagadas?

<details><summary>👀 Ver respostas</summary>

1. Crie o arquivo e rode `docker compose up -d --build`. Sem o `--build`, a página nova não entra na imagem.
2. Não precisa: `docker compose up -d` já recria o container com a porta nova (a imagem não mudou). Abra http://localhost:8084.
3. `image: claude/meu-site:2.0` e `docker compose up -d --build` → `docker images` mostra a `1.0` e a `2.0`.
4. `docker compose down` → não. O `down` apaga containers (e volumes, com `-v`), mas **não** imagens.
   Para apagar: `docker rmi claude/meu-site:1.0 claude/meu-site:2.0`.
</details>

---

## 🧠 Memorize

1. O que faz `build: .`?
2. Para que serve o `image:` junto com o `build:`?
3. Mudei o `index.html` e rodei `docker compose up -d`. Por que nada mudou?
4. Qual comando reconstrói e sobe?
5. Mudei só uma variável no `compose.yaml`. Preciso de `--build`?

<details><summary>👀 Ver respostas</summary>

1. Constrói a imagem com o Dockerfile da pasta atual.
2. Dar nome (e versão) à imagem construída.
3. Porque a imagem já existia, e o Compose reaproveitou ela sem reconstruir.
4. `docker compose up -d --build`
5. Não.
</details>

➡️ Próxima: [Aula 04 — Serviços conversando](04-servicos-conversando.md)
