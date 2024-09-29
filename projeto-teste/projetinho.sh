#!/bin/bash

# Função para criar um backup
criar_backup() {
    echo "Informe o caminho completo do arquivo ou pasta a ser feito o backup:"
    read origem

    # Verifica se o caminho foi fornecido
    if [ -z "$origem" ]; then
        echo "Erro: Nenhum caminho fornecido."
        return 1
    fi

    # Verifica se o arquivo ou pasta existe
    if [ ! -e "$origem" ]; then
        echo "Erro: O arquivo ou diretório não existe!"
        return 1
    fi

    echo "Informe o diretório de destino para o backup:"
    read destino

    # Verifica se o caminho do destino foi fornecido
    if [ -z "$destino" ]; then
        echo "Erro: Nenhum destino fornecido."
        return 1
    fi

    # Verifica se o diretório de destino existe, se não, cria o diretório
    if [ ! -d "$destino" ]; then
        echo "Diretório de destino não existe. Criando o diretório..."
        mkdir -p "$destino"
        if [ $? -eq 0 ]; then
            echo "Diretório criado com sucesso."
        else
            echo "Erro ao criar o diretório!"
            return 1
        fi
    fi

    # Copia o arquivo ou pasta para o diretório de destino
    cp -r "$origem" "$destino"
    if [ $? -eq 0 ]; then
        echo "Backup realizado com sucesso em $destino."
    else
        echo "Erro ao realizar o backup!"
        return 1
    fi
}

# Função para exibir o menu
menu() {
    clear
    echo "Menu de Backup"
    echo "1) Criar Backup"
    echo "2) Sair"
    echo -n "Escolha uma opção: "
    read opcao

    case $opcao in
        1)
            criar_backup
            ;;
        2)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac
}

# Exibe o menu até o usuário sair
while true; do
    menu
done
