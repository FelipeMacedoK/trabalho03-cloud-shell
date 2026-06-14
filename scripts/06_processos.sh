#!/bin/bash
# =====================================================================
# 06_processos.sh - Gerenciamento de Processos
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Uso:
#   ./06_processos.sh listar
#   ./06_processos.sh buscar apache
#   ./06_processos.sh matar 1234
# =====================================================================

LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/06_processos.log"
mkdir -p "$LOG_DIR"

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------------------------------------------------------------------
# Funcao: listar_processos
# Lista os processos ativos do ambiente de atendimento.
# ---------------------------------------------------------------------
listar_processos() {
    echo "[INFO] Processos ativos no ambiente de atendimento:"
    ps aux
    registrar_log "Listagem de processos executada."
}

# ---------------------------------------------------------------------
# Funcao: buscar_processo
# Busca um processo por nome (ex: apache).
# ---------------------------------------------------------------------
buscar_processo() {
    local nome="$1"
    if [ -z "$nome" ]; then
        echo "[ERRO] Informe o nome do processo. Ex: ./06_processos.sh buscar apache"
        return 1
    fi
    echo "[INFO] Buscando processos com nome '$nome':"
    ps aux | grep -i "$nome" | grep -v grep
    registrar_log "Busca de processo: $nome"
}

# ---------------------------------------------------------------------
# Funcao: matar_processo
# Encerra um processo pelo PID informado como parametro.
# ---------------------------------------------------------------------
matar_processo() {
    local pid="$1"
    # Seguranca: impede encerramento sem PID
    if [ -z "$pid" ]; then
        echo "[SEGURANCA] Nenhum PID informado. Operacao cancelada."
        echo "Uso correto: ./06_processos.sh matar <PID>"
        registrar_log "Tentativa de matar processo sem PID (bloqueada)."
        return 1
    fi
    # Seguranca: valida se e numero
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "[SEGURANCA] PID invalido: '$pid'. Informe apenas numeros."
        return 1
    fi

    echo "[INFO] Encerrando processo PID $pid ..."
    if kill "$pid" 2>/dev/null; then
        echo "[OK] Processo $pid encerrado."
        registrar_log "Processo $pid encerrado."
    else
        echo "[ALERTA] Nao foi possivel encerrar o processo $pid (inexistente ou sem permissao)."
        registrar_log "Falha ao encerrar processo $pid."
    fi
}

# ---------------------------------------------------------------------
# Roteamento por parametro (acao)
# ---------------------------------------------------------------------
ACAO="$1"
case "$ACAO" in
    listar)  listar_processos ;;
    buscar)  buscar_processo "$2" ;;
    matar)   matar_processo "$2" ;;
    *)
        echo "===== 06_processos.sh - DescomplicaBusiness ====="
        echo "Uso:"
        echo "  ./06_processos.sh listar          - lista processos ativos"
        echo "  ./06_processos.sh buscar <nome>   - busca processo por nome"
        echo "  ./06_processos.sh matar <PID>     - encerra processo por PID"
        ;;
esac
