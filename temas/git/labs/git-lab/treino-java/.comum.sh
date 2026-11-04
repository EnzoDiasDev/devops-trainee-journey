# Funções compartilhadas pelos scripts do treino (não rode este arquivo diretamente).
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AREA="$KIT/area"
EQUIPE="$AREA/.equipe"          # clone usado pelos "colegas" simulados
PRODUCAO="$AREA/.producao"      # clone que roda a "produção" local
PROJETO_PROD="${TREINO_PROJETO_PROD:-claude-enzobank-prod}"
PORTA_PROD="${TREINO_PORTA_PROD:-8090}"
URL_GITLAB="$(cat "$AREA/.url" 2>/dev/null || true)"

# O SSH do GitLab (container) não oferece troca de chaves "post-quantum" e o cliente avisa a cada conexão.
# O aviso não é um erro; nos scripts ele só polui a saída, então é silenciado quando o ssh suporta a opção.
if ssh -G -o WarnWeakCrypto=no localhost >/dev/null 2>&1; then
  export GIT_SSH_COMMAND="ssh -o WarnWeakCrypto=no"
fi

vermelho() { printf '\e[31m%s\e[0m\n' "$*"; }
verde()    { printf '\e[32m%s\e[0m\n' "$*"; }
amarelo()  { printf '\e[33m%s\e[0m\n' "$*"; }

exigir_treino() { [ -d "$EQUIPE" ] || { vermelho "Treino não preparado. Veja a missão 00 (./preparar.sh <url>)."; exit 1; }; }

como() {  # como "Nome" email <comando git...>  → roda git com essa identidade
  local nome="$1" email="$2"; shift 2
  GIT_AUTHOR_NAME="$nome" GIT_AUTHOR_EMAIL="$email" GIT_COMMITTER_NAME="$nome" GIT_COMMITTER_EMAIL="$email" git "$@"
}

equipe_na_main() {  # deixa o clone da equipe idêntico à main do GitLab
  cd "$EQUIPE" || exit 1
  git fetch -q --prune origin || { vermelho "Não consegui falar com o GitLab ($URL_GITLAB). VPN/rede ok?"; exit 1; }
  git switch -q main 2>/dev/null
  git reset -q --hard origin/main
  git clean -qfd
}
