# Status page

> **Tema:** incidentes
> **Origem:** gestor
> **Iniciado em:** 2026-09-30
> **Status:** 🟢 Concluído <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->

## Em minhas palavras

**O que é?**
Status page é uma página pública que informa aos usuários se está tudo bem com aquela aplicação, se houve alguma instabilidade/quebra, comunica o que está acontecendo/quando volta e serve como um **histórico de incidentes**.

**Para que serve?**
- Reduzir caos no suporte
- Transparência e confiança com o cliente
- Deixar um histórico de incidentes
- *Organiza a comunicação durante crises*
    > Enquanto os engenheiro corrigem o problema, alguém precisa realizar o comunicado e atualizar a página. "Consertar" e "Comunicar" devem acontecer em paralelo.

**O que tem dentro?**
Normalmente é dividida em quatro partes:
- **LISTA DE COMPONENTES**: divide o serviço em pedaços (API, login, pagamentos, banco de dados, ...), pois raramente "tudo" caí.
- **ESTADOS DOS COMPONENTES**:
    - Operational: Funcionando (verde)
    - Degraded performance: Funciona, mas está lento ou instável (amarelo)
    - Partial outage: Parte dos usuários ou das funções está fora do ar (laranja)
    - Major outage: Fora do ar (vermelho)
    - Under maintenance: Parado de propósito, manutenção planejada (azul)
- **LINHA DO TEMPO**: atualização de cada problema que costumam passar por fases
    - Investigating: "Percebemos que algo está errado e estamos investigando"
    - Identified: "Achamos a causa"
    - Monitoring: "Aplicamos a correção e estamos observando se resolveu"
    - Resolved: "Resolvido"
- **HISTÓRICO DE DISPONIBILIDADE**: barrinhas dos últimos 90 dias e um botão de "subscribe" para receber notificações por e-mail, slack, ... sem precisar ficar abrindo a status page.

**Termos da área**
- Uptime / downtime: tempo em que o sistema está no ar / fora do ar. "Tivemos 20 minutos de downtime ontem."
- Outage: a queda em si. No dia a dia, as pessoas dizem "caiu", "tá fora", "tá fora do ar".
- **Incidente**: qualquer evento que atrapalha o serviço e exige resposta. Nem todo incidente é uma queda total. Lentidão também conta.
- Os "noves": forma de falar de disponibilidade. "Três noves" é 99,9% no ar, o que parece muito, mas permite cerca de 43 minutos fora por mês. "Quatro noves" (99,99%) permite só uns 4 minutos por mês. Cada nove a mais custa bem mais caro de garantir.
- SLO (Service Level Objective): a meta interna do time, geralmente mais rígida que o SLA, para ter margem de segurança.
- SLI (Service Level Indicator): a métrica que você mede de fato, como a porcentagem de requisições que responderam com sucesso. Para lembrar a relação: o SLI é o que você mede, o SLO é o que você mira, o SLA é o que você promete.
- MTTR (Mean Time To Recovery/Resolve): tempo médio para resolver um incidente. MTTD é o tempo médio para *detectar* que ele começou.
- **Health check**: um teste automático que pergunta ao sistema "você está vivo?", normalmente acessando uma URL como /health. É isso que alimenta a status page automática.
- Flapping: quando o status fica alternando entre "no ar" e "fora" sem parar, o que gera alarme falso em cadeia.
- On-call / plantão: o engenheiro escalado para ser acionado se algo quebrar fora do horário, inclusive de madrugada. "Tô de plantão essa semana."
- **SEV1, SEV2… (ou P1, P2…)**: níveis de gravidade do incidente. SEV1 é "tudo pegando fogo, chama todo mundo"; números maiores são menos graves.
- Rollback: voltar para a versão anterior quando uma atualização causou problema. Costuma ser a forma mais rápida de estancar um incidente.
- Hotfix: correção urgente, feita às pressas para resolver um problema em produção.
- Blast radius: o "raio da explosão", ou seja, quantos usuários ou sistemas foram afetados.
- Postmortem (ou RCA, Root Cause Analysis): o documento escrito depois do incidente explicando o que aconteceu, por que aconteceu e o que muda para não repetir. Boas empresas fazem postmortems "sem culpados" (blameless): o foco é no processo que falhou, não na pessoa.

## Analogia

Pense no painel de voos do aeroporto. Você não precisa ir ao balcão perguntar "meu voo atrasou?", porque o painel já mostra: no horário, atrasado, cancelado, embarcando. A status page faz isso para sistemas. Em vez de milhares de clientes abrirem chamado perguntando "o site de vocês caiu?", eles abrem a página e veem a resposta.

## Referências

- [Status page do Github](githubstatus.com)
- [Status page da AWS](health.aws.amazon.com)
- [Status page do Claude](status.claude.com)
