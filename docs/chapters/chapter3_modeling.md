# Modelagens (Funcional, Estática e Dinâmica)

Este capítulo apresenta as modelagens do sistema através de diagramas e descrições que ilustram a estrutura, comportamento e interações dos componentes do Peixe Babel.

## Modelagem Funcional

### Diagrama de Contexto

O diagrama de contexto ilustra o sistema e suas interações com atores externos e sistemas adjacentes.

Consultar o diagrama no anexo **E.1 — Diagrama de Contexto**

**Atores**:

- **Usuário (Estudante)**: Interage com o app para criar/revisar flashcards e praticar conversação.

**Sistemas Adjacentes**:

- **LLM API**: Fornece respostas de conversação adaptadas ao vocabulário do aluno.
- **Banco de Dados (PostgreSQL)**: Persiste os dados do sistema.

### Diagrama de Casos de Uso

Consultar o diagrama no anexo **E.2 — Diagrama de Casos de Uso**


**Casos de Uso Identificados**:

- UC01: Criar Flashcard
- UC02: Revisar Flashcards
- UC03: Praticar Conversação
- UC04: Sincronizar Dados
- UC05: Editar/Excluir Flashcard

(Detalhes de cada caso de uso encontram-se no Capítulo 2, seção 2.4)

## Modelagem Estática (Modelo de Dados)

### Diagrama de Classes (Modelo de Dados Atual)

Consultar o diagrama no anexo **E.3 — Diagrama de Classes**

Notas:
- O modelo atual não persiste relação explícita com `User` nos cards.
- Os campos do SRS ficam no próprio card (não há `ReviewSchedule` separado).
- Há tabela para mensagens de chat em inglês (`EnglishChatMessage`).

## Modelagem Dinâmica (Diagramas de Sequência)

### Sequência: Criação de Flashcard

Consultar o diagrama no anexo **E.4.1 — Criação de Flashcard**

**Fluxo**:

1. Usuário insere palavra no app
2. App envia requisição POST ao backend
3. Backend processa enriquecimento (dicionário, exemplos, tradução, áudio)
4. Serviços externos são consultados conforme necessário (sincrônico no MVP)
5. Dados são consolidados e o flashcard é salvo com primeira revisão agendada
6. App recebe confirmação e atualiza a interface

### Sequência: Revisão de Flashcard (SRS)

Consultar o diagrama no anexo **E.4.2 — Revisão de Flashcard (SRS)**

**Fluxo**:

1. App solicita flashcards devidos
2. Backend consulta banco (WHERE next_review <= TODAY)
3. Cards são retornados e exibidos
4. Usuário avalia dificuldade
5. Backend aplica SM-2 para recalcular próximo intervalo
6. Campos do card são atualizados: easiness_factor, interval, repetitions e next_review

### Sequência: Conversação com IA

Consultar o diagrama no anexo **E.4.3 — Conversação com IA**

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

Consultar o diagrama no anexo **E.5 — Diagrama de Estados**

**Estados**:

- **NOVO**: Flashcard recém-criado, aguardando primeira revisão
- **APRENDENDO**: Em processo de memorização (interval < 21 dias)
- **CONSOLIDADO**: Memorizado, mas ainda em reforço (interval 21-180 dias)
- **DOMINADO**: Profundamente consolidado (interval > 180 dias)

## Diagrama de Componentes

Consultar o diagrama no anexo **E.6 — Diagrama de Componentes**

---

**Nota**: Os diagramas apresentados neste capítulo fornecem a base para a implementação descrita no Capítulo 4. Diagramas mais detalhados (UML completo) encontram-se nos Anexos Técnicos.