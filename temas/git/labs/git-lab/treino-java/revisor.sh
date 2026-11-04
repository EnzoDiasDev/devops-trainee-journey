#!/usr/bin/env bash
# O "revisor" (Bruno, o tech lead) revisa o seu Merge Request ANTES de você clicar em Merge no GitLab:
# confere commits e arquivos, se há conflito com a main, se a imagem Docker constrói e se os testes
# passam dentro do container.   Uso: ./revisor.sh <nome-da-branch>
set -uo pipefail
source "$(dirname "$0")/.comum.sh"
exigir_treino
BRANCH="${1:-}"
[ -n "$BRANCH" ] || { echo "Uso: ./revisor.sh <nome-da-branch>"; exit 1; }

recusar() {
  echo; vermelho "❌ MR REPROVADO pelo Bruno. NÃO clique em Merge ainda:"
  for m in "$@"; do echo "   • $m"; done
  echo "   (Depois de corrigir e dar push, o MR no GitLab se atualiza sozinho. Rode o revisor de novo.)"
  echo; exit 1
}

echo "🔎 Bruno está revisando a branch '$BRANCH' (direto do GitLab)..."
equipe_na_main

[ "$BRANCH" = "main" ] && recusar "Não existe MR da main para a main. Crie uma branch (git switch -c ...)."
git rev-parse -q --verify "origin/$BRANCH" >/dev/null || recusar \
  "A branch '$BRANCH' não existe no GitLab." \
  "Você fez o push dela?  git push -u origin $BRANCH" \
  "Confira o nome exato com: git branch"

commits=$(git rev-list --count "origin/main..origin/$BRANCH")
[ "$commits" -eq 0 ] && recusar "A branch não tem nenhum commit novo em relação à main (o MR já foi juntado?)."

problemas=()
while IFS='|' read -r hash msg; do
  minus=$(echo "$msg" | tr '[:upper:]' '[:lower:]' | xargs)
  [[ "$minus" == merge* || "$minus" == revert* ]] && continue
  if [ ${#msg} -lt 12 ] || [[ "$minus" =~ ^(ajuste|ajustes|teste|testes|fix|wip|update|commit|mudança|mudanças|alteração|alterações|correção|ok|pronto|feito|asd.*|aaa.*)$ ]]; then
    problemas+=("Mensagem de commit vaga: \"$msg\" ($hash). Diga O QUE muda, ex.: \"Corrige saque com saldo insuficiente\".")
  fi
done < <(git log --format='%h|%s' "origin/main..origin/$BRANCH")

proibidos=$(git ls-tree -r --name-only "origin/$BRANCH" | grep -E '(^|/)out/|\.class$|(^|/)\.env$|(^|/)dados/|(^|/)token[^/]*\.txt$' || true)
[ -n "$proibidos" ] && problemas+=("Arquivos que não deveriam estar no Git: $(echo $proibidos). Use git rm --cached + .gitignore.")
[ ${#problemas[@]} -gt 0 ] && recusar "${problemas[@]}"

if ! git merge -q --no-ff --no-commit "origin/$BRANCH" >/dev/null 2>&1; then
  em_conflito=$(git diff --name-only --diff-filter=U | tr '\n' ' ')
  git merge --abort 2>/dev/null
  recusar "Sua branch tem CONFLITO com a main (arquivos: $em_conflito). O GitLab vai mostrar 'Merge blocked'." \
    "Resolva no seu computador:  git switch $BRANCH → git pull origin main → resolva → git add → git commit → git push"
fi

echo "🐳 Construindo a imagem Docker (como ficaria depois do Merge)..."
if ! docker build -q -t claude/enzo-bank:revisao . > "$AREA/.revisao.log" 2>&1; then
  git merge --abort 2>/dev/null
  grep -iE 'error|failed|denied|not found' "$AREA/.revisao.log" | head -6 | sed 's/^/      /'
  recusar "A imagem Docker NÃO constrói (veja acima). Teste antes: docker compose build"
fi
echo "🧪 Rodando os testes dentro do container..."
saida=$(docker run --rm claude/enzo-bank:revisao java src/Testes.java 2>&1); status=$?
git merge --abort 2>/dev/null
if [ $status -ne 0 ]; then
  echo "$saida" | grep -E '✘|❌|error:|Exception' | head -10 | sed 's/^/      /'
  recusar "Testes falhando ou código que não compila (veja acima)." \
    "Rode no seu computador:  docker compose run --rm --build api java src/Testes.java"
fi

echo
verde "✅ MR APROVADO pelo Bruno! ($commits commit(s) revisados, imagem constrói, testes passam no container)"
echo
amarelo "Próximos passos:"
echo "   1. No GitLab, abra o MR e clique em  Merge  (deixe marcado 'Delete source branch')"
echo "   2. ../../deploy.sh                       ← publica em produção"
echo "   3. git switch main && git pull"
echo "   4. git branch -d $BRANCH && git fetch --prune"
