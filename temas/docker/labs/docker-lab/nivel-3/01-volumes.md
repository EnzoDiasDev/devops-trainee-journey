# Aula 01 — Seu primeiro volume

## 🎯 Nesta aula
- `docker volume create`, `ls`, `inspect` e `rm`: gerenciar volumes.
- `-v volume:/pasta`: encaixar um volume num container.

---

## 📖 Aprenda: os comandos de volume

Todos começam com `docker volume`:

| Comando | O que faz |
|---------|-----------|
| `docker volume create notas` | Cria um volume chamado `notas` |
| `docker volume ls` | Lista os volumes |
| `docker volume inspect notas` | Mostra detalhes do volume (inclusive onde ele fica no seu computador) |
| `docker volume rm notas` | Apaga o volume **e tudo que tem dentro** ⚠️ |

```bash
$ docker volume create notas
$ docker volume ls
```
> Na lista também aparece um volume de nome enorme (`649b95a8...`). Ele guarda dados do seu cluster
> Girus antigo. **Não apague.**

---

## 📖 Aprenda: `-v` (encaixar o volume)

No `docker run`, a opção `-v` liga um volume a uma pasta do container:

```
docker  run  -v notas:/dados  claude/alpine:3.22 ...
             └─┬─┘ └──┬──┘
           volume   pasta dentro do container
```
"Tudo que o container gravar em `/dados` vai para o volume `notas`."

> Lembra do `-p 8081:80`? A lógica é parecida: **antes** dos dois-pontos fica o lado de fora
> (o volume) e **depois** o lado de dentro (a pasta no container).

### A nota que não some
Refaça o experimento da aula 00, agora gravando **dentro da pasta do volume**:
```bash
$ docker run -it --rm -v notas:/dados claude/alpine:3.22 sh
# echo "anotação importante" > /dados/nota.txt
# cat /dados/nota.txt
# exit
```
O `--rm` apagou o container. Crie **outro** container com o mesmo volume:
```bash
$ docker run -it --rm -v notas:/dados claude/alpine:3.22 sh
# cat /dados/nota.txt
# exit
```
**A nota está lá!** 🎉 O container era novo, mas a gaveta era a mesma.

> ⚠️ Só a pasta do volume (`/dados`) é guardada. Um arquivo gravado em outra pasta, como `/nota.txt`,
> continua sumindo junto com o container.

### Volumes servem para qualquer imagem
O mesmo volume pode ser encaixado em containers de imagens diferentes. A gaveta não pertence a nenhuma imagem:
```bash
$ docker run --rm -v notas:/dados claude/python:3.13-alpine cat /dados/nota.txt
```

### Se o volume não existir, o `-v` cria
```bash
$ docker run --rm -v rascunho:/coisas claude/alpine:3.22 ls /coisas
$ docker volume ls
```
O `rascunho` foi criado automaticamente. Cuidado com isso: se você **digitar o nome errado**, o Docker
cria um volume novo e vazio em vez de reclamar, e parece que seus dados sumiram.

---

## 📖 Aprenda: onde o volume fica de verdade

```bash
$ docker volume inspect notas
```
Procure a linha **`Mountpoint`**, algo como:
```
"Mountpoint": "/home/<seu-usuario>/.local/share/docker/volumes/notas/_data"
```
É uma pasta comum no seu Ubuntu. Dá até para ver o arquivo de fora:
```bash
$ cat ~/.local/share/docker/volumes/notas/_data/nota.txt
```
> No dia a dia, **não mexa** nessa pasta diretamente. Use sempre containers para ler e gravar.
> Aqui é só para você ver que não há mágica.

---

## 📖 Aprenda: apagar volume

```bash
$ docker volume rm rascunho
```
Não dá para apagar um volume **em uso** por algum container (mesmo parado): aparece `volume is in use`.
Apague o container antes.

> ⚠️ Apagar um volume apaga **todos os dados** dele, sem lixeira. Confira o nome duas vezes.

---

## ✍️ Pratique

1. Crie um volume chamado `diario`.
2. Rode um alpine com terminal, com o volume `diario` em `/diario`, que se apague ao sair. Grave o texto
   `Dia 1: aprendi volumes` no arquivo `/diario/hoje.txt` e saia.
3. Rode **outro** container (pode ser do `claude/python:3.13-alpine`) com o mesmo volume e mostre o conteúdo
   do arquivo, sem entrar no container (passe o comando direto no `docker run`).
4. Crie um container **em segundo plano** chamado `segura-diario`, com o volume `diario`, rodando o comando
   `sleep 600` (ele só "dorme" por 10 minutos e mantém o container ligado). Tente apagar o volume. O que acontece?
5. Apague o container e depois o volume `diario`. Confira com `docker volume ls`.
6. Apague também o volume `notas` e, se existir, o `rascunho`.

<details><summary>👀 Ver respostas</summary>

1. `docker volume create diario`
2. ```bash
   $ docker run -it --rm -v diario:/diario claude/alpine:3.22 sh
   # echo "Dia 1: aprendi volumes" > /diario/hoje.txt
   # exit
   ```
3. `docker run --rm -v diario:/diario claude/python:3.13-alpine cat /diario/hoje.txt`
4. ```bash
   $ docker run -d --name segura-diario -v diario:/diario claude/alpine:3.22 sleep 600
   $ docker volume rm diario
   ```
   Erro `volume is in use`: um container está usando o volume.
5. ```bash
   $ docker rm -f segura-diario
   $ docker volume rm diario
   $ docker volume ls
   ```
6. `docker volume rm notas rascunho`
</details>

---

## 🧠 Memorize

1. Como criar o volume `fotos`?
2. Como listar os volumes?
3. Como rodar um container com o volume `fotos` na pasta `/imagens`?
4. Em `-v fotos:/imagens`, qual parte é o volume e qual é a pasta do container?
5. Gravei um arquivo em `/tmp` num container com `-v fotos:/imagens`. Ele fica salvo no volume?
6. O que acontece se eu usar `-v` com um volume que não existe?
7. Por que não consigo apagar um volume?

<details><summary>👀 Ver respostas</summary>

1. `docker volume create fotos`
2. `docker volume ls`
3. `docker run -v fotos:/imagens <imagem>`
4. `fotos` é o volume; `/imagens` é a pasta dentro do container.
5. Não. Só o que estiver em `/imagens`.
6. O Docker cria o volume automaticamente (vazio).
7. Algum container (ligado ou parado) está usando ele. Apague o container antes.
</details>

➡️ Próxima: [Aula 02 — Volume numa aplicação sua](02-volume-na-sua-app.md)
