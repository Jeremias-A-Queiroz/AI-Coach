# AI-Coach: Gerenciamento de Dados Zepp e Geração de Treinos Inteligente

## Descrição do Projeto

Este repositório serve como a espinha dorsal de um sistema de coaching de saúde e fitness personalizado, assistido por IA. Ele foi projetado para extrair, transformar, carregar (ETL) e analisar dados de saúde provenientes do aplicativo Zepp (associado a dispositivos Amazfit), consolidá-los em um formato Org-mode, gerar diagnósticos detalhados e tendências, e criar planos de treino otimizados e compatíveis com as plataformas Zepp e Intervals.icu.

O objetivo é automatizar a análise de telemetrias de alta frequência, fornecendo insights acionáveis e suporte para atingir metas de saúde de curto e longo prazo, como controle de peso, aumento de massa magra e diminuição de gordura visceral.

## Funcionalidades Principais

*   **Extração e Transformação de Dados (ETL)**:
    *   `zepp-csv-to-orgtable.sh`: Um script robusto em Bash que converte arquivos CSV exportados do Zepp (delimitados por vírgula) para tabelas formatadas em Org-mode, limpando automaticamente espaços em branco.
    *   `consolided-zepp-data.org`: Arquivo central para consolidar todos os dados de saúde (atividade, corpo, frequência cardíaca, sono, esporte) de forma hierárquica por ano e mês, pronto para ser lido e processado pela IA.
*   **Sumarização Mensal de Dados de Saúde**:
    *   `prompt-sumarizacao-mes.org`: Um prompt especializado para a IA processar dados brutos de alta frequência e gerar tabelas de resumo mensais para:
        *   **Atividade Contínua**: Minutos ativos, de caminhada e parado (total e média diária).
        *   **Padrões de Sono (Minuto a Minuto)**: Média e desvio padrão para sono profundo, leve, REM e tempo acordado.
        *   **Frequência Cardíaca Contínua**: FC de repouso (média da noite), FC média (acordado) e FC máxima (acordado).
*   **Diagnóstico e Tendências de Saúde por IA**:
    *   `prompt.org`: O prompt principal que orquestra a inteligência do sistema. Ele instrui a IA a:
        *   Ler e integrar dados detalhados do `consolided-zepp-data.org`.
        *   Fatorar um diagnóstico detalhado da rotina de saúde atual e identificar tendências de médio prazo, correlacionando telemetrias como sono, FC, estresse e atividade.
        *   Avaliar a viabilidade e o progresso em relação a objetivos de curto prazo (ex: peso abaixo de 72Kg) e longo prazo (ex: aumento de massa magra, diminuição de gordura visceral).
*   **Geração de Planos de Treino Personalizados**:
    *   A IA cria dois modelos de treino para fazer em casa (sem equipamentos, foco em peso corporal - Bodyweight), priorizando Músculos das Pernas, Quadril e Abdominais, com base na `lista-de-exercicios.org`.
    *   Os treinos são gerados considerando a recuperação muscular, evitando conflitos com treinos recentes (como o treino de abdominais fornecido no prompt).
*   **Padronização e Compatibilidade de Treinos**:
    *   `instrucoes-fatoracao-treino.md`: Manual técnico detalhado que garante que os modelos de treino gerados sejam **diretamente configuráveis no Zepp App** e **compatíveis com a sintaxe de importação do Intervals.icu**. Define tipos de intervalo, métricas de duração, carga e sintaxe de repetição (loops).
*   **Biblioteca de Modelos de Treino**:
    *   `biblioteca-de-modelos-de-treino.org`: Um arquivo Org-mode para armazenar e gerenciar modelos de treino existentes. A IA é instruída a reutilizar treinos pertinentes dessa biblioteca e a sugerir a inclusão de novos treinos gerados.
*   **Lista de Exercícios Compatíveis**:
    *   `lista-de-exercicios.org`: Uma lista abrangente de exercícios compatíveis com o Zepp App, categorizados por grupo muscular, com diretrizes para uso de nomes em português e traduções quando necessário.

## Estrutura do Repositório

```
.
├── biblioteca-de-modelos-de-treino.org    # Biblioteca de treinos pré-existentes
├── consolided-zepp-data.org               # Estrutura de exemplo para dados Zepp consolidados
├── instrucoes-fatoracao-treino.md         # Manual para gerar treinos Zepp/Intervals.icu
├── lista-de-exercicios.org                # Lista de exercícios compatíveis com Zepp
├── prompt-sumarizacao-mes.org             # Prompt para sumarização mensal de dados de saúde
├── prompt.org                             # Prompt principal para diagnóstico e geração de treinos
└── zepp-csv-to-orgtable.sh                # Script para converter CSV do Zepp para tabela Org-mode
``` 

## Como Usar (Fluxo de Trabalho Típico)

1.  **Extração de Dados CSV**: Exporte seus dados de saúde do Zepp App (ou similar) em formato CSV.
2.  **Conversão para Org-mode**:
    *   Execute o script `./zepp-csv-to-orgtable.sh <caminho_para_o_arquivo.csv>` para converter cada arquivo CSV em uma tabela formatada para Org-mode.
    *   Direcione a saída para o `consolided-zepp-data.org` nas seções de mês/ano correspondentes (ex: `>> consolided-zepp-data.org`).
3.  **Sumarização Mensal de Alta Frequência**:
    *   Utilize um LLM (como `gptel` no Emacs) com o conteúdo de `prompt-sumarizacao-mes.org` e os dados brutos CSV (ou as tabelas Org-mode já consolidadas) para gerar os resumos mensais.
    *   Integre os resumos gerados nas seções `Resumos de Alta Frequência` apropriadas dentro de `consolided-zepp-data.org`.
4.  **Análise e Geração de Treinos por IA**:
    *   Alimente o seu LLM (via `gptel` ou outra interface) com o conteúdo do `prompt.org`.
    *   A IA irá ler `consolided-zepp-data.org`, `instrucoes-fatoracao-treino.md` e `lista-de-exercicios.org` para:
        *   Fornecer um diagnóstico de saúde e tendências.
        *   Comentar sobre seus objetivos de curto e longo prazo.
        *   Gerar dois modelos de treino personalizados para os dias solicitados (Sexta e Sábado), seguindo estritamente as regras de formatação do Zepp e Intervals.icu, e evitando conflitos musculares.
5.  **Implementação e Armazenamento dos Treinos**:
    *   Os modelos de treino gerados podem ser configurados no Zepp App ou importados para o Intervals.icu.
    *   **Importante**: Se um treino novo for gerado pela IA, adicione-o à `biblioteca-de-modelos-de-treino.org` para futura referência e reutilização.

## Requisitos

*   **Emacs**: Essencial para a gestão dos arquivos Org-mode e interação com LLMs (via `gptel`).
*   **Bash**: Para a execução de scripts shell.
*   **Awk**: Utilizado pelo script `zepp-csv-to-orgtable.sh` para processamento de CSV.
*   **Um LLM (Large Language Model)**: Necessário para processar os prompts, gerar análises e criar planos de treino.
*   **Aplicativo Zepp / Dispositivo Amazfit**: Fonte dos dados de saúde exportados em CSV.
*   **Intervals.icu (Opcional)**: Plataforma de análise de treinamento compatível com o formato de treino gerado.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues para sugestões, bugs, ou melhorias nos prompts e scripts. Pull requests com novas funcionalidades ou refinamentos são muito apreciados.

## Autor

Jeremias Alves Queiroz
