# Missão 12 — Detetive: quem mudou isso? 🟠

## 🎫 Ticket
> **De:** Auditoria: precisamos de respostas sobre o histórico. Use o Git **e** o GitLab. 🕵️

Sem MR nesta missão. Use a sua `main` atualizada (`git switch main && git pull`).

---

## 📖 Novo: ferramentas de detetive

**No terminal:**
| Comando | Pergunta que responde |
|---------|-----------------------|
| `git log --oneline -- Dockerfile` | Quais commits mexeram **neste arquivo**? |
| `git log --format='%h %an %ad %s' --date=short` | O log com **autor e data** |
| `git log --author=Carla --oneline` | O que **essa pessoa** fez? |
| `git log -S "texto" --oneline` | Quais commits **adicionaram ou removeram** esse texto? |
| `git blame compose.yaml` | **Quem escreveu cada linha**, e em qual commit |
| `git shortlog -sn HEAD` | **Quantos commits** cada pessoa fez |
| `git log --reverse --oneline` | Do **mais antigo** para o mais novo |

**No GitLab:** abra um arquivo (ex.: `compose.yaml`) e use os botões no topo:
| Botão | Mostra |
|-------|--------|
| **Blame** | Quem escreveu cada linha (igual ao `git blame`, só que clicável) |
| **History** | Os commits que mexeram nesse arquivo (igual ao `git log -- arquivo`) |

Também vale explorar **Code → Compare** (ou *Repository → Compare*): escolha duas versões (ex.: dois commits) e veja
tudo que mudou entre elas.

---

## 🕵️ As perguntas (responda pelo terminal **e** confira no GitLab)

1. Quantos commits mexeram no `Dockerfile`? Quem criou ele?
2. Quem escreveu a linha `BANCO_NOME` atual do `compose.yaml`?
3. Em quais commits o texto `claude/java` apareceu ou sumiu?
4. Em quais commits o texto `segredo123` apareceu ou sumiu?
5. Quantos commits a Carla fez? E você?
6. Quem fez mais commits no projeto?
7. Qual foi o **primeiro** commit, e quem fez?
8. No GitLab, compare a versão do primeiro commit com a `main` de hoje: quantos arquivos mudaram?

<details><summary>👀 Respostas (comandos)</summary>

1. `git log --oneline --format='%h %an: %s' -- Dockerfile` → 3: Bruno (criou), Carla, e o Revert.
2. `git blame compose.yaml` (ou **Blame** no GitLab) → você, no merge da missão 08.
3. `git log -S "claude/java" --oneline` → o da Carla e o Revert.
4. `git log -S "segredo123" --oneline` → o do Bruno (criou o compose) e o seu (missão 11).
5. `git log --author=Carla --oneline` · `git log --author="Seu Nome" --oneline`
6. `git shortlog -sn HEAD`
7. `git log --reverse --format='%h %an: %s' | head -1` → Ana Souza.
   (`| head -1` manda a saída para o comando `head`, que mostra só a primeira linha.)
8. **Code → Compare**: origem = o código do primeiro commit, destino = `main`.
</details>

---

## ✅ Pronto quando
- [ ] Você respondeu as 8 perguntas e usou **Blame**, **History** e **Compare** no GitLab.

➡️ [Missão 13](13-pipeline.md)
