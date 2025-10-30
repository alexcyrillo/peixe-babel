# Capítulo 3 — Metodologia e Planejamento

## 1. Abordagem de Desenvolvimento
O projeto seguirá uma abordagem ágil com sprints curtos (2 semanas). Cada sprint terá objetivos claros, entregas mínimas e validação por testes automatizados e demonstração funcional para o orientador.

## 2. Plano de Trabalho (Cronograma)
- Semana 1–4: Levantamento de requisitos detalhados e prototipagem (wireframes/UX).
- Semana 5–8: Implementação do backend mínimo e persistência de flashcards.
- Semana 9–12: Integração do motor de enriquecimento (APIs externas) e SRS.
- Semana 13–16: Módulo de diálogo com LLM, testes de integração e usabilidade.
- Semana 17–20: Polimento, testes com usuários, documentação e preparação da defesa.

## 3. Plano de Testes
- Unitários: funções críticas (algoritmos SRS, parsing de conteúdo).
- Integração: endpoints e integração com APIs externas (TTS, dicionários, LLM).
- Usabilidade: sessões com 5–10 usuários para avaliar experiência.
- Performance: medir latência das respostas do agente e tempo de enriquecimento de flashcards.

## 4. Critérios de Aceitação
- Funcionalidade principal (criação automática de flashcards) funcionando com precisão aceitável.
- Sessões de diálogo usam vocabulario do usuário e não introduzem palavras inadequadas.
- Aplicativo roda no dispositivo alvo (Android) com performance aceitável.

## 5. Ferramentas e Infraestrutura
- Repositório: GitHub
- CI: GitHub Actions
- Linguagem mobile: Flutter (Dart)
- Backend: Django + Django REST Framework (ou FastAPI)
- Banco de dados: PostgreSQL
- Serviços externos: APIs de dicionário, TTS e LLM (fornecedores a definir)

## 6. Riscos e Mitigações
- Dependência de APIs externas: implementar fallback e cache.
- Custos de uso de LLMs: otimizar prompts e limitar contexto; usar modelos menores quando possível.
- Privacidade de dados: criptografar dados sensíveis e obedecer LGPD.

## 7. Entregáveis
- Protótipo funcional (APK) para teste.
- Código-fonte com testes básicos e pipeline CI.
- Relatório do TCC com capítulos do projeto e resultados dos testes.