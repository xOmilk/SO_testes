#!/bin/bash

funcionalidades() 
{ 
    # Definindo o diretório onde os scripts criados pelo usuário serão armazenados
    DIRETORIO_SCRIPTS="$HOME/abj_tools_scripts"
    # Definindo o arquivo que armazenará a contagem de scripts criados
    ARQUIVO_CONTAGEM="$DIRETORIO_SCRIPTS/qntd_scripts.txt"

    # Cria o diretório se ele ainda não existir
    mkdir -p "$DIRETORIO_SCRIPTS"

    # Função para carregar a quantidade de scripts criados previamente
    carregar_contagem() 
    {
        # Se o arquivo com a contagem existir, lê o número de scripts criados
        if [[ -f $ARQUIVO_CONTAGEM ]]; then
            QNTD_SCRIPTS_CRIADOS=$(cat "$ARQUIVO_CONTAGEM")
        else
            # Se o arquivo não existir, inicializa a contagem em 0
            QNTD_SCRIPTS_CRIADOS=0
        fi
    }

    # Função para exibir o uso do disco do diretório home
    mostrar_uso_disco() 
    {
        # Contar a quantidade de arquivos no diretório home
        QUANTIDADE_ARQUIVOS=$(find ~ -type f | wc -l)
        echo "Quantidade de arquivos: $QUANTIDADE_ARQUIVOS"

        # Mostrar os tamanhos das pastas no diretório home, incluindo pastas ocultas
        echo -e "\nPastas e seus tamanhos:"
        du -sh ~/.* 2>/dev/null  # Mostra o tamanho das pastas ocultas
        du -sh ~/* 2>/dev/null   # Mostra o tamanho das pastas visíveis

        echo -e "\n---"

        # Capturar o uso do disco em porcentagem (apenas o home do usuário)
        df_output=$(df -h ~ | awk 'NR==2')  # Obtém a segunda linha da saída do df
        PORCENTAGEM_USADO=$(echo "$df_output" | awk '{print $5}')  # Extrai a porcentagem de uso

        # Exibir a porcentagem de uso do disco
        echo "Uso do disco: $PORCENTAGEM_USADO"
        echo -e "\n---"

    }

    # Função para criar um novo script
    criar_script() 
    {
        # Solicitar ao usuário o nome do novo script
        read -p "Digite o nome do script (sem .sh): " NOME_SCRIPT
        CAMINHO_SCRIPT="$DIRETORIO_SCRIPTS/$NOME_SCRIPT.sh"

        # Incrementar a contagem de scripts criados
        QNTD_SCRIPTS_CRIADOS=$((QNTD_SCRIPTS_CRIADOS + 1))

        # Criar o script com um cabeçalho básico e uma mensagem
        echo "#!/bin/bash" > "$CAMINHO_SCRIPT"
        echo "echo 'Olá, este é o script que você acabou de criar.'" >> "$CAMINHO_SCRIPT"
        echo "echo 'Você já criou $QNTD_SCRIPTS_CRIADOS scripts.'" >> "$CAMINHO_SCRIPT"
        
        # Dar permissão de execução ao script criado
        chmod +x "$CAMINHO_SCRIPT"

        # Atualizar a contagem de scripts no arquivo
        echo "$QNTD_SCRIPTS_CRIADOS" > "$ARQUIVO_CONTAGEM"

        # Mensagem de sucesso ao usuário
        echo "Script '$NOME_SCRIPT.sh' criado com sucesso em $DIRETORIO_SCRIPTS!"
        echo "Você já criou $QNTD_SCRIPTS_CRIADOS scripts."
        echo "Você pode executá-lo com: $DIRETORIO_SCRIPTS/$NOME_SCRIPT.sh"
        echo -e "\n---"
    }

    # Função para remover todos os scripts e a pasta de scripts ao sair
    remover_scripts() 
    {
        # Pergunta ao usuário se ele deseja remover todos os scripts e o diretório
        read -p "Você deseja remover todos os scripts e pasta '$DIRETORIO_SCRIPTS' AO SAIR DO PROGRAMA? (s/n): " CONFIRMACAO_REMOVER
        if [[ $CONFIRMACAO_REMOVER == "s" || $CONFIRMACAO_REMOVER == "S" ]]; then
            # Remover o diretório e todo o seu conteúdo
            rm -rf "$DIRETORIO_SCRIPTS"
            echo "Todos os scripts e a pasta foram removidos."
            echo "Saindo..."
            exit 0
        fi

        # Caso o usuário não queira remover, apenas sai
        echo "Saindo..."
        exit 0
    }

    # Função para preparar possível ambiente de desenvolvimento
    preparar_ambiente_desenvolvimento()
    {
        echo -e "\n---"
        echo "Preparando o seu ambiente de desenvolvimento..."

        # Função para instalar pacotes essenciais
        install_dev_environment() 
        {
            echo "Instalando pacotes essenciais..."
            sudo apt-get update  # Atualiza a lista de pacotes
            sudo apt-get install -y git nodejs python3 docker.io  # Instala as ferramentas necessárias
        }

        # Função para criar diretórios e arquivos padrão
        setup_directories() 
        {
            echo "Criando diretórios padrão..."
            mkdir -p ~/projects/my_project  # Cria um diretório para o projeto
            touch ~/projects/my_project/.gitignore  # Cria arquivo .gitignore
            touch ~/projects/my_project/README.md  # Cria arquivo README
            touch ~/projects/my_project/LICENSE  # Cria arquivo LICENSE
        }

        # Função para configurar permissões
        configure_permissions()
        {
            echo "Configurando permissões..."
            chmod -R 755 ~/projects/my_project  # Configura permissões do diretório do projeto
        }

        # Função para exibir resumo das versões instaladas
        show_summary() 
        {
            echo "Resumo das versões instaladas:"
            git --version  # Exibe a versão do Git
            node -v  # Exibe a versão do Node.js
            python3 --version  # Exibe a versão do Python
            docker --version  # Exibe a versão do Docker
        }

        # Função que agrupa as etapas de instalação e configuração
        rodar_tudo()
        {
            install_dev_environment  # Chama a função para instalar pacotes
            setup_directories  # Chama a função para configurar diretórios
            configure_permissions  # Chama a função para configurar permissões
            show_summary  # Chama a função para mostrar o resumo
        }

        rodar_tudo  # Executa todas as funções de configuração
        echo -e "\n---"
        
    }

    # Função para exibir detalhes do projeto
    detalhes_projeto()
    {
        echo -e "\n---"

        # Exibe informações sobre o projeto e suas funcionalidades
        echo "Este script implementa um menu interativo com quatro funcionalidades principais:"
        echo "1. Exibir o uso do disco da pasta pessoal (home) e as pastas que nela possuem."
        echo "2. Criar novos scripts em um diretório específico (dentro da home)."
        echo "3. Permitir a criação de um ambiente de desenvolvimento."
        echo "4. Permitir a exclusão desse diretório e dos scripts criados ao sair."
        echo "0. Exibir detalhamento do projeto."
        echo
        echo "O script mantém a contagem de quantos scripts foram criados, e essa contagem é persistida em um arquivo"
        echo "para que seja carregada em execuções futuras ou o usuário queira apagar eles ao sair."
        echo
        echo "Ele também possui uma sequência de funções voltadas para a configuração de um ambiente de desenvolvimento"
        echo "em um sistema baseado em Linux, como a instalação de ferramentas como: Git, Python3, NodeJS e Docker."
        echo "Além disso, efetua a criação de uma pasta onde esses projetos podem ser colocados, caso seja de preferência do usuário."
        echo
        echo "Um projeto desenvolvido por: Antônio Gabriel, Beatriz Freitas e Joseph Borges"
        echo "Professor: Toni Borges"

        echo -e "\n---"

    }


    # Carregar a contagem de scripts criada anteriormente
    carregar_contagem

    # Loop para exibir o menu até que o usuário decida sair
    while true; do
        # Exibir o menu de opções para o usuário
        echo "Selecione uma opção:"
        echo "1. Mostrar uso do disco"
        echo "2. Criar um novo script"
        echo "3. Criar ambiente para desenvolvimento"
        echo "4. Sair"
        echo "0. Ajuda(Detalhamento do projeto)"

        # Ler a opção escolhida pelo usuário
        read -p "Opção: " OPCAO

        case $OPCAO in
            # Caso a opção seja 0, o detalhamento do projeto
            0)
                detalhes_projeto
                ;;

            # Caso a opção seja 1, mostrar o uso do disco
            1)
                mostrar_uso_disco
                ;;
            # Caso a opção seja 2, criar um novo script
            2)
                criar_script
                ;;
            # Caso a opção seja 3, preparar o ambiente de desenvolvimento
            3)
                preparar_ambiente_desenvolvimento
                ;;
            # Caso a opção seja 4, perguntar se deseja remover os scripts e sair
            4)
                remover_scripts
                ;;
            # Qualquer outra entrada é inválida
            *)
                echo "Opção inválida. Tente novamente."
                ;;
        esac
    done
}

# Chama a função funcionalidades para iniciar o script
funcionalidades