# Aula 00 — Preparação

## 🎯 Nesta aula
- `mkdir`: criar pastas.
- `code`: abrir pastas e arquivos no VS Code a partir do terminal.
- A ideia geral: **Dockerfile → imagem → container**.

---

## 📖 Aprenda: `mkdir`

`mkdir` vem de *make directory* (criar pasta).

```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir teste
$ ls
```
Apareceu a pasta `teste`.

> O `~` é um atalho para a sua pasta inicial. `cd ~/Projects/docker-lab/nivel-2/pratica` entra
> direto na pasta de prática, de onde você estiver.

---

## 📖 Aprenda: `code`

Para escrever um Dockerfile você precisa de um editor. Use o **VS Code**, que você abre pelo terminal:

| Comando | O que faz |
|---------|-----------|
| `code .` | Abre **a pasta onde você está** no VS Code (o `.` significa "esta pasta") |
| `code arquivo.txt` | Abre (ou cria) esse arquivo no VS Code |

```bash
$ cd teste
$ code .
```
O VS Code abre mostrando a pasta `teste` na lateral esquerda.

### Criando um arquivo no VS Code
1. Na lateral esquerda, clique no ícone de **novo arquivo** (📄+), ou use `Ctrl + N`.
2. Digite o nome do arquivo e aperte `Enter`.
3. Escreva o conteúdo.
4. **Salve com `Ctrl + S`.** Arquivo não salvo = arquivo que o Docker não enxerga. Um ponto ● na aba
   do arquivo indica que ele ainda não foi salvo.

> 💡 Também dá para abrir um terminal **dentro** do VS Code: menu *Terminal → New Terminal*
> (ou `` Ctrl + ` ``). Ele já começa na pasta certa.

---

## 📖 Aprenda: o caminho até o container

```
  Dockerfile  ── docker build ──►  imagem  ── docker run ──►  container
  (a receita)    (cozinhar)        (marmita     (comer)        (o programa
                                    pronta)                     rodando)
```

| Etapa | O que é | Quantas vezes acontece |
|-------|---------|------------------------|
| **Dockerfile** | Arquivo de texto com as instruções para montar a imagem | Você escreve uma vez |
| **`docker build`** | Lê o Dockerfile e **constrói** a imagem | Cada vez que algo muda |
| **`docker run`** | Cria um container a partir da imagem | Quantas vezes quiser |

No nível 1 alguém já tinha feito as duas primeiras etapas por você (as imagens `claude/`).
Agora você faz tudo.

---

## ✍️ Pratique

1. Vá para a pasta `nivel-2/pratica`.
2. Crie uma pasta chamada `aquecimento` e entre nela.
3. Abra essa pasta no VS Code.
4. Crie um arquivo chamado `recado.txt` com o texto `Estou pronto para o nível 2!` e salve.
5. No terminal, liste os arquivos da pasta e mostre o conteúdo do `recado.txt`
   (o comando `cat` também funciona fora de containers).

<details><summary>👀 Ver respostas</summary>

```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir aquecimento
$ cd aquecimento
$ code .
# crie o recado.txt no VS Code e salve com Ctrl + S
$ ls
$ cat recado.txt
```
</details>

---

## 🧠 Memorize

1. Como criar uma pasta chamada `projeto`?
2. Como abrir no VS Code a pasta onde você está?
3. O que significa o `.` em `code .`?
4. Qual a ordem: imagem, Dockerfile, container?
5. Qual comando transforma o Dockerfile em imagem? E qual transforma a imagem em container?

<details><summary>👀 Ver respostas</summary>

1. `mkdir projeto`
2. `code .`
3. "Esta pasta" (a pasta onde você está).
4. Dockerfile → imagem → container.
5. `docker build` cria a imagem; `docker run` cria o container.
</details>

➡️ Próxima: [Aula 01 — Sua primeira imagem](01-primeira-imagem.md)
