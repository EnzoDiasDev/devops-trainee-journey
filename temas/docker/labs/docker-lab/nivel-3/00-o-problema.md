# Aula 00 — O problema: dados que somem

## 🎯 Nesta aula
- Ver o problema acontecer.
- Entender a ideia de **volume**.

---

## 📖 Aprenda: a camada do container

Lembre da analogia: a imagem é a **marmita lacrada**. Quando um container nasce, o Docker não mexe na
marmita: ele coloca uma **folha de rascunho** por cima, e tudo que o container grava vai para essa folha.

```
 ┌──────────────────────┐
 │ folha de rascunho    │  ← o que o container grava (arquivos novos, alterações)
 ├──────────────────────┤
 │ imagem (lacrada)     │  ← nunca muda
 └──────────────────────┘
```
| Ação | O que acontece com a folha de rascunho |
|------|----------------------------------------|
| `docker stop` / `docker start` | **Continua** (é o mesmo container) |
| `docker rm` | **Vai para o lixo junto** com o container |

E apagar containers é algo **normal e frequente** no Docker: para atualizar a versão, para corrigir
uma configuração, para liberar espaço... Um banco de dados que perde tudo a cada atualização não serve.

---

## 🔬 Veja acontecer

```bash
$ docker run -it --name caderno claude/alpine:3.22 sh
# echo "anotação importante" > /nota.txt
# cat /nota.txt
# exit
```
O container parou, mas ainda existe. Ligue-o de novo e entre (você aprendeu `start` no nível 1;
o `-ai` serve para entrar nele ao ligar):
```bash
$ docker start -ai caderno
# cat /nota.txt
# exit
```
A nota continua lá (mesmo container, mesma folha de rascunho). Agora apague e crie outro igual:
```bash
$ docker rm caderno
$ docker run -it --name caderno claude/alpine:3.22 sh
# cat /nota.txt
# exit
$ docker rm caderno
```
`No such file or directory`: a nota sumiu junto com o container antigo. 😢

---

## 📖 Aprenda: a solução, o **volume**

Um **volume** é uma **gaveta guardada fora do container**, gerenciada pelo Docker. Você "encaixa" a
gaveta numa pasta do container. Tudo que o container gravar **nessa pasta** vai para a gaveta.

```
   container 1 (apagado)        container 2 (novo)
   ┌──────────────┐             ┌──────────────┐
   │   /dados ────┼──┐      ┌───┼──── /dados   │
   └──────────────┘  │      │   └──────────────┘
                     ▼      ▼
                ┌──────────────────┐
                │  volume (gaveta) │   ← continua existindo
                └──────────────────┘
```
- Apagou o container? A gaveta **fica**.
- Criou um container novo e encaixou a mesma gaveta? Os dados **estão lá**.

---

## 🧠 Memorize

1. O que acontece com os arquivos gravados por um container quando ele é **parado** (`stop`)?
2. E quando ele é **apagado** (`rm`)?
3. Com suas palavras: o que é um volume?
4. Por que não dá para simplesmente "nunca apagar o container"?

<details><summary>👀 Ver respostas</summary>

1. Continuam lá.
2. São apagados junto com o container.
3. Uma "gaveta" de dados guardada fora do container, que pode ser encaixada numa pasta dele e sobrevive ao `docker rm`.
4. Porque apagar e recriar containers é rotina: atualizar a imagem, mudar configuração (porta, variáveis), corrigir problemas.
</details>

➡️ Próxima: [Aula 01 — Seu primeiro volume](01-volumes.md)
