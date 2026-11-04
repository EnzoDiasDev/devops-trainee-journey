# Missão 15 — Três tickets, zero ajuda 🔴

Crie as três **Issues** no GitLab e resolva cada uma numa branch própria, com MR (`Closes #N`), revisão, Merge e deploy.
Você escolhe nomes de branch e mensagens. **Sem respostas escondidas.** 💪

---

### 🎫 Issue A: Documentação
> No `README.md`, acrescente uma seção **"Como contribuir"** explicando, com as suas palavras, o fluxo da equipe: Issue →
> branch → commits → push → MR → revisão → Merge → deploy.

### 🎫 Issue B: Contador de operações
Em `src/Conta.java`, logo depois do método `getExtrato`:
```java

    public int getQuantidadeOperacoes() {
        return extrato.size();
    }
```
Em `src/Testes.java`, antes de `// FIM DOS TESTES`:
```java
        // quantidade de operações
        Conta q1 = new Conta("Teste");
        q1.depositar(10);
        q1.depositar(20);
        verificar("conta as operações do extrato", q1.getQuantidadeOperacoes() == 2);
```

### 🎫 Issue C: Porta de desenvolvimento (Docker)
> A porta 8070 conflita com outra ferramenta. Mude a porta **de desenvolvimento** padrão para **8075**. A produção
> (8090) não pode mudar.

Dica: no `compose.yaml` está `${PORTA:-8070}`. O `:-8070` é o **valor padrão**, usado quando não existe `PORTA` no `.env`.
A produção define `PORTA=8090` no `.env` dela.

---

## 🌶️ Modo difícil
Abra os três MRs **ao mesmo tempo** (três branches a partir da mesma `main`) e só depois junte, um atrás do outro.
Repare na lista de MRs e no **Repository graph**.

## ✅ Pronto quando
- [ ] Três Issues fechadas por três MRs.
- [ ] `git branch` mostra só a `main` e o `git status` está limpo.
- [ ] Seu ambiente responde em http://localhost:8075, e a produção continua em http://localhost:8090.
- [ ] Você fez tudo sem consultar nada. 🎉

➡️ [Missão 16](16-treino-infinito.md)
