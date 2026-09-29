# Caderno de estudos linux para Treinee DevOps - D2

## M1 - Quem está rodando aqui?

Todo programa em execução é um processo, com um número (PID), um dono (usuário) e um pai (PPID, o processo que o criou). Para pedir que um processo pare, você manda um sinal. kill não "mata": ele manda um sinal, por padrão o SIGTERM (15), que é um pedido educado. O processo pode tratar esse pedido ou até ignorar. O SIGKILL (9) não pode ser ignorado: o próprio kernel encerra o processo, sem dar chance de ele salvar nada.

### Comandos apresentados

- ps aux = lista os processos de todos os usuários, em formato orientado a usuários e incluindo processos sem terminais (daemons, serviços, ...)
- ps -ef = lista todos os processos em **full format** (PPID, STIME, CMD completo)
    - Diferença entre os dois ps:
        |               |           `ps aux`           |               `ps -ef`             |
        |---------------|------------------------------|------------------------------------|
        |      Foco     |          CPU / Memória       | Hierarquia (PPID) / Tempo de start |
        | Colunas-chave |  %CPU, %MEM, VSZ, RSS, STAT  |           PPID, STIME, CMD         |
        |  Quando usar  | "Quem está comendo RAM/CPU?" |      "Quem gerou este processo?"   |
- ps -o pid,ppid,user,%cpu,args -p PID = dissecando o comando:
    ps  -o pid,ppid,user,%cpu,args  -p PID
    │   │                            │
    │   └── Colunas a exibir         └── Qual processo (PID específico)
    └────── "process status"
- pgrep -a = mostra a linha completa do processo juntamente do PID
- pstree -p = trás a árvore de processos juntamente do PID
- top (ou htop) = visualizador de processos interativo em tempo real (htop)
- kill = envia sinais para os processos. É um comando genérico que não serve somente para "matar" um processo, mas também para verificar sua existência, pausar, retomar, ...
- kill -l = lista todos os sinais disponíveis
- pkill = diferentemente do **kill** que precisa de um PID para executar a ação, o pkill utiliza do padrão regex estendida (ERE) para identificar os processos. É um pgrep que ao invés de listar os PIDs, executa algo sobre eles.

#### ps (process status)
> Serve para imprimir um snapshot dos processos ativos no sistema como PID, dono, CPU, memória, comando, estado... .
> Sintaxe geral: ps [OPÇÕES]
> Aceita três estilos de opção (que podem ser misturados):
    | Estilo | Formato | Exemplo |
    |---|---|---|
    | UNIX | `-` + letras agrupadas | `ps -ef` |
    | BSD | letras sem `-` | `ps aux` |
    | GNU long | `--` + palavra | `ps --sort=-%mem` |

#### pgrep (process grep)
> Serve para buscar PIDs de **processos ativos** com base em um padrão. É o equivalente do grep, mas para processos em vez de linhas de texto.
> Sintaxe geral: pgrep [OPÇÕES] PADRÃO
> Saída padrão: um PID por linha.
> Opções mais usadas:
    | Opção | Função |
    |---|---|
    | `-l` | Mostra o **nome** do processo junto com o PID |
    | `-a` | Mostra a **linha de comando completa** junto com o PID |
    | `-f` | Casa contra a **linha de comando inteira** (não só o nome) |
    | `-x` | Match **exato** (sem substring) |
    | `-i` | Case-insensitive |
    | `-c` | **Conta** os matches (em vez de listar PIDs) |
    | `-n` | Só o **mais novo** (recentemente iniciado) |
    | `-o` | Só o **mais antigo** |
    | `-u USUÁRIO` | Filtra por **usuário** dono |
    | `-P PPID` | Filtra por **PID do pai** (filhos de um processo) |
    | `-t TERMINAL` | Filtra por **terminal** (ex: `pts/0`) |
    | `-d SEP` | Define o **delimitador** da saída (padrão: `\n`) |
    | `-v` | **Inverte** o match (processos que NÃO casam) |

#### pstree
> Serve para exibir os processos do sistema em **formato de árvore hierárquica** ao invés de tabela como no **ps**.
> Sintaxe geral: pstree [OPÇÕES] [PID | USUÁRIO]
> Sem argumentos, a árvore é enraizada no PID 1 (systemd/init). Com um PID, a árvore começa naquele processo. Com um usuário, mostra todas as árvores enraizadas em processos daquele usuário.
> Opções mais usadas:
    | Opção | Função |
    |---|---|
    | `-p` | Mostra os **PIDs** ao lado de cada processo |
    | `-a` | Mostra os **argumentos da linha de comando** |
    | `-c` | **Não compacta** subárvores idênticas (exibe cada uma separadamente) |
    | `-n` | Ordena por **PID** (em vez de por nome) |
    | `-s` | Mostra os **ancestrais** (pais) do processo especificado |
    | `-u` | Mostra **transições de UID** (quando o filho roda como usuário diferente do pai) |
    | `-h` | **Destaca** o processo atual e seus ancestrais |
    | `-H PID` | Destaca um **PID específico** e seus ancestrais |
    | `-l` | **Não trunc**a linhas longas |
    | `-T` | **Oculta threads** (mostra só processos) |
    | `-t` | Mostra **nomes completos** das threads |
    | `-g` | Mostra os **PGIDs** (Process Group IDs) |
    | `-A` | Usa caracteres **ASCII** para desenhar a árvore |
    | `-U` | Usa caracteres **UTF-8/Unicode** |
    | `-Z` | Mostra o **contexto SELinux** de cada processo |
    | `-k` | Mostra **threads de kernel** |
    | `-C age` | **Coloriza** por idade (verde < 60s, amarelo < 1h, vermelho > 1h) |

#### htop
> O htop é um visualizador de processos interativo em tempo real. Mostra CPU, memória, processos e hierarquia em uma interface colorida, com suporte a mouse, scroll vertical/horizontal e ações diretas (kill, renice, strace) sem precisar digitar PIDs.
> Sintaxe geral: htop [OPÇÕES]
> Sem argumentos, abre a interface interativa com atualização a cada 2.5s
> Opções:
    | Opção | Função |
    |---|---|
    | `-d DELAY` | Intervalo de atualização, em **décimos de segundo** (ex: `-d 50` = 5s) |
    | `-u USUÁRIO` | Mostra **só** os processos de um usuário |
    | `-p PID1,PID2` | Mostra **só** os PIDs especificados |
    | `-s COLUNA` | Ordena por uma coluna (ex: `-s PERCENT_MEM`) |
    | `-t` | Abre direto em **tree view** (hierarquia) |
    | `-F "filtro"` | Filtra por texto no comando (case-insensitive, sem regex) |
    | `-C` | Modo **monocromático** (sem cores) |
    | `-M` | Desativa o **mouse** |
    | `-H DELAY` | **Destaca** processos novos/terminados por DELAY segundos |
    | `--readonly` | Desativa ações (kill, renice) — modo somente leitura |

> Resumindo: **ps** é para ver uma foto, **top** é para assistir em tempo real (básico), **htop** é para investigar e agir (encontrar, filtrar, matar, renice, strace — tudo sem sair da tela), e **pgrep** é para achar o PID em scripts.

#### kill
> Envia sinais a processos. O nome é enganoso, porque ele não só "mata" processos, mas também pode pausar, retomar, recarregar configuração, verificar se existe, etc. O "kill" é o genérico;
> Sintaxe geral: kill [OPÇÕES] [SINAL] PID...
> Sem sinal, o default é SIGTERM (15) — pede ao processo para terminar.
> Sinais mais importantes:
    | N° | Nome | O que faz |
    |---|---|---|
    | 0 | SIG0 | **Não envia nada** — só verifica se o PID existe (e se você tem permissão) |
    | 1 | SIGHUP | Recarrega configuração (nginx, sshd) ou encerra se for processo de terminal |
    | 2 | SIGINT | Interrupção (equivalente a `Ctrl+C`) |
    | 3 | SIGQUIT | Encerra + gera **core dump** (debug de crash) |
    | 9 | **SIGKILL** | **Força** término imediato. Não pode ser capturado/bloqueado. Último recurso. |
    | 15 | **SIGTERM** | Pede término **gracioso** (o processo pode fazer cleanup). **Default**. |
    | 18 | SIGCONT | **Retoma** um processo pausado |
    | 19 | SIGSTOP | **Pausa** um processo (não pode ser capturado) |
> Opções:
    | Opção | Função |
    |---|---|
    | `-s SINAL` | Especifica o sinal (nome ou número) |
    | `-l` | Lista **todos os sinais** disponíveis |
    | `-l NÚMERO` | Converte número → nome (`kill -l 9` → `KILL`) |
    | `-L` | Lista sinais **com números** (tabela) |
    | `-p` | Só imprime o **PID** (não envia sinal) — útil para verificar se existe |
    | `-a` | Ao usar nome de processo, não restringe ao seu UID |
    | `--verbose` | Mostra os PIDs e sinais que serão enviados |
    | `--timeout MS SINAL` | Envia o sinal, espera MS milissegundos, e envia um **segundo** sinal se o processo ainda existir |
    
#### pkill
> Envia sinais a processos com base em um padrão (nome, linha de comando, usuário, etc.). Em vez de exigir um PID como o kill. É o pgrep com uma ação, em vez de listar os PIDs encontrados, ele age sobre eles.
> Sintaxe geral: pkill [OPÇÕES] PADRÃO
> O PADRÃO é uma regex estendida (ERE) casada contra o nome do processo. Sem opções, envia SIGTERM (15) a todos os matches.
> Opções: 
    | Opção | Função |
    |---|---|
    | `-SIGNAL` / `-s SINAL` | Define o sinal (padrão: SIGTERM) |
    | `-f` | Casa contra a **linha de comando completa** (não só o nome) |
    | `-x` | Match **exato** (sem substring) |
    | `-i` | Case-insensitive |
    | `-u USUÁRIO` | Filtra por **usuário** dono |
    | `-P PPID` | Filtra por **PID do pai** (só filhos) |
    | `-t TERMINAL` | Filtra por **terminal** (ex: `pts/0`) |
    | `-g PGID` | Filtra por **process group** |
    | `-n` | Só o **mais novo** (recentemente iniciado) |
    | `-o` | Só o **mais antigo** |
    | `-v` | **Inverte** o match (processos que NÃO casam) |
    | `-c` | **Conta** os matches (não envia sinal) |
    | `-e` | **Echo** — mostra os PIDs sinalizados |
    | `-F ARQUIVO` | Lê PIDs de um **arquivo** (em vez de padrão) |

### M1A

Primeiro tentei resolver com o uso do pgrep, mas percebi que o comando só encontra os PIDs por nome, padrão, usuário..., e não encontra o que tem o maior tamanho
    
