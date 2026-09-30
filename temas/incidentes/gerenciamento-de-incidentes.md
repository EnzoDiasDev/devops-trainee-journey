# Gerenciamento de incidentes

> **Tema:** incidentes
> **Origem:** gestor
> **Iniciado em:** 2026-09-30
> **Status:** 🟢 Concluído <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->

## Em minhas palavras

**O que é?**
Gerenciamento de incidentes é a forma **organizada** que um time lida com um problema em produção. Geralmente segue um fluxo:
> Detectar o problema -> Fazer a triagem -> Mobilização da equipe -> Mitigação de danos -> Resolução do problema -> Postmortem

**Para que serve?**
Sem processo um incidente vira bagunça. O processo existe para que, no momento de maior pressão, ninguém precise improvisar como agir, só o que fazer tecnicamente. Exemplo:
> Dez pessoas entram na mesma call, todas investigando a mesma coisa, ninguém sabe quem decide, duas pessoas aplicam correções diferentes ao mesmo tempo e pioram o problema, e enquanto isso ninguém avisou os clientes.

**Ciclo de vida de um incidente**
1. *Detecção* = Alguém ou alguma coisa percebe o problema. O ideal é que seja o monitoramento, com um alerta automático. O pior cenário é descobrir pelo cliente reclamando no Twitter.
2. *Triagem* = Avaliar a gravidade e decidir quem precisa ser chamado. É aqui que se define o nível de severidade (os SEV1, SEV2, ...). Um exemplo típico de escala: 
    - SEV1 é o sistema principal fora para todo mundo; 
    - SEV2 é uma função importante quebrada ou muita gente afetada; 
    - SEV3 é algo incômodo com contorno disponível; 
    - SEV4 é um problema menor que pode esperar o horário comercial.
3. *Mitigação* = Fazer o impacto parar, mesmo que a causa ainda seja desconhecida. Este é o princípio mais importante da área e costuma surpreender iniciantes: primeiro estanca, depois investiga. Se um deploy de 10 minutos atrás coincide com a queda, você faz rollback agora e descobre o bug depois. Reiniciar um serviço, desviar tráfego, desligar uma funcionalidade: tudo vale para o usuário voltar a ser atendido.
4. *Resolução* = Corrigir de verdade a causa, confirmar que o sistema está estável e declarar o incidente encerrado.
5. *Pós-incidente* = Escrever o postmortem, identificar o que falhou no processo (não "quem errou") e gerar tarefas concretas de melhoria. Um incidente sem aprendizado é só dor desperdiçada.

**Papéis durante um incidente**
- **O Incident Commander (IC)** é o coordenador = Ele não conserta nada com as próprias mãos. Ele organiza, decide prioridades, distribui tarefas e evita que todo mundo faça a mesma coisa. Parece estranho no começo, mas é justamente por não estar com a cabeça enfiada no código que ele consegue enxergar o quadro geral.
- **O Tech Lead e os especialistas** (chamados de SMEs, Subject Matter Experts) são quem investiga e aplica as correções.
- **O Communications Lead** cuida da comunicação: atualiza a status page, avisa o suporte, a liderança e os clientes.
- **O Scribe** (escriba) anota tudo o que acontece com horário: quem fez o quê, quando, o que foi tentado. Essa linha do tempo é ouro na hora de escrever o postmortem.

**Incidente != Problema**
Essa distinção vem do ITIL, um conjunto de boas práticas de gestão de TI muito usado em grandes empresas.
- O *incidente* é o incêndio de agora: "a API está fora".
- O *problema* é a causa de fundo que pode gerar vários incidentes: "o disco do servidor enche toda semana porque ninguém configurou rotação de logs".
Gerenciamento de incidentes apaga o fogo; gerenciamento de problemas tira o material inflamável dali.

**Ferramentas comuns**
Você vai esbarrar em ferramentas de alerta e plantão, como **PagerDuty** e **incident.io**, que acordam a pessoa certa quando algo quebra e organizam as escalas. Também são comuns ferramentas de chamados como o **Jira Service Management**, e muitas empresas criam automaticamente um canal no **Slack** ou **Teams** para cada incidente, onde toda a conversa fica registrada.

**Termos da área**
- Page / ser pingado / ser acionado: receber o alerta que exige resposta imediata, muitas vezes por ligação ou notificação insistente no celular. "Fui pingado às 3 da manhã." O nome vem dos antigos pagers (bipes).
- **Ack (acknowledge)**: confirmar que você viu o alerta e assumiu. Se ninguém dá ack em alguns minutos, o sistema chama a próxima pessoa da lista.
- MTTA (Mean Time To Acknowledge): tempo médio entre o alerta disparar e alguém assumir. Complementa o MTTD e o MTTR.
- Escalation / escalar: chamar alguém mais experiente ou de outro time quando você não consegue resolver sozinho. Escalar não é fracasso; demorar demais para escalar é que é.
- **Runbook / playbook**: um passo a passo documentado de como agir num tipo específico de problema. "Se a fila de mensagens travar, siga o runbook X." Bons runbooks permitem que alguém que nunca viu o problema resolva às 3 da manhã.
- Workaround / contorno: uma solução provisória que evita o impacto sem corrigir a causa. É a "gambiarra oficial e consciente", com data para ser substituída.
- Stop the bleeding: "estancar o sangramento", o princípio de mitigar antes de investigar.
- Apagar incêndio / firefighting: trabalhar reagindo a problemas em vez de construir coisas. Um time que só apaga incêndio está com algum problema estrutural.
- **Alert fatigue / fadiga de alertas**: quando há tantos alertas, muitos falsos, que as pessoas passam a ignorá-los. É perigosíssimo, porque o alerta verdadeiro se perde no meio do ruído. Por isso se fala em reduzir ruído (*noise*).
- Toil: trabalho manual, repetitivo e que não gera valor duradouro, como reiniciar o mesmo serviço toda semana na mão. O objetivo é automatizar o toil.
- Handoff / handover: passar o incidente (ou o plantão) para outra pessoa, explicando o contexto. Um handoff mal feito faz o próximo recomeçar do zero.
- Action items: as tarefas de melhoria que saem do postmortem, cada uma com responsável e prazo.
- Blameless: "sem culpados". A cultura de analisar falhas focando no sistema e no processo, e não em punir a pessoa. Se alguém derrubou produção com um comando, a pergunta certa é "por que foi possível derrubar produção com um único comando?".
- 5 porquês: técnica simples de investigação em que você pergunta "por quê?" repetidamente até chegar na causa raiz. O site caiu. Por quê? O disco encheu. Por quê? Os logs cresceram sem limite. Por quê? Não havia rotação configurada. E assim por diante.
- Near miss / quase-incidente: algo que quase causou um incidente, mas não chegou a afetar ninguém. Times maduros analisam isso também, porque é aprendizado de graça.
- **Error budget**: a "cota de falha" permitida pelo SLO. Se a meta é 99,9%, você tem uns 43 minutos por mês para "gastar" com falhas. Se o orçamento acabar, o time costuma frear lançamentos e focar em estabilidade.
- **Change freeze / code freeze**: período em que ninguém pode subir mudanças em produção, comum em datas críticas como Black Friday, já que boa parte dos incidentes nasce de mudanças.
- Game day / chaos engineering: quebrar o sistema de propósito, de forma controlada, para treinar o time e descobrir fragilidades antes que elas apareçam sozinhas.

## Analogia

A melhor analogia é um pronto-socorro. Quando chega um paciente grave, a equipe não para para descobrir a origem de tudo. Primeiro faz a triagem ("quão grave é?"), depois estabiliza o paciente ("para o sangramento"), e só quando ele está fora de perigo investiga a causa com calma. Cada pessoa tem um papel claro: quem coordena, quem opera, quem fala com a família. Incidentes em sistemas funcionam igual. Aliás, boa parte das práticas da área foi copiada literalmente dos bombeiros americanos, que criaram um sistema de comando para emergências chamado ICS.