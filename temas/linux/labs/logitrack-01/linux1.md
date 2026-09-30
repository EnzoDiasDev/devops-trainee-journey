# Caderno de estudos linux para Treinee DevOps - D1

## M1 - Reconhecimento

Comandos apresentados: pwd, ls, ls -l, ls -la, cd, cat e tree -a

- pwd: path atual
- ls: lista os arquivos visíveis de dentro da pasta atual
- ls -l: lista com detalhes todos os arquivos visíveis dentre da pasta atual
- ls -la: lista TODOS os arquivos de forma detalhada (arquivos ocultos também)
- cd: navegar entre os diretórios/pastas
- cat: mostra o conteúdo de dentro de um arquivo de texto
- tree -a: mostra a hierarquia de pastas sem esconder as ocultas

### Notes

O ls / traz todos os diretórios raizes, conhecer alguns deles é um passo importante para o aprendizado:

- /etc = diretório que armazena arquivos de configurações do sistema. É o "Sistema nervoso" do sistema porque contém:
    - **Configurações globais** = arquivos que controlam o funcionamento do SO e de serviços instalados.
    - **Scripts de boot** = Instruções e configurações usadas duranto o processo de inicialização
    - **Padrões de usuário** = subdiretórios que fornecem **modelos** de configuração para novos usuários ao criar pastas pessoais.
- /var = abreviação de *variable*, ele armazena dados que mudam com o tempo durante a execução do sistema.
    - Subdiretórios importantes:
        - **/var/log** = logs do sistema
        - **/var/lib** = estado persistente de aplicações (banco de dados, dpkg, MySQL, etc)
        - **/var/cache** = cache de pacotes (/var/cache/apt/archives)
        - **/var/tmp** = arquivos temporários que sobrevivem a reinicializações
        - ...
- /home = espaço pessoal de cada usuário no sistema. Apenas o dono da pasta tem acesso (e o root). Dentro temos:
    - **Organização de arquivos pessoais** = Documents/, Dowloads/, Pictures/, ...
    - **.ssh/** = Caves e configuração de ssh
    - **.config/** = configuração de aplicativos
    - ...
- /tmp = diretório para armazenar arquivos temporários, criados pelo próprio sistema em execução e não precisam sobreviver a um reboot.
- /usr/bin = diretório com os principais comandos executáveis do sistema. É onde fica a grande maioria dos programas que o usuário utiliza no dia a dia:
    - O que vive lá:
        - **Binários instalados VIA GERENCIADOR DE PACOTES** (apt, dnf, pacman, ...)
        - **Editores** (vim, nano)
        - **Ferramentas de rede** (ping, curl, ssh, ...)
        - **Linguagens** (python3, ...)
        - **Utilitários** (grep, sed, awk, ...)
    - Diferença com */bin*:
        - Historicamente, /bin guardava apenas os binários essenciais para boot e modo single-user (necessários antes de /usr ser montado).  O /usr/bin guardava "o resto". Na prática, essa distinção se tornou obsoleta e na maioria das distribuições modernas (Ubuntu 19.04+, Fedora, Arch, Debian 12+), /bin é um symlink para /usr/bin (o chamado usr-merge)
    - Resumo:
        |-----------|----------|
        | Diretório | Conteúdo |
        | /bin -> /usr/bin | Comandos essenciais |
        | /usr/bin | Binários de pacotes do sistema |
        | /usr/local/bin | Binários instalados manualmente pelo admin |
        | ~/.local/bin | binários do usuário fora da hierarquia do sistema |
- /srv = abreviação de *service*, diretório designado para dados que o sistema serve para fora, ou seja, conteúdos que a máquina entrega para clientes remotos via rede.
    - Estrutura: /srv/<serviço>/<dataset>/
    - Subdiretórios:
        - **/srv/www/** = web roots (Apache, Nginx)
        - **/srv/ftp/** = raiz do servidor FTP
        - **/srv/git/** = repositório git bare
        - ...
    
Em um dos testes, acabei me deparando com o comando <code>cd -</code>, que volta ao diretório que eu estava ANTERIORMENTE. Ao contrário do <code>cd ..</code> que volta para a pasta pai do diretório atual, o <code>cd -</code> volta em qualquer pasta que eu estive anteriormente.

#### find (find app -name ".*")
> **O que faz:** localiza arquivos e diretórios. Sintaxe = find [opções] [caminho...] [expressão].
> **Comando que eu rodei e o que aconteceu:** mostrou os paths de todos os arquivos ocultos de dentro da pasta app.
> **Onde isso aparece no mundo real:** Limpeza e gestão de disco, log rotation, ...
> **Onde eu errei / o que me surpreendeu:** n/d
> **Dúvida que ficou:** n/d


---

## M2 - Agulha no palheiro

Comandos apresentados: find e du

- du: significa *disk usage*, reporta o espaço em disco ocupado por arquivos e diretórios. Sintaxe: du [opções] [caminho].

### Notes
    
A primeira etapa da M2 foi tranquilo, apenas usando o find com uma opção de tamanho deu conta (find entregas/ -size +500k). O mais e o menos após o size responde a seguinte pergunta: "quais arquivos são maiores/menores que <tamanho_desejado>".

Já a segunda parte foi um pouco mais complicado já que existe uma maneira de "montar" o find (que eu não sabia que existia). Uma das regras do find é:
    - Opções que afetam a traversa (-maxdepth, -mindepth, -prune) devem vir **antes** dos testes/expressões (-name, -type, -size, ...).
Porém, descobri que por padrão o find já detecta arquivos ocultos e que o -maxdepth não é para detectar arquivos ocultos. Estava conseguindo puxar os arquivos que tinham .csv no final com o comando <code>find entregas/ -name "\*.csv"</code> (o \* é para deixar claro para o .md que quero representar o asterico puro, e não colocar o texto em itálico), mas uma coisa que eu tinha esquecido, o enunciado pede estritamente a contagem de apenas **ARQUIVOS**, ou seja, o -type f daria conta do recado e me retornaria apenas os arquivos. Mas contar um por um chega a ser inviável com o tanto de arquivo .csv que existia, então adicionei o <code>| wc -l</code> para fazer a contagem para mim; **e por que o -l e não utra flag?** wc sem opções imprime 3 números (linhas, palavras e bytes), o -l restringe a saída para somente o contador de linhas. No final, o comando que me deu a resposta foi <code>find -name "\*.csv" -type f | wc -l</code>.

Outro ponto importante é entender a diferença entre **tamanho aparente (apparent size) e espaço real**. quando utilizamos o <code>ls -l</code> ou <code>ls -lh</code>, nos é retornados os dados dos arquivos, e em alguns deles (neste caso, na maioria) o tamanho igual a 4k, que não significa o tamanho real. Para acontecer isso podem acontecer dois cenários:
    - Alocação em blocos: O filesystem aloca espaço em blocos fixos (tipicamente 4 KB). Um arquivo de 1 byte ainda ocupa um bloco inteiro.
    - Arquivos esparsos: Arquivos com "buracos" (regiões de zeros não alocadas) têm tamanho aparente grande mas uso em disco mínimo.

---

## M3 - Lendo log como sysadmin

Comandos e opções apresentados: head, tail, less, grep (-c, -i, -v, -o, -E), cut, sort, uniq -c, wc -l.

- head = mostra as 10 primeiras linhas de um arquivo
- tail = mostra as 10 últimas linhas de um arquivo
- less = é um pager que exibe o conteúdo de um arquivo, permitindo navegação tela a tela
- grep -c = conta o número de linhas que casam com o padrão, em vez de imprimir as linhas
- grep -i = torna a busca case-insensitive (ex: casa com "Error", "error", "ERROR", "eRrOr", etc)
- grep -v = inverte a busca, imprime as linhas que **NÃO** casam com o padrão
- grep -o = imprime apenas a parte que casa com o padrão, em vez da linha inteira
- grep -E = ativa Expressões Regulares Estendidas (ERE) e permite usar os metacaracteres como ?, +, {}, |, (, ) sem backslash (pesquisar sobre os metacaracteres)
- cut = extrai partes específicas de cada linha de um arquivo ou pipe, seja por posição de caractere, por byte, ou por campo delimitado
- sort = ordena linhas de texto como um dicionário por padrão, ou numericamente, por campo, por tamanho, etc. É a peça que transforma uma lista bruta em algo legível
- uniq -c = o uniq filtra linhas duplicadas **adjacentes**, ele compara cada linha apenas com a anterior e, se forem iguais, imprime só a primeira. É por isso que ele quase sempre precisa de um sort antes. REGRA: uniq só enxerga linhas vizinhas. Se os duplicados estão espalhados, ele os ignora. O sort os agrupa, e aí o uniq faz o trabalho.
    - Já o <code>uniq -c</code> prefixa cada linha com a contagem de quantas vezes ela apareceu consecutivamente
    - Comando comum = sort file.txt | uniq -c | sort -rn, sort agrupa os duplicados, uniq -c conta quantos de cada existem, e o sort -rn ordena do mais frequente para o menos
- wc -l = conta a quantidade de **linhas**. OBS: não conta a quantidade de arquivos, pois o wc -l usa o \n para contar.

### Notes

Para resolver a primeira parte estava tentado usar o comando <code>cat app.log | grep -io | wc -l</code> mas alguns problemas nesse comando. Primeiro, o comando cat estava em desuso, era desnecessário já que o grep já lê o arquivo diretamente.
Agora, a parte que mais fez diferença para encontrar a resposta foi o uso da opção -w, já que anteriormente (-io) estava puxando qualquer substring "error" e causando excessos. E o -w vem justamente para corrigir esse erro, e casar só com as palavras exatas.

A segunda parte da M3 estava bem mais difícil de achar por se tratar de um encadeamento de operações. A minha primeira tentativa de resolver a questão foi utilizando o comando da questão anterior como base, o <code>grep -oiw "error" logs/app.log | wc -l</code> mas adaptado, utilizando um segundo grep e adicionando a opção -E para pegar o código no meio da frase (OBS: não esquecer que o padrão utilizado para **QUAIS** caracteres devem ser usados e o para **QUANTOS** caracteres devem estar contidos).
O problema é que mesmo assim o comando ainda não estava puxando o que eu queria, e o problema estava na opção -o dentro do primeiro grep, pois ele estava filtrando a linha inteira para somente a palavra alvo, neste caso "error", e não era possível analisar o código pois ele havia sumido. Neste caso, a solução foi transferir a opção -o do primeiro para o segundo grep, com o comando ficando da segunte forma <code>grep -iw "error" app.log | grep -oE 'BR[0-9]{9}'</code>, mas ele ainda faltava organizar para encontrar o que mais se repete.
Para organizar a saída dos greps utilizei o sort, o uniq -c para contar quantos existem de cada código e o sort -rn para ordenar do maior para o menor. O comando fica da seguinte forma: 
    - grep -iw "error" app.log | grep -oE 'BR[0-9]{9}' | sort | uniq -c | sort -rn

---

## M4 - Redirecionamento

Todo programa tem três canais: 
    - Entrada (0, stdin)
    - Saída normal (1, stdout)
    - Saída de erro (2, stderr)
        - '>' sobrescreve, '>>' acrescenta, '2>' redireciona só os erros, '2>&1' junta erro com saída, '/dev/null' é o lixo.

O objetivo da missão é encontrar somente os arquivos <code>"\*.conf"</code> que **NÃO** retornem permissão negada e salva-los no <code>relatorios/confs.txt</code>. Usando somente o find para encontrar os arquivos <code>"\*.conf"</code> será retornado todos os erros juntos e não será salvo em nenhum lugar. Para arrumar isso utilizamos o <code>1></code> para sobrescrever o documento confs.txt e redirecionar somente os corretos (já que 2> redireciona apenas erros).

Rodando os comandos de experimento na minha própria máquina, de forma simples, obtive os seguintes resultados:
    - find / -name "*.conf" > a.txt = todos os **caminhos** para os arquivos .conf são salvos em "a.txt" e os erros aparecem na tela
    - find / -name "*.conf" 2> b.txt = todos os **erros** são salvos em "b.txt" e os caminhos aparecem na tela
    - find / -name "*.conf" > c.txt 2>&1 = todos os **caminhos e erros** são salvos em "c.txt" e não aparece nada na tela

Caso eu quisesse enviar os documentos para o lixo, basta anexar mais um redirecionamento, com o comando ficando da seguinte forma: find / -name "*.conf" > a.txt 2>/dev/null

---

## M5 - Permissões

Cada arquivo tem dono (u), grupo (g) e outros (o), e cada um pode ter: 
    - leitura (r=4)
    - escrita (w=2)
    - execução (x=1)
O chmod 640 = dono rw (6), grupo r (4), outros nada (0). Em pastas o significado muda: 
    - r lista o conteúdo
    - w cria/apaga arquivos dentro
    - x permite entrar

#### chmod
> Serve para altera as permissões de arquivos e diretórios.
> Sintaxe geral: chmod [opções] MODO ARQUIVO...
> Modos de definir permissões:
    - Numérico = chmod 755 script.sh # rwxr-xr-x
        - 4 = read (r), 2 = write (w), 1 = execute (x) 
    - Simbólico = chmod u+x sript.sh # Adiciona execute só para o dono
        - u = owner, g = group, o = others e a = all. '+' = adiciona, '-' = remove e '=' = define exatamente, apaga as demais
> Opções famosas:
    - "-R" = Recursividade
    - "-v" = Verbose (mostra o que mudou em cada arquivo)
    - "--reference=ARQ" = Copia as permissões de outro arquivo
> Regra de ouro: 644 para arquivos, 755 para diretórios/scripts. 777 é praticamente sempre um erro de segurança. 

### M5A
Para o M5A basta trocar a permissão do arquivo para 600 com <code>chmod 600 config/banco.conf</code>. 

### M5B
Já o M5B, primeiramente precisamos adicionar um número ao owner no mesmo comando anterior, para que o dono possa executar o arquivo, ou seja, <code>chmod 700 ./scripts/backup.sh</code>. Isso indica que ele poderá executar, porém o script **SALVA** backups em algum lugar, e no diretório ./backups/, o owner não tinha poder para escrever (write), ou seja, não era possível colocar nenhum arquivo de backup na pasta. Por isso rodamos o comando <code>chmod 755 ./backups/</code> para alterar a permissão do owner no diretório.

#### umask

> Serve para definir as permissões que são removidas quando um novo arquivo ou diretório é criado. 
> Sintaxe geral: umask [-p] [-S] [mode]
    - [-p] = imprime na forma reutilizável como input (ex: umask 022)
    - [-S] = imprime em notação simbólica (exx: u=rwx,g=rx,o=rx)
    - [mode] = valor a definir, octal ou simbólico, se omitido só imprime o atual
> Atenção: no modo simbólico, o que você escreve é o que fica permitido (o complemento do que é mascarado).  É o inverso do octal: umask 077 = umask u=rwx,g=,o= (só o dono tem permissão).

A primeira vez que rodei um <code>umask</code>, me retornou o número "0002", achei estranho pois achei que existiam apenas o owner, group e others, mas na maioria das distros baseadas em Debian (isso inclui o Ubuntu) vem com algo chamado de **User Private Groups (UPG)**.
Cada usuário possuí um **grupo privado** com o mesmo nome (UID = GID), ou seja, o grupo "joao" só tem o "joao" como membro. A permissão ainda continua sendo com 3 digitos, mas a diferença está em:
- Sem UPG (modelo antigo):
    - owner:  joao
    - group:  devs  →  joao, maria, pedro (vários membros)
    - others: todo mundo

- Com UPG (Ubuntu/Debian moderno):
    - owner:  joao
    - group:  joao  →  só o joao (UID == GID)
    - others: todo mundo
Mas por quê o umask retornou 4 dígitos? O quarto dígito (o mais à esquerda) representa os **bits especiais**:
```
0 0 0 2
↑
└── setuid (4) + setgid (2) + sticky (1)
```

| Valor | Bit | Efeito |
|---|---|---|
| 4 | setuid | Executável roda com privilégio do owner |
| 2 | setgid | Executável roda com privilégio do group / diretório herda group |
| 1 | sticky | Só o dono pode apagar arquivos no diretório |
| 0 | nenhum | (meu caso) |

**Por que ele quase sempre é 0 no umask?** Porque o umask não opera sobre esses bits, ele só mascara rwx. O kernel ignora o primeiro dígito do umask na prática. O umask imprime 4 dígitos apenas para manter consistência com o formato de permissão do chmod/ls -l, que sim pode ter 4 dígitos (4755, 2775, 1777).
Resumo:
> chmod:   4 7 5 5   ← 4º dígito = bits especiais (setuid/sgid/sticky)
> umask:   0 0 0 2   ← 4º dígito = sempre 0 (não tem efeito)

### M5C
Para o M5C é necessário que criemos um arquivo com umask diferente do permanente, mas para isso devemos implementar de duas formas diferentes:
    - Com subshells <code>(...)</code> para isolar cada mudança:
        - (umask 077; touch arquivo.txt)
        - (umask 022; mkdir diretorio)
    - Com env em uma linha só:
        - env -C 077 touch arquivo.txt && env -C 022 mkdir diretorio
            - A opção '-C' é uma flag do env que define que uma umask é apenas para aquele processo
Neste caso optei por usar o comando com subshells, ficando da seguinte forma: <code>(umask 077; touch relatorios/secreto.txt)</code>

### M5D
Para criar um grupo novo utilizei o comando <code>sudo groupadd logistica</code>, e para criar o usuário usei o <code>sudo useradd -m -s /bin/bash -G logistica motorista</code> e <code>sudo passwd motorista</code>:

Dúvidas sobre o comando <code>sudo useradd -m -s /bin/bash -G logistica motorista</code>:
- Para que serve o '-m'?
    Significa 'make home', que cria automaticamente o home directory (/home/motorista) e copia os templates de "~/.bashrc", "~/.profile", etc. de "/etc/skel/." Sem o -m, o usuário fica sem home e ao logar, cai em / e não tem configurações de shell.
- Para que serve o '-s /bin/bash'?
    Define o shell de login do usuário. É o interpretador que roda quando ele faz login.
    | Shell | Uso típico |
    |---|---|
    | `/bin/bash` | Padrão para usuários interativos |
    | `/bin/sh` | Mais leve, POSIX |
    | `/usr/sbin/nologin` | **Impede login** (usado em contas de serviço) |
    Se você não especificar, o useradd usa o shell definido em "/etc/default/useradd" (geralmente /bin/sh). Usar /bin/bash explicitamente garante que o usuário tenha acesso a todas as features do bash (tab completion, [[ ]], arrays, etc.).
- Para que serve o '-G'?
    Adiciona o usuário a grupos adicionais (além do grupo primário). Pode listar vários, separados por vírgula: <code>sudo useradd -m -s /bin/bash -G logistica,devops motorista</code>
    
Agora, para adicionar um usuário **já existente** em um grupo, usamos o usermod da seguinte forma: <code>usermod -aG logistica diasz</code>

Dúvidas sobre o comando <code>usermod -aG logistica diasz</code>:
- Para que serve o usermod?
    Comando para modificar propriedades de um usuário já existente.
    - Flags:
        | Opção | Função |
        |---|---|
        | `-aG grupo` | **Adiciona** o usuário a grupos secundários (sem remover os existentes) |
        | `-G grupo1,grupo2` | **Substitui** toda a lista de grupos secundários |
        | `-g grupo` | Muda o **grupo primário** |
        | `-d /novo/caminho` | Muda o **home directory** |
        | `-d /novo -m` | Muda o home **e move** os arquivos de lá |
        | `-s /bin/zsh` | Muda o **shell** de login |
        | `-l novo_nome` | **Renomeia** o usuário (login) |
        | `-u 1005` | Muda o **UID** |
        | `-e 2026-12-31` | Define **data de expiração** da conta |
        | `-L` | **Trava** a conta (adiciona `!` na senha) |
        | `-U` | **Destrava** a conta |
        | `-c "Comentário"` | Atualiza o campo GECOS (nome completo, RAM, etc.) |
- Para que serve a flag '-aG'?
    É a mesma coisa, mas para usuários já existentes.
        > ATENÇÃO: o usermod precisa do -a (append). Sem ele, ele remove o usuário de todos os outros grupos e deixa só o novo. O useradd -G não tem esse risco porque o usuário ainda não pertence a nada.

#### Saber mais: 
```
- Para verificar os grupos de um usuário em específico basta rodar <code>id -Gn nome_usuário</code>
- Para trocar entre os usuários basta usar:
    - Trocar e voltar depois (sem logout)
        su - motorista
    - ... faz as coisas ...
        exit
- Para verificar os membros de cada grupo é só usar <code>getent group nome_grupo</code>
```

Próximo passo é criar a pasta que a missão pede e definir o dono e grupo, e para fazer isso usamos os seguintes comandos:
- # 1. Criar o diretório
    sudo mkdir -p /srv/logitrack-compartilhado

- 2. Definir dono e grupo
    sudo chown root:logistica /srv/logitrack-compartilhado

- 3. Permissões + setgid
    sudo chmod 2770 /srv/logitrack-compartilhado

#### chown
> Serve para alterar o dono e/ou grupo de um arquivo ou diretório.
> Sintaxe geral: sudo chown [OPÇÕES] DONO:GRUPO ARQUIVO...
> Formatos:
    | Formato | Efeito |
    |---|---|
    | `chown root:logistica /srv/logitrack` | Muda dono **e** grupo |
    | `chown root /srv/logitrack` | Muda só o dono (grupo fica igual) |
    | `chown :logistica /srv/logitrack` | Muda só o grupo (dono fica igual) |
    | `chown -R root:logistica /srv/logitrack` | **Recursivo** — aplica em tudo dentro |

Dúvidas sobre o processo:
- Para que serve o -p no mkdir?
    Cria todos os diretórios do caminho que não existirem. Se o caminho for /srv/a/b/c e /srv/a não existir, o mkdir falha. Com -p, cria a cadeia inteira. Também não dá erro se o diretório já existir.
- Por que o setgid foi adicionado?
    Sem setgid, quando o motorista cria um arquivo lá dentro, o arquivo herda o grupo primário dele (que é motorista, por UPG):
        # Sem setgid:
        -rw-rw-r-- 1 motorista motorista 0 ... nota.txt
        #                         ^^^^^^^^^
        #                         grupo do motorista, NÃO logistica
    Isso quebra o compartilhamento. O diasz (que está em logistica) não consegue ler/escrever o arquivo, porque a permissão de grupo logistica não se aplica e o arquivo pertence ao grupo motorista. Com setgid, o diretório "força" o grupo logistica em tudo que for criado dentro, e ambos consegue acessar via permissão do grupo logistica.

A segunda parte é criar o script para conseguir extrair as informações e jogar em um documento, e o .sh ficou da seguinte forma:

```
#!/usr/bin/env bash
cd "$(dirname "$0")/.."

DATA=$(date +%F)
RELATORIO="relatorios/diario-${DATA}.txt"

{
  echo "==== Relatório diário - Data: ${DATA} ===="
  echo ""

  # Contabiliza os erros no logs/app.log
  ERROS=$(grep -iwc "ERROR" logs/app.log)
  echo "- Total de linhas ERROR: ${ERROS}"

  # Total de pedidos entregues
  ENTREGUES=$(grep -cowi "entregue" logs/app.log)
  echo "- Total de entregas (status = entregue): ${ENTREGUES}"

  # Ranking dos 3 rastreios com mais erros
  echo "- Top 3 rastreios com mais erros:"
  grep -iw "ERROR" logs/app.log | grep -oE 'BR[0-9]{9}' | sort | uniq -c | sort -rn | head -3
} > "$RELATORIO"

echo "Relatorio '${RELATORIO}' criado."
```

Dúvidas:
- linha <code>#!/usr/bin/env bash</code>: shebang (hash + bang) e diz ao kernel qual programa interpretar o script.
    #!  /usr/bin/env  bash
    │   │             │
    │   │             └── O interpretador a procurar (bash)
    │   └── O programa que faz a busca no $PATH
    └──   Sinalizador: "a partir daqui é o caminho do interpretador"
- Linha <code>cd "$(dirname "$0")/.."</code>: Garante que o script funcione de qualquer diretório (vai para a raiz do lab)
- Linha <code>DATA=$(date +%F)</code>: Captura a data atual no formato AAAA-MM-DD


## Fechamento do dia

1. Qual a diferença entre <code>></code> e <code>>><code>? E o que 2>/dev/null faz?
    O caracatere ">" pega as saídas de um comando, e reescreve em outro arquivo. Já o ">>" apenas adiciona e não sobrepões o conteúdo antigo.
    "2>/dev/null" joga todos os erros da saída do comando para o lixo.
    
    - **Correção**: Certa. Só faltou um detalhe: > redireciona apenas a saída normal (canal 1). Por isso os erros continuam aparecendo na tela, e é por isso que o 2> existe. Vale também anotar que > cria o arquivo se ele não existir.

2. O que <code>chmod 750</code> significa, casa por casa?
    O comando chmod altera as permissões de um arquivo ou diretório, e neste caso, a primeira casa representa o "owner" que é a pessoa que tem o maior acesso (tirando o root) e o comando está tirando 7 pontos de permissão desse usuário, ou seja, ele não poderá fazer nada dentro do arquivo e/ou diretório.
    Já a segunda casa representa o "group", e como o próprio nome sugere, as permissões de grupos são aplicadas automaticamente a um conjunto de usuários, e neste caso o chmod está reduzindo 5 de permissão, deixando o grupo com apenas 2 ou 0 (dependendo do valor original).
    E por último, temos o terceiro dígito que representa o "others" ou todos os outros usuários. Neste caso o chmod não está alterando nenhum nível de permissão.

    - **Correção**: O chmod 750 não tira nada, ele define o valor final. Cada dígito é a soma de r=4, w=2 e x=1:
        7 = 4+2+1 = rwx: o dono tem tudo;
        5 = 4+1 = r-x: o grupo lê e executa (ou entra, se for pasta);
        0 = nada: os outros não têm acesso nenhum.
        
        Acho que você misturou com o umask, que é quem de fato subtrai. Essa associação é ótima para o caderno: chmod define, umask tira do padrão.

3. Por que **x** numa pasta é diferente de x num arquivo?
    O **x** dentro de um arquivo representa a capacidade dele ser executável, mas o mesmo não se aplica a diretórios já que eles não possuem tal capacidade. Por isso a permissão **x** é alterada de "execução" para "acessar a pasta".

    - **Correção**: Para completar, compare com o r: numa pasta, r = listar os nomes e x = entrar e acessar o que está dentro. Se você fez o experimento de tirar um e deixar o outro, anote o resultado. Ele mostra que dá para abrir um arquivo cujo nome você já sabe, mesmo sem conseguir listar a pasta.
    
4. Qual pipeline você usaria para achar o IP que mais aparece num log de acesso?
    Usaria um <code>grep -oE</code> para extrair os IPs a partir de um padrão, e depois usaria a sequência <code>sort | uniq -c | sort -rn | head -1</code> para organizar, contabilizar e rankear os IPS.

    - **Correção**: Certa. Faltou só a regex ('([0-9]{1,3}\.){3}[0-9]{1,3}') ou o atalho cut -d' ' -f1, porque em log de nginx/apache o IP é a primeira coluna.

5. Para que serve o setgid numa pasta compartilhada?
    O setgid é o bit especial que determina que o arquivo/diretório será "forçado" as permissões de grupo nele.

    - **Correção**: Vaga e um pouco desviada. O setgid numa pasta não força permissões, ele força o grupo. Todo arquivo criado lá dentro nasce com o grupo da pasta (logistica), e não com o grupo principal de quem criou. Você viu isso na prática: o motorista.txt saiu com grupo logistica, mas com a permissão rw-rw-r--, que veio do umask dele. Faltou também o porquê: sem o setgid, cada arquivo nasceria no grupo pessoal do criador, e o resto da equipe não conseguiria acessar.









