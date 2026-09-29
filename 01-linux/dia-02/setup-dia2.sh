#!/usr/bin/env bash
# =============================================================
#  setup-dia2.sh  —  Laboratório Linux, Dia 2 (LogiTrack)
#  Processos, sinais, systemd, journalctl e cron.
#  Pré-requisito: Dia 1 feito (usuário motorista e grupo logistica).
#  Uso:  bash setup-dia2.sh
# =============================================================
set -euo pipefail

LAB="$HOME/lab-linux/logitrack"
D2="$LAB/dia2"
OPT=/opt/logitrack

# ---------- Pré-requisitos ----------
[[ -d "$LAB" ]] || { echo "Não achei $LAB. Rode o setup do Dia 1 primeiro."; exit 1; }
id motorista >/dev/null 2>&1 || { echo "Usuário 'motorista' não existe. Ele é criado na Missão 5D do Dia 1."; exit 1; }
getent group logistica >/dev/null || { echo "Grupo 'logistica' não existe. Ele é criado na Missão 5D do Dia 1."; exit 1; }

echo "Este setup precisa de sudo (vai criar arquivos em $OPT e iniciar processos de teste)."
sudo -v

# ---------- Limpa rodadas anteriores ----------
sudo pkill -f "$OPT/bin/" 2>/dev/null || true
sleep 1
sudo rm -rf "$OPT/bin"
rm -rf "$D2"

sudo mkdir -p "$OPT/bin" "$OPT/servicos"
mkdir -p "$D2"

# ---------- Processos "problemáticos" (todos se encerram sozinhos em 3h) ----------
sudo tee "$OPT/bin/logitrack-sync" > /dev/null << 'TXT'
#!/usr/bin/env bash
# Sincronizador com bug: fica em loop ocupado e come um núcleo inteiro de CPU.
fim=$(( SECONDS + 10800 ))
while (( SECONDS < fim )); do :; done
TXT

sudo tee "$OPT/bin/logitrack-coletor" > /dev/null << 'TXT'
#!/usr/bin/env bash
# Coletor de rastreios. Recebe destino e token pela linha de comando (péssima ideia).
fim=$(( SECONDS + 10800 ))
while (( SECONDS < fim )); do sleep 5; done
TXT

sudo tee "$OPT/bin/logitrack-teimoso" > /dev/null << 'TXT'
#!/usr/bin/env bash
# Processo que ignora os pedidos educados de encerramento.
trap '' TERM INT HUP
fim=$(( SECONDS + 10800 ))
while (( SECONDS < fim )); do sleep 1; done
TXT

sudo tee "$OPT/bin/logitrack-worker" > /dev/null << 'TXT'
#!/usr/bin/env bash
fim=$(( SECONDS + 10800 ))
while (( SECONDS < fim )); do sleep 2; done
TXT

sudo tee "$OPT/bin/logitrack-supervisor" > /dev/null << 'TXT'
#!/usr/bin/env bash
# Mantém o worker sempre de pé: se ele morrer, sobe outro.
fim=$(( SECONDS + 10800 ))
while (( SECONDS < fim )); do
  bash /opt/logitrack/bin/logitrack-worker &
  wait $!
  sleep 1
done
TXT
sudo chmod 755 "$OPT/bin/"*

# ---------- Serviço para a Missão 3 ----------
sudo tee "$OPT/servicos/rastreador.sh" > /dev/null << 'TXT'
#!/usr/bin/env bash
# Rastreador da LogiTrack: consulta a "API" a cada 5 segundos.
CONF=/opt/logitrack/servicos/rastreador.conf
if ! source "$CONF"; then
  echo "ERRO: não consegui ler $CONF (usuário atual: $(whoami))" >&2
  exit 1
fi
echo "Rastreador iniciado como $(whoami). Código do turno: $CODIGO_TURNO"
n=0
while true; do
  n=$(( n + 1 ))
  echo "ciclo $n: consultando $DESTINO"
  sleep 5
done
TXT
sudo tee "$OPT/servicos/rastreador.conf" > /dev/null << 'TXT'
DESTINO=api.correios.lab
CODIGO_TURNO=TURNO-B3
TXT
sudo chmod 755 "$OPT" "$OPT/servicos" "$OPT/servicos/rastreador.sh"
sudo chown root:root "$OPT/servicos/rastreador.conf"
sudo chmod 600 "$OPT/servicos/rastreador.conf"

# ---------- Sobe os processos ----------
setsid nohup bash "$OPT/bin/logitrack-sync" > /dev/null 2>&1 < /dev/null &
setsid nohup bash "$OPT/bin/logitrack-teimoso" > /dev/null 2>&1 < /dev/null &
setsid nohup bash "$OPT/bin/logitrack-supervisor" > /dev/null 2>&1 < /dev/null &
sudo -u motorista setsid nohup bash "$OPT/bin/logitrack-coletor" \
  --destino=api.correios.lab --token=LAB-TK-4F7Q9 > /dev/null 2>&1 < /dev/null &
sleep 1

# ---------- Respostas, gabarito e verificador ----------
h() { printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | sha256sum | cut -d' ' -f1; }
cat > "$D2/.gabarito" << TXT
H_M1A=$(h "logitrack-sync")
H_M1B=$(h "motorista")
H_M1C=$(h "LAB-TK-4F7Q9")
H_M1D=$(h "logitrack-supervisor")
H_M4A=$(h "TURNO-B3")
TXT

cat > "$D2/respostas-dia2.txt" << 'TXT'
# Preencha depois do "=" (sem espaços). Depois rode: bash verificar-dia2.sh
M1A=
M1B=
M1C=
M1D=
M4A=
TXT

cat > "$D2/verificar-dia2.sh" << 'TXT'
#!/usr/bin/env bash
D2="$(cd "$(dirname "$0")" && pwd)"
source "$D2/.gabarito"
h()  { printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | sha256sum | cut -d' ' -f1; }
ok() { echo "  ✅ $1"; }
no() { echo "  ❌ $1"; }
resp() { grep -E "^$1=" "$D2/respostas-dia2.txt" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '[:space:]'; }
checa() { local v; v="$(resp "$1")"
  if [[ -z "$v" ]]; then no "$1: sem resposta"
  elif [[ "$(h "$v")" == "$2" ]]; then ok "$1: correta"
  else no "$1: '$v' não confere"; fi; }
vivo() { pgrep -f "/opt/logitrack/bin/$1" > /dev/null; }

echo "== Missão 1: processos e sinais =="
checa M1A "$H_M1A"; checa M1B "$H_M1B"; checa M1C "$H_M1C"; checa M1D "$H_M1D"
vivo logitrack-sync     && no "logitrack-sync ainda está rodando"     || ok "logitrack-sync encerrado"
vivo logitrack-teimoso  && no "logitrack-teimoso ainda está rodando"  || ok "logitrack-teimoso encerrado"
if vivo logitrack-supervisor || vivo logitrack-worker; then no "supervisor e/ou worker ainda estão rodando"
else ok "supervisor e worker encerrados"; fi
vivo logitrack-coletor && ok "coletor segue rodando (era pra ficar, você só precisava investigar)" \
                        || no "o coletor foi encerrado, mas era só pra investigar (rode o setup de novo se quiser)"

echo "== Missão 3: serviço systemd =="
S=logitrack-rastreador.service
if systemctl cat "$S" > /dev/null 2>&1; then
  ok "unit $S existe"
  [[ "$(systemctl is-active "$S")"  == active  ]] && ok "serviço ativo (rodando)" || no "serviço não está ativo: $(systemctl is-active "$S")"
  [[ "$(systemctl is-enabled "$S" 2>/dev/null)" == enabled ]] && ok "habilitado no boot" || no "não está habilitado no boot"
  [[ "$(systemctl show -p User --value "$S")" == motorista ]] && ok "roda como motorista" || no "não está rodando como o usuário motorista"
  r="$(systemctl show -p Restart --value "$S")"
  [[ "$r" == on-failure || "$r" == always ]] && ok "reinicia sozinho se cair (Restart=$r)" || no "não reinicia sozinho (Restart=$r)"
  c="$(stat -c '%a' /opt/logitrack/servicos/rastreador.conf)"
  (( c % 10 == 0 )) && ok "rastreador.conf não está aberto para outros ($c)" || no "rastreador.conf ficou aberto para outros ($c)"
else no "unit $S não encontrada"; fi

echo "== Missão 4: logs =="
checa M4A "$H_M4A"

echo "== Missão 5: cron =="
ct="$(crontab -l 2>/dev/null | grep -v '^\s*#')"
linha="$(grep 'relatorio-diario' <<< "$ct")"
if [[ -z "$linha" ]]; then no "nenhuma tarefa com relatorio-diario no seu crontab"
else
  grep -qE '^0[[:space:]]+7[[:space:]]+\*[[:space:]]+\*[[:space:]]+1-5[[:space:]]' <<< "$linha" \
    && ok "agendado para 07:00 de segunda a sexta" || no "horário ainda não é 07:00 de segunda a sexta"
  grep -q '2>&1' <<< "$linha" && grep -q 'cron.log' <<< "$linha" \
    && ok "saída e erros indo para cron.log" || no "a linha não manda saída e erros para logs/cron.log"
fi
[[ -s "$HOME/lab-linux/logitrack/logs/cron.log" ]] && ok "cron.log existe (o cron já rodou pelo menos uma vez)" \
  || no "logs/cron.log vazio: teste com um horário de 'todo minuto' antes do definitivo"
grep -q 'backups' <<< "$ct" && grep -q 'mtime' <<< "$ct" && ok "extra: limpeza de backups agendada" || echo "  ➖ extra: limpeza de backups não agendada (opcional)"
TXT
chmod 755 "$D2/verificar-dia2.sh"

echo
echo "Pronto! Arquivos do Dia 2 em: $D2"
echo "Alguns processos da LogiTrack já estão rodando na sua máquina... e um deles está esquentando o notebook."
echo "Abra o MISSOES-DIA2.md e comece pela Missão 1."
