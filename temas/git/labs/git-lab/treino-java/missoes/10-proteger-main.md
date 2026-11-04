# Missão 10 — Nunca mais commit direto na main 🟠

## 🎫 Ticket
> **De:** Bruno
> Depois do susto de ontem: **ninguém** mais envia direto para a `main`. Tudo passa por MR. Configura isso no GitLab.

## 🎯 Você vai treinar
**GitLab:** Protected branches · **Git:** ver um push sendo recusado pelo servidor

---

## 📖 Novo: branches protegidas

No GitLab, uma **branch protegida** tem regras de quem pode:
| Permissão | Significa |
|-----------|-----------|
| **Allowed to merge** | Quem pode juntar MRs nela (clicar em Merge) |
| **Allowed to push and merge** | Quem pode **enviar commits direto** nela (`git push origin main`) |
| **Allowed to force push** | Se pode reescrever a história dela (deve ficar **desligado**) |

Por padrão, a `main` já vem protegida contra **force push**, mas quem é *Maintainer* (você, no seu projeto) ainda
pode dar **push direto**. Foi assim que a Carla quebrou tudo.

---

## 🛠️ Passo a passo

**1. Antes de proteger, prove o problema.** Na sua `main` local, faça um commit qualquer **direto na `main`**:
```bash
$ git switch main && git pull
$ echo "teste" > teste-direto.txt
$ git add teste-direto.txt
$ git commit -m "Teste de push direto na main"
$ git push
```
Passou. 😬 Desfaça com segurança, para não deixar lixo na `main`:
> Se este primeiro push **já** for recusado com `not allowed to push code to protected branches`, o seu GitLab
> protege a `main` de todo projeto novo por padrão. Ótimo! Pule para o passo 2 só para conferir a configuração, e no passo
> 4 use `git reset --hard origin/main` do mesmo jeito.
```bash
$ git revert --no-edit HEAD
$ git push
```
> 📖 `--no-edit` aceita a mensagem padrão do revert sem abrir o editor. `HEAD` é o último commit.

**2. Proteja a `main`.** No GitLab: **Settings → Repository → Protected branches** (expanda a seção). Na linha da `main`:
- **Allowed to merge:** `Maintainers`
- **Allowed to push and merge:** **`No one`**
- **Allowed to force push:** desligado

**3. Tente de novo:**
```bash
$ echo "teste 2" > teste-direto.txt
$ git add teste-direto.txt
$ git commit -m "Segundo teste de push direto na main"
$ git push
```
```
remote: GitLab: You are not allowed to push code to protected branches on this project.
 ! [remote rejected] main -> main (pre-receive hook declined)
```
**Recusado pelo GitLab!** 🛡️ Agora só entra na `main` o que passar por MR.

**4. Arrume a sua `main` local.** Ela tem um commit que o GitLab nunca vai aceitar. Sem perder o trabalho, mova esse commit
para uma branch e volte a `main` para o que está no GitLab:
```bash
$ git branch teste-protecao                # cria uma branch apontando para o commit atual
$ git reset --hard origin/main             # ⚠️ volta a main local para o estado do GitLab
$ git log --oneline -2
```
> 📖 **Novo:** `git reset --hard origin/main` faz a branch atual **ficar igual** à `origin/main` e **descarta** commits e
> mudanças locais que não estejam lá. ⚠️ É destrutivo: por isso salvamos o commit numa branch antes. Mais sobre
> `reset` nas próximas aulas.

**5.** Apague a branch de teste (não vai precisar dela): `git branch -D teste-protecao`
(`-D` maiúsculo força apagar uma branch que nunca foi juntada).

---

## ✅ Pronto quando
- [ ] O `git push` direto na `main` foi **recusado** pelo GitLab.
- [ ] Sua `main` local está igual à do GitLab (`git status` mostra `up to date with 'origin/main'`).

## 🧠 Reflexão
Os colegas simulados (`colega.sh`) também mandavam direto para a `main`. Eles ainda conseguiriam?
<details><summary>👀 Resposta</summary>
Não. A proteção vale para qualquer push, e o <code>colega.sh</code> usa a sua conta. Por isso os eventos 08 e 09 vieram
<b>antes</b> desta missão. Daqui para frente, o único evento de colega (07) mexe numa branch de tarefa, que não é protegida.
</details>

➡️ [Missão 11](11-segredo.md)
