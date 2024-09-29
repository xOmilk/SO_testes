#!/bin/bash

# Variaveis de configuracao
BACKUP_DIR="/tmp/BACKUPSO"  # Diretorio de backup
DATE=$(date +%Y-%m-%d)  # Data atual
MAX_BACKUPS=5  # Numero maximo de backups que serao mantidos

# Funcao para verificar e instalar pacotes necessarios
instalar_pacotes() {
    echo "Verificando pacotes necessarios..."
    REQUIRED_PACKAGES=("tar" "gzip" "openssh-client" "openssh-server")
    for PACKAGE in "${REQUIRED_PACKAGES[@]}"; do
        if ! dpkg -s $PACKAGE &> /dev/null; then
            echo "Instalando $PACKAGE..."
            sudo apt-get install -y $PACKAGE
        fi
    done
}

# Funcao para criar o diretorio de backup se nao existir
criar_diretorio_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Diretorio de backup criado: $BACKUP_DIR"
    fi
}

# Funcao para selecionar diretorios para backup
selecionar_diretorios() {
    echo "Digite os diretorios que deseja fazer backup, separados por espaco:"
    read -a DIRS
}

# Funcao para pedir dados do servidor remoto
configurar_servidor_remoto() {
    echo "Digite o nome do usuario no servidor remoto:"
    read REMOTE_USER

    echo "Digite o IP ou hostname do servidor remoto:"
    read REMOTE_HOST

    echo "Digite o diretorio de destino no servidor remoto (ex: /home/usuario/backup):"
    read REMOTE_DIR
}

# Funcao para fazer backup dos diretorios
realizar_backup() {
    for DIR in "${DIRS[@]}"; do
        if [ -d "$DIR" ]; then
            TAR_FILE="$BACKUP_DIR/$(basename $DIR)_backup_$DATE.tar.gz"
            tar -czf "$TAR_FILE" "$DIR"
            echo "Backup de $DIR feito e salvo em $TAR_FILE"
        else
            echo "Diretorio $DIR nao encontrado"
        fi
    done
}

# Funcao para remover backups antigos
limpar_backups_antigos() {
    BACKUP_COUNT=$(ls $BACKUP_DIR/*.tar.gz 2> /dev/null | wc -l)
    if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
        echo "Limpando backups antigos..."
        ls -t $BACKUP_DIR/*.tar.gz | tail -n +$(($MAX_BACKUPS + 1)) | xargs rm -f
        echo "Backups antigos removidos."
    fi
}

# Funcao para fazer copia segura para o servidor remoto
copiar_para_servidor_remoto() {
    for TAR_FILE in $BACKUP_DIR/*.tar.gz; do
        scp "$TAR_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
        echo "Backup $TAR_FILE copiado para o servidor remoto"
    done
}

# Fluxo principal

# 1. Instalar pacotes necessarios
instalar_pacotes

# 2. Criar o diretorio de backup se necessario
criar_diretorio_backup

# 3. Selecionar diretorios para backup
selecionar_diretorios

# 4. Configurar o servidor remoto (pedir usuario, IP e diretorio remoto)
configurar_servidor_remoto

# 5. Realizar o backup dos diretorios selecionados
realizar_backup

# 6. Limpar backups antigos, se necessario
limpar_backups_antigos

# 7. Copiar os backups para o servidor remoto
copiar_para_servidor_remoto
