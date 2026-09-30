#!/usr/bin/env bash

cd "$(dirname "$0")/.."

DATA=$(date +%F)
RELATORIO="relatorios/diario-${DATA}.txt"

{
  echo "==== Relatório diário - Data: ${DATA} ===="
  echo ""

  # Contabiliza os erros no logs/app.log
  ERROS=$(grep -iwc "ERROR" logs/app.log)
  echo "- Total de linhas ERROR: ${ERROS}"

  # Total de pedidos entregues
  ENTREGUES=$(grep -cowi "entregue" logs/app.log)
  echo "- Total de entregas (status = entregue): ${ENTREGUES}"

  # Ranking dos 3 rastreios com mais erros
  echo "- Top 3 rastreios com mais erros:"
  grep -iw "ERROR" logs/app.log | grep -oE 'BR[0-9]{9}' | sort | uniq -c | sort -rn | head -3
} > "$RELATORIO"

echo "Relatorio '${RELATORIO}' criado."
