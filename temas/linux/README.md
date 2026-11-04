# Linux

> **Status:** 🟡 Em andamento

**O que é:** o sistema operacional da maioria dos servidores. Aqui estão as anotações e os exercícios práticos de linha de comando, feitos num "servidor" fictício de logística chamado **LogiTrack**.

## Conteúdo

Cada dia tem um **lab** (enunciados e script que monta o ambiente) e um **caderno** com as anotações do que aprendi.

| Dia | Tema | Caderno (leia) | Lab (pratique) |
|---|---|---|---|
| 1 | Arquivos, busca, texto, redirecionamento e permissões | [linux1.md](labs/logitrack-01/linux1.md) | [MISSOES-DIA1.md](labs/logitrack-01/MISSOES-DIA1.md) |
| 2 | Processos e sinais (em andamento) | [linux2.md](labs/logitrack-02/linux2.md) | [MISSOES-DIA2.md](labs/logitrack-02/MISSOES-DIA2.md) |

## Como praticar um lab

```bash
cd temas/linux/labs/logitrack-01
bash setup-dia1.sh              # cria o ambiente de treino em ~/lab-linux/logitrack
```

Depois siga o `MISSOES-DIA1.md`. Se estragar o ambiente, rode o script de novo para recriá-lo do zero. Use um **Linux de verdade** (ou WSL), de preferência numa máquina de estudo.

## Recursos

- `man comando`: o manual de qualquer comando (`/palavra` busca, `q` sai)
- [tldr](https://tldr.sh/): exemplos práticos de comandos
