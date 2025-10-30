# Modelagens (Funcional, Estática e Dinâmica)

Este capítulo apresenta as modelagens do sistema através de diagramas e descrições que ilustram a estrutura, comportamento e interações dos componentes do Peixe Babel.

## Modelagem Funcional

### Diagrama de Contexto

O diagrama de contexto ilustra o sistema e suas interações com atores externos e sistemas adjacentes.

```
┌─────────────┐
│   Usuário   │
│  (Estudante)│
└──────┬──────┘
   │
   │ usa
   ↓
┌─────────────────────────────────────────────┐
│                                             │
│          Sistema Peixe Babel                │
│                                             │
│  ┌─────────────┐      ┌─────────────┐     │
│  │ App Mobile  │←────→│  Backend    │     │
│  │  (Flutter)  │      │  (Django)   │     │
│  └─────────────┘      └──────┬──────┘     │
│                              │             │
└──────────────────────────────┼─────────────┘
               │
         ┌─────────────┴──────────────┐
         │                            │
         ↓                            ↓
    ┌─────────────────┐        ┌──────────────────┐
    │ APIs Externas   │        │  Base de Dados   │
    │                 │        │   (PostgreSQL)   │
    │ • Dicionário    │        └──────────────────┘
    │ • TTS           │
    │ • LLM (GPT-4)   │
    └─────────────────┘
```

**Atores**:

- **Usuário (Estudante)**: Interage com o aplicativo móvel para criar flashcards, revisar vocabulário e praticar conversação.

**Sistemas Adjacentes**:

- **APIs de Dicionário**: Fornecem definições e traduções.
- **APIs de TTS**: Geram áudio de pronúncia.
- **APIs de LLM**: Geram frases de exemplo e conduzem conversação adaptativa.

### Diagrama de Casos de Uso

```
          Peixe Babel System
    ┌──────────────────────────────────────────┐
    │                                          │
    │  (Criar Flashcard)                       │
    │          ↑                               │
    │          │                               │
┌───┴──┐      │                               │
│      │──────┤                               │
│Usuário│      │                               │
│      │──────┤  (Revisar Flashcards)         │
└───┬──┘      │                               │
    │         │                               │
    │         ↓                               │
    │  (Praticar Conversação)                 │
    │                                          │
    │  (Sincronizar Dados)                    │
    │                                          │
    │  (Editar/Excluir Flashcard)             │
    │                                          │
    └──────────────────────────────────────────┘
```

**Casos de Uso Identificados**:

- UC01: Criar Flashcard
- UC02: Revisar Flashcards
- UC03: Praticar Conversação
- UC04: Sincronizar Dados
- UC05: Editar/Excluir Flashcard

(Detalhes de cada caso de uso encontram-se no Capítulo 2, seção 2.4)

## Modelagem Estática (Modelo de Dados)

### Diagrama de Classes Conceitual

```
┌──────────────────┐
│      User        │
├──────────────────┤
│ id: UUID         │
│ username: String │
│ email: String    │
│ native_lang: Str │
│ target_lang: Str │
│ created_at: Date │
└────────┬─────────┘
     │
     │ 1
     │
     │ *
┌────────┴─────────┐
│    Flashcard     │
├──────────────────┤
│ id: UUID         │
│ user_id: UUID    │◄───┐
│ word: String     │    │
│ definition: Text │    │
│ translation: Str │    │
│ example: Text    │    │
│ audio_url: Str   │    │
│ created_at: Date │    │
└────────┬─────────┘    │
     │              │
     │ 1            │
     │              │
     │ *            │
┌────────┴─────────┐    │
│ ReviewSchedule   │    │
├──────────────────┤    │
│ id: UUID         │    │
│ flashcard_id: ID │────┘
│ next_review: Date│
│ interval: Int    │
│ easiness: Float  │
│ repetitions: Int │
└──────────────────┘

┌──────────────────┐
│ ConversationSess │
├──────────────────┤
│ id: UUID         │
│ user_id: UUID    │───┐
│ started_at: Date │   │
│ ended_at: Date   │   │
│ messages: JSON   │   │
└──────────────────┘   │
           │
     ┌─────────────┘
     │
┌────────┴─────────┐
│      User        │
│  (referência)    │
└──────────────────┘
```

**Entidades Principais**:

1. **User**: Representa o usuário do sistema
   - Atributos de autenticação e preferências de idioma
   - Relacionamento 1:N com Flashcard e ConversationSession

2. **Flashcard**: Representa um cartão de estudo
   - Contém palavra/frase, definição, tradução, exemplo e áudio
   - Relacionamento N:1 com User
   - Relacionamento 1:1 com ReviewSchedule

3. **ReviewSchedule**: Armazena dados do algoritmo SRS
   - Próxima data de revisão, intervalo atual, fator de facilidade
   - Relacionamento 1:1 com Flashcard

4. **ConversationSession**: Registro de sessões de conversação
   - Histórico de mensagens (JSON array)
   - Relacionamento N:1 com User

## Modelagem Dinâmica (Diagramas de Sequência)

### Sequência: Criação de Flashcard

```
Usuário    App Mobile    Backend API    EnrichmentService    APIs Externas
   │            │             │                 │                  │
   │ insere     │             │                 │                  │
   │ palavra    │             │                 │                  │
   ├───────────>│             │                 │                  │
   │            │ POST        │                 │                  │
   │            │ /flashcards │                 │                  │
   │            ├────────────>│                 │                  │
   │            │             │ enrich_async    │                  │
   │            │             ├────────────────>│                  │
   │            │             │                 │ fetch_definition │
   │            │             │                 ├─────────────────>│
   │            │             │                 │<─────────────────┤
   │            │             │                 │ definition       │
   │            │             │                 │                  │
   │            │             │                 │ generate_example │
   │            │             │                 ├─────────────────>│
   │            │             │                 │<─────────────────┤
   │            │             │                 │ example          │
   │            │             │                 │                  │
   │            │             │                 │ fetch_TTS        │
   │            │             │                 ├─────────────────>│
   │            │             │                 │<─────────────────┤
   │            │             │                 │ audio_url        │
   │            │             │<────────────────┤                  │
   │            │             │ save_flashcard  │                  │
   │            │             ├─────────>DB     │                  │
   │            │<────────────┤                 │                  │
   │            │ 201 Created │                 │                  │
   │<───────────┤             │                 │                  │
   │ confirmação│             │                 │                  │
```

**Fluxo**:

1. Usuário insere palavra no app
2. App envia requisição POST ao backend
3. Backend dispara enriquecimento assíncrono
4. EnrichmentService consulta APIs externas em paralelo
5. Dados são consolidados e flashcard é salvo
6. App recebe confirmação e atualiza UI

### Sequência: Revisão de Flashcard (SRS)

```
Usuário    App Mobile    Backend API    SRSService    Database
   │            │             │              │            │
   │ abre       │             │              │            │
   │ revisão    │             │              │            │
   ├───────────>│ GET         │              │            │
   │            │ /flashcards │              │            │
   │            │ /due        │              │            │
   │            ├────────────>│ get_due_cards│            │
   │            │             ├─────────────>│            │
   │            │             │              │ SELECT     │
   │            │             │              ├───────────>│
   │            │             │              │<───────────┤
   │            │             │<─────────────┤            │
   │            │<────────────┤ flashcards   │            │
   │<───────────┤             │              │            │
   │ exibe card │             │              │            │
   │            │             │              │            │
   │ avalia     │             │              │            │
   │ (fácil)    │             │              │            │
   ├───────────>│ POST        │              │            │
   │            │ /reviews    │              │            │
   │            ├────────────>│ update_sched │            │
   │            │             ├─────────────>│            │
   │            │             │              │ UPDATE     │
   │            │             │              ├───────────>│
   │            │             │              │<───────────┤
   │            │             │<─────────────┤            │
   │            │<────────────┤ 200 OK       │            │
   │<───────────┤             │              │            │
   │ próx. card │             │              │            │
```

**Fluxo**:

1. App solicita flashcards devidos
2. Backend/SRSService consulta banco (WHERE next_review <= TODAY)
3. Cards são retornados e exibidos
4. Usuário avalia dificuldade
5. SRSService recalcula próximo intervalo (algoritmo SM-2)
6. ReviewSchedule é atualizado no banco

### Sequência: Conversação com IA

```
Usuário    App Mobile    Backend API    DialogueService    LLM API
   │            │             │                 │              │
   │ inicia     │             │                 │              │
   │ conversa   │             │                 │              │
   ├───────────>│ POST        │                 │              │
   │            │ /sessions   │                 │              │
   │            ├────────────>│ create_session  │              │
   │            │             ├────────────────>│              │
   │            │             │                 │ build_prompt │
   │            │             │                 │ (vocab list) │
   │            │             │                 │              │
   │            │             │                 │ call_LLM     │
   │            │             │                 ├─────────────>│
   │            │             │                 │<─────────────┤
   │            │             │                 │ greeting     │
   │            │             │<────────────────┤              │
   │            │<────────────┤ AI_message      │              │
   │<───────────┤             │                 │              │
   │ exibe msg  │             │                 │              │
   │            │             │                 │              │
   │ responde   │             │                 │              │
   ├───────────>│ POST        │                 │              │
   │            │ /messages   │                 │              │
   │            ├────────────>│ send_message    │              │
   │            │             ├────────────────>│              │
   │            │             │                 │ call_LLM     │
   │            │             │                 ├─────────────>│
   │            │             │                 │<─────────────┤
   │            │             │                 │ AI_response  │
   │            │             │<────────────────┤              │
   │            │<────────────┤ response        │              │
   │<───────────┤             │                 │              │
   │ exibe resp │             │                 │              │
```

**Fluxo**:

1. Usuário inicia sessão de conversação
2. Backend cria sessão e recupera vocabulário ativo do usuário
3. DialogueService monta prompt com instruções e lista de vocabulário
4. Primeira mensagem da IA (greeting) é gerada e retornada
5. Usuário envia mensagem
6. DialogueService encaminha ao LLM com contexto completo
7. Resposta da IA é retornada e exibida

## Diagramas de Estado

### Estados de um Flashcard no SRS

```
      [NOVO]
     │
     │ primeira revisão
     ↓
    [APRENDENDO]
     │
     ├──(fácil)──> interval aumenta
     │
     ├──(difícil)─> interval diminui
     │
     │ interval > 21 dias
     ↓
    [CONSOLIDADO]
     │
     ├──(fácil)──> interval aumenta
     │
     ├──(difícil)─> volta para [APRENDENDO]
     │
     │ interval > 180 dias
     ↓
     [DOMINADO]
```

**Estados**:

- **NOVO**: Flashcard recém-criado, aguardando primeira revisão
- **APRENDENDO**: Em processo de memorização (interval < 21 dias)
- **CONSOLIDADO**: Memorizado, mas ainda em reforço (interval 21-180 dias)
- **DOMINADO**: Profundamente consolidado (interval > 180 dias)

## Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────┐
│                    APLICATIVO MÓVEL                     │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ Presentation │  │   Domain     │  │     Data     │ │
│  │   (Views)    │  │  (UseCases)  │  │ (Repository) │ │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘ │
│         │                  │                  │         │
│         └──────────────────┴──────────────────┘         │
└───────────────────────────┬─────────────────────────────┘
            │ HTTP/REST
            ↓
┌─────────────────────────────────────────────────────────┐
│                      BACKEND API                        │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   REST API   │  │   Services   │  │   Database   │ │
│  │ (Endpoints)  │  │ (Business)   │  │   (Models)   │ │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘ │
│         │                  │                  │         │
│         └──────────────────┴──────────────────┘         │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │ Enrichment   │  │     SRS      │  │   Dialogue   │ │
│  │   Service    │  │   Service    │  │   Service    │ │
│  └──────┬───────┘  └──────────────┘  └──────┬───────┘ │
└─────────┼────────────────────────────────────┼─────────┘
          │                                    │
          ↓                                    ↓
┌──────────────────┐                 ┌──────────────────┐
│  APIs Externas   │                 │    LLM API       │
│  (Dict, TTS)     │                 │  (OpenAI/etc.)   │
└──────────────────┘                 └──────────────────┘
```

---

**Nota**: Os diagramas apresentados neste capítulo fornecem a base para a implementação descrita no Capítulo 4. Diagramas mais detalhados (UML completo) encontram-se nos Anexos Técnicos.
