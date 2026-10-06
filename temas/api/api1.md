# API - Parte I - Básico

> **Tema:** API
> **Origem:** Próprio
> **Iniciado em:** 2026-10-05
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->

## Em minhas palavras

---

### O que é?
API (Application Programming Interface, ou Interface de Programação de Aplicações) é uma forma combinada de um programa pedir coisas a outro programa e receber respostas, sem precisar saber como o outro funciona por dentro.

### Por que existem?
- Reaproveitar em vez de reinventar
  - Um app de previsão do tempo não instala estações meteorológicas, ele pede os dados para a API de um serviço de clima. Um site que mostra "entrar com Google" não guarda sua senha do Google, ele conversa com a API do Google.
- Integração
  - Sistemas diferentes, feitos por empresas diferentes, em linguagens diferentes, conseguem trabalhar juntos. É assim que plataformas de atendimento recebem as perguntas de clientes dos marketplaces: o Mercado Livre, por exemplo, oferece uma API para que sistemas de terceiros leiam e respondam mensagens.
- Segurança e controle
  - Em vez de dar acesso direto ao banco de dados (que seria como deixar o cliente entrar na cozinha), a empresa expõe só o que quer, do jeito que quer, e pode verificar quem está pedindo.

### Conversa via API

Hoje, a maioria das APIs que você vai encontrar são APIs web, que conversam usando HTTP, o mesmo protocolo que seu navegador usa para abrir sites. A conversa sempre tem duas metades: uma requisição (request), que o cliente envia, e uma resposta (response), que o servidor devolve.

> A requisição tem quatro partes (⚠️ IMPORTANTE!)
>
> 1. O endereço (URL / endpoint). Para onde você está mandando o pedido. Por exemplo, https://api.github.com/users/octocat. Cada endereço específico que faz uma coisa é chamado de endpoint.
> 2. **O método (ou verbo)**. O que você quer fazer. Os principais:
>   - GET: buscar ou ler algo. "Me mostra os dados do usuário."
>   - POST: criar algo novo. "Cadastra esse pedido."
>   - PUT / PATCH: atualizar algo existente. O PUT costuma substituir o recurso inteiro; o PATCH muda só uma parte.
>   - DELETE: apagar algo.
> 3. **Os cabeçalhos (headers)**. Informações extras sobre o pedido, como "estou mandando dados em formato JSON" ou "esta é minha chave de acesso". É como o envelope de uma carta: não é o conteúdo, mas diz como tratar o conteúdo.
> 4. **O corpo (body)**. Os dados que você está enviando, quando há algum. Um GET normalmente não tem corpo; um POST para criar um pedido teria os dados do pedido.

> A resposta tem três partes principais
> 1. O código de status. Um número de três dígitos que diz, de cara, se deu certo. A regra de bolso é olhar o primeiro dígito:
>    - 2xx: deu certo. 200 OK (tudo certo) e 201 Created (criado com sucesso) são os mais comuns
>    - 3xx: redirecionamento. "O que você procura está em outro endereço"
>    - 4xx: o erro foi do cliente. Você pediu algo errado
>      - 400 Bad Request (pedido mal formado) 
>      - 401 Unauthorized (você não se identificou) 
>      - 403 Forbidden (você se identificou, mas não tem permissão) 
>      - 404 Not Found (isso não existe)
>      - 429 Too Many Requests (você está pedindo rápido demais)
>    - 5xx: o erro foi do servidor. O pedido estava certo, mas o servidor falhou
>      - 500 Internal Server Error (quebrou algo lá dentro)
>      - 503 Service Unavailable (o serviço está fora ou sobrecarregado)
>
> ⚠️ *Guarde essa diferença entre 4xx e 5xx, porque ela é muito importante em DevOps. Um pico de 5xx costuma ser sinal de incidente: é o seu sistema que está quebrado. Um pico de 4xx geralmente indica que algum cliente está usando a API errado.*
> 2. Os cabeçalhos da resposta. Informações sobre a resposta, como o formato dos dados e por quanto tempo ela pode ficar em cache.
> 3. O corpo da resposta. Os dados em si. Quase sempre em JSON, um formato de texto simples organizado em pares de "chave: valor". Por exemplo:
>   ```bash
>   {
>   "login": "octocat",
>   "name": "The Octocat",
>   "public_repos": 8
>   }
>   ```

### Gírias e termos da área

- Endpoint: um endereço específico da API que faz uma coisa. "Esse endpoint retorna a lista de pedidos."
- Bater na API / chamar a API: fazer uma requisição. "O script bate na API dos Correios a cada cinco minutos." Cada requisição também é chamada de chamada (call).
- Consumir / expor uma API: quem usa a API está consumindo; quem oferece está expondo. "Nosso sistema consome a API do Mercado Livre e expõe uma API para o app mobile."
- Payload: o conteúdo útil que vai no corpo da requisição ou da resposta. "Qual é o payload desse POST?"
- Client / server: cliente é quem pede, servidor é quem responde. O mesmo sistema pode ser os dois ao mesmo tempo: servidor para quem o chama e cliente das APIs que ele chama.
- Documentação / docs: o "cardápio" da API, explicando quais endpoints existem, o que cada um espera receber e o que devolve. Ler docs é uma habilidade que você vai usar todos os dias.
- API pública, privada e de parceiros: pública é aberta para qualquer desenvolvedor usar; privada (ou interna) é só para os sistemas da própria empresa; de parceiros é liberada para empresas específicas com acordo.
- API key / chave de API: uma senha que identifica quem está chamando a API. Vamos aprofundar autenticação na Parte 2, mas já guarde uma regra: chave de API nunca vai chumbada no código nem para o GitHub. Ela fica num arquivo .env ou num cofre de segredos.
- Integração: a ligação entre dois sistemas, geralmente via API. "Fiz a integração com o ERP."


## Analogia

---

Imagine que você está num restaurante. Você (o cliente) quer comida, e quem faz a comida é a cozinha (o servidor). Você não entra na cozinha, não mexe nas panelas e nem sabe a receita. Você olha o cardápio, faz o pedido ao garçom, e ele volta com o prato.

Nessa história, o garçom é a API. Ele leva seu pedido num formato que a cozinha entende e traz de volta a resposta. O **cardápio** é a documentação da API: a lista do que você pode pedir e como pedir. Se você pedir algo que não está no cardápio, o garçom volta dizendo "isso não temos", que é exatamente o que uma API faz quando recebe um pedido inválido.

_O ponto central é_: a cozinha pode trocar de cozinheiro, de fogão ou de receita, e você nem fica sabendo, desde que o cardápio continue o mesmo. Em software, isso significa que o time de um sistema pode reescrever tudo por dentro sem quebrar quem usa a API dele.


## Na prática

---

### Prática 1

```bash
# o comando curl faz requisições HTTP, e o -i pede para mostrar o head da resposta junto com o body 
curl -i https://api.github.com/users/EnzoDiasDev
```
**O que aconteceu:**
```bash
# Resultado do comando
HTTP/2 200   # 200 é o código de status da requisição
date: Mon, 05 Oct 2026 17:54:59 GMT
content-type: application/json; charset=utf-8      # application/json é o formato dos dados e o charset é a codificação dos caracteres
cache-control: public, max-age=60, s-maxage=60
vary: Accept,Accept-Encoding, Accept, X-Requested-With
etag: W/"3bb5a1b7f69759de0525dfc92154b9d5dea6948293ea3ab4aac6904551fed691"
last-modified: Wed, 30 Sep 2026 17:08:34 GMT
x-github-media-type: github.v3; format=json
x-github-api-version-selected: 2022-11-28
access-control-expose-headers: ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Used, X-RateLimit-Resource, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, X-GitHub-SSO, X-GitHub-Request-Id, Deprecation, Sunset, Warning
access-control-allow-origin: *
strict-transport-security: max-age=31536000; includeSubdomains; preload
x-frame-options: deny
x-content-type-options: nosniff
x-xss-protection: 0
referrer-policy: origin-when-cross-origin, strict-origin-when-cross-origin
content-security-policy: default-src 'none'
server: github.com
accept-ranges: bytes
x-ratelimit-limit: 60
x-ratelimit-remaining: 29
x-ratelimit-used: 31
x-ratelimit-resource: core
x-ratelimit-reset: 1791223875
content-length: 1374
x-github-request-id: D1D6:B4B67:2CB55F:305D15:6AC3E473
x-github-edge-region: brazilsouth

{              
  #body
  "login": "EnzoDiasDev",
  "id": 191253787,
  "node_id": "U_kgDOC2ZNGw",
  "avatar_url": "https://avatars.githubusercontent.com/u/191253787?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/EnzoDiasDev",
  "html_url": "https://github.com/EnzoDiasDev",
  "followers_url": "https://api.github.com/users/EnzoDiasDev/followers",
  "following_url": "https://api.github.com/users/EnzoDiasDev/following{/other_user}",
  "gists_url": "https://api.github.com/users/EnzoDiasDev/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/EnzoDiasDev/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/EnzoDiasDev/subscriptions",
  "organizations_url": "https://api.github.com/users/EnzoDiasDev/orgs",
  "repos_url": "https://api.github.com/users/EnzoDiasDev/repos",
  "events_url": "https://api.github.com/users/EnzoDiasDev/events{/privacy}",
  "received_events_url": "https://api.github.com/users/EnzoDiasDev/received_events",
  "type": "User",
  "user_view_type": "public",
  "site_admin": false,
  "name": "__EnzoDias__",
  "company": "Unicesumar",
  "blog": "",
  "location": "PR, Brasil",
  "email": null,
  "hireable": null,
  "bio": null,
  "twitter_username": null,
  "public_repos": 9,
  "public_gists": 0,
  "followers": 2,
  "following": 6,
  "created_at": "2024-12-10T14:03:52Z",
  "updated_at": "2026-09-30T17:08:34Z"
}
```

### Prática 2

```bash
# Teste com usuário inexistente
curl -i https://api.github.com/users/---
```

**O que aconteceu?**

```bash
HTTP/2 404  # Status code mudou de 200 para 404
date: Mon, 05 Oct 2026 18:02:43 GMT
content-type: application/json; charset=utf-8
x-github-media-type: github.v3; format=json
x-github-api-version-selected: 2022-11-28
access-control-expose-headers: ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Used, X-RateLimit-Resource, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, X-GitHub-SSO, X-GitHub-Request-Id, Deprecation, Sunset, Warning
access-control-allow-origin: *
strict-transport-security: max-age=31536000; includeSubdomains; preload
x-frame-options: deny
x-content-type-options: nosniff
x-xss-protection: 0
referrer-policy: origin-when-cross-origin, strict-origin-when-cross-origin
content-security-policy: default-src 'none'
vary: Accept-Encoding, Accept, X-Requested-With
server: github.com
x-ratelimit-limit: 60
x-ratelimit-remaining: 19
x-ratelimit-used: 41
x-ratelimit-resource: core
x-ratelimit-reset: 1791223875
content-length: 103
x-github-request-id: D1EA:263760:2ED2C9:32A3C0:6AC3E643
x-github-edge-region: brazilsouth

{
"message": "Not Found",  # Não encontrado, uma pista
"documentation_url": "https://docs.github.com/rest",
"status": "404"  # Status message que diz "Não existe!"
}
```

## Dúvidas

---

- [ ] Respostas de APIs geralmente ficam armazenadas no Redis?
