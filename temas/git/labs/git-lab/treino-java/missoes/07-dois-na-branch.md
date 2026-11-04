# Missão 07 — O tech lead mexeu na sua branch 🟡

## 🎫 Ticket
> **De:** Bruno: Limite de **R$ 1000 por saque**, e documenta no README. Abre o MR que eu dou uma olhada.

## 🎯 Você vai treinar
**Git:** push **rejeitado** porque outra pessoa enviou commits na mesma branch · **GitLab:** commits de outra pessoa no seu MR

---

## 🛠️ Passo a passo

**1.** Atualize a `main` e crie **`feature/limite-saque`**. Em `src/Conta.java`, logo **depois** da linha
`public void sacar(double valor) {`, acrescente:
```java
        if (valor > 1000) {
            throw new IllegalArgumentException("Limite por saque é R$ 1000");
        }
```
E o teste, antes de `// FIM DOS TESTES`:
```java
        // limite de saque
        Conta c5 = new Conta("Teste");
        c5.depositar(5000);
        deveDarErro("não deixa sacar mais de R$ 1000 de uma vez", () -> c5.sacar(1500));
```
**2.** Teste, commit, push e abra o MR.

**3.** O Bruno vai mexer na sua branch:
```bash
$ ../../colega.sh 07
```
Atualize a página do MR, aba **Commits**: há um commit **do Bruno** ali!

**4.** Sem dar `pull`, acrescente no final do `README.md`:
```markdown

## Limites
- Saque: no máximo R$ 1000 por operação.
```
Faça o commit e tente `git push`. **O que aconteceu?**

**5.** Resolva: traga o commit do Bruno (o VS Code abre a mensagem de merge: **salve e feche a aba**), envie, e veja no
MR os commits dos dois.

**6.** Teste (há um teste a mais, do Bruno). Revisor → Merge → deploy → limpar. Produção:
http://localhost:8090/sacar?conta=lia&valor=1500

<details><summary>👀 Comandos</summary>

```bash
$ git switch main && git pull
$ git switch -c feature/limite-saque
# edite Conta.java e Testes.java
$ docker compose run --rm --build api java src/Testes.java
$ git commit -am "Limita o saque a R\$ 1000 por operação"
$ git push -u origin feature/limite-saque
# abra o MR
$ ../../colega.sh 07
# edite o README.md
$ git commit -am "Documenta o limite de saque no README"
$ git push                                   # rejected (fetch first)
$ git pull                                   # salve e feche a aba
$ git push
$ docker compose run --rm --build api java src/Testes.java
$ ../../revisor.sh feature/limite-saque
# Merge → ../../deploy.sh
$ git switch main && git pull
$ git branch -d feature/limite-saque && git fetch --prune
```
</details>

---

## 🧠 Reflexão
Por que **não** usar `--force-with-lease` aqui?
<details><summary>👀 Resposta</summary>
Porque apagaria o commit do Bruno. Force é para substituir o <b>seu próprio</b> trabalho reescrito (missão 05). Quando
outra pessoa contribuiu, o certo é <code>git pull</code> e juntar.
</details>

➡️ [Missão 08](08-conflito.md)
