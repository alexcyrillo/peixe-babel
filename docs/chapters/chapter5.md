# Capítulo 5 — Implementação

## 1. Visão Geral da Implementação
Descrição das escolhas tecnológicas e como os componentes projetados no capítulo anterior foram materializados em código.

## 2. Backend
- Estrutura do projeto (apps/endpoints principais).
- Modelos principais: User, Flashcard, Deck, ReviewSchedule, SessionHistory.
- Serviços: EnrichmentService, TTSService, LLMService.

## 3. Mobile (Flutter)
- Estrutura do aplicativo: páginas, estado (provider/bloc), sincronização offline/online.
- UI/UX: guidelines, componentes reutilizáveis e acessibilidade.

## 4. Infraestrutura
- Configuração de banco, migrations, configuração de variáveis (`.env.example`).
- Pipelines de CI para build, testes e releases.

## 5. Testes Automatizados
- Exemplos de testes unitários e de integração, com snippets de código.

## 6. Observações de Implementação
- Boas práticas adotadas, limites de versão, dependências críticas.
