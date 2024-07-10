#!/bin/bash

# Função para verificar se um comando está disponível
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Diretório onde todas as dependências serão instaladas (oculto)
BASE_DIR="$HOME/.automation_env"

# Verificar se o diretório BASE_DIR existe e criar se não existir
if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
fi

echo "Bem-vindo ao setup do ambiente!"

# Navegar para o diretório BASE_DIR
cd "$BASE_DIR" || exit

# Verificar e instalar o Git, se necessário
if ! command_exists git; then
    echo "Git não encontrado. Instalando..."
    pkg install -y git
    echo "Git instalado com sucesso!"
else
    echo "Git já está instalado."
fi

# Verificar se o repositório já foi clonado
if [ ! -d "$BASE_DIR/chaos" ]; then
    # Clonar o repositório do GitHub
    echo "Clonando seu repositório do GitHub..."
    git clone https://github.com/playeritalo/chaos.git
    echo "Repositório clonado com sucesso!"
else
    echo "Repositório já clonado."
fi

# Navegar para o diretório do repositório clonado
cd "$BASE_DIR/chaos" || exit

# Verificar e instalar o Python, se necessário
if ! command_exists python; then
    echo "Python não encontrado. Instalando..."
    pkg install -y python
    echo "Python instalado com sucesso!"
else
    echo "Python já está instalado."
fi

# Verificar e instalar o pip, se necessário
if ! command_exists pip; then
    echo "pip não encontrado. Instalando..."
    pkg install -y python-pip
    echo "pip instalado com sucesso!"
else
    echo "pip já está instalado."
fi

# Verificar e instalar o Firefox, se necessário
if ! command_exists firefox; then
    echo "Firefox não encontrado. Instalando..."
    pkg install -y firefox
    echo "Firefox instalado com sucesso!"
else
    echo "Firefox já está instalado."
fi

# Verificar e instalar o wget, se necessário
if ! command_exists wget; then
    echo "wget não encontrado. Instalando..."
    pkg install -y wget
    echo "wget instalado com sucesso!"
else
    echo "wget já está instalado."
fi

# Verificar e instalar o geckodriver, se necessário
if ! command_exists geckodriver; then
    echo "geckodriver não encontrado. Baixando e configurando..."
    wget https://github.com/mozilla/geckodriver/releases/download/v0.29.0/geckodriver-v0.29.0-linux64.tar.gz
    tar -xvzf geckodriver-v0.29.0-linux64.tar.gz
    chmod +x geckodriver
    mv geckodriver /usr/local/bin/
    echo "geckodriver configurado com sucesso!"
else
    echo "geckodriver já está configurado."
fi

# Limpar arquivos temporários
rm -f geckodriver-v0.29.0-linux64.tar.gz

# Instalar dependências Python
echo "Instalando dependências Python..."
pip install selenium requests
echo "Dependências Python instaladas com sucesso!"

echo "Setup concluído! Você pode agora executar seu script Python."
