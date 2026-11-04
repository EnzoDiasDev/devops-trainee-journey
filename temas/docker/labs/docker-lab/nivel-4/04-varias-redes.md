# Aula 04 — Várias redes e isolamento

## 🎯 Nesta aula
- Por que separar containers em **redes diferentes**.
- `docker network connect` e `disconnect`: colocar e tirar um container de uma rede.
- Um container em **duas redes** ao mesmo tempo.

---

## 📖 Aprenda: redes são muros

Containers em redes diferentes **não se enxergam**. Isso é ótimo para **segurança**: o banco de dados guarda
dados importantes e deve ser alcançado **só** por quem precisa dele.

Um desenho muito comum:
```
        rede "publica"                       rede "privada"
 ┌────────────────────────────┐     ┌─────────────────────────────┐
 │  ┌──────────┐   ┌────────┐ │     │ ┌────────┐     ┌─────────┐  │
 │  │ visitante│   │  app   │─┼─────┼─│  app   │ ──► │  banco  │  │
 │  └──────────┘   └────────┘ │     │ └────────┘     └─────────┘  │
 └────────────────────────────┘     └─────────────────────────────┘
        o "app" está nas DUAS redes (é a ponte)
```
- O `visitante` fala com o `app`, mas **não alcança o banco**.
- O `app` está nas duas redes: conversa com os dois lados.
- Se o `visitante` for invadido, o atacante não chega ao banco.

---

## 📖 Aprenda: `docker network connect` e `disconnect`

O `--network` do `docker run` coloca o container em **uma** rede. Para acrescentar mais redes (ou tirar),
com o container já criado:

| Comando | O que faz |
|---------|-----------|
| `docker network connect privada app` | Coloca o container `app` **também** na rede `privada` |
| `docker network disconnect privada app` | Tira o `app` da rede `privada` |

> Repare na ordem: primeiro a **rede**, depois o **container**.

---

## 📖 Mão na massa

Use o `banco` da aula 03 (rede `sistema`). Se você apagou, recrie a rede `sistema` e o `banco` com o volume `visitas-dados`.

**1. Uma rede "pública" com um visitante**
```bash
$ docker network create publica
$ docker run -d --name visitante --network publica claude/alpine:3.22 sleep 3600
```
> `sleep 3600` só mantém o container ligado por 1 hora (o alpine não tem um programa que fique rodando
> sozinho), para podermos usar `docker exec` nele.

**2. O visitante não alcança o banco**
```bash
$ docker exec visitante ping -c 1 banco
```
`bad address 'banco'`: o banco está em outra rede. O muro funciona. 🧱

**3. Um container ponte**
```bash
$ docker run -d --name ponte --network publica claude/alpine:3.22 sleep 3600
$ docker network connect sistema ponte
$ docker exec ponte ping -c 1 banco
$ docker exec ponte ping -c 1 visitante
```
A `ponte` alcança os dois lados. Veja em quais redes ela está:
```bash
$ docker network inspect sistema
$ docker network inspect publica
```
A `ponte` aparece na parte `Containers` das **duas** redes.

**4. Tirando da rede**
```bash
$ docker network disconnect sistema ponte
$ docker exec ponte ping -c 1 banco
```
`bad address` de novo: sem a rede `sistema`, sem acesso ao banco.

**Limpeza** (guarde o `banco`, a rede `sistema` e o volume para o desafio, se quiser):
```bash
$ docker rm -f visitante ponte
$ docker network rm publica
```

---

## ✍️ Pratique

Monte um "hospital" com duas áreas.

1. Crie as redes `recepcao` e `prontuarios`.
2. Suba um Postgres chamado `prontuario-db` **só** na rede `prontuarios` (senha `saude123`, volume `prontuario-dados`).
3. Suba um alpine chamado `atendente` (com `sleep 3600`) **só** na `recepcao`.
4. Suba um alpine chamado `medico` (com `sleep 3600`) na `recepcao` e **também** na `prontuarios`.
5. Prove: o `atendente` **não** alcança o `prontuario-db`; o `medico` alcança o `prontuario-db` **e** o `atendente`.
6. O médico foi transferido: tire-o da rede `prontuarios` e prove que ele perdeu o acesso.
7. Mostre quais containers estão em cada rede.
8. Apague tudo: containers, as duas redes e o volume.

<details><summary>👀 Ver respostas</summary>

```bash
$ docker network create recepcao
$ docker network create prontuarios
$ docker run -d --name prontuario-db --network prontuarios -e POSTGRES_PASSWORD=saude123 -v prontuario-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker run -d --name atendente --network recepcao claude/alpine:3.22 sleep 3600
$ docker run -d --name medico --network recepcao claude/alpine:3.22 sleep 3600
$ docker network connect prontuarios medico

$ docker exec atendente ping -c 1 prontuario-db     # bad address
$ docker exec medico ping -c 1 prontuario-db        # responde
$ docker exec medico ping -c 1 atendente            # responde

$ docker network disconnect prontuarios medico
$ docker exec medico ping -c 1 prontuario-db        # bad address

$ docker network inspect recepcao
$ docker network inspect prontuarios

$ docker rm -f prontuario-db atendente medico
$ docker network rm recepcao prontuarios
$ docker volume rm prontuario-dados
```
</details>

---

## 🧠 Memorize

1. Containers em redes diferentes se enxergam?
2. Por que colocar o banco numa rede separada?
3. Como colocar o container `api` também na rede `dados`?
4. Como tirar o `api` da rede `dados`?
5. Como ver quais containers estão na rede `dados`?
6. Para que serve o `sleep 3600` nos exemplos?

<details><summary>👀 Ver respostas</summary>

1. Não.
2. Segurança: só quem precisa alcança o banco.
3. `docker network connect dados api`
4. `docker network disconnect dados api`
5. `docker network inspect dados`
6. Manter um container alpine ligado (por 1 hora), para poder usar `docker exec` nele.
</details>

➡️ Próxima: [Aula 05 — Desafio do nível 4](05-desafio-final.md)
