# 🏦 Enzo Bank

Mini banco digital: uma API HTTP em Java puro (sem Maven nem Gradle) que roda em Docker.

## Rodando (desenvolvimento)
```bash
docker compose up -d --build        # sobe a API em http://localhost:8070
docker compose logs -f api          # acompanha os logs
docker compose down                 # derruba (os saldos ficam salvos no volume)
```

## Testes
```bash
docker compose run --rm --build api java src/Testes.java
```
(Com Java instalado na máquina, também funciona: `java src/Testes.java`.)

## Regras da equipe
1. **Ninguém faz commit direto na `main`.** Toda mudança vai numa branch e passa por Merge Request.
2. Nomes de branch: `feature/...` (novidade), `fix/...` (correção), `chore/...` (arrumação).
3. Mensagens de commit no presente, explicando o que muda: `Corrige saque com saldo insuficiente`.
4. MR com teste falhando ou imagem Docker que não constrói é recusado.
5. Todo MR aprovado vai **automaticamente para produção**.
