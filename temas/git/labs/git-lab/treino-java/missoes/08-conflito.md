# Missão 08 — MR com conflito no `compose.yaml` 🟠

## 🎫 Ticket
> **De:** Marketing: o nome do banco na API deve ser **Enzo Bank Digital** (variável `BANCO_NOME` do `compose.yaml`).

## 🎯 Você vai treinar
**Git:** `git pull origin main` (novo), conflito · **GitLab:** "Merge blocked: merge conflicts" · **Docker:** `compose config`

---

## 🛠️ Passo a passo

**1.** Atualize a `main`, crie **`feature/nome-digital`** e, no `compose.yaml`, troque `BANCO_NOME: Enzo Bank` por:
```yaml
      BANCO_NOME: Enzo Bank Digital
```
Veja no seu ambiente (`docker compose up -d`: sem `--build`, porque só a variável mudou) → http://localhost:8070.
Commit, push, abra o MR.

**2.** Enquanto isso, a Ana juntou uma mudança na `main` (e fez o deploy):
```bash
$ ../../colega.sh 08
```
**3.** Atualize a página do seu MR no GitLab. Em vez do botão Merge aparece algo como **"Merge blocked: merge conflicts
must be resolved"**. Rode o revisor: ele também reprova.

---

## 📖 Novo: `git pull origin main`

A sua branch conflita com o que **entrou na `main` depois** que você a criou. Traga a `main` do GitLab **para dentro
da sua branch** e resolva no seu computador:
```bash
$ git switch feature/nome-digital
$ git pull origin main
```
| Comando | Traz o quê, para onde |
|---------|-----------------------|
| `git pull` | A **mesma** branch do GitLab → para a branch atual |
| `git pull origin main` | A **main** do GitLab → para a branch atual |

> 💡 O GitLab às vezes oferece um botão **Resolve conflicts** para resolver pelo navegador. Funciona para casos simples,
> mas resolver no seu PC deixa você **testar** antes (rodar o app, o `compose config`...). Por isso vamos pelo terminal.

---

**4.** Atualize a sua branch com a `main`. No `compose.yaml`, junte os dois: `BANCO_NOME: Enzo Bank Digital v2`, apague
os marcadores e **cuide da indentação** (6 espaços, como as outras linhas).

**5.** Valide o YAML **antes** de commitar:
```bash
$ docker compose config
```
**6.** Finalize o merge, envie. Atualize o MR: o bloqueio sumiu. Revisor → Merge → deploy → limpar.
http://localhost:8090 deve mostrar **🏦 Enzo Bank Digital v2**.

<details><summary>👀 Comandos</summary>

```bash
$ git switch main && git pull
$ git switch -c feature/nome-digital
# edite o compose.yaml
$ docker compose up -d
$ git commit -am "Muda o nome do banco para Enzo Bank Digital"
$ git push -u origin feature/nome-digital
# abra o MR
$ ../../colega.sh 08
$ ../../revisor.sh feature/nome-digital      # reprovado: conflito
$ git pull origin main                       # CONFLICT in compose.yaml
# resolva e salve
$ docker compose config
$ git add compose.yaml
$ git commit                                 # salve e feche a aba
$ git push
$ ../../revisor.sh feature/nome-digital      # aprovado
# Merge → ../../deploy.sh
$ git switch main && git pull
$ git branch -d feature/nome-digital && git fetch --prune
```
</details>

---

## 🧠 Reflexão
Por que o `docker compose config` é tão importante depois de resolver um conflito em YAML?
<details><summary>👀 Resposta</summary>
Um conflito mal resolvido (marcador esquecido, espaço errado) deixa o arquivo inválido, e aí <b>nada</b> sobe, nem o seu
ambiente nem a produção. O <code>config</code> pega o erro antes do commit.
</details>

➡️ [Missão 09](09-deploy-quebrado.md)
