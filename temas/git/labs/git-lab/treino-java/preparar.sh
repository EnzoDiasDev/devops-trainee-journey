#!/usr/bin/env bash
# Envia o projeto Enzo Bank (com o histórico da equipe) para um projeto VAZIO seu no GitLab
# e coloca a "produção" local no ar em http://localhost:8090.
# Uso: ./preparar.sh <url-ssh-do-projeto>
#  Ex: ./preparar.sh ssh://git@gitlab.example.com:2222/seu.usuario/enzo-bank.git
set -euo pipefail
source "$(dirname "$0")/.comum.sh"
URL="${1:-}"

[ -n "$URL" ] || { echo "Uso: ./preparar.sh <url-ssh-do-projeto>   (veja a missão 00)"; exit 1; }
[ -d "$AREA" ] && { echo "A área de treino já existe. Para começar de novo: ./recomecar.sh <url-de-um-projeto-novo>"; exit 1; }

# Formato "git@host:2222/caminho" não funciona: nesse formato o Git entende "2222/..." como pasta, e não como porta.
if [[ "$URL" != *://* && "$URL" =~ ^([^@:/]+@[^:/]+):([0-9]+)/(.+)$ ]]; then
  vermelho "Essa URL mistura dois formatos e o Git vai ignorar a porta ${BASH_REMATCH[2]}."
  echo "   Use o formato ssh:// (que aceita porta):"
  echo "   ./preparar.sh ssh://${BASH_REMATCH[1]}:${BASH_REMATCH[2]}/${BASH_REMATCH[3]}"
  exit 1
fi
command -v docker >/dev/null || { vermelho "Docker não encontrado."; exit 1; }

echo "🔌 Testando o acesso ao projeto no GitLab..."
erros_ssh="$(mktemp)"
if ! refs=$(git ls-remote "$URL" 2>"$erros_ssh"); then
  vermelho "Não consegui acessar $URL"
  grep -vE 'post-quantum|store now, decrypt later|may need to be upgraded|Permanently added' "$erros_ssh" | sed 's/^/   /' | head -5
  echo "   Confira: a URL (botão 'Clone' → 'Clone with SSH'), a chave SSH no GitLab e 'ssh -T -p 2222 git@<servidor>' (missão 00)."
  exit 1
fi
rm -f "$erros_ssh"
if [ -n "$refs" ]; then
  vermelho "O projeto não está vazio. Crie um projeto novo SEM 'Initialize repository with a README' (missão 00)."
  exit 1
fi

docker image inspect claude/temurin:25-jdk-alpine >/dev/null 2>&1 || {
  echo "🐳 Baixando a imagem do Java (só na primeira vez)..."
  docker pull -q eclipse-temurin:25-jdk-alpine
  docker tag eclipse-temurin:25-jdk-alpine claude/temurin:25-jdk-alpine
  docker rmi eclipse-temurin:25-jdk-alpine >/dev/null
}

mkdir -p "$AREA"
echo "$URL" > "$AREA/.url"
git init -q -b main "$EQUIPE"
cd "$EQUIPE"
git remote add origin "$URL"
git config pull.rebase false; git config core.editor true

commit_em() {   # commit_em "Nome" email dias "mensagem"
  local data; data="$(date -d "$3 days ago 10:00" -R)"
  GIT_AUTHOR_DATE="$data" GIT_COMMITTER_DATE="$data" como "$1" "$2" commit -q -m "$4"
}
BASE="$KIT/codigo-inicial"
ANA=("Ana Souza" "ana@enzobank.dev"); BRUNO=("Bruno Lima" "bruno@enzobank.dev")

mkdir -p src
cp "$BASE/src/Conta.java" src/;  git add src/Conta.java
commit_em "${ANA[@]}" 14 "Cria classe Conta com depósito, saque e transferência"
cp "$BASE/src/Testes.java" src/; git add src/Testes.java
commit_em "${ANA[@]}" 13 "Adiciona testes da classe Conta"
cp "$BASE/src/Banco.java" "$BASE/src/App.java" src/; git add src
commit_em "${ANA[@]}" 12 "Cria a API HTTP do banco"
git switch -q -c feature/docker
cp "$BASE/Dockerfile" .;   git add Dockerfile
commit_em "${BRUNO[@]}" 10 "Adiciona Dockerfile da API"
cp "$BASE/compose.yaml" .; git add compose.yaml
commit_em "${BRUNO[@]}" 10 "Adiciona compose com volume para os saldos"
git switch -q main
cp "$BASE/README.md" .;    git add README.md
commit_em "${ANA[@]}" 9 "Adiciona README do projeto"
data="$(date -d '8 days ago 15:00' -R)"
GIT_AUTHOR_DATE="$data" GIT_COMMITTER_DATE="$data" \
  como "Ana Souza" ana@enzobank.dev merge -q --no-ff feature/docker -m "Merge branch 'feature/docker' (MR aprovado por Ana)"
git branch -q -d feature/docker

echo "⬆️  Enviando o histórico da equipe para o GitLab..."
if ! saida_push=$(git push -q -u origin main 2>&1); then
  vermelho "O GitLab recusou o envio:"
  echo "$saida_push" | grep -vE '^remote: *$|post-quantum|store now|may need to be upgraded' | sed 's/^/   /' | head -8
  echo "   Apague a pasta area/ (rm -rf area) depois de resolver, e rode o preparar de novo."
  exit 1
fi

"$KIT/deploy.sh" || amarelo "⚠️  O primeiro deploy falhou (veja acima). O projeto já está no GitLab; depois rode ./deploy.sh de novo."

echo
verde "✅ Treino preparado!"
echo "   Projeto no GitLab:  $URL"
echo "   Produção local:     http://localhost:$PORTA_PROD"
echo
echo "Próximo passo: missão 01 (clonar o projeto do GitLab)."
