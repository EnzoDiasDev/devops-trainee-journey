# Claude Code: comandos essenciais

> **Tema:** Ferramentas
> **Origem:** inesperado (surgiu no dia a dia, fora do roadmap)
> **Iniciado em:** 2026-10-05
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->
> **Nível:** iniciante.

## Em resumo

O **Claude Code** é um assistente de programação da Anthropic que roda **no terminal**: você conversa com ele em linguagem natural e ele lê arquivos, roda comandos e edita código no seu projeto. Esta nota reúne os comandos de barra (`/...`) que mais uso para gerenciar as conversas.

## Como abrir

```bash
cd meu-projeto     # entre na pasta do projeto
claude             # abre o Claude Code nessa pasta
```

## Comandos de barra

Dentro da conversa, comandos que começam com `/` controlam o próprio Claude Code (não são mensagens para o modelo):

| Comando | O que faz |
|---|---|
| `/resume` | Abre a lista de conversas anteriores para você escolher uma e continuar nela |
| `/clear` | Limpa o contexto e começa uma conversa nova. A conversa anterior continua salva e dá para voltar a ela com `/resume` |
| `/model` | Mostra os modelos disponíveis para a sua conta e permite trocar de modelo ali mesmo |
| `/help` | Lista todos os comandos disponíveis |

Também dá para escolher o modelo já ao abrir, direto no terminal:

```bash
claude --model <nome-do-modelo>
```

## Para completar depois

- [ ] Anotar os demais comandos que eu for usando (compactar contexto, permissões, memória do projeto).

## Referências

- [Documentação oficial do Claude Code](https://docs.claude.com/en/docs/claude-code/overview)
