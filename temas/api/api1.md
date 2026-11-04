# API — Parte 1: o básico

> **Tema:** API
> **Origem:** próprio
> **Iniciado em:** 2026-10-05
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->
> **Nível:** iniciante. Não precisa saber programar para acompanhar.
> **Continua em:** [Parte 2 — intermediário](api2.md)

## Em resumo

Uma **API** é um jeito combinado de um programa pedir coisas a outro e receber respostas, sem precisar saber como o outro funciona por dentro. Esta nota explica o que ela é, por que existe, como é uma conversa via API (requisição e resposta) e mostra dois testes reais com `curl`.

## O que é uma API?

API significa *Application Programming Interface* (Interface de Programação de Aplicações). Na prática, é um "contrato": o sistema A diz "se você me mandar um pedido neste formato, eu devolvo uma resposta neste outro formato".

### Por que as APIs existem?

- **Reaproveitar em vez de reinventar.** Um app de previsão do tempo não instala estações meteorológicas: ele pede os dados à API de um serviço de clima. Um site com "Entrar com Google" não guarda a sua senha do Google: ele conversa com a API do Google.
- **Integrar sistemas diferentes.** Sistemas feitos por empresas, equipes e linguagens diferentes conseguem trabalhar juntos. Um exemplo: sistemas de atendimento leem e respondem mensagens de clientes de um marketplace porque o marketplace oferece uma API para isso.
- **Dar segurança e controle.** Em vez de liberar acesso direto ao banco de dados (seria como deixar o cliente entrar na cozinha do restaurante), a empresa expõe só o que quer, do jeito que quer, e pode verificar quem está pedindo.

## Como é a conversa

Hoje, a maioria das APIs que você vai encontrar são **APIs web**: elas conversam por **HTTP**, o mesmo protocolo que o navegador usa para abrir sites. A conversa sempre tem duas metades:

- a **requisição** (*request*), que o cliente envia;
- a **resposta** (*response*), que o servidor devolve.

### A requisição tem quatro partes

1. **Endereço (URL / endpoint).** Para onde o pedido vai, por exemplo `https://api.github.com/users/octocat`. Cada endereço específico que faz uma coisa é chamado de *endpoint*.
2. **Método (ou verbo).** O que você quer fazer:
   - `GET`: buscar ou ler algo ("me mostra os dados do usuário").
   - `POST`: criar algo novo ("cadastra este pedido").
   - `PUT` / `PATCH`: atualizar algo que já existe. O `PUT` costuma substituir o recurso inteiro; o `PATCH` muda só uma parte.
   - `DELETE`: apagar algo.
3. **Cabeçalhos (*headers*).** Informações extras sobre o pedido, como "estou enviando JSON" ou "esta é a minha chave de acesso". São como o envelope de uma carta: não são o conteúdo, mas dizem como tratá-lo.
4. **Corpo (*body*).** Os dados que você envia, quando há algum. Um `GET` normalmente não tem corpo; um `POST` que cria um pedido leva os dados do pedido.

### A resposta tem três partes

1. **Código de status.** Um número de três dígitos que diz de cara se deu certo. A regra de bolso é olhar o primeiro dígito:

   | Faixa | Significado | Exemplos |
   |---|---|---|
   | **2xx** | Deu certo | `200 OK`, `201 Created` (criado com sucesso) |
   | **3xx** | Redirecionamento: o que você procura está em outro endereço | `301 Moved Permanently` |
   | **4xx** | O erro foi do **cliente** (você pediu algo errado) | `400 Bad Request` (pedido mal formado), `401 Unauthorized` (você não se identificou), `403 Forbidden` (identificou-se, mas não tem permissão), `404 Not Found` (não existe), `429 Too Many Requests` (pedindo rápido demais) |
   | **5xx** | O erro foi do **servidor** (o pedido estava certo, mas o servidor falhou) | `500 Internal Server Error` (quebrou algo lá dentro), `503 Service Unavailable` (fora do ar ou sobrecarregado) |

   > ⚠️ **Guarde a diferença entre 4xx e 5xx**, porque ela é muito importante em DevOps. Um pico de **5xx** costuma indicar um **incidente**: o seu sistema está quebrado. Um pico de **4xx** geralmente indica que algum cliente está usando a API errado.

2. **Cabeçalhos da resposta.** Informações sobre a resposta, como o formato dos dados e por quanto tempo ela pode ficar em cache.
3. **Corpo da resposta.** Os dados em si, quase sempre em **JSON**: um formato de texto simples, organizado em pares `"chave": valor`.

   ```json
   {
     "login": "octocat",
     "name": "The Octocat",
     "public_repos": 8
   }
   ```

## Analogia: o restaurante

Você (o **cliente**) quer comida, e quem faz a comida é a cozinha (o **servidor**). Você não entra na cozinha, não mexe nas panelas e nem sabe a receita. Olha o cardápio, faz o pedido ao garçom, e ele volta com o prato.

- O **garçom** é a API: leva o seu pedido num formato que a cozinha entende e traz a resposta.
- O **cardápio** é a documentação da API: a lista do que você pode pedir e como pedir.
- Se você pedir algo fora do cardápio, o garçom volta dizendo "isso não temos". É exatamente o que uma API faz quando recebe um pedido inválido (veja o `404` na Prática 2).

**O ponto central:** a cozinha pode trocar de cozinheiro, de fogão ou de receita e você nem fica sabendo, desde que o cardápio continue o mesmo. Em software, isso significa que o time de um sistema pode reescrever tudo por dentro sem quebrar quem usa a API dele.

## Na prática

Os dois testes usam o `curl`, uma ferramenta de terminal que faz requisições HTTP. A API usada é a pública do GitHub, que não exige cadastro para consultas simples. Com o `-i`, o `curl` mostra também o cabeçalho da resposta, não só o corpo.

### Prática 1 — uma requisição que dá certo

```bash
curl -i https://api.github.com/users/octocat
```

Resultado (resumido; a resposta real tem mais cabeçalhos e mais campos):

```http
HTTP/2 200                                          # status 200: deu certo
content-type: application/json; charset=utf-8      # os dados vêm em JSON
cache-control: public, max-age=60                  # pode ficar em cache por 60 s
x-ratelimit-limit: 60                              # limite: 60 requisições por hora sem autenticação
x-ratelimit-remaining: 59                          # quantas ainda restam

{
  "login": "octocat",
  "id": 583231,
  "type": "User",
  "name": "The Octocat",
  "company": "@github",
  "location": "San Francisco",
  "public_repos": 8,
  "followers": 24925,
  "created_at": "2011-01-25T18:44:36Z"
}
```

**O que aprendi:** o código `200`, o formato JSON no `content-type` e o corpo com os dados do usuário. Os cabeçalhos `x-ratelimit-*` mostram que a API limita quantos pedidos cada cliente pode fazer (assunto da [Parte 2](api2.md)).

### Prática 2 — uma requisição que dá errado

```bash
# usuário que não existe
curl -i https://api.github.com/users/usuario-que-nao-existe-12345
```

```http
HTTP/2 404                                         # mudou de 200 para 404: não encontrado
content-type: application/json; charset=utf-8

{
  "message": "Not Found",                           # explica o que houve
  "documentation_url": "https://docs.github.com/rest",   # onde ler mais
  "status": "404"
}
```

**O que aprendi:** um erro `4xx` também vem com corpo explicando o problema, e o status mudou de `200` para `404` sem que eu fizesse nada de errado no comando. O erro foi o **dado** (usuário inexistente), e o servidor respondeu corretamente.

## Vocabulário da área

| Termo | O que significa |
|---|---|
| **Endpoint** | Um endereço específico da API que faz uma coisa. "Esse endpoint retorna a lista de pedidos." |
| **Bater na API / chamar a API** | Fazer uma requisição. "O script bate na API dos Correios a cada cinco minutos." Cada requisição também é chamada de *call*. |
| **Consumir / expor** | Quem usa a API a *consome*; quem a oferece a *expõe*. "Nosso sistema consome a API do marketplace e expõe uma API para o app mobile." |
| **Payload** | O conteúdo útil do corpo de uma requisição ou resposta. "Qual é o payload desse POST?" |
| **Client / server** | Cliente é quem pede; servidor é quem responde. O mesmo sistema pode ser os dois ao mesmo tempo. |
| **Documentação (docs)** | O "cardápio" da API: endpoints existentes, o que cada um espera e o que devolve. Ler docs é uma habilidade de uso diário. |
| **API pública / privada / de parceiros** | Pública: aberta a qualquer desenvolvedor. Privada (interna): só para os sistemas da própria empresa. De parceiros: liberada a empresas específicas, com acordo. |
| **API key (chave de API)** | Uma "senha" que identifica quem chama a API. Aprofundamos na [Parte 2](api2.md). |
| **Integração** | A ligação entre dois sistemas, geralmente via API. "Fiz a integração com o ERP." |

> 🔒 **Regra de segurança desde já:** chave de API **nunca** vai escrita direto no código nem para o GitHub. Ela fica num arquivo `.env` (que não é versionado) ou num cofre de segredos.

## Dúvidas em aberto

- [ ] As respostas de uma API costumam ficar armazenadas em um cache como o Redis? (Pesquisar: cache no servidor × cache no cliente.)

## Referências

- [Documentação da API REST do GitHub](https://docs.github.com/rest)
- [Parte 2 — intermediário](api2.md)
