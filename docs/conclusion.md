# Resultados e Considerações Finais

## Resultados Alcançados

### Funcionalidades implementadas

   - Criação de _flashcards_ em inglês com enriquecimento automático (tradução, significado, exemplos) via serviço de enriquecimento (`english_field_generator`).
   - Sistema SRS básico: campos e persistência de `easiness_factor`, `interval`, `repetitions` e `next_review`; endpoints para listar e registrar revisões (`/api/v1/review/`).
   - Módulo de conversação com IA: endpoints para criação e listagem de mensagens (`/api/v1/chat/`).

### Qualidade do código / arquitetura

   - Estrutura modular (models, serializers, services, views) com responsabilidades separadas.
   - Constrains para evitar duplicidade (ex.: `word + translation`).
   - Normalização/limpeza de payloads vindos do LLM centralizada em serviços.

## Contribuições técnicas do estado atual

- Pipeline de enriquecimento de _flashcards_ usando LLM com normalização de saída.
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

## Conclusão

O trabalho apresentado partiu de um problema concreto: a dificuldade de manter uma rotina consistente de estudo de idiomas e de transformar insumos dispersos (textos, conversas, conteúdos de aula) em material de revisão estruturado. A partir desse contexto, o projeto definiu como objetivo principal investigar e demonstrar a viabilidade de um sistema que combinasse **enriquecimento automático de vocabulário**, **revisão espaçada** e **interação por conversação com IA** para apoiar o aprendizado de inglês.

Ao longo dos capítulos de requisitos, modelagem e arquitetura foram especificadas e refinadas as principais funcionalidades: criação de _flashcards_ enriquecidos com tradução, significado e exemplos; uso de um modelo de repetição espaçada com campos dedicados (`easiness_factor`, `interval`, `repetitions`, `next_review`); e um módulo de chat que permite ao usuário praticar o idioma em diferentes modos de interação. A implementação consolidada neste repositório materializa essas decisões em uma API REST, com modelos, serviços e endpoints documentados e testáveis.

Do ponto de vista técnico, o sistema comprova que é possível integrar um serviço de LLM para enriquecimento de cartões, normalizando a saída e persistindo os dados de forma coerente com o modelo de SRS proposto. A arquitetura modular, com separação entre modelos, serializers, views e serviços, facilita a evolução futura do projeto e a eventual troca de provedores de IA, mantendo a lógica de negócio isolada. Os diagramas de caso de uso, classes, componentes e sequência apresentados nos anexos reforçam que há um desenho consistente entre os requisitos elicitados e a solução implementada.

Mesmo em estágio de Produto Mínimo Viável (MVP - Minimum Viable Product), os resultados alcançados são significativos. Já é possível:
- Criar _flashcards_ em inglês a partir de uma palavra ou expressão simples e obter, de forma automática, traduções, significados e exemplos contextualizados.
- Registrar e acompanhar revisões usando um mecanismo básico de repetição espaçada, preservando os principais parâmetros do algoritmo.
- Interagir com um módulo de conversação com IA, que abre caminho para modos mais elaborados de prática (imersão, correção e abordagem bilíngue).

Do ponto de vista pedagógico e social, o sistema reduz a fricção na criação de material de estudo personalizado para interação de estudo diária e demonstra potencial para apoiar aprendizes em contextos com recursos limitados ou que necessitem de uma ferramenta para a prática diária. Ao permitir que o próprio estudante gere e enriqueça seus insumos de estudo, o projeto aproxima práticas de autoaprendizagem da tecnologia de IA generativa, ainda pouco acessível em muitas realidades educacionais.

Por outro lado, as limitações mapeadas ao longo do trabalho são relevantes: ausência de autenticação e de um modelo de usuário, dependência forte de conectividade e de um único provedor de IA, além da falta de suporte offline. Esses pontos explicam porque o sistema deve ser entendido como um protótipo funcional e não como um produto pronto para uso em larga escala.

Os **próximos passos** propostos — como a introdução de modos de conversação específicos, listas de frequência, suporte a múltiplos idiomas, reconhecimento de fala e eventual fine‑tuning de modelos — indicam um caminho claro de evolução, tanto do ponto de vista técnico quanto pedagógico.

Em síntese, o repositório comprova a **viabilidade técnica** das três peças centrais planejadas — enriquecimento automático, revisão espaçada e conversação básica — e entrega um alicerce consistente para trabalhos futuros. Ainda que existam lacunas importantes a serem preenchidas antes de um uso em produção, o projeto cumpre o objetivo de demonstrar, de forma integrada, como o uso LLM e APIs web podem ser combinadas para apoiar o aprendizado de idiomas, abrindo espaço para novas pesquisas e evoluções em contextos educacionais reais.