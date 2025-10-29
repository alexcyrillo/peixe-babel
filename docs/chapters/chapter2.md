# Capítulo 2 — Documento de Arquitetura

Meta
- Versão: 0.1
- Data: TODO
- Autor(es): TODO
- Estado: Rascunho
- Público-alvo: Engenheiros(as), Produto, Operações, Segurança

1. Sumário executivo
- Objetivo do sistema: TODO
- Problema a resolver e valor de negócio: TODO
- Principais decisões e trade-offs: TODO

2. Escopo, contexto e stakeholders
- Escopo incluído: TODO
- Fora de escopo: TODO
- Stakeholders e responsabilidades: TODO
- Restrições (legais, técnicas, organizacionais): TODO

3. Requisitos
- Funcionais (top 5): 
    - TODO
- Não funcionais (atributos de qualidade):
    - Desempenho: TODO
    - Confiabilidade/Disponibilidade: TODO
    - Segurança/Privacidade: TODO
    - Escalabilidade: TODO
    - Manutenibilidade/Observabilidade: TODO
    - Custo: TODO
- Critérios de aceitação e métricas: TODO

4. Visão geral da solução
- Estilo arquitetural (ex.: modular, microserviços, evento-dirigido): TODO
- Diagrama de alto nível: TODO (descrição textual do contexto e fronteiras)
- Fronteiras de domínio e Bounded Contexts: TODO

5. Componentes e responsabilidades
- Componentes principais:
    - Componente A — responsabilidades, inputs, outputs, dependências: TODO
    - Componente B — responsabilidades, inputs, outputs, dependências: TODO
- Contratos entre componentes (sincrono/assíncrono): TODO
- Padrões adotados (ex.: CQRS, Saga, Circuit Breaker): TODO

6. Fluxos principais
- Fluxo 1 (ex.: cadastro): passos, componentes envolvidos, erros esperados: TODO
- Fluxo 2 (ex.: checkout): TODO
- Eventos e tópicos relevantes: TODO

7. Dados e integrações
- Modelo de dados lógico (entidades, relacionamentos): TODO
- Persistência (tipos de storage, estratégias de particionamento/índices): TODO
- Integrações externas (APIs, filas, webhooks): TODO
    - Provedor, protocolo, autenticação, limites, SLAs: TODO

8. APIs e contratos
- Endpoints/recursos: TODO
- Esquemas de request/response e códigos de status: TODO
- Versionamento, limites de taxa e políticas de compatibilidade: TODO

9. Segurança e conformidade
- Ameaças e mitigação (STRIDE resumido): TODO
- Autenticação e autorização: TODO
- Proteção de dados (em trânsito/em repouso, chaveamento): TODO
- Conformidade (LGPD/GDPR, auditoria, retenção): TODO

10. Observabilidade e operação
- Logs, métricas, traces (sinais-chave e cardinalidade): TODO
- Saúde, readiness/liveness: TODO
- Alertas e SLO/SLI/SLAs: TODO
- Gestão de configuração e segredos: TODO

11. Desempenho, escalabilidade e resiliência
- Requisitos de throughput/latência: TODO
- Estratégia de escalabilidade (horizontal/vertical, autoscaling): TODO
- Resiliência (retries, timeouts, backoff, circuit breaker, idempotência): TODO
- Caching (onde, o quê, TTL): TODO

12. Implantação e ambientes
- Ambientes (dev/test/stage/prod): TODO
- Topologia de deployment e rede: TODO
- Pipeline CI/CD (build, test, segurança, releases): TODO
- Estratégias de lançamento (blue/green, canary, feature flags): TODO

13. Riscos, dívidas e decisões
- Riscos principais e plano de mitigação: TODO
- Dívida técnica conhecida: TODO
- Decisões de Arquitetura (ADR)
    - ADR-001: Título — Status — Resumo: TODO
    - ADR-002: TODO

14. Plano de evolução
- Roadmap técnico por marcos: TODO
- Migrações e compatibilidade: TODO
- Experimentos/Spikes necessários: TODO

15. Glossário e referências
- Termos do domínio: TODO
- Referências (documentos, RFCs, padrões internos): TODO

Checklist de revisão
- Requisitos claros e rastreados: [ ] 
- Atributos de qualidade com métricas: [ ] 
- Limites e contratos explícitos: [ ] 
- Plano de observabilidade e SLOs: [ ] 
- Segurança e conformidade endereçadas: [ ] 
- ADRs registrados: [ ] 
- Riscos e mitigação documentados: [ ] 
- Estratégia de implantação validada: [ ]

Notas
- Mantenha o documento enxuto; detalhe o que muda e referencie o que já existe.
- Atualize ADRs ao invés de reescrever histórico.
- Ilustre com exemplos mínimos e casos de falha, quando relevante.