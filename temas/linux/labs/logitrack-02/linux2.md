# Linux, dia 2: processos e sinais

> **Tema:** Linux
> **Origem:** próprio
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->
> **Nível:** iniciante. Recomendo ler antes o [dia 1](../logitrack-01/linux1.md) (navegação, `grep`, pipes e permissões).
> **Lab usado:** [LogiTrack, dia 2](MISSOES-DIA2.md), criado pelo script [`setup-dia2.sh`](setup-dia2.sh).
> **Missões:** M1 (processos e sinais, esta nota) · M2 (primeiro e segundo plano) · M3 (serviço com systemd) · M4 (logs do sistema) · M5 (agendamento com cron). Só a M1 está anotada até aqui.

## Em resumo

Todo programa rodando no Linux é um **processo**. Esta nota explica como **listar** processos (`ps`, `pgrep`, `pstree`, `htop`), como **enviar sinais** a eles (`kill`, `pkill`) e por que o `kill` não é só "matar". Termina com a investigação da missão M1.

## Conceitos

- **Processo:** um programa em execução. Cada um tem um **PID** (número), um **dono** (o usuário que o executa) e um **pai**, identificado pelo **PPID** (o processo que o criou).
- **Sinal:** uma mensagem enviada a um processo. O `kill` não "mata": **envia um sinal**. Por padrão, o **SIGTERM (15)**, que é um *pedido educado* para terminar. O processo pode tratar o pedido (por exemplo, salvar o trabalho antes de sair) ou até ignorá-lo.
- **SIGKILL (9):** não pode ser ignorado. O próprio kernel encerra o processo imediatamente, **sem chance de salvar nada**. É o último recurso.

> Regra prática: primeiro tente o pedido educado (`kill PID`, que envia o 15). Só use o `kill -9` se o processo não obedecer.

## Visão geral dos comandos

| Comando | Para que serve |
|---|---|
| `ps aux` | Lista os processos de **todos** os usuários, com foco em consumo de CPU e memória |
| `ps -ef` | Lista todos os processos em formato completo, com foco em hierarquia (PPID) e hora de início |
| `ps -o pid,ppid,user,%cpu,args -p PID` | Mostra só as colunas pedidas, para um processo específico |
| `pgrep -a padrão` | Acha o PID pelo nome ou padrão e mostra a linha de comando completa |
| `pstree -p` | Mostra os processos em **árvore** (quem é pai de quem), com os PIDs |
| `top` / `htop` | Monitor interativo, em tempo real (o `htop` é a versão mais amigável) |
| `kill` | Envia um sinal a um processo, pelo PID |
| `kill -l` | Lista todos os sinais disponíveis |
| `pkill` | Envia um sinal a processos escolhidos por **padrão** (nome etc.), sem precisar do PID |

**`ps aux` × `ps -ef`:** os dois listam tudo; muda o enfoque.

| | `ps aux` | `ps -ef` |
|---|---|---|
| Foco | CPU e memória | Hierarquia e horário de início |
| Colunas-chave | `%CPU`, `%MEM`, `VSZ`, `RSS`, `STAT` | `PPID`, `STIME`, `CMD` |
| Quando usar | "Quem está consumindo CPU ou RAM?" | "Quem gerou este processo?" |

Dissecando um comando de exemplo:

```bash
ps -o pid,ppid,user,%cpu,args -p 1234
#  │  │                          └─ qual processo (PID específico)
#  │  └─ colunas a exibir
#  └─ "process status"
```

> **Em uma frase:** `ps` é uma **foto** dos processos; `top` é **assistir ao vivo**; `htop` é **investigar e agir** (filtrar, ordenar, enviar sinais) sem sair da tela; `pgrep` é **achar um PID dentro de um script**.

---

## Referência de cada comando

### `ps` (*process status*)

Imprime um **retrato do momento** dos processos ativos: PID, dono, CPU, memória, comando, estado. Sintaxe: `ps [opções]`.

O `ps` aceita três estilos de opção, que podem ser misturados:

| Estilo | Formato | Exemplo |
|---|---|---|
| UNIX | `-` + letras agrupadas | `ps -ef` |
| BSD | letras sem `-` | `ps aux` |
| GNU (longo) | `--` + palavra | `ps --sort=-%mem` |

### `pgrep` (*process grep*)

É o `grep`, mas para **processos** em vez de linhas de texto. Devolve **um PID por linha**. Sintaxe: `pgrep [opções] PADRÃO`.

| Opção | Função |
|---|---|
| `-l` | Mostra o **nome** do processo junto com o PID |
| `-a` | Mostra a **linha de comando completa** junto com o PID |
| `-f` | Procura na linha de comando **inteira**, e não só no nome |
| `-x` | Casamento **exato** (sem aceitar parte do nome) |
| `-i` | Ignora maiúsculas/minúsculas |
| `-c` | **Conta** quantos casaram |
| `-n` / `-o` | Só o processo **mais novo** / o **mais antigo** |
| `-u USUÁRIO` | Só os processos desse **usuário** |
| `-P PPID` | Só os **filhos** de um processo |
| `-v` | **Inverte**: os que **não** casam |

### `pstree`

Mostra os processos como uma **árvore** (hierarquia), em vez de tabela. Sem argumentos, a árvore parte do PID 1 (`systemd`/`init`, o primeiro processo do sistema). Sintaxe: `pstree [opções] [PID | USUÁRIO]`.

| Opção | Função |
|---|---|
| `-p` | Mostra os **PIDs** ao lado de cada processo |
| `-a` | Mostra os **argumentos** da linha de comando |
| `-s` | Mostra os **ancestrais** (pais) do processo indicado |
| `-u` | Marca onde o **usuário muda** entre pai e filho |
| `-n` | Ordena por **PID** (em vez de por nome) |
| `-h` | **Destaca** o processo atual e seus ancestrais |
| `-T` | Esconde as **threads** (mostra só processos) |

### `htop`

Monitor **interativo** em tempo real. Mostra CPU, memória e processos numa interface colorida, com mouse, rolagem e ações diretas (enviar sinal, mudar prioridade) sem digitar PIDs. Sintaxe: `htop [opções]`. Sem argumentos, atualiza a cada ~2,5 s.

| Opção | Função |
|---|---|
| `-d N` | Intervalo de atualização, em **décimos de segundo** (`-d 50` = 5 s) |
| `-u USUÁRIO` | Mostra só os processos de um usuário |
| `-p PID1,PID2` | Mostra só os PIDs informados |
| `-s COLUNA` | Ordena por uma coluna (ex.: `-s PERCENT_MEM`) |
| `-t` | Abre já em **modo árvore** |
| `-C` | Modo monocromático |
| `--readonly` | Modo só de leitura (desativa as ações de enviar sinal etc.) |

### `kill`

Envia **sinais** a processos. O nome engana: além de encerrar, ele pode pausar, retomar, mandar recarregar a configuração ou só verificar se o processo existe. Sintaxe: `kill [-SINAL] PID...`. Sem sinal, usa o **SIGTERM (15)**.

| Nº | Nome | O que faz |
|---|---|---|
| 0 | SIG0 | **Não envia nada**: só verifica se o PID existe (e se você tem permissão) |
| 1 | SIGHUP | Pede para **recarregar a configuração** (nginx, sshd) ou encerra, se for processo de terminal |
| 2 | SIGINT | Interrupção. É o que o **Ctrl+C** envia |
| 3 | SIGQUIT | Encerra e gera um *core dump* (útil para depurar travamentos) |
| 9 | **SIGKILL** | **Força** o encerramento imediato. Não pode ser capturado nem ignorado. Último recurso |
| 15 | **SIGTERM** | Pede o término **gracioso** (o processo pode fazer limpeza). É o **padrão** |
| 18 | SIGCONT | **Retoma** um processo pausado |
| 19 | SIGSTOP | **Pausa** um processo (também não pode ser ignorado) |

| Opção | Função |
|---|---|
| `-s SINAL` | Indica o sinal, por nome ou número |
| `-l` | Lista **todos** os sinais |
| `-l NÚMERO` | Converte número em nome (`kill -l 9` → `KILL`) |
| `-L` | Lista os sinais em tabela, com os números |
| `--timeout MS SINAL` | Envia o sinal indicado depois de esperar MS milissegundos, se o processo ainda existir |

> Os números dos sinais acima valem para Linux em PCs (x86/ARM). Em outros sistemas, como o macOS, alguns números mudam; por isso é mais seguro usar os **nomes**.

### `pkill`

É o `pgrep` com uma **ação**: em vez de listar os PIDs encontrados, ele **envia um sinal** a eles. Escolhe os processos por **padrão** (expressão regular estendida) e não exige o PID. Sintaxe: `pkill [opções] PADRÃO`. Sem opções, envia SIGTERM a **todos** os que casarem.

| Opção | Função |
|---|---|
| `-SINAL` / `-s SINAL` | Define o sinal (padrão: SIGTERM) |
| `-f` | Casa contra a linha de comando **completa**, não só o nome |
| `-x` | Casamento exato |
| `-i` | Ignora maiúsculas/minúsculas |
| `-u USUÁRIO` | Só os processos desse usuário |
| `-P PPID` | Só os filhos de um processo |
| `-n` / `-o` | Só o mais novo / o mais antigo |
| `-v` | Inverte o casamento |
| `-c` | Só **conta** os que casariam (não envia sinal) |
| `-e` | Mostra (*echo*) quais foram sinalizados |

> ⚠️ **Cuidado:** o `pkill` age sobre **todos** os processos que casarem com o padrão. Confira antes com `pgrep -a padrão` para ver quem seria atingido.

---

## Na prática: Missão 1 (em andamento)

O lab simula um servidor com vários processos fictícios da LogiTrack. A missão tem quatro partes:

- **1A:** um processo está consumindo um núcleo inteiro de CPU. Descobrir qual e encerrá-lo.
- **1B e 1C:** um processo (`logitrack-coletor`) roda com **outro usuário** e recebeu um **token** de acesso pela linha de comando. Descobrir o usuário e o token, **sem encerrar** o processo.
- **Teimoso:** um processo ignora o `kill` normal. Encerrá-lo mesmo assim.
- **1D:** um processo "ressuscita" depois de morto. Descobrir quem o recria e resolver de vez.

### 1A: achar o processo que mais usa CPU

**O que tentei:** começar com o `pgrep`. Não serviu: o `pgrep` só procura PIDs por **nome, padrão ou usuário**; ele não sabe qual processo consome mais CPU.

**O que funciona:** ordenar a listagem por consumo.

```bash
ps aux --sort=-%cpu | head    # o "-" antes de %cpu ordena do maior para o menor
```

Também dá para usar o `top` ou o `htop` e ordenar pela coluna de CPU. Com o PID em mãos, usa-se o `kill PID` (ou `pkill -f` com um pedaço do comando).

### Pendente

- [ ] Concluir 1B/1C, 1D e o processo teimoso (e registrar o que aconteceu em cada um).
- [ ] M2: processos em primeiro e segundo plano.
- [ ] M3: serviço com `systemd`.
- [ ] M4: logs do sistema com `journalctl`.
- [ ] M5: agendamento de tarefas com `cron`.

## Dúvidas em aberto

- [ ] Ao ver o token de outro usuário na linha de comando (1B/1C): o que isso mostra sobre passar senhas como argumento de comando? (Pista: qualquer usuário consegue ler a linha de comando dos processos em `ps`. Comparar com a abordagem de arquivo de configuração da missão M3.)
