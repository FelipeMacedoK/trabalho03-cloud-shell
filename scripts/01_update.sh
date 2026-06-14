#!/bin/bash
# =====================================================================
# 01_update.sh - Atualizacao do Sistema
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: manter o ambiente Linux do atendimento atualizado.
# =====================================================================

# Diretorio de logs do projeto (criado se nao existir)
LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/01_update.log"
mkdir -p "$LOG_DIR"

# ---------------------------------------------------------------------
# Funcao: atualizar_sistema
# Atualiza a lista de pacotes e aplica as atualizacoes disponiveis.
# ---------------------------------------------------------------------
atualizar_sistema() {
    echo "[INFO] Iniciando atualizacao do ambiente de atendimento..."
    echo "===== Atualizacao em $(date '+%Y-%m-%d %H:%M:%S') =====" >> "$LOG_FILE"

    # Verifica se esta rodando como root (apt exige privilegios)
    if [ "$(id -u)" -ne 0 ]; then
        echo "[ERRO] Este script precisa ser executado como root (use sudo)."
        echo "[ERRO] Execucao sem privilegios em $(date)" >> "$LOG_FILE"
        return 1
    fi

    # apt update -> atualiza indice de pacotes
    if apt update >> "$LOG_FILE" 2>&1; then
        echo "[OK] Lista de pacotes atualizada."
    else
        echo "[ALERTA] Falha no apt update (veja $LOG_FILE)."
        return 1
    fi

    # apt upgrade -> aplica atualizacoes
    if apt upgrade -y >> "$LOG_FILE" 2>&1; then
        echo "[OK] Pacotes atualizados com sucesso."
        echo "[SUCESSO] Atualizacao concluida em $(date)" >> "$LOG_FILE"
        return 0
    else
        echo "[ALERTA] Falha ao atualizar pacotes (veja $LOG_FILE)."
        echo "[FALHA] Atualizacao com erro em $(date)" >> "$LOG_FILE"
        return 1
    fi
}

# Execucao
atualizar_sistema
