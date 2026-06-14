#!/bin/bash
# =====================================================================
# 09_relatorio.sh - Relatorio Operacional Automatizado
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: consolidar o estado do ambiente em um relatorio unico.
# =====================================================================

LOG_DIR="/app/logs"
RELATORIO="${LOG_DIR}/relatorio_execucao.txt"
BASE="/app/atendimento"
BACKUP_DIR="/app/backups"
WWW="/var/www/html"
mkdir -p "$LOG_DIR"

# Dados do projeto/tema
PROJETO="DescomplicaBusiness"
TEMA="Sistema de Atendimento para um Pequeno Negocio"
ALUNO="Felipe Macedo"

# ---------------------------------------------------------------------
# Funcao: gerar_relatorio
# Monta o relatorio operacional e salva em logs/relatorio_execucao.txt
# ---------------------------------------------------------------------
gerar_relatorio() {
    {
        echo "====================================================="
        echo " RELATORIO OPERACIONAL - $PROJETO"
        echo "====================================================="
        echo "Aluno   : $ALUNO"
        echo "Tema    : $TEMA"
        echo "Data    : $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""

        echo "----- 1. ESPACO EM DISCO -----"
        df -h /
        echo ""

        echo "----- 2. USO DOS DIRETORIOS DO ATENDIMENTO -----"
        if [ -d "$BASE" ]; then
            du -sh "$BASE"/* 2>/dev/null
        else
            echo "Estrutura $BASE ainda nao criada (rode 03_estrutura.sh)."
        fi
        echo ""

        echo "----- 3. STATUS DO APACHE -----"
        if pgrep -x apache2 >/dev/null 2>&1; then
            echo "[OK] Apache em execucao - $(apache2 -v | head -n1)"
        else
            echo "[ALERTA] Apache parado."
        fi
        echo ""

        echo "----- 4. ULTIMOS BACKUPS -----"
        ls -lh "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -n 5 || echo "Nenhum backup encontrado."
        echo ""

        echo "----- 5. ULTIMOS LOGS GERADOS -----"
        ls -lh "$LOG_DIR"/*.log 2>/dev/null | tail -n 10 || echo "Nenhum log encontrado."
        echo ""

        echo "----- 6. ARQUIVOS PUBLICADOS NO APACHE -----"
        ls -lh "$WWW" 2>/dev/null || echo "Nada publicado ainda."
        echo ""

        echo "----- 7. USUARIOS E GRUPOS DO ATENDIMENTO -----"
        echo "Grupo atendimento_ops:"
        getent group atendimento_ops || echo "Grupo ainda nao criado (rode 08_usuarios_permissoes.sh)."
        echo "Permissoes do diretorio de atendimentos:"
        ls -ld "$BASE/atendimentos" 2>/dev/null || echo "Diretorio nao encontrado."
        echo ""

        echo "====================================================="
        echo " FIM DO RELATORIO"
        echo "====================================================="
    } > "$RELATORIO"

    echo "[OK] Relatorio gerado em: $RELATORIO"
    echo "[INFO] Previa do relatorio:"
    echo "-----------------------------------------------------"
    cat "$RELATORIO"
}

gerar_relatorio
