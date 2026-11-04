# Linux, dia 1: arquivos, busca, texto, redirecionamento e permissões

> **Tema:** Linux
> **Origem:** próprio
> **Status:** 🟢 Concluído <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->
> **Nível:** iniciante. Assume só que você sabe abrir um terminal.
> **Lab usado:** [LogiTrack, dia 1](MISSOES-DIA1.md), um servidor fictício de logística criado pelo script [`setup-dia1.sh`](setup-dia1.sh). Cada seção abaixo (M1 a M6) corresponde a uma missão do lab.
> **Continua em:** [Linux, dia 2: processos e sinais](../logitrack-02/linux2.md)

## Em resumo

Estas são as minhas anotações do primeiro dia de estudo de Linux. Passo por seis temas, na ordem das missões:

| Missão | Tema | Comandos principais |
|---|---|---|
| **M1** | Reconhecer o terreno: onde estão as coisas | `pwd`, `ls`, `cd`, `cat`, `tree`, `find` |
| **M2** | Achar arquivos e medir espaço | `find`, `du`, `wc` |
| **M3** | Ler logs como um sysadmin | `grep`, `sort`, `uniq`, `head`, `tail`, `cut` |
| **M4** | Redirecionar entrada e saída | `>`, `>>`, `2>`, `2>&1`, `/dev/null` |
| **M5** | Permissões, usuários e grupos | `chmod`, `umask`, `chown`, `useradd`, `usermod`, setgid |
| **M6** | Primeiro script de verdade | `bash`, `date`, variáveis, `{ ...; } > arquivo` |

No fim há uma seção de **fechamento**, com as perguntas de revisão, as minhas respostas e as correções.

> 💡 Nos exemplos, `<seu-usuario>` representa o nome do seu usuário Linux.

---

## M1: Reconhecimento

### Comandos básicos de navegação

| Comando | O que faz |
|---|---|
| `pwd` | Mostra o caminho (*path*) da pasta em que estou |
| `ls` | Lista os arquivos visíveis da pasta atual |
| `ls -l` | Lista com detalhes (permissões, dono, tamanho, data) |
| `ls -la` | Lista **todos**, inclusive os ocultos (que começam com `.`), com detalhes |
| `cd` | Navega entre pastas |
| `cat` | Mostra o conteúdo de um arquivo de texto |
| `tree -a` | Mostra a hierarquia de pastas, sem esconder as ocultas |

Um atalho que descobri: **`cd -`** volta para a pasta onde eu estava **antes**, seja ela qual for. Já o `cd ..` sempre sobe para a pasta-pai da atual.

### Os diretórios da raiz (`/`)

Rodar `ls /` mostra as pastas principais do sistema. Conhecer as mais comuns é o primeiro passo:

| Diretório | Para que serve |
|---|---|
| `/etc` | **Configurações do sistema.** Contém as configurações globais, scripts de inicialização e os modelos de configuração para novos usuários |
| `/var` | De *variable*: dados que **mudam** durante o funcionamento do sistema. Dentro dele: `/var/log` (logs), `/var/lib` (estado de aplicações, como bancos de dados), `/var/cache` (caches, como o de pacotes do `apt`) e `/var/tmp` (temporários que **sobrevivem** ao reboot) |
| `/home` | Espaço pessoal de cada usuário (`Documents/`, `Downloads/`...). Dentro dele ficam também `.ssh/` (chaves SSH) e `.config/` (configuração de aplicativos). Por padrão só o dono (e o root) acessa |
| `/tmp` | Arquivos temporários, que **não** precisam sobreviver a um reboot |
| `/usr/bin` | A grande maioria dos programas do dia a dia: editores (`vim`, `nano`), ferramentas de rede (`ping`, `curl`, `ssh`), linguagens (`python3`) e utilitários (`grep`, `sed`, `awk`) |
| `/srv` | De *service*: dados que a máquina **serve para fora** pela rede. Ex.: `/srv/www/` (sites Apache/Nginx), `/srv/ftp/`, `/srv/git/` |

**`/bin` × `/usr/bin`:** antigamente, `/bin` guardava os binários essenciais para o boot e `/usr/bin` guardava "o resto". Hoje a distinção acabou: nas distribuições modernas (Ubuntu 19.04+, Fedora, Arch, Debian 12+), `/bin` é só um **atalho (symlink)** para `/usr/bin`. Esse arranjo se chama *usr-merge*.

| Onde | O que fica lá |
|---|---|
| `/bin` → `/usr/bin` | Comandos essenciais (é um atalho) |
| `/usr/bin` | Programas instalados pelo gerenciador de pacotes (`apt`, `dnf`, `pacman`...) |
| `/usr/local/bin` | Programas instalados **manualmente** pelo administrador |
| `~/.local/bin` | Programas do **usuário**, fora da hierarquia do sistema |

### `find` pela primeira vez

```bash
find app -name ".*"
```

- **O que faz:** localiza arquivos e diretórios. Sintaxe: `find [opções] [caminho...] [expressão]`.
- **O que aconteceu:** listou o caminho de todos os arquivos ocultos dentro de `app`.
- **Onde aparece no mundo real:** limpeza e gestão de disco, rotação de logs.

---

## M2: Agulha no palheiro

**Comandos:** `find` e `du` (*disk usage*, mostra o espaço em disco ocupado por arquivos e pastas; sintaxe `du [opções] [caminho]`).

### Achando arquivos grandes

```bash
find entregas/ -size +500k
```

O `+` e o `-` depois de `-size` respondem "maiores que" e "menores que" o tamanho indicado.

### Contando arquivos `.csv`

O pedido era contar apenas **arquivos** `.csv`. Duas coisas importaram:

1. **`-type f`** restringe a busca a **arquivos** (sem ele, pastas cujo nome termina em `.csv` também entrariam).
2. **`| wc -l`** conta as linhas da saída, em vez de eu contar à mão. O `wc` sem opções imprime três números (linhas, palavras e bytes); o **`-l`** deixa só o de linhas.

```bash
find entregas/ -name "*.csv" -type f | wc -l
```

**Pontos de atenção sobre o `find`:**

- O `find` **já inclui arquivos ocultos** por padrão (diferente do `ls`, que precisa de `-a`).
- Opções que afetam *como* ele percorre as pastas (`-maxdepth`, `-mindepth`, `-prune`) devem vir **antes** dos testes (`-name`, `-type`, `-size`...). Fora de ordem, ele emite um aviso.
- `-maxdepth` limita a **profundidade** da busca. Ele não tem relação com arquivos ocultos.

### Tamanho aparente × espaço real

O `ls -l` mostra o **tamanho aparente** (quantos bytes de conteúdo o arquivo tem). O `du` mostra o **espaço realmente ocupado em disco**. Os dois podem divergir por dois motivos:

- **Alocação em blocos:** o sistema de arquivos reserva espaço em blocos fixos (tipicamente 4 KB). Um arquivo de 1 byte ainda ocupa um bloco inteiro. É também por isso que **pastas** aparecem com `4096` no `ls -l`.
- **Arquivos esparsos:** arquivos com "buracos" (regiões de zeros que não são gravadas de fato) têm tamanho aparente grande, mas uso de disco mínimo.

---

## M3: Lendo logs como sysadmin

### Comandos

| Comando | O que faz |
|---|---|
| `head` | Mostra as 10 primeiras linhas |
| `tail` | Mostra as 10 últimas linhas |
| `less` | *Pager*: exibe o arquivo e permite navegar tela a tela |
| `grep -c` | **Conta** as linhas que casam com o padrão, em vez de imprimi-las |
| `grep -i` | Ignora maiúsculas/minúsculas (*case-insensitive*) |
| `grep -v` | **Inverte**: mostra as linhas que **não** casam |
| `grep -o` | Mostra **só o trecho** que casou, e não a linha inteira |
| `grep -w` | Casa apenas **palavras inteiras** (`error` casa, `errors` não) |
| `grep -E` | Ativa expressões regulares estendidas (`?`, `+`, `{}`, `\|`, `()`) sem precisar de `\` |
| `cut` | Extrai partes de cada linha (por caractere, byte ou campo delimitado) |
| `sort` | Ordena as linhas (como dicionário, por padrão; ou numericamente com `-n`) |
| `uniq -c` | Colapsa linhas **repetidas e vizinhas** e prefixa com a contagem |
| `wc -l` | Conta **linhas** (conta quebras de linha `\n`; não conta "arquivos") |

> ⚠️ **Regra do `uniq`:** ele só enxerga linhas **vizinhas**. Por isso quase sempre vem depois de um `sort`, que agrupa as repetições.

**Pipeline clássico de "o que mais se repete":**

```bash
sort arquivo.txt | uniq -c | sort -rn
#  └ agrupa     └ conta cada     └ ordena do mais frequente (-r reverso, -n numérico)
```

### Contando erros no log

Minha primeira tentativa foi `cat app.log | grep -io | wc -l`. Tinha dois problemas:

1. O `cat` era desnecessário: o `grep` já lê o arquivo diretamente.
2. O `-io` pegava **qualquer** trecho "error" (inclusive dentro de outras palavras). A opção **`-w`** resolve isso, casando só a palavra exata.

### Rastreio com mais erros (pipeline em etapas)

O objetivo: descobrir qual código de rastreio (formato `BR` + 9 dígitos) aparece mais em linhas de erro.

A primeira ideia foi colocar o `-o` no primeiro `grep`, mas isso reduzia cada linha à palavra "error" e **o código sumia**. A solução foi usar **dois `grep` em sequência**: o primeiro filtra as linhas de erro, e o segundo, com `-o`, extrai só o código.

```bash
grep -iw "error" app.log | grep -oE 'BR[0-9]{9}' | sort | uniq -c | sort -rn
```

| Etapa | O que faz |
|---|---|
| `grep -iw "error" app.log` | Fica só com as linhas que têm a palavra "error" |
| `grep -oE 'BR[0-9]{9}'` | Extrai só o código: `BR` seguido de 9 dígitos |
| `sort` | Agrupa os códigos iguais |
| `uniq -c` | Conta quantas vezes cada código aparece |
| `sort -rn` | Ordena do mais frequente para o menos frequente |

> Na regex, uma parte define **quais** caracteres são aceitos (`[0-9]`) e outra define **quantos** (`{9}`).

---

## M4: Redirecionamento

Todo programa tem três canais:

| Canal | Número | Nome |
|---|---|---|
| Entrada | `0` | `stdin` |
| Saída normal | `1` | `stdout` |
| Saída de erro | `2` | `stderr` |

| Operador | Efeito |
|---|---|
| `>` | Redireciona a saída normal para um arquivo, **sobrescrevendo** (cria se não existir) |
| `>>` | Redireciona **acrescentando** ao final |
| `2>` | Redireciona **só os erros** |
| `2>&1` | Junta os erros na mesma saída da saída normal |
| `/dev/null` | O "lixo": o que vai pra lá desaparece |

### A missão

Salvar em `relatorios/confs.txt` os arquivos `*.conf` encontrados **sem** os erros de "permissão negada". Rodando `find` como usuário comum, ele mistura resultados e erros na tela. Experimentei três variações:

```bash
find / -name "*.conf" > a.txt        # caminhos vão para a.txt; os erros continuam aparecendo na tela
find / -name "*.conf" 2> b.txt       # erros vão para b.txt; os caminhos continuam aparecendo na tela
find / -name "*.conf" > c.txt 2>&1   # caminhos E erros vão para c.txt; nada aparece na tela
```

Para guardar só os resultados e **descartar** os erros:

```bash
find / -name "*.conf" > relatorios/confs.txt 2>/dev/null
```

---

## M5: Permissões

Cada arquivo tem um **dono** (`u`, *user*), um **grupo** (`g`) e **outros** (`o`). Cada um pode ter:

| Permissão | Letra | Valor |
|---|---|---|
| Leitura | `r` | 4 |
| Escrita | `w` | 2 |
| Execução | `x` | 1 |

O número do `chmod` soma esses valores **para cada um dos três**. Exemplo: `chmod 640` = dono `rw-` (4+2=6), grupo `r--` (4), outros nada (0).

**Em pastas o significado muda:**

| Permissão | Em arquivo | Em pasta |
|---|---|---|
| `r` | ler o conteúdo | **listar** os nomes dentro |
| `w` | alterar o conteúdo | **criar e apagar** arquivos dentro |
| `x` | executar como programa | **entrar** na pasta e acessar o que há nela |

### `chmod`: alterar permissões

```bash
chmod [opções] MODO ARQUIVO...
```

- **Modo numérico:** `chmod 755 script.sh` (resulta em `rwxr-xr-x`).
- **Modo simbólico:** `chmod u+x script.sh` (adiciona execução só para o dono). Em `u`/`g`/`o`/`a` (todos), `+` adiciona, `-` remove e `=` define exatamente.
- **Opções úteis:** `-R` (recursivo), `-v` (mostra o que mudou), `--reference=ARQ` (copia as permissões de outro arquivo).

> **Regra de ouro:** `644` para arquivos e `755` para pastas e scripts. `777` quase sempre é um erro de segurança.

### M5A e M5B: corrigindo permissões

- **M5A:** restringir um arquivo de configuração ao dono: `chmod 600 config/banco.conf`.
- **M5B:** o script de backup não executava e nem gravava:
  1. O dono não tinha permissão de execução → `chmod 700 ./scripts/backup.sh`.
  2. O script grava em `./backups/`, mas o dono não tinha `w` nessa pasta → `chmod 755 ./backups/`.

### `umask`: o que é "tirado" na criação

O `umask` define quais permissões são **removidas** quando um arquivo ou pasta novo é criado. Sintaxe: `umask [-p] [-S] [modo]` (`-p` imprime de forma reutilizável, `-S` imprime em notação simbólica; sem `modo`, só mostra o atual).

> **Resumo:** o `chmod` **define** a permissão final; o `umask` **subtrai** do padrão.

Ao rodar `umask`, vi **`0002`** e estranhei: por que quatro dígitos e por que o grupo mantém permissão de escrita?

- **Grupo com escrita (`002`):** no Ubuntu/Debian existe o **User Private Group (UPG)**: cada usuário tem um grupo próprio, com o mesmo nome, em que só ele é membro. Como ninguém mais está nesse grupo, é seguro deixar o grupo escrever.
- **Quarto dígito:** o primeiro dígito dos bits especiais (`setuid`=4, `setgid`=2, `sticky`=1) existe no `chmod` (ex.: `2775`). No `umask` ele aparece só por consistência de formato e **não tem efeito**.

| Bit especial | Valor | Efeito |
|---|---|---|
| setuid | 4 | Executável roda com os privilégios do **dono** |
| setgid | 2 | Executável roda com os do **grupo**; em **pasta**, tudo criado dentro herda o grupo da pasta |
| sticky | 1 | Em pasta, só o dono do arquivo pode apagá-lo (ex.: `/tmp`) |

### M5C: criar um arquivo com umask diferente do padrão

Isolei a mudança em um **subshell** `( ... )`, assim o `umask` vale só dentro dos parênteses:

```bash
(umask 077; touch relatorios/secreto.txt)   # só o dono lê e escreve
(umask 022; mkdir diretorio)
```

> ✏️ **Correção:** minha anotação anterior sugeria `env -C 077 touch ...` como alternativa de uma linha. Isso está **errado**: a opção `-C` do `env` **troca o diretório** de trabalho (`env -C /tmp comando`), e não define umask. Uma alternativa correta de uma linha é `bash -c 'umask 077; touch arquivo'`.

### M5D: usuário, grupo e pasta compartilhada

**Criar o grupo e o usuário:**

```bash
sudo groupadd logistica
sudo useradd -m -s /bin/bash -G logistica motorista
sudo passwd motorista
```

| Opção do `useradd` | O que faz |
|---|---|
| `-m` | Cria a pasta pessoal (`/home/motorista`) e copia os modelos de `/etc/skel` (`.bashrc`, `.profile`...). Sem ela, o usuário fica sem home |
| `-s /bin/bash` | Define o **shell de login**. Outras escolhas: `/bin/sh` (mais leve) e `/usr/sbin/nologin` (impede login; usado em contas de serviço) |
| `-G grupo1,grupo2` | Adiciona o usuário a **grupos secundários** |

**Adicionar um usuário que já existe a um grupo:**

```bash
sudo usermod -aG logistica <seu-usuario>
```

> ⚠️ **O `-a` (append) é obrigatório.** Sem ele, o `usermod -G` **substitui** todos os grupos secundários do usuário pelos informados, e ele perde os anteriores.

Outras opções do `usermod`:

| Opção | Função |
|---|---|
| `-aG grupo` | **Acrescenta** a grupos secundários (mantém os atuais) |
| `-G g1,g2` | **Substitui** toda a lista de grupos secundários |
| `-g grupo` | Muda o grupo **primário** |
| `-d /novo -m` | Muda o home **e move** os arquivos |
| `-s /bin/zsh` | Muda o shell de login |
| `-l novo_nome` | Renomeia o login |
| `-L` / `-U` | **Trava** / **destrava** a conta |
| `-e 2026-12-31` | Define a data de **expiração** da conta |

**Para conferir:**

```bash
id -Gn motorista            # grupos de um usuário
getent group logistica      # membros de um grupo
su - motorista              # entra como esse usuário (digite exit para voltar)
```

**Criar a pasta compartilhada e definir dono, grupo e setgid:**

```bash
sudo mkdir -p /srv/logitrack-compartilhado           # 1. cria a pasta
sudo chown root:logistica /srv/logitrack-compartilhado   # 2. dono root, grupo logistica
sudo chmod 2770 /srv/logitrack-compartilhado             # 3. permissões + setgid
```

- `mkdir -p` cria toda a cadeia de pastas que faltar no caminho e **não dá erro** se a pasta já existir.
- `chown DONO:GRUPO` muda o dono e/ou o grupo. `chown root:logistica x` muda os dois; `chown root x` só o dono; `chown :logistica x` só o grupo; `-R` aplica a tudo dentro.
- O `2` em `2770` é o **setgid**. Sem ele, um arquivo criado pelo `motorista` ficaria com o grupo **pessoal** dele (`motorista`), e os demais membros de `logistica` não conseguiriam acessá-lo. Com o setgid, tudo que for criado ali nasce com o grupo `logistica`.

---

## M6: Primeiro script de verdade

Um script que gera o relatório do dia em `relatorios/` (versão completa em [`scripts/relatorio-diario.sh`](scripts/relatorio-diario.sh)):

```bash
#!/usr/bin/env bash
cd "$(dirname "$0")/.."                       # vai para a raiz do lab, de onde quer que seja chamado

DATA=$(date +%F)                              # data atual no formato AAAA-MM-DD
RELATORIO="relatorios/diario-${DATA}.txt"

{
  echo "==== Relatório diário - Data: ${DATA} ===="
  echo ""
  ERROS=$(grep -iwc "ERROR" logs/app.log)
  echo "- Total de linhas ERROR: ${ERROS}"
  ENTREGUES=$(grep -cowi "entregue" logs/app.log)
  echo "- Total de entregas (status = entregue): ${ENTREGUES}"
  echo "- Top 3 rastreios com mais erros:"
  grep -iw "ERROR" logs/app.log | grep -oE 'BR[0-9]{9}' | sort | uniq -c | sort -rn | head -3
} > "$RELATORIO"                               # tudo que está entre { } vai para o arquivo

echo "Relatorio '${RELATORIO}' criado."
```

- **`#!/usr/bin/env bash`** (*shebang*): diz ao sistema qual programa deve interpretar o script. O `env` procura o `bash` no `PATH`.
- **`cd "$(dirname "$0")/.."`**: garante que o script funcione de qualquer pasta, indo para a raiz do lab.
- **`date +%F`**: data atual em `AAAA-MM-DD`.

---

## Fechamento do dia: perguntas de revisão

Cada item mostra a minha resposta e a correção.

**1. Qual a diferença entre `>` e `>>`? O que faz `2>/dev/null`?**
- *Minha resposta:* o `>` reescreve o arquivo com a saída; o `>>` acrescenta sem apagar o conteúdo antigo; `2>/dev/null` joga os erros no lixo.
- ✏️ **Correção:** certa. Detalhes que faltaram: o `>` redireciona **apenas a saída normal** (canal 1), por isso os erros continuam aparecendo na tela, e é para isso que existe o `2>`. Além disso, o `>` **cria** o arquivo se ele não existir.

**2. O que significa `chmod 750`, dígito por dígito?**
- *Minha resposta:* achei que o comando "tirava" permissão (7 pontos do dono, 5 do grupo).
- ✏️ **Correção:** o `chmod 750` não tira nada, ele **define** o valor final. Cada dígito é a soma de r=4, w=2 e x=1:
  - `7` = 4+2+1 = `rwx`: o dono pode tudo;
  - `5` = 4+1 = `r-x`: o grupo lê e executa (ou entra, se for pasta);
  - `0` = nada: os outros não têm acesso.
- Eu tinha misturado com o `umask`, que é quem de fato **subtrai**. Para fixar: *chmod define, umask tira do padrão.*

**3. Por que `x` numa pasta é diferente de `x` num arquivo?**
- *Minha resposta:* num arquivo é executar; numa pasta vira "acessar a pasta".
- ✏️ **Correção:** certa. Para completar, comparar com o `r`: numa pasta, `r` = **listar** os nomes e `x` = **entrar** e acessar o que há dentro. Dá para abrir um arquivo cujo nome você já sabe mesmo sem poder listar a pasta (`x` sem `r`). Vale testar isso e anotar o resultado.

**4. Qual pipeline acha o IP que mais aparece num log de acesso?**
- *Minha resposta:* `grep -oE` para extrair os IPs, depois `sort | uniq -c | sort -rn | head -1`.
- ✏️ **Correção:** certa. Faltou só a regex dos IPs, `'([0-9]{1,3}\.){3}[0-9]{1,3}'`, ou o atalho `cut -d' ' -f1`, porque em logs de nginx e apache o IP é a **primeira coluna**.

**5. Para que serve o `setgid` numa pasta compartilhada?**
- *Minha resposta:* é o bit especial que força as permissões de grupo no arquivo ou pasta.
- ✏️ **Correção:** vaga e um pouco desviada. O `setgid` numa pasta **não força permissões, força o grupo**: todo arquivo criado lá dentro nasce com o grupo **da pasta** (`logistica`), e não com o grupo principal de quem criou. Isso foi visto na prática: o arquivo do `motorista` saiu com o grupo `logistica`, mas com permissão `rw-rw-r--`, que veio do `umask` dele. O porquê: sem o `setgid`, cada arquivo nasceria no grupo pessoal do criador, e o resto da equipe não conseguiria acessá-lo.

---

## Para fixar (resumo de bolso)

| Preciso de... | Comando |
|---|---|
| Achar arquivos por nome/tamanho/tipo | `find caminho -name "*.csv" -type f -size +500k` |
| Contar linhas | `... \| wc -l` |
| Ranking do que mais se repete | `... \| sort \| uniq -c \| sort -rn \| head` |
| Guardar só o resultado, descartando erros | `comando > saida.txt 2>/dev/null` |
| Definir permissão final | `chmod 640 arquivo` |
| Pasta onde todo arquivo herda o grupo | `chmod 2770 pasta` (setgid) |
| Adicionar usuário a um grupo sem perder os outros | `usermod -aG grupo usuario` |
