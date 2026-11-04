#!/usr/bin/env bash
# Publica a main do GitLab na "produção" local (http://localhost:8090).
# Rode depois de cada MR que você der Merge no GitLab.   Uso: ./deploy.sh
set -uo pipefail
source "$(dirname "$0")/.comum.sh"
exigir_treino
echo "🚀 Deploy da main do GitLab em produção (http://localhost:$PORTA_PROD)..."
if [ ! -d "$PRODUCAO" ]; then
  git clone -q "$URL_GITLAB" "$PRODUCAO" 2>/dev/null || { vermelho "Não consegui clonar do GitLab."; exit 1; }
fi
cd "$PRODUCAO"
git fetch -q origin || { vermelho "Não consegui falar com o GitLab. VPN/rede ok?"; exit 1; }
git reset -q --hard origin/main
echo "   Versão: $(git log -1 --format='%h %an: %s')"
printf 'TAG=producao\nPORTA=%s\nTOKEN_ADMIN=token-de-producao\n' "$PORTA_PROD" > .env
if docker compose -p "$PROJETO_PROD" up -d --build > "$AREA/.deploy.log" 2>&1; then
  for _ in $(seq 1 20); do curl -sf "localhost:$PORTA_PROD/" >/dev/null && break; sleep 1; done
  verde "   ✅ Produção atualizada: http://localhost:$PORTA_PROD"
else
  vermelho "   🔥 O DEPLOY FALHOU! A produção continua rodando a versão anterior."
  grep -iE 'error|failed|denied' "$AREA/.deploy.log" | head -5 | sed 's/^/      /'
  exit 1
fi
