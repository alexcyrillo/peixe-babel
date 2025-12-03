# Estratégias de Implementação

Este capítulo apresenta as decisões técnicas, arquitetura de software e estratégias adotadas para implementar o Sistema Peixe Babel, alinhadas ao estado atual do repositório.

## Visão Geral da Arquitetura

O sistema segue uma **arquitetura cliente-servidor em camadas** (layered) com princípios de **clean architecture** para modularidade, testabilidade e manutenibilidade.

Estilo arquitetural: aplicativo móvel nativo se comunica com um backend via _Representational State Transfer_ (REST) Interface de Programação de Aplicações (API - Application Programming Interface) e integra serviços externos especializados.

## Componentes Principais

- Aplicativo Mobile (Flutter): UI, consumo da API, revisão SRS, sincronização de dados básicos.
- Backend (Django + Django REST Framework): persistência, regras de negócio de flashcards e conversas, integração com LLM.
- Módulo de Diálogo: orquestra prompts e chama a API do LLM com contexto (vocabulário ativo, histórico de mensagens).
- Banco de Dados: PostgreSQL para persistência de flashcards e histórico de mensagens.

Planejado (não implementado integralmente no código atual):
- Autenticação: JWT/OAuth2 e gestão de usuários.
- Cache/Queue: Redis para cache e filas assíncronas (enriquecimento, processamento de áudio).

## Diagramas e Fluxos

- Criação de flashcard: inserção → possível enriquecimento (planejado) → persistência → agendamento no SRS.
- Diálogo: abertura de sessão → recuperação de vocabulário ativo → montagem de prompt → chamada ao LLM → pós-processamento → armazenamento de histórico.
- Listagem de flashcards: consulta (paginada/filtrada) → exibição → seleção para ações.
- Edição de flashcard: abertura do item → alteração de campos → validação → atualização → possível reavaliação do agendamento.
- Exclusão de flashcard: confirmação → remoção do registro → atualização de contagens/métricas.
- Revisão SRS: seleção de cards devidos → apresentação ao usuário → registro de resposta (qualidade) → atualização do agendamento.
- Sincronização: envio/recebimento de dados essenciais para manter consistência entre dispositivo e backend (escopo básico no estado atual).

## Contratos e APIs

Base: `/api/v1/` (ver `backend/src/peixe_babel/urls.py` e `backend/src/flashcard/urls.py`).

### Flashcards

A Tabela 3 apresenta os principais endpoints disponíveis para o gerenciamento de flashcards, detalhando o método HTTP, o caminho do recurso, uma breve descrição e o código de status esperado em caso de sucesso.

**Tabela 3 – Endpoints de Flashcards**

| Método | Caminho                | Descrição                                  | Código de Sucesso |
|--------|------------------------|---------------------------------------------|-------------------|
| GET    | `/flashcards/`         | Listar flashcards (filtros futuros)         | 200               |
| POST   | `/flashcards/`         | Criar novo flashcard                        | 201               |
| GET    | `/flashcards/{id}/`    | Obter detalhes de um flashcard              | 200               |
| PATCH  | `/flashcards/{id}/`    | Atualizar campos de um flashcard            | 200               |
| DELETE | `/flashcards/{id}/`    | Remover definitivamente um flashcard        | 204               |

<p class="footnote">Fonte: Elaborado pelo autor (2025).</p>

#### Listar

Resposta 200:
```json
[
  {
    "id": 1,
    "word": "apple",
    "translation": "maçã",
    "meaning": "a round fruit with red or green skin",
    "examples": [ { "en": "I ate an apple.", "pt": "Eu comi uma maçã." } ],
    "easiness_factor": 2.5,
    "interval": 0,
    "repetitions": 0,
    "next_review": "2025-11-13T10:00:00Z",
    "created_at": "2025-11-13T09:00:00Z",
    "updated_at": "2025-11-13T09:00:00Z"
  }
]
```

#### Criar

Campos do corpo:

- Obrigatórios: `word` (string)
- Opcionais: `translation` (string) — utilizado quando se quer uma definição específica.
- Preenchidos automaticamente (quando disponíveis): `meaning`, `examples`.

Exemplo de requisição:
```json
{ "word": "apple", "translation": "maçã" }
```
Resposta 201 (detalhe do item criado):
```json
{ "id": 1, "word": "apple", "translation": "maçã", "meaning": "a round fruit with red or green skin", "examples": [ { "en": "I ate an apple.", "pt": "Eu comi uma maçã." } ], "easiness_factor": 2.5, "interval": 0, "repetitions": 0, "next_review": "2025-11-13T10:00:00Z" }
```

#### Atualizar

Campos permitidos (qualquer combinação): `word`, `translation`, `examples`.
Exemplo:
```json
{ "translation": "maçã (fruta)" }
```
Resposta 200: item atualizado.

#### Excluir

Resposta 204 sem corpo.

### Revisões

A Tabela 4 lista os endpoints dedicados ao processo de revisão espaçada, permitindo consultar itens pendentes e registrar o desempenho do usuário.

**Tabela 4 – Endpoints de Review**

| Método | Caminho             | Descrição                                    | Código |
|--------|---------------------|-----------------------------------------------|--------|
| GET    | `/review/`          | Listar flashcards devidos para revisão        | 200    |
| PATCH  | `/review/{id}/`     | Registrar resultado da revisão (qualidade)    | 200    |

<p class="footnote">Fonte: Elaborado pelo autor (2025).</p>

#### Listar devidos

Resposta 200:
```json
[
  { "id": 1, "word": "apple", "easiness_factor": 2.5, "interval": 0, "repetitions": 0, "next_review": "2025-11-13T10:00:00Z" }
]
```

#### Registrar revisão

Campos (corpo):
- `easiness_factor` (number) — calculado após qualidade, no MVP enviado diretamente.

Exemplo:
```json
{ "easiness_factor": 3.0 }
```
Resposta 200:
```json
{ "id": 1, "easiness_factor": 3.0, "interval": 1, "repetitions": 1, "next_review": "2025-11-14T10:00:00Z" }
```

### Conversação (IA)

A Tabela 5 descreve os endpoints responsáveis pela interação com o módulo de conversação, possibilitando o envio de mensagens e a recuperação do histórico do diálogo.

**Tabela 5 – Endpoints de Chat**

| Método | Caminho     | Descrição                         | Código |
|--------|-------------|-----------------------------------|--------|
| GET    | `/chat/`    | Listar histórico de mensagens     | 200    |
| POST   | `/chat/`    | Enviar nova mensagem do usuário   | 201    |

<p class="footnote">Fonte: Elaborado pelo autor (2025).</p>

#### Listar mensagens

Resposta 200:
```json
[
  { "created_at": "2025-11-13T09:00:00Z", "user_message": "Hello!", "agent_message": "Hi! How can I help you?" }
]
```

#### Enviar mensagem

Campos obrigatórios: `user_message` (string)

Requisição:
```json
{ "user_message": "Hello!" }
```
Resposta 201:
```json
{ "created_at": "2025-11-13T09:05:00Z", "user_message": "Hello!", "agent_message": "Hi there!" }
```

Observação: requer chave de IA configurada nas variáveis de ambiente; sem ela, retorna 502 com `detail`.

## Segurança

- HTTPS recomendado em produção; dados sensíveis via variáveis de ambiente.
- Autenticação e autorização avançadas (JWT/OAuth2) — planejado.

## Escalabilidade e Resiliência

- O backend pode ser conteinerizado e escalado horizontalmente.
- Políticas de retry/backoff e cache/filas — planejado.

## Observabilidade

- Logs estruturados e métricas de latência — base.
- Tracing distribuído e métricas de uso de tokens do LLM — planejado.

## Decisões de Arquitetura (ADR)

- Registrar decisões e trade-offs (ex.: escolha do LLM, uso de serviços externos, capacidades offline) em `docs/adr/` — sugerido.