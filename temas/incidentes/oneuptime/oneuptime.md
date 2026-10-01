# OneUptime

> **Tema:** incidentes
> **Origem:** gestor
> **Iniciado em:** AAAA-MM-DD
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->

## Em minhas palavras

O OneUptime é uma plataforma de observabilidade e gestão de incidentes que busca substituir outras aplicações separadas (**Datadog** de APM e métricas, **PugerDuty** de On-calls e Alerts, **StatusPage.io** para status pages, **Incident.io** para gestão de incidentes).

**Troque serviços indivíduais pelo OneUptime**
| Instead of… | Use OneUptime for… |
|---|---|
| Pingdom / UptimeRobot | **Uptime Monitoring** — website, API, ping, port, SSL, DNS & synthetic checks from around the world |
| StatusPage.io | **Status Pages** — branded public & private status pages with subscribers |
| PagerDuty / Opsgenie | **On-Call & Alerts** — schedules, escalation policies, SMS / call / push / Slack |
| Incident.io | **Incident Management** — declare, triage, communicate, and post-mortem |
| Datadog / New Relic | **APM & Metrics** — traces, dashboards, and service performance |
| Loggly | **Log Management** — collect, search, and alert on logs |
| Sentry | **Error Tracking** — exceptions with full stack traces and context |

**Edições**
- Community — gratuita, self-hosted (Docker Compose ou Kubernetes), com tudo o que está na tabela acima.
- Enterprise — adiciona **SSO** (SAML/OIDC), SCIM, audit logs, data residency e suporte prioritário. 

**O que é o SSO?** 
Basicamente é um login único, uma solução de autenticação que permite o usuário se autenticar uma única vez em um provedor de identidade (IdP).
> **O que é um IdP?**
> É o sistema central que CRIA, ARMAZENA e AUTENTICA identidades digitais. É a "fonte da verdade" sobre "quem é quem" dentro de uma organização. 
>> - O que ele faz?
>>   - Cria e gerencia identidades
>>   - Autentica (MFA, password, certificado, ...) e decide se o acesso é liberado
>>   - Emite tokens/assertions: Após autenticar, o IdP assina um token (**OIDC**) ou um assertion (**SAML**) 
>>   - Gestiona ciclo de vida: provisioning/desprovisioning de contas, muitas vezes **SCIM** e políticas de acesso (RBAC, ABAC)
>> - Exemplos:
>>   - Okta 
>>   - Google workspace 
>>   - Auth0 
>>   - Keycloak  
>
> <div style="display: flex; gap: 20px;">
>   <div style="flex: 1;">
>     <h3>OIDC (OpenID Connect)</h3>
>     <p>
>         É um protocolo de autenticação construído sobre <i>OAuth 2.0</i> (que nada mais é do que outro protocolo/framework de autorização. <i>Atenção: ele não é um IdP!</i>). Enquanto:
>     </p>
>     <ul>
>         <li>OAuth 2.0 resolve a <strong>autorização</strong>, ou seja, é o "O que o app pode acessar?"</li>
>         <li>- OIDC adiciona uma camada de <strong>autenticação</strong>, é o "Quem é esse usuário?"</li>
>     </ul>
>     <h5>
>         O que ele faz na prática?
>     </h5>
>     <p>
>         Quando você clica em "Sign in with Google" ou "Login com Microsoft", o fluxo que se segue é OIDC:
>     </p>
>     <ol>
>         <li>O app (Relying Party) redireciona o usuário ao IdP (Identity Provider)</li>
>         <li>O IdP autentica o usuário (senha, MFA, biometria, passkey…)</li>
>         <li>O IdP devolve um ID Token (um JWT assinado) contendo claims do usuário: sub, email, name, exp, etc.</li>
>         <li>O app valida a assinatura do token e estabelece a sessão</li>
>     </ol>
>     <h5>O usuário nunca digita senha no app, apenas no IdP.</h5>
>   </div>
>   <div style="flex: 1;">
>     <h3>SAML (Security Assertion Markup Language)</h3>
>     <p>É um padrão aberto baseado em XML para trocar dados de autenticação e autorização entre IdP e um <strong>SP (Service Provider)</strong>.</p>
>     <h5>Fluxo SAML</h5>
>     <ol>
>         <li>Usuário acessa o SP (ex.: Salesforce, Zoom)</li>
>         <li>O SP redireciona o browser ao IdP com um AuthnRequest (XML)</li>
>         <li>O IdP autentica o usuário (senha, MFA, etc.)</li>
>         <li>O IdP gera uma SAML Assertion — um documento XML assinado digitalmente (X.509) contendo:</li>
>         <ul>
>             <li>NameID (identificador do usuário)</li>
>             <li>Atributos: e-mail, nome, grupos, papéis</li>
>             <li>Timestamp e condições de validade</li>
>         </ul>
>         <li>O browser faz HTTP POST da assertion de volta ao SP</li>
>         <li>O SP valida a assinatura com o certificado do IdP → libera o acesso</li>
>     </ol>
>   </div>
> </div>
>
> ---
>
> **Diferença entre OCID e SAML**
> | | *SAML 2.0* | *OIDC* |
> |---|---|---|
> | Formato | *XML* (documentos assinados) | *JWT* (JSON) |
> | Foco | SSO enterprise, web apps | Apps web, mobile, APIs, SPAs |
> | Idade | ~2005 (mais antigo) | ~2014 (mais moderno) |
> | Transmissão | HTTP POST/Redirect (form hidden no browser) | HTTP + JSON (API-friendly) |
> | Suporte mobile/API | ❌ Não suporta | ✅ Sim |
>
>.

Ou seja, o SSO centraliza diversas ferramentas e plataformas do ecossistema DevOps, como o Azure DevOps, GitHub, BackStage, Jira, entre outras, sem precisar redigitar credenciais de acesso para cada aplicação.

**Mas por que ele é essencial no mundo DevOps?**
1. **Centraliza a segurança**: reduz a superfície de ataque e impõe políticas consistentes (MFA) em um único ponto.
2. **Acelera o provisionamento**: conceder e revogar acesso a múltiplos sistemas se torna uma ação única no IdP.
3. **Melhora a produtividade**: elimina a fadiga de senhas e o tempo gasto com logins repetidos durante o fluxo de trabalho.

## Referências

- [GitHuB OneUptime](https://github.com/oneuptime/oneuptime)
