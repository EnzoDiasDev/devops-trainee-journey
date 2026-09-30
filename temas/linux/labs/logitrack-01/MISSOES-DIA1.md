# Laboratório Linux — Dia 1 (sábado, 26/09)
### Tema: o servidor da LogiTrack · arquivos, busca, texto, redirecionamento e permissões

A LogiTrack é uma empresa de logística fictícia (sim, parente da sua automação dos Correios). Você acabou de entrar no time e herdou um servidor bagunçado: arquivos escondidos, logs enormes, permissões erradas e um script de backup que não funciona. Seu trabalho é investigar e consertar.

**Tempo estimado:** 4h a 4h30, contando as anotações.

---

## Como usar

```bash
bash setup-dia1.sh          # cria o lab em ~/lab-linux/logitrack
cd ~/lab-linux/logitrack
bash verificar.sh           # rode quantas vezes quiser para ver o progresso
```

As respostas das missões 1 a 3 vão em `respostas.txt`. As missões 4 a 6 o verificador confere olhando o estado do sistema. Se quebrar tudo, rode o setup de novo e ele recria do zero.

**Duas ferramentas para ter aberto o tempo todo:** `man comando` (manual oficial; `/palavra` busca dentro, `q` sai) e `tldr comando` (exemplos práticos, instale com `sudo apt install tldr`). A regra do dia: antes de abrir as dicas, tente `tldr` e `man`. Aprender a se virar com o manual é metade do trabalho de DevOps.

## O caderno

Crie uma pasta `~/estudos-devops/` e um arquivo `linux.md` dentro dela. Anote **depois** de testar, nunca copiando da documentação. Um modelo que funciona bem:

```markdown
## chmod
**O que faz (com minhas palavras):**
**Comando que eu rodei e o que aconteceu:**
**Onde isso aparece no mundo real:**   (ex: chave SSH com permissão errada)
**Onde eu errei / o que me surpreendeu:**
**Dúvida que ficou:**
```

A linha "onde eu errei" é a mais valiosa do caderno. Quando der, faça `git init` nessa pasta e um commit no fim de cada dia: você chega no bloco de Git já com um repositório seu.

---

## Missão 1 · Reconhecimento (≈20 min)

**Conceito.** No Linux tudo começa em `/` (a raiz). Arquivos e pastas cujo nome começa com `.` ficam ocultos no `ls` comum. `.` é a pasta atual e `..` é a pasta de cima.

**Investigue:** `pwd`, `ls`, `ls -l`, `ls -la`, `cd`, `cat`, `tree -a` (se tiver).

**Objetivo.** Existe um arquivo oculto dentro de `app/` com um código. Coloque o código em `M1=`. Cuidado: existe mais de um arquivo oculto ali.

**Para o caderno.** Rode `ls /` e escreva, com suas palavras, para que servem `/etc`, `/var`, `/home`, `/tmp`, `/usr/bin` e `/srv`. (Você vai usar `/var/log` amanhã e `/srv` hoje.)

**Experimento.** Qual a diferença entre `ls -la` e `ls -lA`? E entre `cd`, `cd -` e `cd ~`?

<details><summary>Dica 1</summary>

`ls -la` mostra ocultos, mas só da pasta atual. Você precisa entrar nas pastas ocultas também.
</details>
<details><summary>Dica 2</summary>

O `find` procura recursivamente: `find app -name ".*"`.
</details>

---

## Missão 2 · Agulha no palheiro (≈30 min)

**Conceito.** `find` percorre pastas procurando por nome, tipo, tamanho, data, dono. É um dos comandos que você mais vai usar em servidor.

**Investigue:** `find` com `-name`, `-type`, `-size`, `-mtime`; `wc -l`; `du -sh`.

**Objetivos.**
- `M2A=` o nome (só o nome, sem caminho) do único arquivo maior que 500 KB em todo o `logitrack`.
- `M2B=` quantos **arquivos** `.csv` existem dentro de `entregas/`, incluindo os ocultos.

Tem pegadinha escondida no M2B. Se o seu número não bater, desconfie do que o `find` está contando.

**Experimento.** `du -sh entregas/2026/*` mostra o quê? Compare com `ls -lh`. Por que `ls -l` numa pasta mostra 4.0K e não o tamanho real do conteúdo?

<details><summary>Dica 1 (M2A)</summary>

`find . -size +500k`. Leia no `man find` o que significam `+`, `-` e as letras `k`, `M`.
</details>
<details><summary>Dica 2 (M2B)</summary>

Uma "coisa" com nome terminado em `.csv` nem sempre é um arquivo. Veja a opção `-type f`. E o `find` enxerga ocultos por padrão, diferente do `ls`.
</details>

---

## Missão 3 · Lendo log como sysadmin (≈45 min)

**Conceito.** Pipe (`|`) liga a saída de um comando na entrada do próximo. Com meia dúzia de comandos pequenos encadeados você responde perguntas sobre milhares de linhas. É assim que se investiga incidente de verdade.

**Investigue:** `head`, `tail`, `less`, `grep` (`-c`, `-i`, `-v`, `-o`, `-E`), `cut`, `sort`, `uniq -c`, `wc -l`.

**Objetivos** (em `logs/app.log`):
- `M3A=` quantas linhas são de **nível** ERROR.
- `M3B=` qual código de rastreio (formato `BR` + 9 dígitos) aparece em mais linhas de nível ERROR.

**Experimento ao vivo.** Abra dois terminais. No primeiro: `tail -f logs/ao-vivo.log`. No segundo: `./scripts/gerar-log.sh`. Depois tente filtrar ao vivo só os erros: `tail -f logs/ao-vivo.log | grep ERROR`. Isso é exatamente o que você vai fazer olhando log de container no bloco de Docker.

<details><summary>Dica 1 (M3A)</summary>

Compare `grep -c ERROR` com `grep -c '\[ERROR\]'`. Por que dão números diferentes? Abra o log e procure linhas que contêm a palavra ERROR mas não são de nível ERROR.
</details>
<details><summary>Dica 2 (M3B)</summary>

A receita clássica de "o que mais aparece": `... | sort | uniq -c | sort -nr | head`. Falta você descobrir como isolar só o código de rastreio antes (`grep -o` com uma expressão ou `cut -d`).
</details>

---

## Missão 4 · Redirecionamento (≈20 min)

**Conceito.** Todo programa tem três canais: entrada (0, stdin), saída normal (1, stdout) e saída de erro (2, stderr). `>` sobrescreve, `>>` acrescenta, `2>` redireciona só os erros, `2>&1` junta erro com saída, `/dev/null` é o lixo.

**Objetivo.** Rode um `find` pelo sistema inteiro atrás de arquivos `*.conf`. Ele vai despejar um monte de "Permissão negada". Salve **só os resultados válidos** em `relatorios/confs.txt`, sem nenhuma linha de erro misturada.

**Experimento.** Rode as três versões e compare o que aparece na tela e no arquivo:
`find / -name "*.conf" > a.txt` · `find / -name "*.conf" 2> b.txt` · `find / -name "*.conf" > c.txt 2>&1`

<details><summary>Dica</summary>

Você quer que o canal 1 vá para o arquivo e o canal 2 vá para o lixo.
</details>

---

## Missão 5 · Permissões (≈1h30, a mais importante do dia)

**Conceito.** Cada arquivo tem dono (u), grupo (g) e outros (o), e cada um pode ter leitura (r=4), escrita (w=2) e execução (x=1). `chmod 640` = dono rw (6), grupo r (4), outros nada (0). Em **pastas** o significado muda: `r` lista o conteúdo, `w` cria/apaga arquivos dentro, `x` permite entrar.

Antes de começar, faça `ls -l config/ scripts/` e `ls -ld backups/` e traduza cada permissão para o caderno.

**5A · Senha exposta.** `config/banco.conf` tem senha (falsa) e está com permissão 777: qualquer usuário da máquina lê e altera. Deixe só o dono lendo e escrevendo.

**5B · O backup que não funciona.** Rode `./scripts/backup.sh`. Não vai funcionar, e o motivo vai mudar conforme você conserta. Resolva até o backup ser criado em `backups/`. Regra: o script deve ficar executável e **ninguém além do dono** pode ter permissão de escrita nele (script que outros podem editar é porta de entrada para ataque).

**5C · umask.** Rode `umask`, crie um arquivo e uma pasta e veja as permissões que nasceram. Escreva no caderno a conta que explica esses números. Depois, sem mudar seu umask permanente, crie `relatorios/secreto.txt` já nascendo com permissão 600.

**5D · Pasta compartilhada da equipe (precisa de sudo).**
1. Crie o grupo `logistica` e o usuário de teste `motorista`, e coloque você e ele no grupo.
2. Crie `/srv/logitrack-compartilhado` pertencente a `root:logistica`, onde só dono e grupo têm acesso total, e onde todo arquivo criado lá dentro herda o grupo `logistica` automaticamente.
3. Crie um arquivo lá dentro **como o motorista** e confira que o grupo foi herdado.

Seu próprio usuário só "ganha" o grupo novo depois de um novo login. Teste `id` antes e depois de rodar `newgrp logistica` e anote o que mudou.

**Experimentos (quebre de propósito, é aqui que fixa):**
- Crie uma pasta com um arquivo dentro. Tire o `r` da pasta e mantenha o `x`. Você consegue dar `ls` nela? E `cat pasta/arquivo`? Agora o inverso: `r` sem `x`.
- Tire sua própria permissão de leitura de um arquivo seu (`chmod 000`). Você ainda consegue devolver a permissão? Por quê?
- `chmod u+x`, `chmod g-w`, `chmod o=` fazem o mesmo que os números. Quando você usaria cada forma?

<details><summary>Dica 5B</summary>

Leia a mensagem de erro com calma: ela diz qual arquivo ou pasta foi o problema. Primeiro é o script, depois é o destino do backup. Lembre o que `w` significa numa pasta.
</details>
<details><summary>Dica 5C</summary>

O umask "tira" permissões do padrão (666 para arquivos, 777 para pastas). Rodar comandos entre parênteses cria um subshell: o que mudar ali não vaza para o seu terminal.
</details>
<details><summary>Dica 5D</summary>

Comandos: `groupadd`, `useradd -m`, `usermod -aG` (o `-a` é crucial, descubra por quê no man), `chown`, `chmod`, `sudo -u motorista comando`. O bit que faz herdar o grupo se chama **setgid** e vale 2 na casa extra da frente (ex: `2770`).
</details>

---

## Missão 6 · Seu primeiro script de verdade (≈45 min)

Junte tudo. Crie `scripts/relatorio-diario.sh` que gera `relatorios/diario-AAAA-MM-DD.txt` (data do dia) contendo pelo menos:
- total de linhas ERROR do `app.log`
- total de entregas com `status=entregue`
- os 3 rastreios com mais erros

Ele precisa começar com shebang (`#!/usr/bin/env bash`) e ser executável. Nada de copiar script pronto: são os mesmos comandos das missões 3 e 4, só que num arquivo.

**Extra (se sobrar tempo):** use variáveis para o caminho do log e para a data (`$(date +%F)`), e faça o script funcionar de qualquer pasta que você esteja.

---

## Fechamento do dia (≈15 min)

Sem olhar nada, responda no caderno:
1. Qual a diferença entre `>` e `>>`? E o que `2>/dev/null` faz?
2. O que `chmod 750` significa, casa por casa?
3. Por que `x` numa pasta é diferente de `x` num arquivo?
4. Qual pipeline você usaria para achar o IP que mais aparece num log de acesso?
5. Para que serve o setgid numa pasta compartilhada?

Depois compare com suas anotações e marque o que errou. **Amanhã, antes de começar o Dia 2, gaste 10 minutos tentando responder de novo** sem olhar. Esse esforço de lembrar é o que transforma anotação em memória.

Não apague o usuário `motorista` nem o grupo: eles voltam no Dia 2 (processos e serviços). A limpeza fica para segunda à noite.
