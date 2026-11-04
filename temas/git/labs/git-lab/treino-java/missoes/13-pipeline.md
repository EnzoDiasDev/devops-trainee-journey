# Missão 13 — Um robô revisor: pipeline de CI 🔴

## 🎫 Ticket
> **De:** Bruno: Cansei de rodar o revisor na mão. Quero que o **GitLab** rode os testes sozinho a cada push, e que o
> MR mostre se passou.

## 🎯 Você vai treinar
**GitLab:** `.gitlab-ci.yml`, Pipelines, Jobs, status do pipeline no MR · **Docker:** imagens usadas pelo CI

---

## 📖 Novo: CI (Integração Contínua)

**CI** = a cada `git push`, um computador do GitLab (o **runner**) baixa o código e roda verificações automáticas: testes,
build, checagens. O resultado (✅ ou ❌) aparece no MR. O roteiro fica num arquivo **`.gitlab-ci.yml`** na raiz do projeto.

```yaml
stages:              # as etapas, em ordem
  - verificacao

testes:              # nome do job (você escolhe)
  stage: verificacao # em qual etapa ele roda
  image: eclipse-temurin:25-jdk-alpine   # o job roda DENTRO de um container desta imagem
  script:            # os comandos do job
    - java src/Testes.java
```
- Cada **job** roda num **container** novo, criado a partir da `image`. É o Docker que você conhece!
- Se algum comando do `script` falhar, o job fica ❌ **failed**.

> ⚠️ Aqui a imagem é a **original** (`eclipse-temurin:...`), e não a `claude/...`: o padrão `claude/` existe só no **seu
> computador**. O runner baixa a imagem do registro configurado no seu GitLab.

---

## 🛠️ Passo 0: o seu GitLab tem runners?

No GitLab: **Settings → CI/CD → Runners** (expanda). Procure **Instance runners** (ou *Shared runners*).
| Situação | O que fazer |
|----------|-------------|
| Há runners disponíveis e ativados para o projeto | 🎉 Siga a missão inteira |
| Não há runners, ou estão desativados | Faça a missão mesmo assim: o pipeline vai ficar **pending/stuck**, e isso também ensina. Verifique se existe um runner que você possa usar (no gitlab.com há runners compartilhados gratuitos, com limite mensal). O `revisor.sh` continua sendo o seu revisor |

---

## 🛠️ Passo a passo

**1.** Atualize a `main` e crie **`chore/pipeline`**. Crie o **`.gitlab-ci.yml`**:
```yaml
stages:
  - verificacao

testes:
  stage: verificacao
  image: eclipse-temurin:25-jdk-alpine
  script:
    - java src/Testes.java

arquivos-proibidos:
  stage: verificacao
  image: alpine:3.22
  script:
    - if [ -e .env ] || [ -d out ] || ls token*.txt >/dev/null 2>&1; then echo "Arquivo proibido no repositório!"; exit 1; fi
    - echo "Nenhum arquivo proibido."
```
**2.** Commit, push, abra o MR.

**3.** No GitLab, vá em **Build → Pipelines** (ou *CI/CD → Pipelines*): há um pipeline para a sua branch. Clique nele e
depois em cada **job** para ver o log, que é a saída dos comandos dentro do container. Na página do MR, o status do
pipeline também aparece.

**4. Prove que o robô pega erros.** Na mesma branch, quebre um teste de propósito: em `src/Testes.java`, troque
`nova.getSaldo() == 0` por `nova.getSaldo() == 1`. Commit, push. O job `testes` fica ❌. Abra o log e ache o `✘`.
Depois **desfaça** com `git revert --no-edit HEAD` e push: ✅ de novo.

**5. Torne o pipeline obrigatório** (só se os runners funcionaram): **Settings → Merge requests →** marque
**Pipelines must succeed** (em *Merge checks*). Salve. Agora o GitLab **bloqueia o Merge** se o pipeline falhar.

**6.** Revisor → Merge → deploy → limpar. A partir de agora, cada push mostra o resultado do pipeline no MR.

<details><summary>👀 Comandos</summary>

```bash
$ git switch main && git pull
$ git switch -c chore/pipeline
# crie o .gitlab-ci.yml
$ git add .gitlab-ci.yml
$ git commit -m "Adiciona pipeline de CI com testes e checagem de arquivos"
$ git push -u origin chore/pipeline
# abra o MR, acompanhe em Build → Pipelines
# quebre o teste
$ git commit -am "Quebra um teste de propósito para testar o CI"
$ git push                                  # pipeline ❌
$ git revert --no-edit HEAD
$ git push                                  # pipeline ✅
$ ../../revisor.sh chore/pipeline
# Merge → ../../deploy.sh
$ git switch main && git pull
$ git branch -d chore/pipeline && git fetch --prune
```
</details>

| Status do pipeline | Significa |
|--------------------|-----------|
| 🔵 **running** | Rodando |
| ✅ **passed** | Tudo certo |
| ❌ **failed** | Algum job falhou: clique e leia o log |
| ⏸️ **pending / stuck** | Nenhum runner pegou o job (falta runner) |

> 🔭 **Para depois:** o pipeline também pode **construir a imagem Docker** e **fazer o deploy**, substituindo o seu
> `revisor.sh` e o `deploy.sh`. Isso é tema do módulo de CI/CD nas próximas aulas.

---

## ✅ Pronto quando
- [ ] Você viu um pipeline ❌ por um teste quebrado e ✅ depois do revert (ou entendeu por que ficou *pending*).

➡️ [Missão 14](14-pix.md)
