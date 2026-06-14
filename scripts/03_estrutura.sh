#!/bin/bash
# =====================================================================
# 03_estrutura.sh - Estrutura de Diretorios Tematica
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: criar a arvore de diretorios do sistema de atendimento.
# =====================================================================

LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/03_estrutura.log"
mkdir -p "$LOG_DIR"

# Diretorio raiz do tema (atendimento de pequeno negocio)
BASE="/app/atendimento"

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------------------------------------------------------------------
# Funcao: criar_estrutura
# Cria os diretorios coerentes com o tema de atendimento ao cliente.
# ---------------------------------------------------------------------
criar_estrutura() {
    echo "[INFO] Preparando estrutura do DescomplicaBusiness..."

    # Remove estrutura antiga com seguranca (apenas dentro de /app/atendimento)
    if [ -d "$BASE" ]; then
        echo "[INFO] Removendo estrutura anterior em $BASE ..."
        rm -rf "${BASE:?}/"*
        registrar_log "Estrutura anterior removida com seguranca."
    fi

    # Diretorios do tema: atendimentos, clientes, gravacoes, relatorios...
    DIRS=(
        "$BASE/atendimentos"
        "$BASE/clientes"
        "$BASE/gravacoes"
        "$BASE/relatorios"
        "$BASE/dados"
        "$BASE/logs"
        "$BASE/backups"
        "$BASE/publicacao"
    )

    for d in "${DIRS[@]}"; do
        mkdir -p "$d"
        echo "[OK] Criado: $d"
    done

    # Arquivos iniciais coerentes com o tema
    echo "ID;Cliente;Assunto;Status;Data" > "$BASE/atendimentos/atendimentos.csv"
    echo "ID;Nome;Email;Telefone" > "$BASE/clientes/clientes.csv"
    echo "Relatorios de atendimento do DescomplicaBusiness" > "$BASE/relatorios/README.txt"

    echo "[OK] Estrutura do sistema de atendimento criada com sucesso."
    registrar_log "Estrutura de diretorios do atendimento criada."
}

criar_estrutura
