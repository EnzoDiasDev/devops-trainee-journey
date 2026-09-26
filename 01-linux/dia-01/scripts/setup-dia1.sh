#!/usr/bin/env bash
# =============================================================
#  setup-dia1.sh  —  Laboratório Linux, Dia 1 (LogiTrack)
#  Cria um "servidor" fictício de uma empresa de logística em
#  ~/lab-linux/logitrack para você investigar e consertar.
#  Uso:  bash setup-dia1.sh
# =============================================================
set -euo pipefail

LAB="$HOME/lab-linux/logitrack"

if [[ -d "$LAB" ]]; then
  echo "Já existe um laboratório em $LAB."
  read -rp "Apagar e recriar do zero? [s/N] " resp
  if [[ "${resp,,}" == "s" ]]; then
    chmod -R u+rwX "$LAB" 2>/dev/null || true
    rm -rf "$LAB"
  else
    echo "Nada foi alterado."
    exit 0
  fi
fi

echo "Montando o laboratório em $LAB ..."
mkdir -p "$LAB"/{app,config,logs,backups,scripts,relatorios,entregas/2026}

# Gerador pseudoaleatório com semente fixa (todo mundo recebe o mesmo lab)
SEED=20260926
rnd() { SEED=$(( (SEED * 1103515245 + 12345) % 2147483648 )); R=$(( (SEED / 65536) % $1 )); }

# ---------- Missão 1: arquivo oculto ----------
cat > "$LAB/app/.leia-me" << 'TXT'
Quase! Esse arquivo é oculto, mas não é o que você procura.
Continue cavando: existem pastas ocultas também.
TXT
mkdir -p "$LAB/app/.config-antiga/v1"
cat > "$LAB/app/.config-antiga/v1/.boas-vindas" << 'TXT'
Achou! Arquivos e pastas que começam com ponto não aparecem no "ls" comum.
Código da Missão 1: TRILHA-7Q
TXT
cat > "$LAB/app/main.py" << 'TXT'
# Sistema de rastreio da LogiTrack (arquivo ilustrativo do laboratório)
print("LogiTrack rodando")
TXT
printf 'requests==2.32.3\n' > "$LAB/app/requirements.txt"

# ---------- Configs ----------
cat > "$LAB/config/banco.conf" << 'TXT'
# Configuração do banco da LogiTrack (LABORATÓRIO: credenciais falsas)
DB_HOST=localhost
DB_USER=logitrack
DB_PASS=senha-falsa-do-lab
TXT
cat > "$LAB/config/app.conf" << 'TXT'
PORTA=8080
AMBIENTE=homologacao
TXT

# ---------- Missão 2: entregas (find) ----------
n_csv=0
for mes in 07 08 09; do
  rnd 4; nlotes=$(( 6 + R ))
  for (( i=1; i<=nlotes; i++ )); do
    lote="$LAB/entregas/2026/$mes/lote-$mes-$(printf '%02d' "$i")"
    mkdir -p "$lote"
    printf 'rastreio,cidade,status\nBR%09d,Sao Paulo,entregue\n' "$SEED" > "$lote/manifesto.csv"; n_csv=$((n_csv+1))
    rnd 2; if (( R == 0 )); then printf 'rota,km\nR1,%d\n' "$R" > "$lote/rotas.csv"; n_csv=$((n_csv+1)); fi
    rnd 3; if (( R == 0 )); then printf 'rastreio,ocorrencia\n' > "$lote/ocorrencias.csv"; n_csv=$((n_csv+1)); fi
    rnd 2; if (( R == 0 )); then echo "Lote conferido." > "$lote/notas.txt"; fi
    rnd 4; if (( R == 0 )); then echo '{"ok": true}' > "$lote/resumo.json"; fi
    rnd 9; if (( R == 0 )); then echo "rascunho" > "$lote/.rascunho.csv"; n_csv=$((n_csv+1)); fi
  done
done
# Pegadinhas
mkdir -p "$LAB/entregas/2026/antigos.csv"
echo "Isto é uma PASTA chamada antigos.csv, não um arquivo." > "$LAB/entregas/2026/antigos.csv/LEIA.txt"
echo "arquivo sem extensão" > "$LAB/entregas/2026/07/csv"
head -c 409600 /dev/zero > "$LAB/entregas/2026/09/lote-09-02/fotos-comprovantes.zip"
head -c 614400 /dev/zero > "$LAB/entregas/2026/08/lote-08-03/manifesto-extra.dat"

# ---------- Missão 3: log da aplicação ----------
codes=()
for (( c=0; c<30; c++ )); do rnd 32768; a=$R; rnd 32768; codes+=( "$(printf 'BR%09d' $(( (a * 32768 + R) % 1000000000 )) )" ); done
hot="${codes[7]}"
declare -A err_by_code=()
n_err=0; t=0
ok_msgs=(entregue em_transito saiu_para_entrega postado)
err_msgs=(endereco_invalido destinatario_ausente falha_api_correios)
{
  for (( l=0; l<2000; l++ )); do
    rnd 90; t=$(( t + 20 + R ))
    d=$(( 20 + t / 86400 )); h=$(( (t % 86400) / 3600 )); m=$(( (t % 3600) / 60 )); s=$(( t % 60 ))
    ts=$(printf '2026-09-%02d %02d:%02d:%02d' "$d" "$h" "$m" "$s")
    rnd 30; code="${codes[$R]}"
    rnd 100; lvl=$R
    if (( lvl < 68 )); then
      rnd 4; echo "$ts [INFO] rastreio=$code status=${ok_msgs[$R]}"
    elif (( lvl < 80 )); then
      echo "$ts [WARN] rastreio=$code status=atraso previsao=+1d"
    elif (( lvl < 93 )); then
      rnd 4; (( R == 0 )) && code="$hot"
      rnd 3; echo "$ts [ERROR] rastreio=$code status=${err_msgs[$R]}"
      n_err=$(( n_err + 1 )); err_by_code[$code]=$(( ${err_by_code[$code]:-0} + 1 ))
    else
      echo "$ts [INFO] rastreio=$code status=entregue msg=reprocessado_apos_ERROR"
    fi
  done
} > "$LAB/logs/app.log"
top_code=""; top_n=0
for c in "${!err_by_code[@]}"; do
  if (( err_by_code[$c] > top_n )); then top_n=${err_by_code[$c]}; top_code=$c; fi
done

# ---------- Scripts ----------
cat > "$LAB/scripts/backup.sh" << 'TXT'
#!/usr/bin/env bash
# Faz backup das pastas config/ e app/ da LogiTrack
DIR="$(cd "$(dirname "$0")/.." && pwd)"
DESTINO="$DIR/backups/backup-$(date +%F-%H%M%S).tar.gz"
if tar -czf "$DESTINO" -C "$DIR" config app; then
  echo "Backup criado em: $DESTINO"
else
  echo "FALHOU ao criar o backup. Investigue a mensagem de erro acima." >&2
  exit 1
fi
TXT

cat > "$LAB/scripts/gerar-log.sh" << 'TXT'
#!/usr/bin/env bash
# Escreve uma linha por segundo em logs/ao-vivo.log durante 60 segundos.
# Use para treinar "tail -f" em outro terminal.
DIR="$(cd "$(dirname "$0")/.." && pwd)"
st=(INFO INFO INFO WARN ERROR)
for i in $(seq 1 60); do
  echo "$(date '+%F %T') [${st[$((RANDOM % 5))]}] rastreio=BR$((RANDOM * RANDOM)) evento=$i" >> "$DIR/logs/ao-vivo.log"
  sleep 1
done
echo "Pronto: 60 linhas escritas em logs/ao-vivo.log"
TXT
chmod 755 "$LAB/scripts/gerar-log.sh"

# ---------- Gabarito (só hashes, não adianta ler) ----------
h() { printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | sha256sum | cut -d' ' -f1; }
cat > "$LAB/.gabarito" << TXT
# Sim, você achou o gabarito. São hashes SHA-256: dá pra conferir, não dá pra ler.
H_M1=$(h "TRILHA-7Q")
H_M2A=$(h "manifesto-extra.dat")
H_M2B=$(h "$n_csv")
H_M3A=$(h "$n_err")
H_M3B=$(h "$top_code")
TXT

cat > "$LAB/respostas.txt" << 'TXT'
# Preencha depois do "=" (sem espaços). Depois rode: bash verificar.sh
M1=
M2A=
M2B=
M3A=
M3B=
TXT

# ---------- Verificador ----------
cat > "$LAB/verificar.sh" << 'TXT'
#!/usr/bin/env bash
# Confere o progresso do Dia 1. Rode de dentro de ~/lab-linux/logitrack
LAB="$(cd "$(dirname "$0")" && pwd)"
source "$LAB/.gabarito"
h()  { printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | sha256sum | cut -d' ' -f1; }
ok() { echo "  ✅ $1"; }
no() { echo "  ❌ $1"; }
resp() { grep -E "^$1=" "$LAB/respostas.txt" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '[:space:]'; }
checa() { local v; v="$(resp "$1")"
  if [[ -z "$v" ]]; then no "$1: sem resposta"
  elif [[ "$(h "$v")" == "$2" ]]; then ok "$1: correta"
  else no "$1: '$v' não confere"; fi; }
perm() { stat -c '%a' "$1" 2>/dev/null; }

echo "== Respostas =="
checa M1 "$H_M1"; checa M2A "$H_M2A"; checa M2B "$H_M2B"; checa M3A "$H_M3A"; checa M3B "$H_M3B"

echo "== Missão 4: redirecionamento =="
f="$LAB/relatorios/confs.txt"
if [[ -s "$f" ]] && ! grep -qiE 'permission denied|permissão negada|permiss.o negada' "$f"; then ok "confs.txt limpo, sem mensagens de erro"
elif [[ -s "$f" ]]; then no "confs.txt tem mensagens de erro misturadas"
else no "relatorios/confs.txt não existe ou está vazio"; fi

echo "== Missão 5: permissões =="
[[ "$(perm "$LAB/config/banco.conf")" == "600" ]] && ok "5A banco.conf protegido" || no "5A banco.conf está $(perm "$LAB/config/banco.conf")"
b="$LAB/scripts/backup.sh"
if [[ -x "$b" && -O "$b" ]] && (( ($(stat -c '%a' "$b") % 100) / 10 % 4 < 2 )) && (( $(stat -c '%a' "$b") % 10 % 4 < 2 )); then
  ok "5B backup.sh executável e sem escrita para grupo/outros"
else no "5B backup.sh ainda não está como deveria"; fi
if compgen -G "$LAB/backups/backup-*.tar.gz" > /dev/null; then ok "5B backup gerado"; else no "5B nenhum backup em backups/"; fi
[[ "$(perm "$LAB/relatorios/secreto.txt")" == "600" ]] && ok "5C secreto.txt criado com umask certo" || no "5C relatorios/secreto.txt ausente ou com permissão errada"
d=/srv/logitrack-compartilhado
if [[ -d "$d" && "$(stat -c '%G %a' "$d")" == "logistica 2770" ]]; then ok "5D pasta compartilhada (logistica, 2770)"
else no "5D $d ausente ou diferente de grupo logistica + 2770"; fi
if [[ -d "$d" ]] && sudo -n true 2>/dev/null && sudo find "$d" -type f -user motorista -group logistica 2>/dev/null | grep -q .; then ok "5D arquivo do motorista herdou o grupo"
elif [[ -r "$d" ]] && find "$d" -type f -user motorista -group logistica 2>/dev/null | grep -q .; then ok "5D arquivo do motorista herdou o grupo"
else no "5D nenhum arquivo do usuário motorista com grupo logistica (se a pasta existe, rode 'sudo -v' antes)"; fi

echo "== Missão 6: seu primeiro script =="
s="$LAB/scripts/relatorio-diario.sh"
if [[ -x "$s" ]] && head -1 "$s" | grep -q '^#!'; then ok "relatorio-diario.sh existe, tem shebang e é executável"
else no "scripts/relatorio-diario.sh ausente, sem shebang ou sem permissão de execução"; fi
rel=$(ls -1 "$LAB"/relatorios/diario-*.txt 2>/dev/null | tail -1)
if [[ -n "$rel" ]]; then
  achou_n=0; achou_c=0
  for n in $(grep -oE '[0-9]+' "$rel"); do [[ "$(h "$n")" == "$H_M3A" ]] && achou_n=1; done
  for c in $(grep -oE 'BR[0-9]{9}' "$rel"); do [[ "$(h "$c")" == "$H_M3B" ]] && achou_c=1; done
  (( achou_n )) && ok "relatório tem o total de erros certo" || no "relatório não tem o total de erros certo"
  (( achou_c )) && ok "relatório mostra o rastreio campeão de erros" || no "relatório não mostra o rastreio campeão de erros"
else no "nenhum relatorios/diario-AAAA-MM-DD.txt gerado"; fi
TXT
chmod 755 "$LAB/verificar.sh"

# Estado "quebrado" inicial que você vai consertar
chmod 777 "$LAB/config/banco.conf"
chmod 644 "$LAB/scripts/backup.sh"
chmod 555 "$LAB/backups"

echo
echo "Pronto! Laboratório criado em: $LAB"
echo "Próximo passo:  cd $LAB   e abra o MISSOES-DIA1.md"
