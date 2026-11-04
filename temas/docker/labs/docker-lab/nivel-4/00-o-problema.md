# Aula 00 — O problema: containers isolados

## 🎯 Nesta aula
- Duas ferramentas para testar conexões: `ping` e `wget`.
- O que é o `localhost` **dentro** de um container.
- Por que, sem uma rede própria, um container não acha o outro pelo nome.
- Uma pegadinha de DNS que acontece em algumas redes.

---

## 📖 Aprenda: `ping` e `wget`

São dois programas que já vêm no `claude/alpine:3.22`. Você vai usá-los **dentro** de containers para
testar se um consegue falar com o outro.

| Comando | O que faz |
|---------|-----------|
| `ping -c 1 <endereço>` | Manda **um** "toc-toc" para o endereço e espera resposta (`-c 1` = uma vez só). A 1ª linha mostra **qual IP** o nome virou |
| `wget -qO- http://<endereço>` | **Baixa a página** do endereço e mostra na tela (`-q` = sem mensagens extras, `O-` = mostrar na tela) |
| `wget -qO- -T 3 http://<endereço>` | O mesmo, desistindo após 3 segundos (`-T 3`) |

> `<endereço>` é só um lugar para preencher: troque pelo **nome** de quem você quer testar, como
> `example.com` (um site) ou, nas próximas aulas, o nome de um container (`site`, `banco`...).
> Você **não precisa saber nenhum IP**: o próprio `ping` descobre e mostra para você.

> 💡 **IP** é o "número de telefone" de um computador na rede (ex.: `172.18.0.2`). Um **nome**
> (como `google.com`) é convertido em IP antes da conexão, como numa agenda. Essa "agenda" se chama **DNS**.

Teste com um site da internet:
```bash
$ docker run --rm claude/alpine:3.22 ping -c 1 example.com
$ docker run --rm claude/alpine:3.22 wget -qO- http://example.com
```

---

## 📖 Aprenda: o `localhost` do container

`localhost` significa "**eu mesmo**". No seu computador, `localhost:8081` é o seu computador.
Mas **dentro de um container**, `localhost` é **o próprio container**, e não o seu computador nem outro container.

```
 seu computador                     container A
 ┌──────────────────────┐          ┌────────────────────────┐
 │ localhost = o PC     │          │ localhost = o próprio A │
 └──────────────────────┘          └────────────────────────┘
```

Veja:
```bash
$ docker run -d --name vizinho -p 8081:80 claude/nginx:alpine
$ docker run --rm claude/alpine:3.22 wget -qO- -T 3 http://localhost:8081
```
Erro `Connection refused`. Para o container alpine, `localhost` é ele mesmo, e não há nada na porta 8081 **dele**.
No navegador (seu computador), `localhost:8081` funciona normalmente.

> 📌 Esta é a causa nº 1 de "funciona na minha máquina, mas não no Docker": uma aplicação configurada
> para achar o banco em `localhost`.

---

## 📖 Aprenda: sem rede própria, sem nomes

Tente chamar o `vizinho` **pelo nome**:
```bash
$ docker run --rm claude/alpine:3.22 ping -c 1 vizinho
```
Seria de esperar um erro (`bad address`, endereço desconhecido). Mas **em algumas redes** (corporativas ou de provedores) acontece uma coisa estranha:
```
PING vizinho (198.51.100.25): 56 data bytes
64 bytes from 198.51.100.25 ...
```
Alguém respondeu! Só que `198.51.100.25` **não é o seu container**. É um servidor externo, que nada tem a ver com o seu teste.

### 🌐 A pegadinha dos domínios de busca (*search domain*)
O seu computador pode estar configurado para, quando um nome não é encontrado, tentar de novo com um
**sufixo de domínio no final** (por exemplo, `.rede.example`). Se o DNS da rede responde para **qualquer** nome com
esse sufixo, então `vizinho` vira `vizinho.rede.example`, e um servidor externo responde.

Prova:
```bash
$ docker run --rm claude/alpine:3.22 wget -qO- -T 3 http://vizinho
```
`HTTP/1.1 403 Forbidden`: um servidor externo recusou o acesso. Não é o seu nginx.

> ⚠️ **Lição importante:** quando um nome "resolve" para um IP estranho, desconfie. Se uma aplicação sua
> fizesse isso com a **senha do banco**, ela mandaria a senha para um servidor que não é seu. Na próxima aula
> você vai ver que, numa **rede própria**, isso não acontece.

### Por que o nome não funcionou?
Todo container criado sem `--network` vai para uma rede padrão chamada **`bridge`**. Nela os containers
até se alcançam pelo **IP**, mas **não existe agenda de nomes** (DNS) entre eles. E IPs mudam toda vez que
um container é recriado, então usar IP não é uma solução.

```bash
$ docker rm -f vizinho
```

---

## 🧠 Memorize

1. Para que servem o `ping -c 1` e o `wget -qO-`?
2. Dentro de um container, quem é o `localhost`?
3. Uma aplicação num container procura o banco em `localhost:5432`, e o banco está em outro container. Funciona?
4. Na rede padrão (`bridge`), um container acha o outro pelo nome?
5. O `ping` de um nome de container respondeu com o IP `198.51.100.25`. O que aconteceu?

<details><summary>👀 Ver respostas</summary>

1. `ping -c 1` testa se o endereço responde e mostra o IP dele; `wget -qO-` baixa a página e mostra na tela.
2. O próprio container.
3. Não. `localhost` é o próprio container da aplicação, e não o do banco.
4. Não. Na rede padrão não há DNS entre containers.
5. O nome não foi encontrado e virou `nome.<sufixo-da-rede>`, que o DNS da rede resolve para um servidor externo. Não é o seu container.
</details>

➡️ Próxima: [Aula 01 — Sua primeira rede](01-primeira-rede.md)
