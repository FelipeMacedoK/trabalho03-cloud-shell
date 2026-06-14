#!/bin/bash
# =====================================================================
# 08_usuarios_permissoes.sh - Usuarios, Grupos e Permissoes
# Projeto: DescomplicaBusiness (Sistema de Atendimento)
# Funcao: criar grupo/usuario do time de atendimento e ajustar acessos.
# =====================================================================

LOG_DIR="/app/logs"
LOG_FILE="${LOG_DIR}/08_usuarios_permissoes.log"
mkdir -p "$LOG_DIR"

# Nomes coerentes com o tema (operacao do atendimento)
GRUPO="atendimento_ops"
USUARIO="atendente_user"
DIR_ALVO="/app/atendimento/atendimentos"

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ---------------------------------------------------------------------
# Funcao: configurar_acessos
# Cria grupo e usuario de sistema e aplica permissoes restritas.
# ---------------------------------------------------------------------
configurar_acessos() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "[ERRO] Criar usuarios/grupos exige root (use sudo)."
        return 1
    fi

    # Garante que o diretorio do tema exista
    mkdir -p "$DIR_ALVO"

    # Cria grupo do time de atendimento (se nao existir)
    if getent group "$GRUPO" >/dev/null; then
        echo "[INFO] Grupo '$GRUPO' ja existe."
    else
        groupadd "$GRUPO"
        echo "[OK] Grupo '$GRUPO' criado."
        registrar_log "Grupo $GRUPO criado."
    fi

    # Cria usuario de sistema (sem login interativo) do atendimento
    if id "$USUARIO" >/dev/null 2>&1; then
        echo "[INFO] Usuario '$USUARIO' ja existe."
    else
        useradd -r -g "$GRUPO" -s /usr/sbin/nologin "$USUARIO"
        echo "[OK] Usuario de sistema '$USUARIO' criado e adicionado ao grupo '$GRUPO'."
        registrar_log "Usuario $USUARIO criado no grupo $GRUPO."
    fi

    # Aplica dono e permissoes ao diretorio de atendimentos
    # chown -> dono atendente_user, grupo atendimento_ops
    chown -R "$USUARIO":"$GRUPO" "$DIR_ALVO"
    # chmod 750 -> dono total, grupo le/executa, outros sem acesso
    # (evita 777; protege dados de atendimento dos clientes)
    chmod -R 750 "$DIR_ALVO"

    echo "[OK] Permissoes aplicadas em $DIR_ALVO:"
    ls -ld "$DIR_ALVO"
    registrar_log "Permissoes 750 aplicadas em $DIR_ALVO (dono $USUARIO:$GRUPO)."
}

configurar_acessos
