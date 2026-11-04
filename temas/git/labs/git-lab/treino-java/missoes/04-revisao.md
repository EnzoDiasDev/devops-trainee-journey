# Missão 04 — Depósito negativo + revisão no GitLab 🟢

## 🎫 Ticket (crie como Issue no GitLab!)
> **Título:** Depósito com valor negativo é aceito
> **Descrição:** Em produção dá para depositar R$ -10, o que tira dinheiro da conta. Fazer em dois commits: teste e correção.

## 🎯 Você vai treinar
**Git:** dois commits, `diff` × `diff --staged` · **GitLab:** revisar o próprio MR, **comentar linhas** e resolver discussões

---

## 🛠️ Parte 1: os dois commits

**1.** Crie a Issue acima no GitLab. Atualize a `main` e crie a branch **`feature/deposito-invalido`**.

**2.** Cole o teste antes de `// FIM DOS TESTES`:
```java
        // depósito inválido
        Conta c4 = new Conta("Teste");
        deveDarErro("não aceita depósito zero ou negativo", () -> c4.depositar(-10));
```
Rode os testes no container: **um falha** (esperado). Prepare **só** o `Testes.java`, confira o que vai entrar e faça o
**1º commit**.

**3.** Em `Conta.java`, troque o `depositar` por:
```java
    public void depositar(double valor) {
        if (valor <= 0) {
            throw new IllegalArgumentException("Valor de depósito inválido");
        }
        saldo += valor;
        extrato.add("Depósito: " + formatar(valor));
    }
```
Teste (agora passa), veja a mudança **antes** de preparar e faça o **2º commit**. Envie e abra o MR com `Closes #N`.

<details><summary>👀 Comandos da parte 1</summary>

```bash
$ git switch main && git pull
$ git switch -c feature/deposito-invalido
# cole o teste
$ docker compose run --rm --build api java src/Testes.java      # 1 falha
$ git add src/Testes.java
$ git diff --staged
$ git commit -m "Testa depósito com valor inválido"
# cole a correção
$ docker compose run --rm --build api java src/Testes.java      # tudo passa
$ git diff
$ git add src/Conta.java
$ git commit -m "Recusa depósito com valor zero ou negativo"
$ git push -u origin feature/deposito-invalido
```
</details>

---

## 🛠️ Parte 2: revisando no GitLab

Na vida real, outra pessoa revisa o seu MR na aba **Changes**. Treine fazendo o papel do revisor:

**4.** Abra a aba **Commits** do MR: estão os dois commits, na ordem certa?

**5.** Abra a aba **Changes**. Passe o mouse sobre a linha `if (valor <= 0) {` e clique no **balão de comentário**
que aparece ao lado do número da linha. Escreva:
> E se o valor for maior que, sei lá, R$ 1 milhão? Vale um limite?

e clique em **Start a review** (ou *Add comment now*). Se usou *Start a review*, termine com **Submit review**.

**6.** Na aba **Overview**, o comentário virou uma **discussão (thread)**. Responda:
> Boa ideia! Vou abrir uma Issue separada para isso, para não misturar com este MR.

e clique em **Resolve thread**. 

> 💡 Em muitos times o MR só pode ser juntado com **todas as threads resolvidas**. É assim que a revisão vira ação.

**7.** Revisor → Merge → deploy → atualizar e limpar. Confira em produção:
http://localhost:8090/depositar?conta=ze&valor=-10

---

## ✅ Pronto quando
- [ ] MR juntado com **2 commits**, a Issue fechada e a thread resolvida.
- [ ] Você sabe a diferença entre o que o `git diff` e o `git diff --staged` mostraram.

➡️ [Missão 05](05-mensagem-ruim.md)
