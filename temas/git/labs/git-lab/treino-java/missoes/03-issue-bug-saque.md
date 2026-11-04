# Missão 03 — 🐛 Bug reportado numa Issue 🟢

## 🎯 Você vai treinar
**GitLab:** Issues, ligar MR e Issue com `Closes #N` · **Git:** branch `fix/` · **Docker:** testes no container

---

## 📖 Novo: Issues

Uma **Issue** é um **ticket** dentro do GitLab: bug, tarefa, ideia. Ela recebe um número (`#1`, `#2`...), pode ter
responsável, etiquetas e comentários. É onde o trabalho **começa**.

O truque: se a **descrição do MR** tiver `Closes #1`, quando o MR for juntado na `main` o GitLab **fecha a Issue #1
sozinho**. A Issue fica ligada ao código que a resolveu.

---

## 🛠️ Passo a passo

**1. Veja o bug em produção:** http://localhost:8090/sacar?conta=ze&valor=999 → o Zé, que não tem saldo, sacou! 😱

**2. Abra a Issue.** No GitLab: **Plan → Issues** (ou *Issues*) → **New issue**:
- **Title:** `Saque é permitido mesmo sem saldo`
- **Description:**
  > Em produção, `/sacar?conta=ze&valor=999` funciona para uma conta zerada e deixa o saldo negativo. O saque deveria ser recusado.
- Em **Assignee**, atribua a você mesmo (*Assign to me*). **Create issue**. Anote o número (provavelmente **#1**).

**3.** Atualize a `main` e crie a branch **`fix/saque-sem-saldo`**.

**4.** Em `src/Conta.java`, troque o método `sacar` inteiro por:
```java
    public void sacar(double valor) {
        if (valor > saldo) {
            throw new IllegalArgumentException("Saldo insuficiente");
        }
        saldo -= valor;
        extrato.add("Saque: " + formatar(valor));
    }
```
Em `src/Testes.java`, antes de `// FIM DOS TESTES`:
```java
        // saque sem saldo
        Conta c3 = new Conta("Teste");
        c3.depositar(50);
        deveDarErro("não deixa sacar mais que o saldo", () -> c3.sacar(80));
```
**5.** Teste no container (`docker compose run --rm --build api java src/Testes.java`), faça o commit e envie.

**6.** Abra o MR com a descrição:
> Recusa saque maior que o saldo, com teste.
>
> Closes #1

(Troque o `1` pelo número da sua Issue.)

**7.** Revisor → Merge → deploy → atualizar e limpar. Depois:
- abra a Issue: ela está **Closed**, com um aviso de que foi fechada pelo seu MR;
- abra de novo http://localhost:8090/sacar?conta=ze&valor=999 → **Saldo insuficiente**. ✅

<details><summary>👀 Comandos</summary>

```bash
$ git switch main && git pull
$ git switch -c fix/saque-sem-saldo
# edite os arquivos
$ docker compose run --rm --build api java src/Testes.java
$ git commit -am "Impede saque maior que o saldo"
$ git push -u origin fix/saque-sem-saldo
# abra o MR no GitLab com "Closes #1" na descrição
$ ../../revisor.sh fix/saque-sem-saldo
# clique em Merge no GitLab
$ ../../deploy.sh
$ git switch main && git pull
$ git branch -d fix/saque-sem-saldo && git fetch --prune
```
> 📖 O `&&` junta dois comandos numa linha: o segundo só roda se o primeiro der certo.
</details>

---

## ✅ Pronto quando
- [ ] A Issue fechou sozinha com o Merge.
- [ ] A produção recusa o saque sem saldo.

➡️ [Missão 04](04-revisao.md)
