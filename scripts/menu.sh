#!/bin/bash
# =====================================================================
# menu.sh - Menu Principal (DevOps Cloud)
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: integrar as principais rotinas operacionais por menu.
# =====================================================================

# Diretorio onde estao os scripts (mesma pasta deste menu)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------
# Funcao: pausar
# Espera o usuario pressionar Enter para voltar ao menu.
# ---------------------------------------------------------------------
pausar() {
    echo ""
    read -p "Pressione Enter para voltar ao menu..." _
}

# ---------------------------------------------------------------------
# Funcao: mostrar_menu
# Exibe as opcoes do menu operacional.
# ---------------------------------------------------------------------
mostrar_menu() {
    clear
    echo "====================================================="
    echo " Criado por : Felipe Macedo"
    echo " Instituicao: Unidavi"
    echo " Tema       : DescomplicaBusiness - Sistema de Atendimento"
    echo "====================================================="
    echo "          ===== MENU DEVOPS CLOUD ====="
    echo " 1 - Atualizar sistema"
    echo " 2 - Instalar Apache"
    echo " 3 - Criar estrutura do projeto"
    echo " 4 - Realizar backup"
    echo " 5 - Fazer deploy"
    echo " 6 - Ver processos"
    echo " 7 - Monitorar sistema"
    echo " 8 - Configurar usuarios e permissoes"
    echo " 9 - Gerar relatorio"
    echo " 0 - Sair"
    echo "====================================================="
}

# Loop principal do menu
while true; do
    mostrar_menu
    read -p "Escolha uma opcao: " opcao
    case "$opcao" in
        1) bash "$DIR/01_update.sh"; pausar ;;
        2) bash "$DIR/02_apache.sh"; pausar ;;
        3) bash "$DIR/03_estrutura.sh"; pausar ;;
        4) bash "$DIR/04_backup.sh"; pausar ;;
        5) bash "$DIR/05_deploy.sh"; pausar ;;
        6)
            read -p "Acao (listar/buscar/matar): " ac
            read -p "Parametro (nome ou PID, se houver): " pr
            bash "$DIR/06_processos.sh" "$ac" "$pr"
            pausar ;;
        7) bash "$DIR/07_monitoramento.sh"; pausar ;;
        8) bash "$DIR/08_usuarios_permissoes.sh"; pausar ;;
        9) bash "$DIR/09_relatorio.sh"; pausar ;;
        0) echo "Encerrando o menu do DescomplicaBusiness. Ate logo!"; exit 0 ;;
        *) echo "[ERRO] Opcao invalida. Tente novamente."; pausar ;;
    esac
done
