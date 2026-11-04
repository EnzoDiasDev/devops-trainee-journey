# Missão 09 — 🔥 A estagiária quebrou o deploy 🟠

## 🎫 Ticket
Dispare o evento:
```bash
$ ../../colega.sh 09
```
> **De:** Bruno — 🔥 O deploy quebrou! A produção ainda está no ar com a versão antiga, mas não conseguimos publicar
> nada. Descobre o que aconteceu e desfaz, **sem apagar a história**.

## 🎯 Você vai treinar
**GitLab:** investigar pelo histórico, **botão Revert** · **Docker:** ler um erro de build, Dockerfile quebrado

---

## 🛠️ Passo a passo

**1.** Atualize a sua `main` e tente construir:
```bash
$ git switch main && git pull
$ docker compose build
```
Leia o erro. Lembra do Docker Lab (nível 1, aula 06)? 🤔

**2. Investigue pelo GitLab:** em **Code → Commits**, qual foi o último commit da `main`? Quem fez? Clique nele: que
linha de qual arquivo mudou?

**3.** A produção (http://localhost:8090) continua no ar. Por quê?

---

## 📖 Novo: o botão Revert do GitLab

Na página de um commit (ou de um MR já juntado), o GitLab tem o botão **Revert** (às vezes dentro de **Options**).
Ele faz o `git revert` para você **e já abre um MR** com o resultado.

---

**4.** Na página do commit da Carla, clique em **Revert**. Na janela:
- **Revert in branch:** `main`;
- deixe marcado **Start a new merge request with these changes**;
- confirme.

O GitLab cria uma branch (algo como `revert-1a2b3c4d`) com o commit `Revert "Atualiza a imagem base do Java"` e abre o
formulário do MR. Crie o MR.

**5.** Copie o **nome da branch** que o GitLab criou (aparece no MR) e peça a revisão:
```bash
$ ../../revisor.sh revert-1a2b3c4d          # use o nome que apareceu para você
```
**6.** Merge → deploy (agora volta a funcionar ✅) → `git switch main && git pull` → `git fetch --prune`.
(Não há branch local para apagar: ela foi criada no GitLab.)

<details><summary>👀 Respostas</summary>

- **Erro do build:** `pull access denied ... claude/java:25`. A imagem não existe no seu PC, e o Docker tentou baixar do
  Docker Hub, onde também não existe (igual ao `claude/busybox` apagado no nível 1).
- **Commit:** "Atualiza a imagem base do Java", da Carla: trocou `FROM claude/temurin:25-jdk-alpine` por `FROM claude/java:25`.
- **Por que a produção não caiu:** o deploy falhou **no build**, antes de trocar o container. O antigo continuou rodando.
- **Pelo terminal**, o mesmo seria: `git switch -c fix/reverte-imagem-base` → `git revert <código>` → push → MR.
</details>

---

## ✅ Pronto quando
- [ ] O MR de revert foi juntado e o deploy voltou a funcionar.
- [ ] No histórico aparecem **os dois**: o commit da Carla **e** o `Revert`.

## 🧠 Reflexão
A Carla conseguiu enviar direto para a `main`. Como impedir isso? (É a próxima missão.)

➡️ [Missão 10](10-proteger-main.md)
