# Capítulo 4 — Arquitetura e Design do Sistema

## 1. Visão Geral da Arquitetura
Descrição do estilo arquitetural adotado (modular, separação entre mobile e backend, serviços de integração), diagrama de alto nível e fronteiras do sistema.

## 2. Componentes Principais
- Aplicativo Mobile (Flutter): UI, sincronização, reprodução de áudio.
- Backend (Django / FastAPI): autenticação, persistência, orquestração de enriquecimento e histórico.
- Serviço de Enriquecimento: integração com APIs de dicionário, gerador de frases e TTS.
- Módulo de Diálogo: orquestra prompts e chama a API do LLM com contexto do usuário.
- Banco de Dados: PostgreSQL para persistência de flashcards, histórico e usuários.
- Cache/Queue: Redis para cache de respostas e filas assíncronas (enriquecimento, processamento de áudio).

## 3. Diagramas e Fluxos
- Diagrama de contexto: usuário ↔ app móvel ↔ backend ↔ serviços externos.
- Fluxo de criação de flashcard: inserção → enriquecimento assíncrono → persistência → agendamento no SRS.
- Fluxo de diálogo: requisição de sessão → recuperação de vocabulário ativo → prompt assembly → chamada ao LLM → pós-processamento.

## 4. Contratos e APIs
- Endpoints REST/HTTP principais com exemplos simplificados (auth, cards, sessions, sync).

## 5. Segurança
- Autenticação: JWT / OAuth2.
- Criptografia em trânsito (HTTPS) e em repouso para dados sensíveis.

## 6. Escalabilidade e Resiliência
- Estratégias de escala para backend e filas, uso de cache e políticas de retry/backoff.

## 7. Observabilidade
- Logs estruturados, métricas (tempo de resposta, uso de tokens LLM), tracing para chamadas entre componentes.

## 8. Decisões de Arquitetura (ADR)
- Registrar as decisões importantes e trade-offs (ex.: escolha do LLM, uso de TTS externo, offline-capabilities).

Referências: incluir diagramas (imagens) em `docs/img/` e ADRs em `docs/adr/`.
