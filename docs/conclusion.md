# Resultados e Considerações Finais

## Resultados Alcançados

### Funcionalidades implementadas

   - Criação de flashcards em inglês com enriquecimento automático (tradução, significado, exemplos) via serviço de enriquecimento (`english_field_generator`).
   - Sistema SRS básico: campos e persistência de `easiness_factor`, `interval`, `repetitions` e `next_review`; endpoints para listar e registrar revisões (`/api/v1/review/`).
   - Módulo de conversação com IA: endpoints para criação e listagem de mensagens (`/api/v1/chat/`).

### Qualidade do código / arquitetura

   - Estrutura modular (models, serializers, services, views) com responsabilidades separadas.
   - Constrains para evitar duplicidade (ex.: `word + translation`).
   - Normalização/limpeza de payloads vindos do LLM centralizada em serviços.

## Contribuições técnicas do estado atual

- Pipeline de enriquecimento de flashcards usando LLM com normalização de saída.
- Integração inicial entre SRS e serviços de enriquecimento, com armazenamento dos campos SRS no próprio card.
- Camada de serviços que isola lógica de IA (facilitando testes e troca de provedores).

## Limitações

1. Dependência direta de LLM para enriquecimento — sem fallback local.
2. Ausência de autenticação e modelo `User` — impede uso multiusuário e métricas por usuário.
3. Falta de suporte offline: criação e revisão dependem de conectividade.

## Próximos passos

| Horizonte | Iniciativa | Objetivo pedagógico / técnico | Dependências | Esforço (S/M/L) |
|-----------|------------|--------------------------------|--------------|----------------|
| ≤3m | Modos de conversação (Imersão, Correção, Bilíngue) | Aumentar variedade de prática e feedback | Feature flag IA, logging | M |
| ≤3m | Lista de frequências para enriquecimento | Priorizar vocabulário útil e reduzir custo | Serviço enriquecimento modular | S |
| 3–9m | Gamificação (streak, XP, conquistas) | Engajamento e retenção | Autenticação, métricas básicas | M |
| 3–9m | OCR para captura de palavras | Reduz atrito de entrada de vocabulário | Biblioteca OCR, fallback offline | M |
| 3–9m | Painel administrativo (B2B) | Uso em escolas / acompanhamento | Autenticação, coleta de métricas | L |
| 9–18m | Fine‑tuning / modelo próprio | Reduzir custo e latência de enriquecimento | Corpus rotulado, métricas qualidade | L |
| 9–18m | Reconhecimento de fala (pronúncia) | Feedback oral e fluência | Pipeline áudio, modelo STT | L |
| 9–18m | Multi‑idioma adicional (ES, JP, FR) | Expandir alcance internacional | Internacionalização, datasets | L |

Modos de conversação (detalhe rápido):
- Imersão: respostas direto no idioma alvo, mínima sinalização de erro.
- Correção: resposta + correções e reformulações.
- Bilíngue: resposta + tradução para idioma nativo do usuário.


## Impacto social

Mesmo em estágio de MVP (Minimum Viable Product – Produto Mínimo Viável), o sistema reduz a fricção na criação de material de estudo personalizado. Ao incluir offline e multi‑idioma e reduzir dependência de um único provedor de IA, o alcance para contextos com restrição de recursos será ampliado significativamente.

## Conclusão

O repositório comprova a viabilidade técnica das três peças centrais: enriquecimento automático, revisão espaçada e conversação básica.
