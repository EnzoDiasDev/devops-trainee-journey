# DevOps Trainee Journey

Registro do que eu aprendo na minha jornada em DevOps: tanto os estudos que eu planejo quanto o que surge pelo caminho.
Aprendendo na prática: anotações nas minhas palavras, labs, scripts e exercícios, organizados **por tema**.

Cada tema tem um README com o índice e a ordem de leitura sugerida. Se você está começando, boas portas de entrada são
[Linux](temas/linux), [Git](temas/git) e [API](temas/api).

## Temas

| Tema | O que tem | Status | Onde |
| --- | --- | --- | --- |
| Linux | Cadernos e labs de linha de comando: arquivos, logs, permissões, processos | 🟡 Em andamento | [temas/linux](temas/linux) |
| Git/GitHub | Notas sobre histórico, branches e merge; labs de Git e de fluxo em equipe | 🟡 Em andamento | [temas/git](temas/git) |
| Incidentes | Status page, gerenciamento de incidentes, OneUptime e SSO | 🟢 Concluído | [temas/incidentes](temas/incidentes) |
| API | Conceitos, REST, autenticação, paginação e webhooks | 🟡 Em andamento | [temas/api](temas/api) |
| Docker | Lab em 5 níveis: contêineres, imagens, volumes, redes e Compose | 🟡 Em andamento (4 dos 5 níveis feitos) | [temas/docker](temas/docker) |
| AWS | Lab por serviço no Free Tier, começando por EC2 | 🟡 Em andamento | [temas/aws](temas/aws) |
| Kubernetes | Fundamentos | ⚪ A fazer | [temas/kubernetes](temas/kubernetes) |

Legenda: 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer

O que vem a seguir (sem datas fixas) está no [ROADMAP.md](ROADMAP.md).

## Estrutura

```
.
├── README.md        # você está aqui
├── ROADMAP.md       # backlog de estudos: em andamento / próximos / concluído
├── inbox/           # notas novas que ainda não têm tema definido
├── _templates/      # modelos de nota e de lab
└── temas/
    └── <tema>/
        ├── README.md   # status, índice e ordem de leitura do tema
        ├── *.md        # notas: o que aprendi, nas minhas palavras
        └── labs/       # exercícios práticos, ambientes de lab e scripts
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
