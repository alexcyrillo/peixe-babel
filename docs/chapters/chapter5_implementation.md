# Implementação

## Visão Geral da Implementação

Esta seção descreve como as escolhas tecnológicas foram materializadas. Diferenciamos o que já está **implementado** do que está **planejado** para evitar confusão no escopo atual do repositório.

## Backend

### Tecnologias

- Django 5 / Django REST Framework (API REST)
- PostgreSQL (persistência)
- OpenAI (integração de enriquecimento e chat)

### Estrutura (implementado)

```
backend/src/
  flashcard/
    models/ (BaseCard, EnglishCard, EnglishChatMessage)
    serializers/ (EnglishCardSerializer, ReviewSerializer, EnglishChatSerializer)
    services/ (english_field_generator.py, chat_open_api.py, vocabulary_getter.py)
    views/ (english_card_view_set.py, english_card_review_view_set.py, english_ai_chat_view_set.py)
  peixe_babel/ (settings, urls)
```
- Roteamento: `peixe_babel/urls.py` inclui `flashcard/urls.py` sob `/api/v1/`.

### Modelos (implementado)

- `EnglishCard`: campos da palavra e metadados SRS (easiness_factor, interval, repetitions, next_review). Constraint única `(word, translation)`.
- `EnglishChatMessage`: histórico simples de conversas (user_message, agent_message).
- `BaseCard`: classe abstrata com timestamps e campos SRS.

### Modelos (planejado)

- `User`: conta e preferências (idioma, nível, configurações de revisão).
- `Deck`: agrupamento temático de cards.
- `ReviewSchedule`: tabela dedicada para agendamentos avançados (caso se separe de cada card).

### Serviços (implementado)

- `english_field_generator`: usa LLM para preencher tradução, significado e exemplos; normalização robusta de payload.
- `chat_open_api`: monta instruções adaptadas ao vocabulário ativo e consulta o modelo.

### Serviços (planejado)

- `EnrichmentService`: integração com dicionários externos (reduzir dependência de IA para casos simples).
- `TTSService`: geração de áudio de pronúncia.
- `LLMService`: abstração única de provedores (OpenAI / alternativos) com fallback.


## Mobile (Flutter)

### Tecnologias

- Flutter SDK 3.9.x
- `dio` para HTTP, `http` simples em cenários pontuais
- Material Design 3 (parcial) / `flutter_svg` / ícones customizados

### Estrutura (implementado)

```
frontend/lib/
  main.dart
  pages/ (conversation_page.dart, main_flashcard_page.dart, main_page.dart)
  widgets/ (button_widget.dart)
  services/api/ (ApiProvider...
  theme/ (app_theme.dart)
```

### UI/UX

- Uso de `ColorScheme` (personalização básica).
- Planejado: acessibilidade (larger fonts, contrast check), componentes reutilizáveis (listagem de cards, estado de carregamento) e testes de widget.

## Infraestrutura

### Banco e Migrations

- PostgreSQL inicializado via Docker (docker-compose). Script SQL em `db_init/init.sql`.
- Migrations Django gerenciadas via `manage.py makemigrations/migrate`.

### Variáveis de Ambiente

- Backend utiliza `OPENAI_API_KEY`, `OPENAI_MODEL`.

### Dependências Críticas

- Django / DRF (core da API)
- OpenAI SDK (enriquecimento/chat)
- supermemo2 (lógica SRS)
- dio / http (consumo de API no Flutter)