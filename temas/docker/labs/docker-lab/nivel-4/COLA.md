# 🧾 Cola do nível 4

## Testar conexões (dentro de um container alpine ou nginx)
| Comando | O que faz |
|---------|-----------|
| `ping -c 1 nome` | Testa se responde e mostra o IP do nome |
| `wget -qO- http://nome` | Baixa a página e mostra na tela |
| `wget -qO- -T 3 http://nome:porta` | Idem, com porta e desistindo em 3 s |

## Redes
| Quero... | Comando |
|----------|---------|
| Criar | `docker network create rede` |
| Listar | `docker network ls` |
| Ver detalhes e containers | `docker network inspect rede` |
| Apagar | `docker network rm rede` |
| Criar container numa rede | `docker run --network rede --name app ...` |
| Pôr um container em mais uma rede | `docker network connect rede app` |
| Tirar de uma rede | `docker network disconnect rede app` |

## Portas
| Quem acessa | Endereço | Precisa de `-p`? |
|-------------|----------|------------------|
| Outro container na mesma rede | `nome-do-container:porta-do-container` | ❌ |
| Seu navegador | `localhost:porta-do-computador` | ✅ |

```
-p 127.0.0.1:8081:80   → só o seu computador (recomendado)
-p 8081:80             → aberto para todos (0.0.0.0)
```

## App + banco
```bash
$ docker network create sistema
$ docker run -d --name banco --network sistema -e POSTGRES_PASSWORD=senha -v banco-dados:/var/lib/postgresql claude/postgres:18-alpine
$ docker run --rm --network sistema -e DB_HOST=banco -e DB_SENHA=senha claude/minha-app:1.0
```

## Regras de ouro
- `localhost` dentro do container = **o próprio container**.
- Para se acharem pelo **nome**, os containers precisam estar na **mesma rede criada por você**.
- Use **nomes**, nunca IPs (IPs mudam).
- Banco **sem `-p`** e numa rede só com quem precisa dele.
- 🌐 Em algumas redes, um nome inexistente na rede padrão vira `nome.<sufixo-da-rede>` (IP `198.51.100.x`). Se aparecer
  um IP estranho, desconfie e não rode aplicações com senhas reais fora de uma rede própria.

## Erros comuns
| Mensagem | Causa provável |
|----------|----------------|
| `Connection refused` | `localhost` no lugar do nome, porta do computador no lugar da do container, ou serviço desligado |
| `failed to resolve host` / `bad address` | Nome errado, rede diferente ou container desligado |
| `password authentication failed` | Conectou, mas a senha está errada |
| `HTTP/1.1 403 Forbidden` ao chamar um container | O nome não existe na rede e foi parar num servidor externo |
| `has active endpoints` | Tentou apagar uma rede com containers dentro |
