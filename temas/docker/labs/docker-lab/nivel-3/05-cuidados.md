# Aula 05 — Cuidados e limpeza

## 🎯 Nesta aula
- **Volumes anônimos**: os volumes de nome estranho que aparecem "do nada".
- `docker rm -v`: apagar o container junto com o volume anônimo dele.
- `docker system df`: quanto espaço o Docker está usando.
- Boas práticas para não perder dados nem acumular lixo.

---

## 📖 Aprenda: volumes anônimos

Algumas imagens (como a do Postgres) **criam um volume sozinhas**, mesmo quando você não usa `-v`.
O criador da imagem marcou a pasta de dados como "precisa de volume", e o Docker obedece.

Veja acontecer:
```bash
$ docker volume ls
$ docker run -d --name banco-sem-volume -e POSTGRES_PASSWORD=x claude/postgres:18-alpine
$ docker volume ls
```
Apareceu um volume com um nome enorme, como `6c0239e1c45e...`. Isso é um **volume anônimo**: o Docker
criou e deu um nome aleatório.

O problema: com um nome desses, **ninguém sabe de quem ele é**. Se o container for apagado com o
`docker rm` comum, o volume **fica para trás**, ocupando espaço, e vira lixo misterioso.

### `docker rm -v`
O `-v` no `docker rm` apaga o container **e os volumes anônimos dele**:
```bash
$ docker rm -f -v banco-sem-volume
$ docker volume ls
```
O volume de nome estranho sumiu. 🧹

> ⚠️ O `-v` do `docker rm` **não** apaga volumes com nome (os que você criou, como `banco-dados`).
> Esses só saem com `docker volume rm`. Isso protege seus dados.

### Como evitar
**Sempre dê nome aos volumes** com `-v nome:/pasta`. Na aula 04 você encaixou o `banco-dados`
exatamente na pasta que a imagem queria (`/var/lib/postgresql`), então nenhum volume anônimo foi criado.

---

## 📖 Aprenda: `docker system df`

Mostra quanto espaço o Docker está ocupando:
```bash
$ docker system df
```
| Linha | O que é |
|-------|---------|
| `Images` | Imagens |
| `Containers` | Containers (a folha de rascunho de cada um) |
| `Local Volumes` | Volumes |
| `Build Cache` | O cache do `docker build` (o `CACHED` do nível 2) |

---

## 📖 Aprenda: boas práticas

| Faça | Por quê |
|------|---------|
| Dê **nomes claros** aos volumes (`loja-banco`, `blog-uploads`) | Daqui a um mês você vai saber de quem é cada um |
| Rode `docker volume ls` antes de apagar | Para conferir o nome exato |
| Apague volumes **um por um, pelo nome** | `docker volume rm` não tem lixeira |
| Use `docker rm -v` para containers de teste sem `-v` nomeado | Não deixa volume anônimo para trás |

> 🚫 Existe um comando que apaga **todos** os volumes que não estão em uso (`docker volume prune`).
> **Não use** na sua máquina: o volume do seu cluster Girus (`649b95a8...`) não está em uso agora e seria
> apagado junto. Prefira sempre apagar pelo nome.

---

## ✍️ Pratique

1. Liste os volumes e anote quantos existem.
2. Rode um Postgres de teste chamado `pg-teste`, **sem** `-v`, em segundo plano. Liste os volumes. O que mudou?
3. Apague o `pg-teste` **sem** o `-v`. Liste os volumes. O volume anônimo sumiu?
4. Apague esse volume que ficou para trás, pelo nome (copie o nome do `docker volume ls`).
5. Rode outro Postgres de teste, `pg-teste2`, sem `-v`. Apague-o de um jeito que **não deixe** volume para trás. Confira.
6. Veja quanto espaço seus volumes estão usando.

<details><summary>👀 Ver respostas</summary>

1. `docker volume ls`
2. `docker run -d --name pg-teste -e POSTGRES_PASSWORD=x claude/postgres:18-alpine` → `docker volume ls` mostra um volume novo, de nome aleatório.
3. `docker rm -f pg-teste` → `docker volume ls`: **não** sumiu.
4. `docker volume rm <nome-enorme-que-apareceu>`
5. ```bash
   $ docker run -d --name pg-teste2 -e POSTGRES_PASSWORD=x claude/postgres:18-alpine
   $ docker rm -f -v pg-teste2
   $ docker volume ls
   ```
6. `docker system df` → linha `Local Volumes`.
</details>

---

## 🧠 Memorize

1. O que é um volume anônimo e por que ele aparece?
2. Qual a diferença entre `docker rm` e `docker rm -v`?
3. O `docker rm -v` apaga volumes com nome?
4. Como evitar volumes anônimos num Postgres?
5. Qual comando mostra quanto espaço o Docker está usando?

<details><summary>👀 Ver respostas</summary>

1. Um volume de nome aleatório que o Docker cria quando a imagem pede um volume e você não informou nenhum com `-v`.
2. `docker rm -v` também apaga os volumes anônimos do container.
3. Não.
4. Usando `-v nome:/var/lib/postgresql`.
5. `docker system df`
</details>

➡️ Próxima: [Aula 06 — Desafio do nível 3](06-desafio-final.md)
