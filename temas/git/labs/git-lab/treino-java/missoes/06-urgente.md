# Missão 06 — 🚨 Urgente no meio de outra tarefa 🟡

## 🎫 Ticket 1 (o que você estava fazendo)
> **De:** Ana: Numere as linhas do extrato (1., 2., 3....).

## 🎫 Ticket 2 (chega no meio do caminho)
> **De:** Bruno — 🚨 **URGENTE:** a transferência em produção está **sem a taxa de R$ 1,00**! Larga tudo e corrige agora.

## 🎯 Você vai treinar
**Git:** `stash` / `stash pop`, hotfix · **GitLab:** dois MRs abertos ao mesmo tempo

---

## 🛠️ Passo a passo

**Parte 1: a tarefa normal (não termine!)**

**1.** Atualize a `main`, crie **`feature/extrato-numerado`** e, no método `extrato` do `src/App.java`, troque o `for` por:
```java
        int numero = 1;
        for (String linha : conta.getExtrato()) {
            texto.append("  ").append(numero).append(". ").append(linha).append("\n");
            numero++;
        }
```
Faça o commit e **envie** a branch, e abra o MR com o título começando por **`Draft:`**
(ex.: `Draft: Numera as linhas do extrato`).

> 📖 **Novo:** um MR com `Draft:` no título fica marcado como **rascunho**: o GitLab **bloqueia o Merge** até você tirar
> o `Draft:` (botão **Mark as ready**). Serve para mostrar o trabalho em andamento sem risco de alguém juntar antes da hora.

**2.** Continue: em `src/App.java`, no método `inicio()`, troque `"Experimente no navegador:\n"` por
`"Experimente no navegador (rotas da API):\n"`. Salve e **não faça commit**: chegou o urgente! 🚨

**Parte 2: o hotfix**

**3.** Guarde a mudança inacabada na "gaveta" e confira que a pasta ficou limpa.

**4.** Volte para a `main`, atualize, e crie **`fix/taxa-transferencia`**. Em `src/Conta.java`, troque
`double taxa = 0.0;` por `double taxa = 1.0;` e cole o teste:
```java
        // taxa da transferência
        Conta o2 = new Conta("Origem");
        Conta d2 = new Conta("Destino");
        o2.depositar(200);
        o2.transferir(d2, 100);
        verificar("transferência cobra taxa de R$ 1,00", o2.getSaldo() == 99);
```
**5.** Teste, commit, push, MR. Abra a lista **Merge requests** do projeto: há **dois MRs abertos** (o Draft e o hotfix).
Revisor → Merge **só do hotfix** → deploy → atualizar e limpar. Confira em produção:
- http://localhost:8090/depositar?conta=lia&valor=200
- http://localhost:8090/transferir?de=lia&para=ze&valor=100 → saldo da Lia **R$ 99,00** ✅

**Parte 3: de volta à tarefa**

**6.** Volte para `feature/extrato-numerado`, **tire a mudança da gaveta**, faça o commit e envie. O MR Draft ganhou o commit novo.

**7.** No MR, clique em **Mark as ready** (some o `Draft:`). Revisor → Merge → deploy → limpar. Veja o extrato numerado em
http://localhost:8090/extrato?conta=lia

<details><summary>👀 Comandos</summary>

```bash
$ git switch main && git pull
$ git switch -c feature/extrato-numerado
# edite o extrato
$ git commit -am "Numera as linhas do extrato"
$ git push -u origin feature/extrato-numerado
# MR com "Draft:" no título
# edite o inicio() (sem commit)
$ git stash
$ git status

$ git switch main && git pull
$ git switch -c fix/taxa-transferencia
# edite Conta.java e Testes.java
$ docker compose run --rm --build api java src/Testes.java
$ git commit -am "Cobra taxa de R\$ 1,00 na transferência"
$ git push -u origin fix/taxa-transferencia
# MR → ../../revisor.sh fix/taxa-transferencia → Merge → ../../deploy.sh
$ git switch main && git pull
$ git branch -d fix/taxa-transferencia && git fetch --prune

$ git switch feature/extrato-numerado
$ git stash pop
$ git commit -am "Detalha o título da lista de rotas"
$ git push
# Mark as ready → ../../revisor.sh feature/extrato-numerado → Merge → ../../deploy.sh
$ git switch main && git pull
$ git branch -d feature/extrato-numerado && git fetch --prune
```
> 📖 Dentro de aspas duplas, `$` é especial no terminal: para escrever "R$" use `R\$` (ou aspas simples).
</details>

---

## ✅ Pronto quando
- [ ] Os dois MRs foram juntados e `git stash list` está vazio.
- [ ] Em produção, a transferência cobra a taxa e o extrato está numerado.

➡️ [Missão 07](07-dois-na-branch.md)
