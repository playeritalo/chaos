#!/bin/bash

# Limpar a tela do terminal
clear

# Definir a variável BASE_DIR
BASE_DIR="$HOME/.chaos_utilities"

# Verificar se o diretório existe; caso contrário, criá-lo
if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
fi

# Função para exibir a contagem em segundos
contagem_segundos() {
    local SECONDS=0
    while true; do
        printf "\rContagem de segundos: %d" "$SECONDS"
        SECONDS=$((SECONDS + 1))
        sleep 1
    done
}

# Limpar a tela do terminal
clear

# Usar o BASE_DIR em operações subsequentes
echo "O diretório base para automação é $BASE_DIR, 
\nNÃO apague, caso contratário, 
\ntéra de reinstalar a automação dentro desta sessão."

# Iniciar a contagem em segundos
contagem_segundos

# Limpar a tela do terminal
clear

# Inicia
echo "Bem-vindo ao setup de instalação dentro do seu terminal linux!"

# Navegar para o diretório BASE_DIR
cd "$BASE_DIR" || exit
echo "\n"

# Verificar e instalar o Git, se necessário
if ! command_exists git; then
    echo "O Git não foi encontrado. \nInstalando o Git..."
    apk install -y git
    echo "O Git foi instalado com sucesso!"
else
    echo "Git já está instalado."
fi
# Limpar a tela do terminal
clear

# Verificar se o repositório já foi clonado
if [ ! -d "$BASE_DIR/chaos" ]; then
    # Clonar o repositório do GitHub
    echo "Clonando o repositório da automação do GitHub..."
    git clone https://github.com/playeritalo/chaos.git
    echo "Repositório clonado com sucesso!"
else
    echo "Repositório já clonado."
fi

# Limpar a tela do terminal
clear

# Navegar para o diretório do repositório clonado
cd "$BASE_DIR/chaos" || exit

# Verificar e instalar o Python, se necessário
if ! command_exists python; then
    echo "Python não encontrado. Instalando..."
    apk install -y python
    echo "Python instalado com sucesso!"
else
    echo "Python já está instalado."
fi

# Limpar a tela do terminal
clear

# Verificar e instalar o pip, se necessário
if ! command_exists pip; then
    echo "pip não encontrado. Instalando..."
    apk install -y python-pip
    echo "pip instalado com sucesso!"
else
    echo "pip já está instalado."
fi

# Limpar a tela do terminal
clear

# Verificar e instalar o Firefox, se necessário
if ! command_exists firefox; then
    echo "Firefox não encontrado. Instalando..."
    apk install -y firefox
    echo "Firefox instalado com sucesso!"
else
    echo "Firefox já está instalado."
fi

# Limpar a tela do terminal
clear

# Verificar e instalar o wget, se necessário
if ! command_exists wget; then
    echo "wget não encontrado. Instalando..."
    apk install -y wget
    echo "wget instalado com sucesso!"
else
    echo "wget já está instalado."
fi

# Limpar a tela do terminal
clear

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

# Limpar a tela do terminal
clear

# Limpar arquivos temporários
rm -f geckodriver-v0.29.0-linux64.tar.gz

# Instalar dependências Python
echo "Instalando dependências Python..."
pip install selenium requests
echo "Dependências Python instaladas com sucesso!"

# Limpar a tela do terminal
clear

echo "Setup concluído! Você pode agora executar seu script Python."

# Iniciar a contagem em segundos
contagem_segundos

echo "Para começar a usar a automação, use o comando: python chaos_scripter.py"