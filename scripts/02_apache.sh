#!/bin/bash
# =====================================================================
# 02_apache.sh - Instalacao e Validacao do Apache
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: garantir o servidor web que publica o portal de atendimento.
# =====================================================================

LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/02_apache.log"
mkdir -p "$LOG_DIR"

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------------------------------------------------------------------
# Funcao: instalar_apache
# Instala o Apache2 (e ffmpeg, pois o atendimento pode lidar com
# gravacoes de audio/video dos clientes - coerente com o tema).
# ---------------------------------------------------------------------
instalar_apache() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "[ERRO] Instalacao do Apache exige root (use sudo)."
        return 1
    fi

    echo "[INFO] Instalando Apache para o portal de atendimento..."
    apt update >> "$LOG_FILE" 2>&1
    apt install -y apache2 ffmpeg >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "[OK] Apache (e ffmpeg para gravacoes) instalado."
        registrar_log "Apache instalado com sucesso."
        # Inicia o servico quando aplicavel
        apache2ctl start >> "$LOG_FILE" 2>&1
    else
        echo "[ALERTA] Falha na instalacao do Apache."
        registrar_log "Falha na instalacao do Apache."
        return 1
    fi
}

# ---------------------------------------------------------------------
# Funcao: verificar_apache
# Valida se o Apache esta instalado e em execucao.
# ---------------------------------------------------------------------
verificar_apache() {
    if command -v apache2 >/dev/null 2>&1; then
        echo "[OK] Apache esta instalado."
        if pgrep -x apache2 >/dev/null 2>&1; then
            echo "[OK] Apache esta em execucao."
            registrar_log "Apache instalado e em execucao."
        else
            echo "[ALERTA] Apache instalado, mas parado. Iniciando..."
            apache2ctl start >> "$LOG_FILE" 2>&1
            registrar_log "Apache iniciado pela verificacao."
        fi
    else
        echo "[ERRO] Apache NAO esta instalado."
        registrar_log "Apache ausente na verificacao."
        return 1
    fi
}

# ---------------------------------------------------------------------
# Funcao: versao_apache
# Exibe a versao instalada do Apache.
# ---------------------------------------------------------------------
versao_apache() {
    echo "[INFO] Versao do Apache instalada:"
    apache2 -v
    registrar_log "Versao consultada: $(apache2 -v | head -n1)"
}

# Execucao em sequencia
instalar_apache
verificar_apache
versao_apache
