#!/bin/bash

# Este script automatiza a criação e ativação de um ambiente virtual Python
# e oferece a opção de instalar bibliotecas comuns.

echo "--- Automatizador de Ambiente Virtual Python ---"

# 1. Solicita o nome da pasta do projeto
read -p "Digite o nome da pasta para o seu novo projeto (ex: meu_web_scraper): " PROJECT_NAME

# Verifica se o nome do projeto foi fornecido
if [ -z "$PROJECT_NAME" ]; then
    echo "Nome do projeto não pode ser vazio. Saindo."
    exit 1
fi

# 2. Cria a pasta do projeto se não existir
if [ -d "$PROJECT_NAME" ]; then
    read -p "A pasta '$PROJECT_NAME' já existe. Deseja usá-la mesmo assim? (s/N): " USE_EXISTING
    if [[ ! "$USE_EXISTING" =~ ^[sS]$ ]]; then
        echo "Operação cancelada. Por favor, escolha um nome de projeto diferente ou remova a pasta existente."
        exit 1
    fi
else
    echo "Criando pasta do projeto: $PROJECT_NAME"
    mkdir "$PROJECT_NAME"
fi

# Entra na pasta do projeto
cd "$PROJECT_NAME" || { echo "Falha ao entrar na pasta do projeto. Saindo."; exit 1; }

# 3. Solicita o nome do ambiente virtual
read -p "Digite o nome para o seu ambiente virtual (sugestão: venv): " VENV_NAME
VENV_NAME=${VENV_NAME:-venv} # Define 'venv' como padrão se o usuário não digitar nada

# Verifica se o ambiente virtual já existe
if [ -d "$VENV_NAME" ]; then
    read -p "O ambiente virtual '$VENV_NAME' já existe nesta pasta. Deseja removê-lo e criar um novo? (s/N): " REMOVE_VENV
    if [[ "$REMOVE_VENV" =~ ^[sS]$ ]]; then
        echo "Removendo ambiente virtual existente: $VENV_NAME"
        rm -rf "$VENV_NAME"
    else
        echo "Usando ambiente virtual existente. Ativando..."
        source "$VENV_NAME/bin/activate"
        echo "Ambiente virtual '$VENV_NAME' ativado. Pronto para usar."
        exit 0 # Sai do script, pois o ambiente já foi ativado
    fi
fi

# 4. Cria o ambiente virtual
echo "Criando ambiente virtual '$VENV_NAME'..."
python3 -m venv "$VENV_NAME" || { echo "Erro ao criar o ambiente virtual. Verifique se o Python 3 está instalado e no seu PATH."; exit 1; }

# 5. Ativa o ambiente virtual
echo "Ativando ambiente virtual '$VENV_NAME'..."
source "$VENV_NAME/bin/activate" || { echo "Erro ao ativar o ambiente virtual."; exit 1; }
echo "Ambiente virtual '$VENV_NAME' ativado!"

# 6. Oferece a instalação de bibliotecas comuns
echo ""
read -p "Deseja instalar bibliotecas comuns (requests, beautifulsoup4)? (s/N): " INSTALL_LIBS
if [[ "$INSTALL_LIBS" =~ ^[sS]$ ]]; then
    echo "Instalando bibliotecas: requests beautifulsoup4..."
    pip install requests beautifulsoup4 || { echo "Erro ao instalar bibliotecas. Verifique sua conexão ou tente novamente."; }
    echo "Bibliotecas instaladas."
else
    echo "Nenhuma biblioteca comum será instalada agora. Você pode instalá-las mais tarde com 'pip install <nome_da_biblioteca>'."
fi

echo ""
echo "Ambiente virtual criado e ativado com sucesso em '$PROJECT_NAME/$VENV_NAME'."
echo "Você está agora dentro do ambiente virtual. Digite 'deactivate' para sair."
echo "Para ativar novamente mais tarde, vá para a pasta '$PROJECT_NAME' e execute: source $VENV_NAME/bin/activate"
echo "--- Fim do Script ---"


