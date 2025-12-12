#!/bin/bash
#
# zepp-csv-to-orgtable.sh: Converte um arquivo CSV para uma tabela Org-mode.
#
# Autor:      Jeremias Alves Queiroz
# Versão:     0.1
#
# Descrição:  Este script lê um arquivo .csv cujo delimitador é a vírgula (,)
#             e o converte para uma tabela formatada para o Org-mode, enviando
#             o resultado para a saída padrão (stdout).
#
# Uso:
#             ./zepp-csv-to-orgtable.sh arquivo.csv
#             ./zepp-csv-to-orgtable.sh arquivo.csv > tabela.org
#

# --- Melhores Práticas para Scripts Robustos ---
# set -e: Sai imediatamente se um comando falhar.
# set -u: Trata variáveis não definidas como um erro.
# set -o pipefail: O status de saída de um pipeline é o do último comando a falhar.
set -euo pipefail

# --- Funções ---

# Função para mostrar a forma correta de usar o script e sair.
mostrar_uso() {
    # Imprime a mensagem de erro na saída de erro (stderr)
    echo "Erro: Argumento inválido." >&2
    echo "Uso: $(basename "$0") <caminho_para_o_arquivo.csv>" >&2
    exit 1
}

# --- Verificações Iniciais ---

# 1. Verifica se exatamente um argumento foi fornecido.
#    "$#" contém o número de argumentos passados para o script.
if [ "$#" -ne 1 ]; then
    mostrar_uso
fi

# 2. Armazena o primeiro argumento em uma variável para clareza.
arquivo_csv="$1"

# 3. Verifica se o arquivo fornecido existe e se pode ser lido.
#    O operador '-r' checa se o arquivo existe E tem permissão de leitura.
if [ ! -r "$arquivo_csv" ]; then
    echo "Erro: O arquivo '$arquivo_csv' não existe ou não pode ser lido." >&2
    exit 1
fi

# --- Lógica Principal com AWK ---

# awk é a ferramenta perfeita para processar arquivos baseados em colunas.
# -F','      : Define o delimitador de campo (Field Separator) como uma vírgula.
# O script awk é executado para cada linha do arquivo_csv.

awk -F',' '
# Bloco BEGIN: Executa uma vez antes de processar qualquer linha.
BEGIN {
    # Nada a fazer aqui neste caso, mas é bom saber que existe.
}

# Bloco principal: Executa para CADA linha do arquivo de entrada.
{
    # Inicia a linha da tabela Org com um pipe.
    printf "| "

    # Itera por cada campo (coluna) da linha atual.
    # NF é uma variável interna do awk que contém o Número de Campos na linha.
    for (i=1; i<=NF; i++) {
        # $i representa o valor do campo atual (ex: $1, $2, etc.).
        # gsub remove espaços em branco no início e no fim de cada campo,
        # o que é uma boa prática para limpar os dados.
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i);
        printf "%s | ", $i
    }
    # Após imprimir todos os campos, pula para a próxima linha.
    print ""

    # Se for a primeira linha (NR == 1), adiciona a linha separadora do cabeçalho.
    # NR é uma variável interna do awk que contém o Número do Registro (linha atual).
    if (NR == 1) {
        printf "|-"
        for (i=1; i<=NF; i++) {
            printf "---"
            # Adiciona um "+" entre os separadores, mas um "|" no final.
            if (i < NF) {
                printf "+"
            } else {
                printf "|"
            }
        }
        print ""
    }
}

# Bloco END: Executa uma vez após todas as linhas terem sido processadas.
END {
    # Nada a fazer aqui, mas útil para resumos ou finalizações.
}
' "$arquivo_csv"
