# Aula 05 — Seu site dentro de uma imagem

## 🎯 Nesta aula
- Montar uma imagem de site a partir do nginx.
- `COPY` de uma **pasta inteira**.
- `EXPOSE`: documentar a porta.

No nível 1 você mudou a página do nginx com `docker exec`, e a mudança **sumia** quando o container era
apagado. Agora a página vai ficar **dentro da imagem**, para sempre.

---

## 📖 Aprenda: imagem de site

Lembre: o nginx mostra os arquivos da pasta **`/usr/share/nginx/html/`**. Então basta partir do nginx e
copiar a sua página para lá:

```dockerfile
FROM claude/nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```
Não precisa de `CMD`: a imagem do nginx **já tem** um comando padrão (ligar o nginx), que a sua imagem
**herda** pelo `FROM`.

```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir aula-05
$ cd aula-05
$ code .
```
`index.html`:
```html
<h1>Meu site em uma imagem Docker</h1>
<p>Feito pelo Enzo 🐳</p>
```
`Dockerfile`: o de cima. Então:
```bash
$ docker build -t claude/meu-site:1.0 .
$ docker run -d --name meu-site -p 8081:80 claude/meu-site:1.0
```
Abra **http://localhost:8081**. 🎉

### A prova: a página não some mais
```bash
$ docker rm -f meu-site
$ docker run -d --name meu-site -p 8081:80 claude/meu-site:1.0
```
Atualize o navegador: **a página continua lá**. Ela faz parte da imagem, e todo container novo já nasce com ela.

---

## 📖 Aprenda: `COPY` de uma pasta

Sites costumam ter vários arquivos. Para copiar o **conteúdo de uma pasta** inteira:
```dockerfile
COPY site/ /usr/share/nginx/html/
```
"Copie tudo que está dentro da pasta `site` para dentro de `/usr/share/nginx/html/`."

---

## 📖 Aprenda: `EXPOSE`

```dockerfile
EXPOSE 80
```
É um **aviso** para quem for usar a imagem: "este programa atende na porta 80". **Não abre porta
nenhuma**: você continua precisando do `-p 8081:80` no `docker run`.

> Pense numa etiqueta na marmita: "consumir quente". A etiqueta não esquenta nada, só informa.

---

## ✍️ Pratique

Monte um site com **duas páginas**.

1. Na pasta `aula-05`, crie uma pasta `site` (pode criar pelo VS Code ou com `mkdir site`). Dentro dela:
   - `index.html`:
     ```html
     <h1>Página inicial</h1>
     <a href="sobre.html">Sobre mim</a>
     ```
   - `sobre.html`:
     ```html
     <h1>Sobre mim</h1>
     <p>Estou aprendendo Docker!</p>
     <a href="index.html">Voltar</a>
     ```
2. Mude o Dockerfile para copiar **a pasta `site` inteira** para a pasta do nginx e para avisar que a
   porta usada é a 80.
3. Construa como `claude/meu-site:2.0`.
4. Apague o container `meu-site` e crie outro com a `2.0`, na mesma porta. Navegue entre as duas páginas.
5. Rode **ao mesmo tempo** a `1.0` num container chamado `site-antigo` na porta 8082. Abra as duas versões
   lado a lado no navegador.
6. Apague os dois containers.

<details><summary>👀 Ver respostas</summary>

2. Dockerfile:
   ```dockerfile
   FROM claude/nginx:alpine
   COPY site/ /usr/share/nginx/html/
   EXPOSE 80
   ```
3. `docker build -t claude/meu-site:2.0 .`
4. ```bash
   $ docker rm -f meu-site
   $ docker run -d --name meu-site -p 8081:80 claude/meu-site:2.0
   ```
   http://localhost:8081 → clique em "Sobre mim".
5. `docker run -d --name site-antigo -p 8082:80 claude/meu-site:1.0` → http://localhost:8082
6. `docker rm -f meu-site site-antigo`
</details>

---

## 🧠 Memorize

1. Em que pasta o nginx procura as páginas?
2. Por que a imagem do site não precisa de `CMD`?
3. Como copiar o conteúdo da pasta `public` para `/usr/share/nginx/html/`?
4. `EXPOSE 80` permite acessar o site sem `-p`?
5. Qual a diferença entre mudar a página com `docker exec` (nível 1) e com `COPY` no Dockerfile?

<details><summary>👀 Ver respostas</summary>

1. `/usr/share/nginx/html/`
2. Porque herda o `CMD` da imagem do nginx (via `FROM`).
3. `COPY public/ /usr/share/nginx/html/`
4. Não. `EXPOSE` só documenta; quem publica a porta é o `-p`.
5. Com `exec` a mudança fica só naquele container e some quando ele é apagado. Com `COPY` ela fica na imagem e todo container novo já nasce com ela.
</details>

➡️ Próxima: [Aula 06 — Configurar sem reconstruir](06-env.md)
