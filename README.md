# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno
Felipe Macedo - Sistemas de Informação - Unidavi

## Tema
**DescomplicaBusiness — Sistema de Atendimento para um Pequeno Negócio**

## Descrição do Projeto
Atuando como profissional **júnior de DevOps**, preparei um ambiente Linux containerizado para operar o sistema de atendimento *DescomplicaBusiness*.
O ambiente roda em um container **Ubuntu Server 22.04** com **Apache**, e toda a operação (atualização, instalação de serviços, estrutura de diretórios, backup, deploy, monitoramento, processos, usuários/permissões e relatórios) é automatizada por **scripts Shell**.

Relação com Cloud Computing: reproduz, em escala de laboratório, as rotinas operacionais que um time de infraestrutura executa em uma VM Linux na nuvem, com volume persistente equivalente ao armazenamento em bloco/objeto e deploy de um portal web.

## Tecnologias Utilizadas
- Linux Ubuntu 22.04 (Server)
- Docker e Docker Compose
- Apache HTTP Server
- Shell Script (Bash)
- GitHub e DockerHub

## Estrutura do Projeto
```
trabalho03-cloud-shell/
├── Dockerfile              # Imagem Ubuntu + Apache + scripts
├── docker-compose.yml      # Orquestração + volumes persistentes
├── README.md               # Este arquivo
├── scripts/                # Scripts Shell da operação
│   ├── 01_update.sh
│   ├── 02_apache.sh
│   ├── 03_estrutura.sh
│   ├── 04_backup.sh
│   ├── 05_deploy.sh
│   ├── 06_processos.sh
│   ├── 07_monitoramento.sh
│   ├── 08_usuarios_permissoes.sh
│   ├── 09_relatorio.sh
│   └── menu.sh             # Menu principal integrando as rotinas
├── source/                 # Portal estático do atendimento
│   ├── index.html
│   ├── sobre.html
│   └── assets/style.css
├── backups/                # Backups .tar.gz gerados
├── logs/                   # Logs e relatório operacional
└── evidencias/             # Prints de execução
```

Dentro do container, o tema vive em `/app/atendimento` com subpastas
`atendimentos/`, `clientes/`, `gravacoes/`, `relatorios/`, `dados/`, `logs/`,
`backups/` e `publicacao/`.

## Como Executar o Projeto
Pré-requisito: Docker Desktop instalado e em execução.

```bash
git clone https://github.com/FelipeMacedoK/trabalho03-cloud-shell.git
cd trabalho03-cloud-shell
docker compose up -d --build
docker ps
```

## Como Acessar o Apache no Navegador
O Apache já sobe com o container. Após o build, acesse:

**http://localhost:8080**

A página inicial padrão do Apache aparece de imediato; após rodar o
`05_deploy.sh`, o portal do *DescomplicaBusiness* passa a ser exibido.

## Como Entrar no Container
```bash
docker exec -it trabalho03-atendimento bash
cd /app/scripts
chmod +x *.sh        # garante permissão de execução
```

## Como Executar Cada Script
Dentro do container, na pasta `/app/scripts`:

| Script | O que faz | Como rodar |
|---|---|---|
| 01_update.sh | Atualiza pacotes do sistema (apt update/upgrade) | `./01_update.sh` |
| 02_apache.sh | Instala, valida e mostra a versão do Apache (+ ffmpeg p/ gravações) | `./02_apache.sh` |
| 03_estrutura.sh | Cria a estrutura de diretórios do atendimento | `./03_estrutura.sh` |
| 04_backup.sh | Gera backup `.tar.gz` com data/hora em `backups/` | `./04_backup.sh` |
| 05_deploy.sh | Publica o portal em `/var/www/html` | `./05_deploy.sh` |
| 06_processos.sh | Lista/busca/encerra processos | `./06_processos.sh listar` |
| 07_monitoramento.sh | CPU, RAM, disco e status do Apache com alertas | `./07_monitoramento.sh` |
| 08_usuarios_permissoes.sh | Cria grupo/usuário e aplica permissões | `./08_usuarios_permissoes.sh` |
| 09_relatorio.sh | Gera `logs/relatorio_execucao.txt` | `./09_relatorio.sh` |
| menu.sh | Menu interativo integrando tudo | `./menu.sh` |

Exemplos do `06_processos.sh`:
```bash
./06_processos.sh listar
./06_processos.sh buscar apache
./06_processos.sh matar 1234
```

## Como Executar o Menu Principal
```bash
cd /app/scripts
./menu.sh
```
Escolha as opções de 1 a 9 (0 para sair).

## Sequência recomendada para validar tudo
```bash
cd /app/scripts
chmod +x *.sh
./01_update.sh
./02_apache.sh
./03_estrutura.sh
./08_usuarios_permissoes.sh
./04_backup.sh
./05_deploy.sh           # depois acesse http://localhost:8080
./07_monitoramento.sh
./09_relatorio.sh
```

## Evidências de Funcionamento
Os prints estão na pasta [`evidencias/`](evidencias/), nomeados em ordem
(`01-container-rodando.png` … `13-dockerhub-imagem.png`).

## DockerHub
Imagem publicada:
```bash
docker pull felipemacedok/descomplica-atendimento:1.0
```
Link: https://hub.docker.com/r/felipemacedok/descomplica-atendimento

## Uso de Inteligência Artificial
Utilizei IA (Claude) como apoio para revisar a lógica dos scripts, sugerir boas práticas de Shell (validação de root, uso de funções, tratamento de PID vazio) e organizar a documentação do README. Revisei e testei cada script manualmente no container, ajustei nomes de diretórios/usuários para o tema de atendimento e validei as saídas. Aprendi, na prática, como estruturar funções, registrar logs, gerar backups `.tar.gz` e aplicar permissões com `chown`/`chmod` sem expor dados com `777`.

## Dificuldades Encontradas
- Garantir que o Apache subisse e o container permanecesse vivo ao mesmo tempo
  (resolvido com `apache2ctl -D FOREGROUND`).
- Cálculo de uso de CPU/memória apenas com ferramentas nativas (`top`, `free`).
- Fim de linha CRLF do Windows quebrando o shebang — resolvido no Dockerfile com
  `sed -i 's/\r$//'`.
