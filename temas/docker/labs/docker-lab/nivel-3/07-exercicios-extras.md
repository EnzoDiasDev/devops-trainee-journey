# Exercícios extras — Volumes

Mais treino com o que você viu no nível 3. Os exercícios vão do mais fácil ao mais difícil.
Quando um exercício precisa de algo novo, a explicação está **no próprio enunciado**.

Trabalhe em `~/Projects/docker-lab/nivel-3/extras/` (crie a pasta).

> 💡 Imagens usadas: `claude/alpine:3.22`, `claude/nginx:alpine`, `claude/python:3.13-alpine` e
> `claude/postgres:18-alpine`. Confira com `docker images` se estão todas aí.

---

## 🟢 Aquecimento

**1.** Crie os volumes `fotos` e `videos`. Liste os volumes e mostre onde o `fotos` fica no seu computador.

**2.** Grave o texto `praia.jpg` no arquivo `/fotos/lista.txt` usando um alpine com o volume `fotos`
(sem sobrar container). Depois, com **outro** container, mostre o conteúdo da lista sem entrar nele.

**3.** Encaixe **os dois volumes no mesmo container**: rode um alpine com `fotos` em `/fotos` e `videos`
em `/videos` (o `-v` pode aparecer mais de uma vez no mesmo comando). Lá dentro, liste as duas pastas e saia.

**4.** Apague `fotos` e `videos` com um único comando.

<details><summary>👀 Ver respostas do aquecimento</summary>

1. ```bash
   $ docker volume create fotos
   $ docker volume create videos
   $ docker volume ls
   $ docker volume inspect fotos        # linha Mountpoint
   ```
2. ```bash
   $ docker run -it --rm -v fotos:/fotos claude/alpine:3.22 sh
   # echo "praia.jpg" > /fotos/lista.txt
   # exit
   $ docker run --rm -v fotos:/fotos claude/alpine:3.22 cat /fotos/lista.txt
   ```
3. ```bash
   $ docker run -it --rm -v fotos:/fotos -v videos:/videos claude/alpine:3.22 sh
   # ls /fotos
   # ls /videos
   # exit
   ```
4. `docker volume rm fotos videos`
</details>

---

## 🔍 Detetive: o que deu errado?

Para cada caso: **leia o sintoma, descubra a causa** e diga como corrigir. Se quiser, reproduza no
terminal para investigar.

**5. "Os recados não são salvos"**
O script grava em `/mural/recados.txt`. O comando usado foi:
```bash
$ docker run --rm -v mural-dados:/app/mural claude/mural:1.0
```
Toda vez o mural aparece com um recado só, ou dá `FileNotFoundError`.

**6. "O banco perdeu tudo"**
Alguém subiu o Postgres assim, criou tabelas, apagou o container e criou outro com o mesmo comando.
As tabelas sumiram, e apareceu um volume de nome enorme no `docker volume ls`.
```bash
$ docker run -d --name banco -e POSTGRES_PASSWORD=x -v banco-dados:/var/lib/postgres claude/postgres:18-alpine
```

**7. "Meu site virou a página do nginx"**
Dentro da pasta do projeto, que tem a subpasta `site` com o `index.html`, foi rodado:
```bash
$ docker run -d --name loja -p 8081:80 -v site:/usr/share/nginx/html claude/nginx:alpine
```
O navegador mostra "Welcome to nginx!".

**8. "Ontem os dados estavam aqui"**
Ontem: `docker run ... -v estoque-dados:/dados ...`. Hoje: `docker run ... -v estoque-dado:/dados ...`.
O container sobe sem erro nenhum, mas tudo está vazio.

<details><summary>👀 Ver respostas do detetive</summary>

5. O volume foi encaixado em `/app/mural`, mas o script grava em `/mural` (caminho com `/` no começo
   ignora o `WORKDIR`). O recado vai para a folha de rascunho e some. **Correção:** `-v mural-dados:/mural`.
6. Erro de digitação no caminho: `/var/lib/postgres` em vez de `/var/lib/postgresql`. O volume `banco-dados`
   ficou **vazio**, e o Postgres gravou na pasta certa, que, sem volume nomeado, ganhou um **volume
   anônimo** (o de nome enorme). Ao apagar e recriar o container, um volume anônimo **novo** foi criado.
   **Correção:** `-v banco-dados:/var/lib/postgresql`.
   (Ainda dá para recuperar os dados antigos, que ficaram no volume anônimo antigo, se ele não foi apagado.)
7. Faltou o `./`: `site` virou o **nome de um volume** novo, que recebeu a página padrão da imagem.
   **Correção:** `-v ./site:/usr/share/nginx/html:ro` (e `docker volume rm site` para limpar).
8. Nome do volume digitado errado (`estoque-dado`). O `-v` não reclama: ele **cria** um volume novo e vazio.
   **Correção:** usar o nome certo. Confira com `docker volume ls` e apague o criado por engano.
</details>

---

## 🛠️ Prática

### 9. Vitrine: um container escreve, outro mostra

Dois containers podem usar **o mesmo volume ao mesmo tempo**.

a) Suba um nginx chamado `vitrine`, porta 8081, com o volume `vitrine-html` em `/usr/share/nginx/html`
   **somente leitura** (o `:ro` também funciona com volumes, não só com bind mount).
b) Abra no navegador. Que página aparece? Por quê?
c) Sem mexer no `vitrine`, use **outro** container (alpine, com o mesmo volume em `/html`, sem sobrar
   container) para trocar o `index.html` por `<h1>Promoção de hoje: 50% off</h1>`.
d) Atualize o navegador.
e) Tente mudar a página de dentro do `vitrine`. O que acontece?

<details><summary>👀 Ver resposta</summary>

```bash
$ docker run -d --name vitrine -p 8081:80 -v vitrine-html:/usr/share/nginx/html:ro claude/nginx:alpine
```
b) "Welcome to nginx!". O volume era novo e vazio, então o Docker copiou para ele os arquivos que a
imagem tinha nessa pasta.
```bash
$ docker run -it --rm -v vitrine-html:/html claude/alpine:3.22 sh
# echo "<h1>Promoção de hoje: 50% off</h1>" > /html/index.html
# exit
```
d) A promoção aparece: os dois containers enxergam a mesma gaveta.
```bash
$ docker exec -it vitrine sh
# echo "x" > /usr/share/nginx/html/index.html
# exit
```
e) `Read-only file system`: o `vitrine` só pode ler. Quem escreve é o outro container.
**Guarde o `vitrine-html`** para os exercícios 11 e 12.
</details>

### 10. Contador de palavras: arquivos entrando e saindo

Bind mounts servem para **entregar arquivos** a um programa e **receber o resultado**.

Na pasta `extras/contador`, crie o `contador.py` (pronto). Ele lê os arquivos de `/entrada`, conta as
palavras de cada um e grava um resumo em `/saida/resumo.txt`:
```python
import os

linhas = []
for nome in sorted(os.listdir("/entrada")):
    texto = open(f"/entrada/{nome}").read()
    linhas.append(f"{nome}: {len(texto.split())} palavras")

resumo = "\n".join(linhas)
with open("/saida/resumo.txt", "w") as arquivo:
    arquivo.write(resumo + "\n")

print(resumo)
print("Resumo salvo em /saida/resumo.txt")
```
a) Escreva um Dockerfile (Python, `WORKDIR /app`, copie o script, rode o script) e construa como `claude/contador:1.0`.
b) Crie a pasta `entrada` com dois arquivos de texto (escreva o que quiser neles).
c) Rode a imagem com `./entrada` em `/entrada` **somente leitura** e `./saida` em `/saida`.
d) Confira, **no seu computador**, o arquivo `saida/resumo.txt`.
e) Acrescente um terceiro arquivo em `entrada` e rode de novo. Precisou reconstruir a imagem?
f) Rode **sem** o `-v` da saída. O que acontece? Por quê?

<details><summary>👀 Ver resposta</summary>

```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
COPY contador.py .
CMD ["python", "contador.py"]
```
```bash
$ docker build -t claude/contador:1.0 .
$ mkdir entrada
# crie entrada/a.txt e entrada/b.txt no VS Code
$ docker run --rm -v ./entrada:/entrada:ro -v ./saida:/saida claude/contador:1.0
$ cat saida/resumo.txt
```
e) Não. Os arquivos chegam pelo bind mount na hora em que o container roda, e não pela imagem.
f) `FileNotFoundError: ... '/saida/resumo.txt'`: a pasta `/saida` não existe na imagem. Ela só existia
porque o Docker a criava para encaixar o bind mount. (A pasta `saida` do seu computador também foi criada
pelo Docker no primeiro `docker run`.)
</details>

### 11. Clonar um volume

O comando **`cp`** copia arquivos. Para copiar **todo o conteúdo** de uma pasta para outra:
```
cp -r /origem/. /destino/
   │  └──┬───┘
   │     └── o "/." no fim significa "o conteúdo de dentro da pasta"
   └── -r = copiar também as subpastas
```
a) Crie um volume `vitrine-copia`.
b) Rode um alpine com **dois** volumes, `vitrine-html` em `/origem` (somente leitura) e `vitrine-copia` em
   `/destino`, executando o `cp` acima direto no `docker run`.
c) Mostre o `index.html` do `vitrine-copia`. É a promoção?
d) Suba um segundo nginx, `vitrine-teste`, porta 8082, usando a **cópia**. Mude a página da cópia para
   `<h1>Teste de layout</h1>`. A `vitrine` original (8081) mudou?

<details><summary>👀 Ver resposta</summary>

```bash
$ docker volume create vitrine-copia
$ docker run --rm -v vitrine-html:/origem:ro -v vitrine-copia:/destino claude/alpine:3.22 cp -r /origem/. /destino/
$ docker run --rm -v vitrine-copia:/v claude/alpine:3.22 cat /v/index.html
$ docker run -d --name vitrine-teste -p 8082:80 -v vitrine-copia:/usr/share/nginx/html:ro claude/nginx:alpine
$ docker run -it --rm -v vitrine-copia:/html claude/alpine:3.22 sh
# echo "<h1>Teste de layout</h1>" > /html/index.html
# exit
```
d) Não. Depois da cópia, são duas gavetas independentes: dá para testar à vontade sem estragar o original.
</details>

### 12. Backup e restauração

a) **Backup:** copie o conteúdo do `vitrine-html` para uma pasta `backup` **do seu computador**
   (um volume como origem e um bind mount como destino). Confira com `ls backup`.
b) **Desastre:** apague o container `vitrine` e o volume `vitrine-html`. 💥
c) **Restauração:** crie de novo o volume `vitrine-html` e copie o conteúdo de `./backup` para ele.
d) Suba a `vitrine` de novo (mesmo comando do exercício 9). A promoção voltou?

<details><summary>👀 Ver resposta</summary>

```bash
$ docker run --rm -v vitrine-html:/origem:ro -v ./backup:/backup claude/alpine:3.22 cp -r /origem/. /backup/
$ ls backup

$ docker rm -f vitrine
$ docker volume rm vitrine-html

$ docker volume create vitrine-html
$ docker run --rm -v ./backup:/backup:ro -v vitrine-html:/destino claude/alpine:3.22 cp -r /backup/. /destino/

$ docker run -d --name vitrine -p 8081:80 -v vitrine-html:/usr/share/nginx/html:ro claude/nginx:alpine
```
d) Sim. 🎉 É assim que funciona um backup: uma cópia **fora** do volume que permite reconstruí-lo.

> ⚠️ Esse jeito de copiar serve para arquivos simples, como os de um site. Para **bancos de dados** existem
> ferramentas próprias de backup, que você vai ver mais adiante.
</details>

---

## 🏁 Desafio extra: o turno da noite

Monte e resolva tudo sozinho, sem olhar as respostas acima:

1. Um Postgres `estoque`, com volume `estoque-dados` (cuidado com o caminho!), senha `estoque123`, e uma tabela
   `produtos (nome TEXT)` com 3 produtos.
2. Um nginx `painel`, porta 8085, servindo o volume `painel-html` em somente leitura, com uma página
   `<h1>Estoque: 3 produtos</h1>` gravada por **outro** container.
3. Um backup do `painel-html` na pasta `./backup-painel`.
4. Apague os containers `estoque` e `painel` e suba **novos** com os mesmos volumes. Prove que os produtos e a
   página continuam lá.
5. Limpe tudo: containers, os volumes dos exercícios e as pastas `backup`/`backup-painel` se quiser.
   Confira com `docker volume ls` que não sobrou nenhum volume anônimo.

<details><summary>👀 Ver resposta do desafio</summary>

```bash
$ docker run -d --name estoque -e POSTGRES_PASSWORD=estoque123 -v estoque-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker exec -it estoque psql -U postgres
```
```sql
CREATE TABLE produtos (nome TEXT);
INSERT INTO produtos VALUES ('teclado');
INSERT INTO produtos VALUES ('mouse');
INSERT INTO produtos VALUES ('monitor');
\q
```
```bash
$ docker run -d --name painel -p 8085:80 -v painel-html:/usr/share/nginx/html:ro claude/nginx:alpine
$ docker run -it --rm -v painel-html:/html claude/alpine:3.22 sh
# echo "<h1>Estoque: 3 produtos</h1>" > /html/index.html
# exit
$ docker run --rm -v painel-html:/origem:ro -v ./backup-painel:/backup claude/alpine:3.22 cp -r /origem/. /backup/

$ docker rm -f estoque painel
$ docker run -d --name estoque -e POSTGRES_PASSWORD=estoque123 -v estoque-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker run -d --name painel -p 8085:80 -v painel-html:/usr/share/nginx/html:ro claude/nginx:alpine
$ docker exec -it estoque psql -U postgres -c "SELECT * FROM produtos;"
# e abra http://localhost:8085

$ docker rm -f estoque painel vitrine vitrine-teste
$ docker volume rm estoque-dados painel-html vitrine-html vitrine-copia
$ docker volume ls
```
</details>

---

Quando quiser seguir, é só avisar: **"bora para o nível 4"** (redes: containers conversando entre si).
