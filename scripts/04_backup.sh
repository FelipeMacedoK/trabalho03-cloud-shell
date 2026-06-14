#!/bin/bash
# =====================================================================
# 04_backup.sh - Backup Automatizado
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: gerar backup compactado dos dados do atendimento.
# =====================================================================

# Variaveis de origem e destino
ORIGEM="/app/atendimento"
DESTINO="/app/backups"
LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/04_backup.log"

mkdir -p "$DESTINO" "$LOG_DIR"

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------------------------------------------------------------------
# Funcao: realizar_backup
# Compacta o diretorio do atendimento em .tar.gz com data/hora.
# ---------------------------------------------------------------------
realizar_backup() {
    # Valida se a origem existe (estrutura deve ter sido criada antes)
    if [ ! -d "$ORIGEM" ]; then
        echo "[ERRO] Diretorio de origem $ORIGEM nao existe. Rode 03_estrutura.sh antes."
        registrar_log "Backup abortado: origem inexistente."
        return 1
    fi

    DATA=$(date '+%Y-%m-%d_%H-%M')
    ARQUIVO="backup_atendimento_${DATA}.tar.gz"
    CAMINHO="${DESTINO}/${ARQUIVO}"

    echo "[INFO] Gerando backup do atendimento em $ARQUIVO ..."
    tar -czf "$CAMINHO" -C "$(dirname "$ORIGEM")" "$(basename "$ORIGEM")" 2>>"$LOG_FILE"

    # Valida se o backup foi criado corretamente
    if [ -f "$CAMINHO" ]; then
        TAMANHO=$(du -h "$CAMINHO" | cut -f1)
        echo "[OK] Backup criado: $CAMINHO ($TAMANHO)"
        registrar_log "Backup gerado com sucesso: $ARQUIVO ($TAMANHO)"
    else
        echo "[ERRO] Backup NAO foi criado."
        registrar_log "Falha ao gerar backup."
        return 1
    fi
}

realizar_backup
