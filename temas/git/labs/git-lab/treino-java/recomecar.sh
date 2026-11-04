#!/usr/bin/env bash
# Apaga TUDO do treino no seu computador (clones, containers, volumes e imagens do Enzo Bank) e prepara de
# novo usando um projeto NOVO e vazio do GitLab.   Uso: ./recomecar.sh <url-ssh-do-projeto-novo>
source "$(dirname "$0")/.comum.sh"
[ -n "${1:-}" ] || { echo "Uso: ./recomecar.sh <url-ssh-de-um-projeto-NOVO-e-vazio>   (veja a missão 16)"; exit 1; }
read -rp "Isto apaga area/ (seus clones locais e os dados do treino). O projeto antigo no GitLab NÃO é apagado. Continuar? [s/N] " r
[[ "$r" =~ ^[sS]$ ]] || { echo "Cancelado."; exit 0; }
cd "$KIT" || exit 1   # sai de dentro da area/ antes de apagá-la
[ -d "$PRODUCAO" ] && (cd "$PRODUCAO" && docker compose -p "$PROJETO_PROD" down -v >/dev/null 2>&1)
[ -f "$AREA/enzo-bank/compose.yaml" ] && (cd "$AREA/enzo-bank" && docker compose down -v >/dev/null 2>&1)
for img in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep '^claude/enzo-bank:'); do docker rmi "$img" >/dev/null 2>&1; done
rm -rf "$AREA"
"$KIT/preparar.sh" "$1"
