# Estratégias de Implementação

Este capítulo apresenta as decisões técnicas, arquitetura de software e estratégias adotadas para implementar o Sistema Peixe Babel.

## Visão Geral da Arquitetura

O sistema segue uma **arquitetura cliente-servidor com camadas separadas** (layered architecture) combinada com princípios de **clean architecture** para garantir modularidade, testabilidade e manutenibilidade.

**Estilo Arquitetural**: Aplicação móvel nativa comunicando-se com backend via REST API, com integração a serviços externos especializados.

## Componentes Principais

- Aplicativo Mobile (Flutter): UI, sincronização, reprodução de áudio.
- Backend (Django / FastAPI): autenticação, persistência, orquestração de enriquecimento e histórico.
- Serviço de Enriquecimento: integração com APIs de dicionário, gerador de frases e TTS.
- Módulo de Diálogo: orquestra prompts e chama a API do LLM com contexto do usuário.
- Banco de Dados: PostgreSQL para persistência de flashcards, histórico e usuários.
- Cache/Queue: Redis para cache de respostas e filas assíncronas (enriquecimento, processamento de áudio).

## Diagramas e Fluxos

- Diagrama de contexto: usuário ↔ app móvel ↔ backend ↔ serviços externos.
- Fluxo de criação de flashcard: inserção → enriquecimento assíncrono → persistência → agendamento no SRS.
- Fluxo de diálogo: requisição de sessão → recuperação de vocabulário ativo → prompt assembly → chamada ao LLM → pós-processamento.

## Contratos e APIs

- Endpoints REST/HTTP principais com exemplos simplificados (auth, cards, sessions, sync).

## Segurança

- Autenticação: JWT / OAuth2.
- Criptografia em trânsito (HTTPS) e em repouso para dados sensíveis.

## Escalabilidade e Resiliência

- Estratégias de escala para backend e filas, uso de cache e políticas de retry/backoff.

## Observabilidade

- Logs estruturados, métricas (tempo de resposta, uso de tokens LLM), tracing para chamadas entre componentes.

## Decisões de Arquitetura (ADR)

- Registrar as decisões importantes e trade-offs (ex.: escolha do LLM, uso de TTS externo, offline-capabilities).

Referências: incluir diagramas (imagens) em `docs/img/` e ADRs em `docs/adr/`.
