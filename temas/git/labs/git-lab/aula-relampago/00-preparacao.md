# Bloco 00 — O que é Git + configurar

## 🎯 Neste bloco
- A ideia do Git em 2 minutos.
- Configurar o Git **uma vez** no seu computador.

---

## 📖 Aprenda: o que é Git

O Git é um **sistema de controle de versões**: ele guarda **fotografias** do seu projeto ao longo do tempo.

```
  foto 1              foto 2                    foto 3
 "Cria o site"  ──►  "Adiciona página"  ──►  "Corrige o título"
   (segunda)           (terça)                 (hoje)
```
Cada fotografia se chama **commit**. Com os commits você consegue:
- ver **o que mudou**, **quando** e **quem** mudou;
- **voltar** para uma versão antiga se algo der errado;
- trabalhar em várias coisas ao mesmo tempo sem misturar (**branches**);
- **juntar** o trabalho de várias pessoas (via **GitLab**, GitHub...).

| Termo | O que é |
|-------|---------|
| **Repositório** (repo) | Uma pasta cujo histórico o Git está guardando |
| **Commit** | Uma fotografia do projeto, com uma mensagem explicando o que mudou |
| **Branch** | Uma "linha do tempo" paralela (bloco 04) |
| **Remoto** | Uma cópia do repositório num servidor, como o GitLab (bloco 06) |

> **Git × GitLab:** o **Git** é o programa que roda no seu computador. O **GitLab** (ou GitHub) é um **site**
> que guarda repositórios Git na internet ou na rede corporativa, para a equipe compartilhar.

---

## 📖 Aprenda: configurar (uma vez só)

Confira a versão:
```bash
$ git --version
```

Agora rode estes comandos. **Troque pelo seu nome e e-mail**: eles aparecem em cada commit que você fizer.
Use o **mesmo e-mail** do seu GitLab.
```bash
$ git config --global user.name "Seu Nome"
$ git config --global user.email "seu.email@empresa.com.br"
```

Mais quatro configurações que deixam a vida mais fácil (explicadas abaixo):
```bash
$ git config --global init.defaultBranch main
$ git config --global core.editor "code --wait"
$ git config --global pull.rebase false
$ git config --global color.ui auto
```
| Configuração | Para quê |
|--------------|----------|
| `user.name` / `user.email` | Quem é o autor dos commits |
| `init.defaultBranch main` | A branch principal se chamar `main` (o padrão atual) |
| `core.editor "code --wait"` | Quando o Git precisar que você escreva uma mensagem, ele **abre o VS Code**. Você escreve, **salva e fecha a aba**, e o Git continua |
| `pull.rebase false` | Define como o `git pull` junta mudanças (bloco 06). Sem isso, ele pode dar um erro confuso |
| `color.ui auto` | Saídas coloridas no terminal |

> O `--global` significa "para todos os repositórios deste computador". Por isso é só uma vez.

Confira tudo:
```bash
$ git config --global --list
```

---

## 📖 Aprenda: duas coisas do terminal

| Situação | O que fazer |
|----------|-------------|
| O Git mostrou uma tela que não volta para o terminal (aparece `:` ou `(END)` embaixo) | Aperte **`q`** para sair. É o "visualizador" de textos longos (`git log`, `git diff`...) |
| Use as setas `↑` `↓` ou a barra de espaço | Para rolar nessa tela |

---

## ✍️ Pratique

1. Rode as 6 configurações acima com os **seus** dados.
2. Liste a configuração e confira o seu nome e e-mail.
3. Responda: o Git e o GitLab são a mesma coisa?

<details><summary>👀 Ver respostas</summary>

1. Os 6 `git config --global ...` deste bloco.
2. `git config --global --list` → procure `user.name=` e `user.email=`.
3. Não. O Git é o programa no seu computador; o GitLab é um site/servidor que guarda repositórios Git para a equipe.
</details>

---

## 🧠 Memorize

1. O que é um commit?
2. O que é um repositório?
3. O que significa o `--global` no `git config`?
4. Por que configurar `user.email`?
5. Como sair de uma tela do Git que mostra `(END)`?

<details><summary>👀 Ver respostas</summary>

1. Uma fotografia do projeto num momento, com uma mensagem.
2. Uma pasta cujo histórico o Git guarda.
3. Vale para todos os repositórios do computador.
4. Para identificar o autor de cada commit.
5. Apertando `q`.
</details>

➡️ Próximo: [Bloco 01 — Salvar versões](01-primeiro-repositorio.md)
