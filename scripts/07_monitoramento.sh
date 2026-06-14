#!/bin/bash
# =====================================================================
# 07_monitoramento.sh - Monitoramento do Sistema
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: coletar CPU, memoria, disco e status do Apache, com alertas.
# =====================================================================

LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/07_monitoramento.log"
mkdir -p "$LOG_DIR"

# Limites para alertas (em %)
LIMITE_CPU=80
LIMITE_MEM=80
LIMITE_DISCO=80

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------------------------------------------------------------------
# Funcao: monitorar
# Coleta e exibe os recursos do ambiente de atendimento.
# ---------------------------------------------------------------------
monitorar() {
    echo "================================================="
    echo " MONITORAMENTO - DescomplicaBusiness (Atendimento)"
    echo " Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================================="

    # ---- CPU ----
    # Uso de CPU = 100 - %idle (lido do top em modo batch)
    CPU_IDLE=$(top -bn1 | grep -i "Cpu(s)" | awk '{print $8}' | cut -d',' -f1)
    if [ -z "$CPU_IDLE" ]; then CPU_IDLE=100; fi
    CPU_USO=$(awk "BEGIN {printf \"%.0f\", 100 - $CPU_IDLE}")
    echo "[CPU]    Uso aproximado: ${CPU_USO}%"
    if [ "$CPU_USO" -ge "$LIMITE_CPU" ]; then
        echo "[ALERTA] Uso de CPU acima de ${LIMITE_CPU}%"
    fi

    # ---- Memoria ----
    MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    MEM_USADA=$(free -m | awk '/Mem:/ {print $3}')
    MEM_USO=$(awk "BEGIN {printf \"%.0f\", ($MEM_USADA/$MEM_TOTAL)*100}")
    echo "[MEM]    Uso de memoria: ${MEM_USO}% (${MEM_USADA}MB / ${MEM_TOTAL}MB)"
    if [ "$MEM_USO" -ge "$LIMITE_MEM" ]; then
        echo "[ALERTA] Uso de memoria acima de ${LIMITE_MEM}%"
    fi

    # ---- Disco ----
    DISCO_USO=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    echo "[DISCO]  Uso do disco (/): ${DISCO_USO}%"
    if [ "$DISCO_USO" -ge "$LIMITE_DISCO" ]; then
        echo "[ALERTA] Uso de disco acima de ${LIMITE_DISCO}%"
    fi

    # ---- Apache ----
    if pgrep -x apache2 >/dev/null 2>&1; then
        echo "[OK]     Apache em execucao"
    else
        echo "[ALERTA] Apache NAO esta em execucao"
    fi

    echo "================================================="
    registrar_log "Coleta -> CPU:${CPU_USO}% MEM:${MEM_USO}% DISCO:${DISCO_USO}%"
}

monitorar
