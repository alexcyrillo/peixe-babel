# Modelagens (Funcional, Estática e Dinâmica)

Este capítulo apresenta as modelagens do sistema através de diagramas e descrições que ilustram a estrutura, comportamento e interações dos componentes do Peixe Babel.

## Modelagem Funcional

### Diagrama de Contexto

O diagrama de contexto ilustra o sistema e suas interações com atores externos e sistemas adjacentes. 

![Diagrama de Contexto do Sistema e atores externos](../img/diagrama_contexto.png)

**Atores**:

- **Usuário (Estudante)**: Interage com o app para criar/revisar flashcards e praticar conversação.

**Sistemas Adjacentes**:

- **LLM API**: Fornece respostas de conversação adaptadas ao vocabulário do aluno.
- **Banco de Dados (PostgreSQL)**: Persiste os dados do sistema.

### Diagrama de Casos de Uso

![Diagrama de Casos de Uso: criar, revisar, conversar, sincronizar, editar](../img/diagrama_casos_uso.png)


**Casos de Uso Identificados**:

- UC01: Criar Flashcard
- UC02: Revisar Flashcards
- UC03: Praticar Conversação
- UC04: Sincronizar Dados
- UC05: Editar/Excluir Flashcard

(Detalhes de cada caso de uso encontram-se no Capítulo 2, seção 2.4)

## Modelagem Estática (Modelo de Dados)

### Diagrama de Classes (Modelo de Dados Atual)

![Diagrama de Classes: entidades de flashcard, mensagem de chat e relações](../img/diagrama_classes.png)

Notas:
- O modelo atual não persiste relação explícita com `User` nos cards.
- Os campos do SRS ficam no próprio card (não há `ReviewSchedule` separado).
- Há tabela para mensagens de chat em inglês (`EnglishChatMessage`).

## Modelagem Dinâmica (Diagramas de Sequência)

### Sequência: Criação de Flashcard

![Diagrama de Sequência: fluxo de criação e enriquecimento de flashcard](../img/diagrama_seq_criar_flashcard.png)

**Fluxo**:

1. Usuário insere palavra no app
2. App envia requisição POST ao backend
3. Backend processa enriquecimento (dicionário, exemplos, tradução, áudio)
4. Serviços externos são consultados conforme necessário (sincrônico no MVP)
5. Dados são consolidados e o flashcard é salvo com primeira revisão agendada
6. App recebe confirmação e atualiza a interface

### Sequência: Revisão de Flashcard (SRS)

![Diagrama de Sequência: fluxo de revisão SRS e atualização de intervalo](../img/diagrama_seq_revisao.png)

**Fluxo**:

1. App solicita flashcards devidos
2. Backend consulta banco (WHERE next_review <= TODAY)
3. Cards são retornados e exibidos
4. Usuário avalia dificuldade
5. Backend aplica SM-2 para recalcular próximo intervalo
6. Campos do card são atualizados: easiness_factor, interval, repetitions e next_review

### Sequência: Conversação com IA

![Diagrama de Sequência: diálogo com IA adaptado ao vocabulário do usuário](../img/diagrama_seq_chat.png)


**Fluxo**:

1. Usuário inicia sessão de conversação
2. Backend cria sessão e recupera vocabulário ativo do usuário
3. DialogueService monta prompt com instruções e lista de vocabulário (pedindo tradução para termos novos)
4. Primeira mensagem da IA (greeting) é gerada e retornada
5. Usuário envia mensagem
6. DialogueService encaminha ao LLM com contexto completo
7. Resposta da IA é retornada e exibida

## Diagramas de Estado

### Estados de um Flashcard no SRS

![Diagrama de Estados: transições do flashcard no SRS](../img/diagrama_estados_flashcard.png)

**Estados**:

- **NOVO**: Flashcard recém-criado, aguardando primeira revisão
- **APRENDENDO**: Em processo de memorização (interval < 21 dias)
- **CONSOLIDADO**: Memorizado, mas ainda em reforço (interval 21-180 dias)
- **DOMINADO**: Profundamente consolidado (interval > 180 dias)

## Diagrama de Componentes

![Diagrama de Componentes: app Flutter, API Django, PostgreSQL e integrações](../img/diagrama_componentes.png)

---

**Nota**: Os diagramas apresentados neste capítulo fornecem a base para a implementação descrita no Capítulo 4. Diagramas mais detalhados (UML completo) encontram-se nos Anexos Técnicos.