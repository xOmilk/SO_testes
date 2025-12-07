# 🛠️ Gerenciador de Scripts e Ambiente de Desenvolvimento (Linux)

Este projeto consiste em um script Bash interativo desenvolvido como atividade acadêmica. Ele atua como um facilitador para tarefas de administração de sistema, criação de scripts automatizada e configuração rápida de ambientes de desenvolvimento em sistemas baseados em Debian/Ubuntu.

## 👥 Autores
**Alunos:**
* Antônio Gabriel
* Beatriz Freitas
* Joseph Borges

**Professor:**
* Toni Borges

---

## Funcionalidades

O script oferece um menu interativo com as seguintes opções:

### 1.  Monitoramento de Disco
* Exibe a contagem total de arquivos no diretório `home` do usuário.
* Lista o tamanho das pastas (incluindo ocultas).
* Mostra a porcentagem de uso do disco atual.

### 2. 📝 Gerenciador de Scripts
* Cria novos arquivos `.sh` automaticamente em uma pasta dedicada (`~/abj_tools_scripts`).
* Já insere um cabeçalho padrão (`#!/bin/bash`) e permissões de execução (`chmod +x`).
* Mantém um contador persistente de quantos scripts foram criados (salvo em `qntd_scripts.txt`).

### 3. 💻 Setup de Ambiente Dev
Automatiza a instalação de ferramentas essenciais para programadores:
* **Atualização do sistema:** `apt-get update`
* **Ferramentas:** Git, Node.js, Python3, Docker.
* **Estrutura de Projetos:** Cria a pasta `~/projects/my_project` com arquivos iniciais (`README.md`, `.gitignore`, `LICENSE`).
* **Permissões:** Ajusta automaticamente as permissões dos diretórios criados.

### 4. 🧹 Limpeza e Saída
* Oferece a opção de remover todo o diretório de scripts criados e os arquivos de log ao encerrar o programa, garantindo que nenhum lixo seja deixado no sistema se o usuário desejar.

---

## 📋 Pré-requisitos

* Sistema Operacional: Linux (distribuições baseadas em Debian/Ubuntu, como Ubuntu, Mint, Pop!_OS, etc., devido ao uso do `apt-get`).
* Permissões: O usuário deve ter acesso ao `sudo` para a funcionalidade de instalação de pacotes.

## 🔧 Como Executar

1. **Baixe o arquivo** ou clone este repositório.
2. **Dê permissão de execução** ao arquivo (`projeto.sh`):
   ```bash
   chmod +x projeto.sh
