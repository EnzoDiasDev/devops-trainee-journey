# Missão 05 — MR reprovado por mensagem ruim 🟡

## 🎫 Ticket
> **De:** Ana
> Quero uma mensagem de agradecimento no final da página inicial da API: "Obrigado por usar o Enzo Bank! 💙".

**Atenção:** nesta missão você vai errar **de propósito**, para treinar o conserto.

## 🎯 Você vai treinar
**Git:** `--amend`, `push --force-with-lease` (novo) · **GitLab:** o MR se atualiza com o force push · **Docker:** `up --build`

---

## 🛠️ Passo a passo

**1.** Atualize a `main` e crie a branch **`feature/agradecimento`**.

**2.** Em `src/App.java`, no método `inicio()`, troque a **última** linha:
```java
                + "  /extrato?conta=ana\n";
```
por:
```java
                + "  /extrato?conta=ana\n"
                + "\n"
                + "Obrigado por usar o Enzo Bank! 💙\n";
```
**3.** Veja no seu ambiente: `docker compose up -d --build` → http://localhost:8070.

**4.** Faça o commit com a mensagem **`ajuste`** (a ruim, de propósito 😈), envie e abra o MR. Rode o revisor: **reprovado**.

**5.** Conserte a mensagem com `--amend` e tente `git push`:
```
 ! [rejected]        feature/agradecimento -> feature/agradecimento (non-fast-forward)
```

---

## 📖 Novo: `git push --force-with-lease`

O `--amend` **substitui** o commit (o código dele muda). Agora o seu commit e o do GitLab são **diferentes**, e o Git não
deixa o push "apagar" o commit do servidor sem você pedir:

| Comando | O que faz |
|---------|-----------|
| `git push --force-with-lease` | **Substitui** a branch no GitLab pela sua, **mas** recusa se alguém enviou algo novo nela desde o seu último pull |
| `git push --force` | Substitui **sem conferir nada**. ⚠️ Evite |

> 🚨 **Regra de ouro:** só **na sua própria branch de tarefa**. Na `main` o GitLab nem deixa (ela vem protegida contra
> force push por padrão).

---

**6.** Envie com `--force-with-lease` e abra o MR no GitLab: na aba **Overview** aparece um aviso do tipo
*"force-pushed the feature/agradecimento branch"*, e na aba **Commits** está só o commit novo. O MR se atualizou sozinho.

**7.** Revisor (agora ✅) → Merge → deploy → limpar. Confira http://localhost:8090.

<details><summary>👀 Comandos</summary>

```bash
$ git switch main && git pull
$ git switch -c feature/agradecimento
# edite o App.java
$ docker compose up -d --build
$ git commit -am "ajuste"
$ git push -u origin feature/agradecimento
# abra o MR
$ ../../revisor.sh feature/agradecimento        # reprovado
$ git commit --amend -m "Adiciona mensagem de agradecimento na página inicial"
$ git push                                      # rejeitado
$ git push --force-with-lease
$ ../../revisor.sh feature/agradecimento        # aprovado
# Merge no GitLab
$ ../../deploy.sh
$ git switch main && git pull
$ git branch -d feature/agradecimento && git fetch --prune
```
</details>

---

## ✅ Pronto quando
- [ ] O MR foi juntado e a mensagem aparece em http://localhost:8090.
- [ ] Você sabe explicar por que o `git push` normal foi rejeitado.

## 🧠 Reflexão
Como **evitar** tudo isso?
<details><summary>👀 Resposta</summary>
Conferir a mensagem <b>antes</b> do push (<code>git log --oneline -1</code>). Com o commit ainda só no seu PC, um
<code>--amend</code> resolve sem force.
</details>

➡️ [Missão 06](06-urgente.md)
