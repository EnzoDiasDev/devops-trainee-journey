# OneUptime e SSO

> **Tema:** incidentes
> **Origem:** indicado
> **Iniciado em:** 2026-10-06
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->
> **Nível:** iniciante a intermediário.
> **Pré-requisitos (recomendado):** [Status page](../status-page.md) e [Gerenciamento de incidentes](../gerenciamento-de-incidentes.md).

## Em resumo

O **OneUptime** é uma plataforma de código aberto de **observabilidade e gestão de incidentes**: monitora se os sistemas estão no ar, avisa a pessoa de plantão quando algo quebra, publica a status page e ajuda a conduzir o incidente. A proposta é **substituir várias ferramentas separadas por uma só**.

A segunda metade desta nota explica o **SSO** (login único), porque ele é a principal diferença entre a edição gratuita e a paga, e é um conceito que aparece em todo ambiente corporativo.

## O que o OneUptime faz

Cada linha da tabela mostra uma ferramenta conhecida e a função equivalente no OneUptime:

| Em vez de... | ...o OneUptime oferece | Para que serve |
|---|---|---|
| Pingdom, UptimeRobot | **Uptime Monitoring** | Testa de vários pontos do mundo se um site, API, porta, certificado SSL ou DNS está respondendo |
| StatusPage.io | **Status Pages** | Páginas de status públicas ou privadas, com a identidade visual da empresa e inscrição de assinantes |
| PagerDuty, Opsgenie | **On-Call & Alerts** | Escalas de plantão, políticas de escalonamento e alertas por SMS, ligação, push e Slack |
| Incident.io | **Incident Management** | Declarar, fazer a triagem, comunicar e escrever o postmortem do incidente |
| Datadog, New Relic | **APM & Metrics** | Traces, painéis e desempenho dos serviços (*APM = Application Performance Monitoring*) |
| Loggly | **Log Management** | Coletar, pesquisar e criar alertas sobre logs |
| Sentry | **Error Tracking** | Registrar exceções com a pilha de chamadas (*stack trace*) e o contexto do erro |

### Edições

- **Community:** gratuita e *self-hosted* (você mesmo instala, com Docker Compose ou Kubernetes). Inclui tudo o que está na tabela.
- **Enterprise:** acrescenta **SSO** (SAML/OIDC), **SCIM**, *audit logs* (registro de quem fez o quê), residência de dados e suporte prioritário.

## Diagrama: a tela de monitoramento

O arquivo [`detect.excalidraw`](detect.excalidraw) (abre em [excalidraw.com](https://excalidraw.com)) anota os elementos da tela de detecção:

- **Probes:** servidores de monitoramento externos, espalhados geograficamente, que testam continuamente a disponibilidade e o desempenho dos sistemas.
- **Uptime:** a porcentagem de tempo em que o sistema ficou operando e acessível, sem interrupções, num período definido (aqui, 30 dias). O tempo total de instabilidade aparece detalhado ao lado.
- **Percentis de tempo de resposta:** servem para entender o comportamento real do sistema e a experiência dos usuários.
  - **p50 (mediana):** o tempo de resposta que 50% dos usuários experimentam. Metade das requisições foi mais rápida que esse valor, e metade foi mais lenta. É o cenário do "usuário comum".
  - **p95:** 95% das pessoas tiveram um tempo menor ou igual a esse valor, e os 5% mais azarados sofreram uma lentidão ainda maior. É a métrica mais usada para rastrear gargalos, porque a média esconde esses casos ruins.

## SSO, IdP, OIDC e SAML

### O que é SSO?

**SSO** (*Single Sign-On*, login único) permite que a pessoa se autentique **uma única vez** em um provedor de identidade e, a partir daí, acesse várias ferramentas sem digitar a senha de novo em cada uma.

### O que é um IdP?

**IdP** (*Identity Provider*, provedor de identidade) é o sistema central que **cria, guarda e autentica** as identidades digitais. É a "fonte da verdade" sobre quem é quem dentro de uma organização. Exemplos: Okta, Google Workspace, Auth0 e Keycloak.

O que ele faz:

- cria e gerencia as identidades;
- autentica (senha, MFA, certificado...) e decide se o acesso é liberado;
- emite um *token* assinado (OIDC) ou uma *assertion* assinada (SAML) provando que a autenticação aconteceu;
- gerencia o ciclo de vida das contas (criar e remover acessos), muitas vezes via **SCIM**, e aplica políticas de acesso.

### OIDC × SAML: os dois protocolos de SSO

**OIDC (OpenID Connect)** é uma camada de **autenticação** construída sobre o **OAuth 2.0**. Os dois se complementam:

- **OAuth 2.0** responde: "o que este aplicativo pode acessar?" (**autorização**);
- **OIDC** responde: "quem é este usuário?" (**autenticação**).

Fluxo quando você clica em "Entrar com Google":

1. O aplicativo redireciona você ao IdP.
2. O IdP autentica você (senha, MFA, biometria...).
3. O IdP devolve ao aplicativo um **ID Token**: um JWT assinado com dados do usuário (e-mail, nome, validade...).
4. O aplicativo valida a assinatura do token e abre a sessão.

Você só digita a senha no IdP, nunca no aplicativo.

**SAML (Security Assertion Markup Language)** é um padrão aberto, baseado em **XML**, para trocar dados de autenticação entre o IdP e o aplicativo (chamado de **SP**, *Service Provider*, como Salesforce ou Zoom).

1. Você acessa o SP.
2. O SP redireciona seu navegador ao IdP com um pedido de autenticação em XML.
3. O IdP autentica você.
4. O IdP gera uma **SAML Assertion**: um XML assinado digitalmente, com o identificador do usuário, atributos (e-mail, grupos, papéis) e prazo de validade.
5. Seu navegador entrega a assertion ao SP.
6. O SP confere a assinatura com o certificado do IdP e libera o acesso.

| | **SAML 2.0** | **OIDC** |
|---|---|---|
| Formato | XML (documento assinado) | JWT (JSON) |
| Uso típico | SSO corporativo em aplicações web | Apps web, mobile, APIs e SPAs |
| Surgiu | ~2005 (mais antigo) | ~2014 (mais moderno) |
| Transporte | HTTP POST/Redirect (formulário oculto no navegador) | HTTP + JSON, mais amigável a APIs |
| Mobile e APIs | Não é adequado | Sim |

### Por que o SSO importa em DevOps

O SSO conecta as ferramentas do ecossistema (Azure DevOps, GitHub, Backstage, Jira, o próprio OneUptime...) sem pedir as credenciais de novo em cada uma. Ele é essencial porque:

1. **Centraliza a segurança:** reduz a superfície de ataque e aplica políticas iguais (como MFA) em um único ponto.
2. **Acelera o provisionamento:** liberar ou revogar o acesso a vários sistemas vira uma única ação no IdP.
3. **Aumenta a produtividade:** elimina a fadiga de senhas e o tempo perdido em logins repetidos.

## Referências

- [Repositório do OneUptime no GitHub](https://github.com/oneuptime/oneuptime)
- [Status page](../status-page.md) e [Gerenciamento de incidentes](../gerenciamento-de-incidentes.md): os conceitos que o OneUptime automatiza
