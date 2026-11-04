#!/usr/bin/env bash
# Desliga a produção local (8090) e o seu ambiente de desenvolvimento, SEM apagar dados.
# Para ligar a produção de novo: ./deploy.sh
source "$(dirname "$0")/.comum.sh"
[ -d "$PRODUCAO" ] && (cd "$PRODUCAO" && docker compose -p "$PROJETO_PROD" down) && echo "Produção desligada."
[ -f "$AREA/enzo-bank/compose.yaml" ] && (cd "$AREA/enzo-bank" && docker compose down) && echo "Ambiente de desenvolvimento desligado."
echo "Pronto. Os saldos continuam guardados nos volumes. Para religar a produção: ./deploy.sh"
