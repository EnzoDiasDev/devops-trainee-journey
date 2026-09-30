# Laboratório Linux — Dia 2
### Tema: o que está rodando na máquina · processos, sinais, systemd, logs e cron

Ontem você arrumou os **arquivos** do servidor da LogiTrack. Hoje o problema é o que está **rodando** nele: tem processo esquentando o notebook, processo que se recusa a morrer, processo que ressuscita e um token vazando para qualquer um ver. Depois você transforma o rastreador da empresa num serviço de verdade e agenda o relatório que escreveu ontem.

**Tempo estimado:** 4h, contando as anotações.

**Antes de começar (10 min, sem olhar nada):** responda de novo as 5 perguntas do fechamento do Dia 1. Depois confira.

---

## Como usar

```bash
bash setup-dia2.sh                    # pede sudo e já deixa processos rodando
cd ~/lab-linux/logitrack/dia2
bash verificar-dia2.sh                # confere o progresso
```

As respostas vão em `respostas-dia2.txt`. Se precisar recomeçar, rode o setup de novo: ele mata os processos antigos e sobe tudo do zero. Todos os processos de teste se encerram sozinhos depois de 3 horas, então nada fica rodando para sempre.

A regra continua: `tldr` e `man` antes das dicas.

---

## Missão 1 · Quem está rodando aqui? (≈1h)

**Conceito.** Todo programa em execução é um **processo**, com um número (PID), um dono (usuário) e um pai (PPID, o processo que o criou). Para pedir que um processo pare, você manda um **sinal**. `kill` não "mata": ele manda um sinal, por padrão o SIGTERM (15), que é um pedido educado. O processo pode tratar esse pedido ou até ignorar. O SIGKILL (9) não pode ser ignorado: o próprio kernel encerra o processo, sem dar chance de ele salvar nada.

**Investigue:** `ps aux`, `ps -ef`, `ps -o pid,ppid,user,%cpu,args -p PID`, `pgrep -a`, `pstree -p`, `top` (ou `htop`), `kill`, `kill -l`, `pkill`.

**1A · O notebook está esquentando.** Um processo da LogiTrack está consumindo um núcleo inteiro de CPU. Descubra qual e encerre. Em `M1A=`, coloque o nome dele (só o nome, sem o caminho e sem o `bash` da frente).

**1B e 1C · Vazamento na linha de comando.** O processo `logitrack-coletor` está rodando com outro usuário e recebeu um token de acesso pela linha de comando. Em `M1B=`, coloque o usuário que roda o coletor. Em `M1C=`, coloque o token. **Não encerre o coletor**, é só investigação.

Para o caderno: se você, com seu usuário comum, conseguiu ver o token de outro usuário, o que isso diz sobre passar senha como argumento de comando? Compare com o `rastreador.conf` que você vai ver na Missão 3.

**Teimoso.** O `logitrack-teimoso` ignora o `kill` normal. Encerre mesmo assim.

**1D · O processo que ressuscita.** Mate o `logitrack-worker`, espere 3 segundos e procure de novo. Ele voltou, com outro PID. Descubra quem está recriando o worker e resolva de vez. Em `M1D=`, coloque o nome do processo responsável.

**Experimentos (é aqui que fixa):**
- No `top`, a coluna de comando mostra só `bash` para todos os processos da LogiTrack. Aperte `c` e veja o que muda. Aperte `P` e `M` para ordenar.
- Tente dar `kill` no coletor com o seu usuário. Qual mensagem aparece? Por quê?
- Na 1D, anote o PPID do worker **antes** e **depois** de matar o pai. Para quem o worker "foi adotado"? Rode `ps -p 1` para ver quem é esse processo.
- `kill -l` lista todos os sinais. Ache o SIGHUP e o SIGINT. Qual deles o Ctrl+C manda?

<details><summary>Dica 1A</summary>

`ps aux --sort=-%cpu | head` ou `top`. O `kill` pede o PID; o `pkill -f` aceita um pedaço do comando.
</details>
<details><summary>Dica 1B/1C</summary>

`ps aux` mostra o usuário na primeira coluna e o comando completo, com argumentos, na última. `pgrep -a coletor` também serve.
</details>
<details><summary>Dica teimoso</summary>

Se o pedido educado (15) não funciona, qual sinal não pode ser ignorado?
</details>
<details><summary>Dica 1D</summary>

`ps -o ppid= -p PID_DO_WORKER` mostra quem é o pai. `pstree -p` mostra a árvore inteira. Pense na ordem: se você matar o filho antes do pai, o que o pai faz?
</details>

---

## Missão 2 · Primeiro e segundo plano (≈15 min, sem verificação)

**Conceito.** Um comando no terminal roda em **primeiro plano** e prende o prompt até terminar. Com `&` no final ele vai para o **segundo plano** e o prompt fica livre. Esses processos são os "jobs" daquele terminal.

**Experimentos:**
1. Rode `~/lab-linux/logitrack/scripts/gerar-log.sh`. Aperte **Ctrl+Z**. Rode `jobs`. O que aconteceu com ele?
2. Rode `bg`, depois `jobs` de novo. Rode `fg` e encerre com Ctrl+C.
3. Rode `sleep 600 &`, feche o terminal inteiro e, num terminal novo, rode `pgrep -a sleep`. O processo sobreviveu?
4. Repita com `nohup sleep 600 &`. E agora?

Para o caderno: por que o sleep do item 3 morreu? (Olhe o nome do sinal SIGHUP: "hang up", desligar o telefone.) É por isso que o setup de hoje usou `nohup`, e é por isso que em servidor de verdade ninguém sobe serviço com `&`, e sim com systemd, que vem agora.

---

## Missão 3 · Um serviço de verdade com systemd (≈1h15)

**Conceito.** O **systemd** é o processo PID 1 da máquina (você o viu na 1D). Ele sobe e vigia os serviços. Cada serviço é descrito por um arquivo de texto chamado **unit**, que fica em `/etc/systemd/system/`. Com ele o processo sobe no boot, roda com o usuário certo, reinicia se cair e manda os logs para o journal. Tudo isso que o `&` não faz.

**Investigue:** `systemctl status`, `start`, `stop`, `restart`, `enable`, `disable`, `daemon-reload`, `is-active`, `is-enabled`, `cat`; e `man systemd.service` (procure por `Restart=`).

Antes de escrever o seu, leia uma unit de verdade: `systemctl cat cron` ou `systemctl cat ssh`. Anote o que é cada seção.

**Objetivo.** Transforme `/opt/logitrack/servicos/rastreador.sh` num serviço chamado `logitrack-rastreador` que:
- roda como o usuário `motorista`, e não como root;
- reinicia sozinho se cair;
- sobe automaticamente no boot;
- está rodando agora.

Tem um problema escondido: o serviço não vai subir de primeira, e o motivo está nos logs, não na tela. Conserte **sem deixar a configuração aberta para outros usuários**. O Dia 1 te deu a ferramenta certa para isso.

**Experimentos:**
- Com o serviço rodando, pegue o PID dele em `systemctl status` e mande um SIGKILL. Espere alguns segundos e rode `status` de novo. O PID mudou? Compare com o `sleep &` da Missão 2.
- Rode `sudo systemctl stop logitrack-rastreador`. Ele volta sozinho? Por que o `stop` é diferente do kill? (Pista: é o `on-failure`.)
- `systemctl list-units --type=service --state=running`: quantos serviços sua máquina está rodando agora? Reconhece algum?

<details><summary>Dica 1: onde e como</summary>

O arquivo vai em `/etc/systemd/system/logitrack-rastreador.service` (precisa de sudo para criar). Uma unit simples tem três seções: `[Unit]` (descrição), `[Service]` (o que rodar e como) e `[Install]` (quando subir no boot).
</details>
<details><summary>Dica 2: as chaves que você precisa</summary>

Em `[Service]`: `ExecStart=`, `User=`, `Restart=`, `RestartSec=`. Em `[Install]`: `WantedBy=multi-user.target`. Toda vez que editar a unit, rode `sudo systemctl daemon-reload`. O `enable --now` habilita e já inicia de uma vez.
</details>
<details><summary>Dica 3: não sobe</summary>

`journalctl -u logitrack-rastreador -n 30` mostra os últimos logs do serviço. A mensagem diz qual arquivo o motorista não conseguiu ler. Quem é dono dele? Em que grupo o motorista está? Se aparecer "start request repeated too quickly", o systemd desistiu de tentar: rode `sudo systemctl reset-failed logitrack-rastreador` depois de consertar.
</details>

---

## Missão 4 · Lendo os logs do sistema (≈30 min)

**Conceito.** Serviços do systemd mandam tudo que imprimem para o **journal**, lido com `journalctl`. Muita coisa também vai para arquivos texto em `/var/log`. Quando alguma coisa quebra num servidor, a primeira pergunta é sempre: o que o log diz?

**Investigue:** `journalctl -u`, `-f`, `-n`, `--since`, `-p err`, `-b`; `ls -lh /var/log`.

**4A.** Quando o rastreador sobe com sucesso, ele imprime um código de turno. Coloque o código em `M4A=`.

**Experimentos:**
- `journalctl -u logitrack-rastreador -f`: deixe aberto e veja os ciclos chegando ao vivo. É o `tail -f` do Dia 1, mas para serviços.
- `journalctl -u logitrack-rastreador --since "15 min ago"` e `journalctl -p err -b`: o que cada um filtra?
- **Auditoria:** ontem você rodou `sudo usermod -aG logistica diasz`. Ache esse registro com `sudo grep usermod /var/log/auth.log`. Que informações o sistema guardou sobre o que você fez? (Em servidor de empresa, é assim que se descobre quem mexeu no quê.)
- Em `ls /var/log`, repare em arquivos como `syslog.1` e `auth.log.2.gz`. O que você acha que são? Pesquise "logrotate" e ligue com o backup do Dia 1.

<details><summary>Dica 4A</summary>

`journalctl -u logitrack-rastreador | grep -i turno`. Se não aparecer nada, o serviço ainda não subiu direito: volte à Missão 3.
</details>

---

## Missão 5 · Automatizando com cron (≈45 min)

**Conceito.** O **cron** roda comandos em horários agendados. Cada usuário tem sua própria tabela de tarefas (o crontab), editada com `crontab -e`. Cada linha tem 5 campos de tempo e depois o comando:

```
minuto  hora  dia-do-mês  mês  dia-da-semana   comando
```

O site crontab.guru traduz uma expressão cron para português claro e ajuda a conferir.

**Objetivo.** Agende o seu `relatorio-diario.sh` do Dia 1 para rodar **às 07:00, de segunda a sexta**, mandando a saída **e os erros** para `~/lab-linux/logitrack/logs/cron.log`.

**Faça em duas etapas.** Primeiro agende para **todo minuto** e acompanhe com `tail -f` no `cron.log`. Só depois de ver funcionando, troque para o horário definitivo. É assim que se testa cron no mundo real: ninguém espera até as 7h para descobrir que deu errado.

**Aviso de pegadinha.** O cron não roda o seu script como você roda no terminal. Ele não passa pelo seu `.bashrc` (repare que o `(base)` do conda some), usa um PATH mínimo e começa na sua home, não na pasta do lab. Se o `cron.log` mostrar erro, a causa está nessa frase.

**Extra:** agende também uma limpeza diária às 23:30 que apaga os backups `.tar.gz` com mais de 7 dias em `backups/`. Rode o `find` **sem** o `-delete` primeiro para ver o que ele apagaria. Apagar com cron sem testar é a forma clássica de perder dado.

<details><summary>Dica 1</summary>

Todo minuto é `* * * * *`. Para o definitivo, dia da semana: 0 é domingo, e intervalos se escrevem com hífen.
</details>
<details><summary>Dica 2: deu erro no cron.log</summary>

Use caminhos absolutos em tudo: no crontab para chamar o script e dentro do script para achar o `app.log`. O `>> arquivo 2>&1` do Dia 1 é o que joga saída e erro no log.
</details>
<details><summary>Dica extra</summary>

`find CAMINHO -name "*.tar.gz" -mtime +7`. Para testar sem esperar 7 dias, crie um arquivo "velho" com `touch -d "10 days ago" backups/backup-teste.tar.gz`.
</details>

---

## Fechamento do dia (≈15 min)

Sem olhar nada, responda no caderno:
1. Qual a diferença entre SIGTERM e SIGKILL, e por que você tenta o TERM primeiro?
2. O que acontece com um processo filho quando o pai morre?
3. Por que subir um serviço com `&` é pior do que com systemd? Cite três motivos.
4. Onde você olha primeiro quando um serviço não sobe?
5. Escreva de cabeça a linha de cron para "toda segunda às 9h30".

Amanhã, antes do Dia 3, os 10 minutos de sempre: tente responder de novo.

**Não desfaça nada ainda.** O serviço, o motorista e o cron voltam no Dia 3, que é redes e um desafio final de troubleshooting juntando os três dias. A limpeza completa vem no fim dele.
