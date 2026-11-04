# Aula 05 — Entrar dentro do container

## 🎯 Nesta aula
- `-it`: rodar um container e "entrar" nele para digitar comandos.
- `docker exec`: entrar num container que **já está ligado**.
- 4 comandos para usar lá dentro: `cat`, `echo`, `hostname`, `exit`.

---

## 📖 Aprenda: `-it` e o comando `sh`

Até agora o container rodava o programa que veio na imagem. Mas você pode dizer **qual programa**
rodar, escrevendo-o **depois** do nome da imagem. Um programa muito útil é o **`sh`**: um terminal.

```
docker  run  -it  --rm  claude/alpine:3.22  sh
             └┬┘                            └┬┘
     modo interativo               programa a rodar (um terminal)
```

- `-it` = "quero digitar coisas nesse container" (são duas opções juntas: `-i` mantém o teclado
  conectado e `-t` cria uma tela de terminal). Sempre use as duas juntas.
- `--rm` = apagar o container quando você sair (aula 02).
- `sh` = o programa que vai rodar: um terminal.

```bash
$ docker run -it --rm claude/alpine:3.22 sh
```
Repare que o começo da linha mudou para algo como **`/ #`**. Isso significa que você está
**dentro do container**. Os comandos agora rodam lá dentro, não no seu Ubuntu.

> Nesta aula, comandos digitados **dentro** do container aparecem com `#` na frente (em vez de `$`).
> Também não digite o `#`.

### Comandos para usar lá dentro
| Comando | O que faz | Exemplo |
|---------|-----------|---------|
| `ls` | Lista arquivos (você já conhece) | `ls` |
| `cat` | **Mostra o conteúdo** de um arquivo | `cat /etc/os-release` |
| `hostname` | Mostra o nome da "máquina". Num container, é o ID dele | `hostname` |
| `exit` | **Sai** do container e volta para o seu terminal | `exit` |

Experimente lá dentro:
```bash
# ls
# cat /etc/os-release
# hostname
# exit
```
O `cat /etc/os-release` mostrou **Alpine Linux**, mesmo seu computador sendo Ubuntu. Cada imagem
traz o próprio sistema de arquivos.

Ao dar `exit`, o `sh` terminou → o container parou → e o `--rm` apagou o container. Lembra da regra
de ouro da aula 01? **O container vive enquanto o programa dele estiver rodando.**

---

## 📖 Aprenda: `echo` e `>` (escrever num arquivo)

| Comando | O que faz |
|---------|-----------|
| `echo "olá"` | Mostra o texto na tela |
| `echo "olá" > recado.txt` | Em vez de mostrar, **grava** o texto no arquivo `recado.txt` (cria o arquivo, ou **substitui** o conteúdo se ele já existir) |

O `>` significa "mande o resultado para este arquivo". Teste:
```bash
$ docker run -it --rm claude/alpine:3.22 sh
# echo "olá"
# echo "olá, container" > recado.txt
# ls
# cat recado.txt
# exit
```

---

## 📖 Aprenda: `docker exec`

`docker run -it` **cria um container novo**. Mas e se o container já estiver ligado (como um site
com `-d`) e você quiser entrar nele? Use `docker exec`:

```
docker  exec  -it  site  sh
                   └┬─┘  └┬┘
         container ligado  programa a rodar lá dentro
```

```bash
$ docker run -d --name site -p 8081:80 claude/nginx:alpine
$ docker exec -it site sh
```

Agora você está **dentro do container do site**. A página que o nginx mostra fica no arquivo
`/usr/share/nginx/html/index.html`. Veja e depois troque o conteúdo:
```bash
# cat /usr/share/nginx/html/index.html
# echo "<h1>Meu primeiro site no Docker</h1>" > /usr/share/nginx/html/index.html
# exit
```
Abra **http://localhost:8081** → aparece o seu texto! 🎉

Repare: depois do `exit` o site **continua ligado** (`docker ps`). Com `exec` você entrou num container
que já existia e saiu dele sem desligá-lo.

| | `docker run -it imagem sh` | `docker exec -it container sh` |
|---|---|---|
| Recebe | uma **imagem** | um **container ligado** |
| Cria container novo? | Sim | Não |
| Ao dar `exit` | O container para | O container continua ligado |

### ⚠️ Mudanças dentro do container somem quando ele é apagado
Desligar e ligar (`docker stop` / `docker start`) **não** apaga as mudanças: é o mesmo container.
Mas **apagar** (`docker rm`) e criar outro, sim:
```bash
$ docker rm -f site
$ docker run -d --name site -p 8081:80 claude/nginx:alpine
```
Atualize o navegador → voltou o "Welcome to nginx!". O container novo nasceu da **imagem**, que
continua original. Lembra: mexer no bolo não muda a receita. (Como guardar dados de verdade é
assunto de um nível futuro.)

```bash
$ docker rm -f site
```

---

## ✍️ Pratique

1. Rode um container do `claude/alpine:3.22` e entre nele com um terminal, de forma que ele se apague
   sozinho quando você sair. Lá dentro:
   - mostre o nome da máquina;
   - crie um arquivo `nome.txt` com o seu nome dentro;
   - mostre o conteúdo do arquivo;
   - saia.
2. Rode de novo o mesmo comando do item 1 e procure o `nome.txt`. Ele existe? Por quê?
3. Crie um site nginx chamado `vitrine` na porta 8085, em segundo plano.
4. Entre no `vitrine` e troque a página para mostrar `<h1>Vitrine do Enzo</h1>`. Confira no navegador.
5. Saia e confirme que o `vitrine` continua ligado.
6. Apague o `vitrine`.

<details><summary>👀 Ver respostas</summary>

1. ```bash
   $ docker run -it --rm claude/alpine:3.22 sh
   # hostname
   # echo "Enzo" > nome.txt
   # cat nome.txt
   # exit
   ```
2. Não existe. O `--rm` apagou o container anterior e o `docker run` criou um **novo**, a partir da
   imagem original. Use `ls` para conferir e `exit` para sair.
3. `docker run -d --name vitrine -p 8085:80 claude/nginx:alpine`
4. ```bash
   $ docker exec -it vitrine sh
   # echo "<h1>Vitrine do Enzo</h1>" > /usr/share/nginx/html/index.html
   # exit
   ```
   Depois abra http://localhost:8085.
5. `docker ps`
6. `docker rm -f vitrine`
</details>

---

## 🧠 Memorize

1. Como rodar um container do `claude/alpine:3.22` e entrar num terminal dentro dele?
2. Como entrar no container `site`, que já está ligado?
3. Como sair de dentro de um container?
4. Como ver o conteúdo do arquivo `/etc/hostname`?
5. Como gravar o texto `teste` no arquivo `a.txt`?
6. Dei `exit` de um container que entrei com `exec`. Ele desligou?
7. Apaguei o container e criei outro igual. As mudanças que fiz no antigo continuam?

<details><summary>👀 Ver respostas</summary>

1. `docker run -it --rm claude/alpine:3.22 sh` (o `--rm` é opcional, mas evita sobrar container)
2. `docker exec -it site sh`
3. `exit`
4. `cat /etc/hostname`
5. `echo "teste" > a.txt`
6. Não.
7. Não. O container novo começa do zero, a partir da imagem.
</details>

➡️ Próxima: [Aula 06 — Imagens](06-imagens.md)
