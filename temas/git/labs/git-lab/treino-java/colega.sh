#!/usr/bin/env bash
# Simula colegas da equipe mexendo no projeto do GitLab.  Uso: ./colega.sh <missão>  (a missão diz quando)
set -uo pipefail
source "$(dirname "$0")/.comum.sh"
exigir_treino
equipe_na_main

enviar() {  # git push mostrando só o erro, se houver
  local saida; saida=$(git push -q "$@" 2>&1) || { vermelho "O GitLab recusou o push dos colegas:"; echo "$saida" | grep -v '^remote: *$' | sed 's/^/   /' | head -6
    if echo "$saida" | grep -q 'protected branch'; then
      amarelo "   A main do seu projeto está protegida (alguns GitLab fazem isso por padrão)."
      echo "   Para este evento, libere por um instante: Settings → Repository → Protected branches →"
      echo "   'Allowed to push and merge' = Maintainers. Rode o colega.sh de novo e depois volte para 'No one'."
    fi
    exit 1; }
}

case "${1:-}" in
  07)
    B="feature/limite-saque"
    git rev-parse -q --verify "origin/$B" >/dev/null || { echo "❗ A branch $B ainda não está no GitLab. Faça o push dela primeiro."; exit 1; }
    git switch -q -C "$B" "origin/$B"
    sed -i 's|^        // FIM DOS TESTES|        // saque no limite exato\n        Conta c6 = new Conta("Teste");\n        c6.depositar(5000);\n        c6.sacar(1000);\n        verificar("deixa sacar exatamente R$ 1000", c6.getSaldo() == 4000);\n\n        // FIM DOS TESTES|' src/Testes.java
    git add src/Testes.java
    como "Bruno Lima" bruno@enzobank.dev commit -q -m "Testa saque no limite exato de R\$ 1000"
    enviar origin "$B"
    git switch -q main; git branch -q -D "$B"
    echo "👨‍💻 Bruno: \"Vi o seu MR do limite de saque e já subi um teste a mais na SUA branch ($B). Olha lá no GitLab! 😉\""
    ;;
  08)
    git switch -q -c feature/versao-no-nome
    sed -i 's|^      BANCO_NOME: .*|      BANCO_NOME: Enzo Bank v2|' compose.yaml
    git add compose.yaml
    como "Ana Souza" ana@enzobank.dev commit -q -m "Mostra a versão 2 no nome do banco"
    git switch -q main
    como "Ana Souza" ana@enzobank.dev merge -q --no-ff feature/versao-no-nome -m "Merge branch 'feature/versao-no-nome' (MR aprovado por Bruno)"
    git branch -q -d feature/versao-no-nome
    enviar origin main
    echo "👩‍💻 Ana: \"Acabei de juntar na main uma mudança no nome do banco, no compose.yaml (versão 2)! Já fiz o deploy.\""
    "$KIT/deploy.sh" | tail -1
    ;;
  09)
    sed -i 's|^FROM .*|FROM claude/java:25|' Dockerfile
    git add Dockerfile
    como "Carla Mendes" carla@enzobank.dev commit -q -m "Atualiza a imagem base do Java"
    enviar origin main
    echo "👩‍🎓 Carla (estagiária): \"Atualizei a imagem base do Java! Subi direto na main, era só uma linha. 😇\""
    echo "   (rodando o deploy...)"
    "$KIT/deploy.sh"
    echo
    echo "📢 Bruno: \"Gente, o deploy quebrou! Alguém pode ver?\""
    ;;
  *) echo "Uso: ./colega.sh <missão>   (eventos disponíveis: 07, 08, 09)"; exit 1 ;;
esac
