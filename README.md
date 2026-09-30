# DevOps Trainee Journey

Registro do que eu aprendo na minha jornada em DevOps — tanto os estudos que eu planejo quanto o que surge no dia a dia da vaga.
Aprendendo na prática: anotações nas minhas palavras, labs, scripts e exercícios, organizados **por tema**.

> ⚠️ Este repositório é público. Aqui ficam apenas conceitos e práticas gerais.
> Nada de informações internas da empresa (sistemas, arquitetura, incidentes reais, clientes, credenciais).

## Temas

| Tema | Status | Onde |
| --- | --- | --- |
| Linux | 🟡 Em andamento | [temas/linux](temas/linux) |
| Git/GitHub | 🟡 Em andamento | [temas/git](temas/git) |
| Incidentes (Status Page, gestão de incidentes, OneUptime) | 🟡 Em andamento | [temas/incidentes](temas/incidentes) |
| Docker | ⚪ A fazer | [temas/docker](temas/docker) |
| Kubernetes | ⚪ A fazer | [temas/kubernetes](temas/kubernetes) |
| AWS | ⚪ A fazer | [temas/aws](temas/aws) |

Legenda: 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer

O que vem a seguir (sem datas fixas) está no [ROADMAP.md](ROADMAP.md).

## Estrutura

```
.
├── README.md        # você está aqui
├── ROADMAP.md       # backlog de estudos: em andamento / próximos / concluído
├── inbox/           # conteúdo novo que ainda não tem tema definido
├── _templates/      # modelos de nota e de lab
└── temas/
    └── <tema>/
        ├── README.md   # status, índice e recursos do tema
        ├── notas/      # anotações por assunto
        ├── labs/       # exercícios práticos e ambientes de lab
        └── scripts/    # scripts avulsos
```

## Como eu uso este repositório

1. **Conteúdo novo e planejado** → entra no `ROADMAP.md` e ganha uma pasta em `temas/`.
2. **Conteúdo inesperado** → vai primeiro para `inbox/`. Quando ficar claro onde encaixa, é movido (`git mv`) para o tema certo ou vira um tema novo.
3. **Anotações** seguem o modelo [`_templates/nota.md`](_templates/nota.md).
4. **Labs e exercícios** seguem o modelo [`_templates/lab.md`](_templates/lab.md).
5. **Datas** não definem a estrutura: ficam no cabeçalho de cada nota e no histórico do Git (`git log`).

## Convenção de commits

Uso [Conventional Commits](https://www.conventionalcommits.org/pt-br/), com o tema como escopo:

```
docs(linux): adiciona anotações sobre processos e sinais
feat(docker): adiciona Dockerfile do projeto de logística
fix(git): corrige exemplo de rebase nas notas
refactor: reorganiza repositório por tema
chore: atualiza roadmap
```

## Histórico

A primeira versão deste repositório era organizada por dia de estudo (`01-linux/dia-01/...`).
Esse estado está preservado na tag [`v0-estrutura-por-dia`](../../tree/v0-estrutura-por-dia).

## Recursos gerais

- [Learn Git Branching](https://learngitbranching.js.org/): Git
- [GitHub Skills](https://skills.github.com/): GitHub
- [OneUptime (repositório oficial)](https://github.com/OneUptime/oneuptime): observabilidade, status page e incidentes
