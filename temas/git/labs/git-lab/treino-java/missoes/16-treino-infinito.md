# Missão 16 — Treino infinito 🏆

Fluência vem de **repetição**. Refaça o treino do zero, cada vez mais rápido.

## Como recomeçar
1. No GitLab, crie um **projeto novo e vazio** (sem README), por exemplo `enzo-bank-rodada-2`.
2. Rode:
   ```bash
   $ cd ~/Projects/git-lab/treino-java
   $ ./recomecar.sh ssh://git@gitlab.example.com:2222/seu.usuario/enzo-bank-rodada-2.git
   ```
   Ele limpa tudo **no seu computador** (clones, containers, volumes e imagens do Enzo Bank) e prepara de novo.
3. Recomece pela missão 01.

> O projeto antigo continua no GitLab. Para apagar: **Settings → General → Advanced → Delete project**. Confira o nome
> duas vezes: apagar projeto não tem volta.

## 🎯 Metas por rodada
| Rodada | Meta (missões 02 a 11) |
|--------|------------------------|
| 1ª | Até **2h30**, consultando os blocos 👀 |
| 2ª | Até **1h30**, consultando só as colas |
| 3ª | Até **1h**, sem consultar nada |

## 🎲 Variações
- Outros nomes de branch e mensagens; Issues com descrições suas.
- Na missão 08, resolva o conflito pelo botão **Resolve conflicts** do GitLab, para comparar com o terminal.
- Na missão 09, faça o revert **pelo terminal** em vez do botão.
- Peça para um colega de verdade revisar um MR seu: adicione-o ao projeto (**Manage → Members**) como *Reporter* ou *Developer*.

## 🔌 Fim do dia
```bash
$ ./desligar.sh     # desliga produção e dev, sem apagar dados
$ ./deploy.sh       # religa a produção
```

## ✅ Você está fluente quando...
- [ ] Faz Issue → branch → commit → push → MR → Merge → limpeza **sem pensar**.
- [ ] Lê erros do Git, do Docker e do GitLab e sabe o que fazer (`rejected`, `CONFLICT`, `pull access denied`,
  `not allowed to push code to protected branches`...).
- [ ] Desfaz qualquer coisa sem pânico (`restore`, `--amend`, `revert`).

Quando chegar lá, avise o Claude: **"bora para o próximo módulo de git"**. 🚀
