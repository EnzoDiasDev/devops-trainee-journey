# Missão 14 — Funcionalidade nova: Pix 🔴

## 🎫 Ticket (crie como Issue)
> **Título:** Pix na API
> **Descrição:** Transferência **sem taxa**, até **R$ 2000**, pela rota `/pix?de=ana&para=bruno&valor=50`. Extrato:
> `Pix enviado: R$ ...` / `Pix recebido: R$ ...`.

**A partir daqui, não há comandos no roteiro.** Use as colas ([Git](../../aula-relampago/COLA.md) ·
[Compose](../../../../../docker/labs/docker-lab/nivel-5/COLA.md)) só se travar.

---

## 📖 Novo: abrir o MR direto pelo `git push`

O GitLab aceita **opções de push** (`-o`) que criam o MR sem abrir o navegador:
```bash
$ git push -u origin feature/pix \
    -o merge_request.create \
    -o merge_request.target=main \
    -o merge_request.title="Adiciona Pix na API" \
    -o merge_request.description="Closes #N" \
    -o merge_request.remove_source_branch
```
| Opção | Faz |
|-------|-----|
| `merge_request.create` | Cria o MR |
| `merge_request.target=main` | Destino: `main` |
| `merge_request.title="..."` | Título |
| `merge_request.description="..."` | Descrição (ponha o `Closes #N`!) |
| `merge_request.remove_source_branch` | Marca "Delete source branch" |

(A `\` só quebra o comando em várias linhas.) A resposta do push traz o link do MR criado.

---

## 📋 O que fazer

Numa branch `feature/pix`, em **3 commits**, e abrindo o MR **pelo `git push -o`**:

**Commit 1: os testes** (antes de `// FIM DOS TESTES`):
```java
        // pix
        Conta p1 = new Conta("Pix 1");
        Conta p2 = new Conta("Pix 2");
        p1.depositar(500);
        p1.pix(p2, 200);
        verificar("pix não cobra taxa", p1.getSaldo() == 300);
        verificar("pix credita o destino", p2.getSaldo() == 200);
        verificar("pix aparece no extrato de quem recebe", p2.getExtrato().get(0).startsWith("Pix recebido"));

        // limite do pix
        Conta p3 = new Conta("Pix 3");
        p3.depositar(5000);
        deveDarErro("pix acima de R$ 2000 é recusado", () -> p3.pix(p2, 2500));
```
**Commit 2: a regra** (em `src/Conta.java`, logo **antes** do comentário `/** Usado ao carregar...`):
```java
    public void pix(Conta destino, double valor) {
        if (valor > 2000) {
            throw new IllegalArgumentException("Limite do Pix é R$ 2000");
        }
        if (valor > saldo) {
            throw new IllegalArgumentException("Saldo insuficiente");
        }
        saldo -= valor;
        extrato.add("Pix enviado: " + formatar(valor));
        destino.saldo += valor;
        destino.extrato.add("Pix recebido: " + formatar(valor));
    }

```
**Commit 3: a rota** (em `src/App.java`, logo **antes** da linha `rota(servidor, "/extrato", ...`):
```java
        rota(servidor, "/pix", p -> {
            Conta origem = banco.conta(p.get("de"));
            Conta destino = banco.conta(p.get("para"));
            origem.pix(destino, valor(p));
            return "Pix enviado! Saldo de " + origem.getTitular() + ": " + Conta.formatar(origem.getSaldo());
        });
```
Teste no seu ambiente, abra o MR pelo push, revisor (e pipeline, se você tiver), Merge, deploy, limpe e **use o Pix em produção**.

## ✅ Pronto quando
- [ ] MR com 3 commits juntado, Issue fechada, `/pix` funcionando em http://localhost:8090.
- [ ] Você **não abriu** nenhuma cola (ou no máximo uma vez). Anote no PROGRESSO.

➡️ [Missão 15](15-sem-roteiro.md)
