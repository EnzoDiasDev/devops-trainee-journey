# Missão 01 — Primeiro dia 🟢

## 🎫 Ticket
> **De:** Bruno (tech lead)
> Bem-vindo! Clona o projeto do GitLab, sobe o ambiente de desenvolvimento no Docker e dá uma olhada no histórico,
> pelo terminal **e** pela interface do GitLab. A produção roda em `http://localhost:8090`, e **lá não se mexe
> na mão**: só depois de Merge.

## 🎯 Você vai treinar
**Git:** `clone`, `log`, `show` · **GitLab:** navegar em Commits, Graph e arquivos · **Docker:** `compose up`

---

## 🛠️ Passo a passo

**1. Clone o projeto** (URL SSH da missão 00) para a pasta `area/enzo-bank` e entre nela.

<details><summary>👀 Comandos</summary>

```bash
$ cd ~/Projects/git-lab/treino-java/area
$ git clone ssh://git@gitlab.example.com:2222/seu.usuario/enzo-bank.git enzo-bank
$ cd enzo-bank
$ git remote -v
```
</details>

**2. Conheça os arquivos** (`code .`):
| Arquivo | O que é |
|---------|---------|
| `src/Conta.java` | A regra de negócio: depósito, saque, transferência |
| `src/App.java` | A API: transforma endereços como `/depositar?conta=ana&valor=100` em operações |
| `src/Banco.java` | Guarda as contas e salva os saldos (dentro do **volume**) |
| `src/Testes.java` | Os testes |
| `Dockerfile` / `compose.yaml` | Como montar e subir a API |

**3. Suba o seu ambiente** e use a API **pelo navegador**:
- http://localhost:8070
- http://localhost:8070/depositar?conta=ana&valor=500
- http://localhost:8070/transferir?de=ana&para=bruno&valor=100
- http://localhost:8070/extrato?conta=ana

| Ambiente | Endereço | Quem mexe |
|----------|----------|-----------|
| 🧪 Desenvolvimento (o seu) | http://localhost:8070 | Você, à vontade |
| 🌍 Produção | http://localhost:8090 | Só o `deploy.sh`, depois de um Merge |

<details><summary>👀 Comando</summary>

```bash
$ docker compose up -d --build
```
</details>

**4. O histórico pelo terminal.** Responda:
a) Quantos commits existem?
b) Quem colocou o projeto em Docker? Em que branch?
c) O que mudou no commit "Adiciona Dockerfile da API"?

> 📖 `git log --oneline --graph --format='%h %an: %s'` mostra o autor de cada commit
> (`%h` = código, `%an` = autor, `%s` = mensagem).

**5. O mesmo histórico pelo GitLab.** No projeto, no menu lateral:
| Menu (pode variar conforme a versão) | O que mostra | Equivale a |
|--------------------------------------|--------------|------------|
| **Code → Commits** (ou *Repository → Commits*) | Lista de commits; clique num para ver o diff | `git log` + `git show` |
| **Code → Repository graph** (ou *Graph*) | O desenho das branches e merges | `git log --graph` |
| **Code → Repository** (ou *Files*) | Os arquivos da branch escolhida | `ls` + `cat` |

Abra o commit "Adiciona Dockerfile da API" no GitLab e compare com o que o `git show` mostrou.

<details><summary>👀 Respostas</summary>

a) 7 (`git log --oneline`).
b) Bruno Lima, na branch `feature/docker` (aparece no merge e no Repository graph).
c) `git show <código>` (ou clicando no commit no GitLab): criou o `Dockerfile`.
</details>

---

## ✅ Pronto quando
- [ ] A API de desenvolvimento responde em http://localhost:8070.
- [ ] Você achou o mesmo commit no terminal e no GitLab.

➡️ [Missão 02](02-primeiro-mr.md)
