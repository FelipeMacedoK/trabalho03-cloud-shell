# =====================================================================
# DescomplicaBusiness - Trabalho 03 (Linux, Shell Script e Cloud)
# Imagem base: Ubuntu 22.04 (Ubuntu Server)
# Objetivo: ambiente Linux containerizado para operacao do sistema
#           de atendimento "DescomplicaBusiness".
# Aluno: Felipe Macedo
# =====================================================================
FROM ubuntu:22.04

# Evita prompts interativos do apt durante o build
ENV DEBIAN_FRONTEND=noninteractive

# Pacotes basicos do ambiente operacional:
# - apache2  -> servidor web que publica o site estatico do tema
# - procps   -> ps / top / free (gerenciamento e monitoramento)
# - sudo, cron, nano, less -> apoio operacional
# - tar, gzip -> backups .tar.gz
# - net-tools, iproute2 -> diagnostico de rede
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apache2 \
        procps \
        sudo \
        cron \
        nano \
        less \
        tar \
        gzip \
        net-tools \
        iproute2 \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Diretorio de trabalho do projeto dentro do container
WORKDIR /app

# Copia scripts e site estatico do tema para dentro da imagem
COPY scripts/ /app/scripts/
COPY source/  /app/source/

# Garante que os scripts tenham fim de linha LF (caso editados no Windows)
# e que estejam com permissao de execucao.
RUN sed -i 's/\r$//' /app/scripts/*.sh && \
    chmod +x /app/scripts/*.sh

# Expoe a porta padrao do Apache (mapeada para 8080 no docker-compose)
EXPOSE 80

# Mantem o Apache em primeiro plano -> container fica vivo e o site
# fica acessivel no navegador. O professor ainda pode entrar com
# "docker exec" e rodar os scripts manualmente.
CMD ["apache2ctl", "-D", "FOREGROUND"]
