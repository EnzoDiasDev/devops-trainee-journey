# API - Parte II - Intermediário

> **Tema:** API
> **Origem:** Próprio
> **Iniciado em:** 2026-10-05
> **Status:** 🟡 Em andamento <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->

## Em minhas palavras

---

A parte II é voltada para como as APIs são organizadas, protegidas e usadas na prática. O padão REST, autenticação, paginação, limites de uso, webhooks e as ferramentas do dia a dia.

**REST (Representational State Transfer)** não é uma tecnologia nem uma biblioteca. É um estilo de arquitetura, um conjunto de convenções sobre como desenhar uma API. Quando alguém diz que uma API é RESTful, quer dizer que ela segue essas convenções.

A ideia principal é pensar em recursos, que são as "coisas" do seu sistema (pedidos, clientes, produtos), e usar os métodos HTTP como os verbos que agem sobre eles. O endereço diz o quê; o método diz o que fazer.

Pense num sistema de pedidos:
```
GET    /pedidos        → lista os pedidos
GET    /pedidos/42     → mostra o pedido 42
POST   /pedidos        → cria um pedido novo
PATCH  /pedidos/42     → altera parte do pedido 42
DELETE /pedidos/42     → apaga o pedido 42
```
Repare que as URLs têm só substantivos (pedidos), nunca verbos. Uma API mal desenhada teria endereços como <code>/criarPedido</code> ou <code>/apagarPedido?id=42</code>. Funciona, mas foge do padrão, e o padrão é o que permite que qualquer desenvolvedor entenda sua API sem ler um manual enorme.

Outra convenção importante do REST é ser **stateless (sem estado)**: cada requisição precisa carregar tudo o que o servidor precisa para atendê-la. O servidor não "lembra" da requisição anterior. É como um atendente que não te reconhece: toda vez você mostra seu documento de novo. Parece chato, mas é isso que permite colocar dez servidores iguais lado a lado e mandar cada requisição para qualquer um deles.



### Parâmetros: como detalhar o pedido

Há duas formas comuns de passar informação na URL.

**Path params (parâmetros de caminho)** fazem parte do endereço e identificam qual recurso: em /pedidos/42, o 42 é um path param.

**Query params (parâmetros de consulta)** vêm depois do ? e servem para filtrar, ordenar ou paginar, separados por &. Por exemplo:

<code>GET /pedidos?status=aberto&ordenar=data&page=2</code>


### Idempotência: um conceito que evita prejuízo

Uma operação é idempotente quando fazê-la uma vez ou dez vezes dá o mesmo resultado final.

- Apagar o pedido 42 (DELETE) é idempotente: depois da primeira vez ele já não existe, e as próximas não mudam nada. 
- Ler (GET) também é, porque não altera nada. 
- PUT também é, porque substituir algo pelo mesmo conteúdo várias vezes dá no mesmo. 
- Já o POST **não é idempotente**: mandar "cria um pedido" três vezes cria três pedidos.



### Autenticação e autorização

São duas perguntas diferentes, e confundir as duas é muito comum:
- Autenticação: quem é você? (como mostrar o crachá na portaria). 
- Autorização: o que você pode fazer? (o crachá abre a sala de servidores ou só o refeitório?).

As formas mais comuns de autenticação são:
- API key. Uma chave fixa enviada num cabeçalho. Simples, comum em APIs de serviço para serviço. O problema é que, se vazar, quem tiver a chave se passa por você até alguém revogá-la. 
- Bearer token. Um token enviado no cabeçalho Authorization: Bearer <token>. "Bearer" significa "portador": quem porta o token tem o acesso, como um ingresso de show. Por isso ele precisa ser protegido como uma senha. 
- OAuth 2.0. O protocolo por trás do "Entrar com Google". Ele resolve um problema específico: deixar um aplicativo acessar seus dados em outro serviço sem você entregar sua senha para ele. A analogia clássica é a chave de manobrista: ela liga o carro, mas não abre o porta-malas nem o porta-luvas. Você autoriza no Google, o Google entrega ao aplicativo um token limitado, e esse token tem scopes (escopos), que definem exatamente o que ele pode fazer, como "ler seu e-mail" mas não "enviar e-mail". 
- JWT (JSON Web Token). Um formato de token muito usado, com três partes separadas por pontos: cabeçalho, conteúdo e assinatura. A assinatura garante que ninguém alterou o conteúdo. Um alerta importante: o conteúdo de um JWT é só codificado em Base64, não criptografado. Qualquer pessoa com o token consegue ler o que está dentro dele. Nunca coloque segredos num JWT.

E a regra que já vimos continua valendo: tokens e chaves nunca no código, nunca no GitHub, nunca em log.



### Paginação: não traga tudo de uma vez

Imagine pedir GET /pedidos num sistema com dois milhões de pedidos. A resposta seria gigantesca, lenta e poderia derrubar o servidor. Por isso APIs devolvem os dados em páginas.

Os dois modelos mais comuns são **offset** (?page=3&per_page=50, "pule os 100 primeiros e me dê os próximos 50"), simples mas que fica lento e impreciso em listas enormes que mudam o tempo todo, e **cursor**, em que a resposta traz um marcador apontando "onde você parou", e a próxima requisição continua dali. É mais robusto para grandes volumes.



### Rate limit: o limite de pedidos

APIs limitam quantas requisições cada cliente pode fazer num intervalo de tempo. Isso protege o servidor de sobrecarga, seja por abuso, seja por um script mal feito rodando em loop.

Quando você passa do limite, recebe o <code>429 Too Many Requests</code>. Muitas APIs informam seu saldo nos cabeçalhos da resposta, e algumas mandam um cabeçalho <code>Retry-After</code> dizendo quanto tempo esperar antes de tentar de novo.



### Erros bem informados

Uma boa API não devolve só o código de erro: o corpo da resposta explica o que deu errado, geralmente com uma mensagem e às vezes um link para a documentação. Um 400 dizendo "o campo email está em formato inválido" economiza horas de investigação comparado a um 400 mudo. Se você rodar aquele teste do usuário inexistente da Parte 1, vai ver um exemplo disso na prática.



### Versionamento: mudar sem quebrar os outros

Lembra da analogia do cardápio? Se o restaurante muda o nome de um prato, quem pedia pelo nome antigo fica sem resposta. Em APIs, uma mudança que quebra quem já usa é chamada de **breaking change**: remover um campo, renomear um endpoint, mudar o formato de uma data.

Para evolução sem quebrar ninguém, as APIs usam versões, normalmente na URL (/v1/pedidos, /v2/pedidos) ou num cabeçalho. A versão antiga continua funcionando por um tempo, marcada como deprecated (descontinuada), até ser desligada com aviso prévio.


### Webhooks: em vez de perguntar, ser avisado

Imagine que você quer saber quando chega uma mensagem nova de cliente. Há dois jeitos.

**Polling** é perguntar de tempos em tempos: "chegou algo? E agora? E agora?". É como ligar para a pizzaria a cada cinco minutos perguntando se a pizza saiu. Funciona, mas desperdiça requisições e tem atraso.

**Webhook** é inverter a conversa: você cadastra um endereço seu no outro sistema, e ele chama você quando algo acontece. É a pizzaria te mandando mensagem quando o motoboy sai. Mais eficiente, mais rápido, e é assim que a maioria dos marketplaces avisa sistemas parceiros sobre perguntas e vendas novas.

O cuidado com webhooks é que seu endpoint fica exposto na internet, então ele precisa verificar se a chamada veio mesmo de quem diz ter vindo, geralmente por uma assinatura enviada no cabeçalho. Senão qualquer pessoa pode mandar eventos falsos para o seu sistema.


### Documentação e ferramentas

O padrão mais usado para documentar APIs REST é o **OpenAPI** (antigamente chamado de Swagger, e muita gente ainda chama assim). É um arquivo que descreve todos os endpoints, parâmetros e respostas, e a partir dele ferramentas geram páginas interativas onde você testa a API direto do navegador.

Para fazer requisições, além do curl, você vai ver **Postman**, **Insomnia** e **Bruno**, programas com interface gráfica para montar, salvar e organizar requisições. E para ler JSON no terminal, existe o **jq**, que formata e filtra a saída. Por exemplo, <code>curl -s https://api.github.com/users/octocat | jq '.public_repos'</code> mostra só o número de repositórios.



### Gírias e termos da área

- **Recurso (resource)**: a "coisa" que a API manipula, como pedido, cliente ou produto.
- Rota: sinônimo informal de endpoint, muito usado por quem programa o backend. "Criei uma rota nova para relatórios."
- CRUD: criar, ler, atualizar e apagar, as operações básicas sobre um recurso.
- **Stateless**: o servidor não guarda memória entre requisições; cada pedido é autossuficiente.
- Breaking change: mudança que quebra quem já usa a API.
- Deprecated: marcado para ser removido no futuro. Ainda funciona, mas você deveria parar de usar.
- **Throttling**: desacelerar ou recusar requisições de quem está passando do limite. É o rate limit em ação.
- SDK: um pacote pronto, numa linguagem específica, que facilita usar uma API. Em vez de montar requisições HTTP na mão, você chama uma função como cliente.pedidos.listar().
- **Wrapper**: código que "embrulha" uma API para facilitar o uso. Um SDK é um tipo de wrapper.
- **Sandbox**: um ambiente de testes da API, com dados falsos, onde você pode errar à vontade. APIs de pagamento sempre têm, para você não cobrar cartões reais enquanto desenvolve.
- Mock: uma API falsa que imita a real, usada para testar seu código quando a API verdadeira não está disponível ou é cara de chamar.
- Token: credencial temporária que comprova quem você é. "Meu token expirou."
- Scope: o recorte de permissões que um token tem.

## Dúvidas

---

- [X] Qual a diferença entre a API Key e a Bearer token? E por que a API key é mais usada em serviço p/ serviço?
  - Resposta: 
    - API Key é um segredo fixo e de longa duração que identifica quem é o cliente (a aplicação). Você gera uma vez e manda em todo request, geralmente num header como X-API-Key: abc123. 
    - Bearer token é um formato de envio: Authorization: Bearer <token>. "Bearer" significa "portador": quem tiver o token tem acesso. O token em si normalmente é temporário e emitido após um login ou fluxo OAuth. Muitas vezes é um JWT, que carrega dados como usuário, permissões e expiração.
    
    ||API Key|Bearer token|
    |---|---|---|
    |Identifica|A aplicação|Geralmente o usuário (ou app) com permissões específicas|
    |Duração|Longa, até você revogar|Curta (minutos/horas, revogável)|
    |Como é obtido|Gerado em um painel|Emitido por um login/0Auth|
    |Se vazar|Dano grande e duradouro|Dano limitado pelo tempo de expiração|

    - Uma API key também pode ser enviada como Bearer (Authorization: Bearer sk-...). Por isso a comparação é meio de "conceito vs. formato", e muitas APIs misturam os dois.
    - Por que a API key é comum entre serviços (server-to-server)?
      - Simples: não precisa de tela de login, redirecionamento nem fluxo de renovação.
      - Não há usuário humano no meio, então não faz sentido pedir consentimento.
      - O segredo fica seguro no servidor (variável de ambiente), longe de navegador ou celular, onde vazar é mais fácil.
      - Fácil de rotacionar e revogar por serviço

- [X] Caso alguém tenha acesso ao endpoint de um webhook de mensagens de pré-venda de um marketplace, seria possível manipular de forma maliciosa?
  - Resposta:
    - Sim, mas com algumas alterações. A pessoa não **ALTERA** a mensagem original, apenas **FORJA** uma nova e manda para o endpoint como se fosse o marketplace.
