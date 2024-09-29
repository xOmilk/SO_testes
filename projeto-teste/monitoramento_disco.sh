#!/bin/bash

# Função principal que encapsula o código do monitoramento de disco
monitoramento_disco() {

    # Função para verificar o uso de disco
    verificar_disco() {
        local DIRETORIO
        local USO_DISCO
        local USO_ATUAL
        local LIMITE_CRITICO=85  # Definindo limite crítico

        read -p "Digite o diretório que deseja verificar (padrão /): " DIRETORIO
        DIRETORIO=${DIRETORIO:-/}

        if [ ! -d "$DIRETORIO" ]; then
            echo "Diretório inválido."
            return
        fi

        # Exibe diretamente o uso do disco
        USO_DISCO=$(df -h "$DIRETORIO")
        echo "$USO_DISCO"
        
        # Extraindo o percentual de uso
        USO_ATUAL=$(echo "$USO_DISCO" | awk 'NR==2 {print $5}' | sed 's/%//')

        if [ "$USO_ATUAL" -ge "$LIMITE_CRITICO" ]; then
            echo "Atenção! O uso de disco atingiu $USO_ATUAL%."
        else
            echo "O uso de disco está normal."
        fi
        
    }

    # Limpeza automática de arquivos temporários
    limpeza_automatica() {
        local NUM_ARQUIVOS

        if [ ! -w /tmp ]; then
            echo "Erro: Sem permissão para limpar arquivos temporários."
            return
        fi

        # Contar quantos arquivos temporários serão removidos
        NUM_ARQUIVOS=$(find /tmp -type f -mtime +7 | wc -l)
        
        if [ "$NUM_ARQUIVOS" -eq 0 ]; then
            echo "Nenhum arquivo temporário antigo encontrado para limpeza."
            return
        fi

        echo "Limpando $NUM_ARQUIVOS arquivos temporários antigos..."
        find /tmp -type f -mtime +7 -exec rm -f {} \;
        echo "Limpeza concluída. $NUM_ARQUIVOS arquivos foram removidos."
    }

    # Limpeza de pasta específica
    limpeza_pasta_especifica() {
        local CAMINHO_PASTA

        read -p "Digite o caminho completo da pasta que deseja excluir: " CAMINHO_PASTA

        if [ ! -d "$CAMINHO_PASTA" ]; then
            echo "Pasta inválida."
            return
        fi

        echo "Arquivos na pasta:"
        ls "$CAMINHO_PASTA"

        # Confirmação de exclusão
        local CONFIRMACAO
        read -p "Tem certeza que deseja excluir esta pasta e todo o seu conteúdo? (s/n): " CONFIRMACAO
        
        if [[ "$CONFIRMACAO" =~ ^[Ss]$ ]]; then
            rm -rf "$CAMINHO_PASTA" && echo "Pasta excluída."
        else
            echo "Exclusão cancelada."
        fi
    }

    # Menu simplificado
    while true; do
        local OPCAO

        echo "1. Verificar uso de disco"
        echo "2. Limpeza automática"
        echo "3. Excluir uma pasta"
        echo "4. Sair"
        read -p "Escolha uma opção: " OPCAO

        if [ "$OPCAO" = "1" ]; then
            verificar_disco
        elif [ "$OPCAO" = "2" ]; then
            limpeza_automatica
        elif [ "$OPCAO" = "3" ]; then
            limpeza_pasta_especifica
        elif [ "$OPCAO" = "4" ]; then
            echo "Saindo..."
            break
        else
            echo "Opção inválida."
        fi
    done
}

# Fim da função monitoramento_disco
