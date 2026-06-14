#!/bin/bash
# =====================================================================
# 05_deploy.sh - Deploy do Site Estatico do Tema
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: publicar o portal de atendimento no Apache.
# =====================================================================

# Origem dos arquivos estaticos (portal do atendimento) e destino Apache
ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/05_deploy.log"
mkdir -p "$LOG_DIR"

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------------------------------------------------------------------
# Funcao: realizar_deploy
# Limpa o destino, copia o portal e valida a publicacao.
# ---------------------------------------------------------------------
realizar_deploy() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "[ERRO] Deploy em $DESTINO exige root (use sudo)."
        return 1
    fi

    if [ ! -d "$ORIGEM" ]; then
        echo "[ERRO] Pasta de origem $ORIGEM nao encontrada."
        registrar_log "Deploy abortado: origem inexistente."
        return 1
    fi

    echo "[INFO] Limpando diretorio de publicacao $DESTINO ..."
    rm -rf "${DESTINO:?}/"*

    echo "[INFO] Publicando portal do atendimento..."
    cp -r "$ORIGEM"/* "$DESTINO"/

    echo "[INFO] Arquivos publicados:"
    ls -lh "$DESTINO"

    # Valida se o index.html existe no destino
    if [ -f "$DESTINO/index.html" ]; then
        echo "[OK] Deploy concluido. Portal disponivel em http://localhost:8080"
        registrar_log "Deploy concluido com sucesso (index.html presente)."
    else
        echo "[ERRO] index.html nao encontrado no destino. Deploy incompleto."
        registrar_log "Deploy falhou: index.html ausente."
        return 1
    fi
}

realizar_deploy
