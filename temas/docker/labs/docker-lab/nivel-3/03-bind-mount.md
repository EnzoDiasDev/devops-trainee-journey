# Aula 03 — Ligar uma pasta do seu computador

## 🎯 Nesta aula
- **Bind mount**: ligar uma pasta **sua** a uma pasta do container.
- Editar um site no VS Code e ver a mudança na hora, sem rebuild.
- `:ro`: deixar o container só ler, sem escrever.

---

## 📖 Aprenda: volume × bind mount

| | Volume (aulas 01 e 02) | Bind mount (esta aula) |
|---|---|---|
| Onde ficam os dados | Numa pasta **gerenciada pelo Docker** | Numa pasta **sua**, que você escolhe |
| Como escreve no `-v` | `-v nome-do-volume:/pasta` | `-v ./minha-pasta:/pasta` |
| Melhor para | **Dados da aplicação** (banco, uploads) | **Desenvolvimento**: editar arquivos e ver o efeito na hora |

O bind mount é como um **espelho**: a pasta do seu computador e a pasta do container passam a ser
**a mesma**. Mudou de um lado, mudou do outro.

### A diferença está no começo do nome
```
-v ./site:/usr/share/nginx/html     ← começa com ./  → é uma PASTA sua (bind mount)
-v site:/usr/share/nginx/html       ← só um nome     → é um VOLUME chamado "site"
```
> O `./` significa "a partir da pasta onde estou". Esquecer o `./` é um erro comum: o Docker cria um
> volume vazio chamado `site` e o nginx mostra uma página de erro.

---

## 📖 Mão na massa: site com edição ao vivo

```bash
$ cd ~/Projects/docker-lab/nivel-3/pratica
$ mkdir aula-03
$ cd aula-03
$ mkdir site
$ code .
```
Crie `site/index.html`:
```html
<h1>Editando ao vivo</h1>
<p>Versão 1</p>
```
Rode o nginx com a pasta `site` espelhada na pasta de páginas dele:
```bash
$ docker run -d --name ao-vivo -p 8081:80 -v ./site:/usr/share/nginx/html claude/nginx:alpine
```
> Rode esse comando **dentro da pasta `aula-03`**, porque o `./site` é relativo à pasta onde você está.

Abra **http://localhost:8081**. Agora, no VS Code, mude `Versão 1` para `Versão 2`, **salve** (`Ctrl + S`)
e atualize o navegador. **Mudou na hora**, sem `docker build` e sem recriar o container. ⚡

Crie também um `site/contato.html` e acesse **http://localhost:8081/contato.html**: arquivos novos
aparecem na hora também.

| Jeito | Para ver uma mudança |
|-------|----------------------|
| `COPY` no Dockerfile (nível 2) | Rebuild + recriar o container |
| Bind mount | Só salvar o arquivo |

> Por isso o bind mount é ótimo para **desenvolver**. Para **entregar** a aplicação, o normal continua
> sendo `COPY` na imagem: o servidor de produção não tem a sua pasta.

---

## 📖 Aprenda: o espelho funciona nos dois sentidos

```bash
$ docker exec -it ao-vivo sh
# echo "<h1>Escrito de dentro do container</h1>" > /usr/share/nginx/html/de-dentro.html
# exit
$ ls site
```
O arquivo `de-dentro.html` apareceu na **sua** pasta. Às vezes isso é útil; às vezes é perigoso
(o container pode apagar ou estragar seus arquivos).

## 📖 Aprenda: `:ro` (somente leitura)

Acrescente `:ro` (de *read-only*) no final do `-v` para o container **só poder ler**:
```bash
$ docker rm -f ao-vivo
$ docker run -d --name ao-vivo -p 8081:80 -v ./site:/usr/share/nginx/html:ro claude/nginx:alpine
$ docker exec -it ao-vivo sh
# echo "teste" > /usr/share/nginx/html/index.html
# exit
```
Erro: `Read-only file system`. O nginx só precisa **ler** as páginas, então `:ro` é a escolha mais segura.
E você continua editando normalmente pelo VS Code.

---

## ✍️ Pratique

1. Apague o arquivo `site/de-dentro.html` no VS Code. Ele some de `http://localhost:8081/de-dentro.html`?
2. Rode um **segundo** nginx chamado `espelho`, na porta 8082, com a **mesma** pasta `site` em modo somente
   leitura. Edite o `index.html` e atualize as duas abas. O que acontece?
3. Apague o `espelho` e crie-o de novo **esquecendo o `./`** (`-v site:/usr/share/nginx/html:ro`).
   O que aparece no navegador? Liste os volumes e explique.
4. Arrume a bagunça: apague os containers `ao-vivo` e `espelho` e o volume criado por engano.

<details><summary>👀 Ver respostas</summary>

1. Sim: atualizando o navegador aparece erro 404. A pasta é a mesma.
2. ```bash
   $ docker run -d --name espelho -p 8082:80 -v ./site:/usr/share/nginx/html:ro claude/nginx:alpine
   ```
   As duas abas mostram a mudança. Os dois containers leem a mesma pasta.
3. ```bash
   $ docker rm -f espelho
   $ docker run -d --name espelho -p 8082:80 -v site:/usr/share/nginx/html:ro claude/nginx:alpine
   $ docker volume ls
   ```
   Aparece a página padrão do nginx ("Welcome to nginx!"), e não o seu site. Sem o `./`, `site` virou o
   **nome de um volume**, criado novo. (Quando um volume novo e vazio é encaixado numa pasta que já tem
   arquivos na imagem, o Docker copia esses arquivos para o volume. Por isso aparece a página padrão
   em vez de uma pasta vazia.)
4. ```bash
   $ docker rm -f ao-vivo espelho
   $ docker volume rm site
   ```
</details>

---

## 🧠 Memorize

1. Qual a diferença entre volume e bind mount?
2. Como saber, olhando o `-v`, se é volume ou bind mount?
3. Para que serve o `:ro`?
4. Bind mount ou `COPY`? Para desenvolver e para entregar.
5. Rodei o comando com `-v ./site:...` estando na pasta errada. O que provavelmente aconteceu?

<details><summary>👀 Ver respostas</summary>

1. O volume é uma pasta gerenciada pelo Docker; o bind mount usa uma pasta sua, escolhida por você.
2. Se começa com `./` (ou `/`), é uma pasta sua (bind mount); se é só um nome, é volume.
3. Deixa o container só ler a pasta, sem poder alterar.
4. Desenvolver: bind mount. Entregar: `COPY` na imagem.
5. O `./site` apontou para uma pasta `site` que não existe ali. O Docker cria uma pasta vazia e o nginx não encontra a página (erro 403 ou 404).
</details>

➡️ Próxima: [Aula 04 — Um banco de dados que não perde nada](04-banco-de-dados.md)
