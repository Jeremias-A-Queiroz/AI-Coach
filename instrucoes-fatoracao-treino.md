## MANUAL TÉCNICO DEFINITIVO: FATORAÇÃO DE MODELOS DE TREINO (ZEPP & INTERVALS.ICU)

Este manual é a referência técnica completa para gerar programas de treino que são **diretamente configuráveis no Zepp App** e, simultaneamente, **compatíveis com a sintaxe de importação do Intervals.icu**.

### 1. ESTRUTURA E REGRAS ZEPP APP

O Modelo de Treino no Zepp é construído como uma sequência ordenada de **Intervalos**.

#### 1.1. Tipos de Intervalo e Uso:
| Tipo de Intervalo | Uso Típico | Observação |
| :---: | :--- | :--- |
| **Aquecimento** | Início do treino. | Geralmente duração manual ou tempo fixo. |
| **Treino** | Blocos de esforço principal. | Usará Repetições (Reps), Duração, FC ou Kcal. |
| **Descansar** | Pausa entre séries ou exercícios. | Duração definida em tempo (m/s). |
| **Restaurar** | Recuperação ativa (ex: pedal leve). | Pode ser definido por tempo ou Kcal. |
| **Relaxado** | Fim do treino (desaquecimento, alongamento). | Geralmente duração manual ou tempo fixo. |

#### 1.2. Mapeamento de Duração/Métrica (Como o Intervalo Termina):
A duração deve ser escolhida em uma única métrica por passo.

* **Por vezes:** O exercício termina após um número `X` de repetições (ex: `15 vezes`).
* **Por duração:** O exercício termina após um tempo fixo (ex: `1m 30s`).
* **Por consumo de calorias:** O exercício termina após `X Kcal` serem queimadas.
* **Por frequência cardíaca (FC):** O exercício termina ou dura enquanto a FC estiver em um alvo (ex: `FC > 140 bpm`).
* **Quando o botão Ignorar é tocado:** Duração manual, o usuário controla o fim (típico de Aquecimento/Relaxado).

#### 1.3. Mapeamento de Carga (Campo Peso):
A forma como a carga é rastreada ou definida.

* **Por peso:** Carga fixa em kg/lb.
* **Por peso corporal:** Exercícios sem peso externo.
* **Por RM (Repetição Máxima):** Carga definida como percentual da 1RM do usuário (intensidade relativa).

#### 1.4. Sintaxe de Repetição ZEPP (Loops)
* **Definição:** A opção `Repetir` na tela principal cria um *loop* de `N` repetições sobre um conjunto específico de Intervalos.
* **Regra:** O LLM deve agrupar blocos **Treino + Descansar** ou **Treino + Restaurar** em um loop.
* **Exemplo:** Um *loop* de 4 séries de Agachamento (Bloco B) com 1 minuto de descanso (Bloco C) deve ser expresso como: `4x { Bloco B + Bloco C }`.

### 2. SINTAXE DE IMPORTAÇÃO INTERVALS.ICU

Este é o conjunto de regras estritas para gerar o formato de texto plano aceito pelo Intervals.icu.

#### 2.1. Regras de Formato (Geral)
* **Início do Passo:** Cada passo do treino começa com um traço (`-`).
* **Repetição (Loop):** A sintaxe é `Nx { ... }` onde `N` é o número de repetições.
* **Formato de Tempo:** Usar `m` para minutos e `s` para segundos.
* **Ordem de Elementos:** A ordem deve ser **`- [DURAÇÃO] @ [INTENSIDADE] [DESCRIÇÃO DO PASSO]`**.

#### 2.2. Formas de Especificar Intensidade
* **Percentual de FTP (Ciclismo/Corrida):** Usar `% FTP`. Ex: `- 10m @ 65% FTP Aquecimento Leve`
* **Zonas de Esforço (RPE/FC):** Usar a tag `@` seguida do valor. Ex: `- 30s @ Z4 Ataque Máximo` ou `- 1m @ RPE 7 Descanso Ativo`
* **Potência Fixa:** Usar `WATTS`. Ex: `- 5m @ 220 WATTS Esforço Constante`
* **Força/Repetições:** Usar o número de repetições e a descrição. Ex: `- 12 repetições Deadlift (RM)`
* **FC (Frequência Cardíaca):** Usar `bpm` ou faixas de FC. Ex: `- 2m @ 135-145 bpm Zona Aeróbica`
* **Manual/Sem Intensidade:** Usar apenas a duração/condição e a descrição. Ex: `- Quando Ignorado Alongamento Final`

### 3. FORMATO DE SAÍDA OBRIGATÓRIO (OUTPUT FINAL)

O LLM DEVE gerar **três blocos de código** para cada treino, mantendo consistência total entre eles.

#### 3.1. Bloco A: Tabela de Configuração ZEPP (Markdown)
*É o resumo dos dados de cada Intervalo.*

| Campo | Tipo de Intervalo | Nome do Exercício | Duração / Reps | Carga | Repetir (Loop) | Nota |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| X | ... | ... | ... | ... | ... | ... |

* **Regra de Tradução:** Se o `Nome do Exercício` for em Inglês, a `Nota` **DEVE** conter a tradução em Português.

#### 3.2. Bloco B: Manual de Criação ZEPP (Lista Numerada)
*É o passo a passo lógico para a implementação no App.*

1.  **Configuração Inicial:** Defina o Nome do Treino.
2.  **Intervalo 1 (Aquecimento):** Tipo: Aquecimento. Duração: [Métrica específica]. Nome do Exercício: [Nome]. Nota: [Nota].
3.  **Intervalo X...** (Configure todos os blocos na ordem sequencial).
4.  **Configuração de Repetição (Se aplicável):** Clique em 'Repetir', selecione os blocos [Números/Nomes dos blocos] e defina o valor como [N vezes].

#### 3.3. Bloco C: Sintaxe INTERVALS.ICU (Texto Plano)
*É o formato de ingestão de dados para a plataforma de análise.*

*EXEMPLO DE SINTAXE PARA O INTERVALS.ICU*

```
- 5m @ 50% FTP Aquecimento Leve

4x {
- 3m @ Z4 Esforço Total
- 1m30s @ Z1 Recuperação Passiva
}

- Quando Ignorado Alongamento Final
```

### 4. RESTRIÇÃO DE CONSISTÊNCIA

A lógica de repetição e os parâmetros de duração e intensidade definidos nos três blocos (Tabela, Manual e Sintaxe Intervals.icu) DEVEM ser idênticos.
