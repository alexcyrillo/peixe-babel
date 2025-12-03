---
hide:
  - nav
  - toc
---

# Introdução

## Contexto

O aprendizado de idiomas é um processo complexo e prolongado que envolve não apenas a memorização de vocabulário, mas também a capacidade de utilizar esse conhecimento de forma espontânea em situações reais de comunicação. Estudantes frequentemente enfrentam dois desafios principais: (i) a criação e manutenção de material de estudo eficiente e (ii) a prática de conversação em um ambiente seguro e adaptado ao seu nível de proficiência.

A literatura sobre aquisição de línguas distingue entre conhecimento passivo (reconhecimento de palavras ao ler ou ouvir) e conhecimento ativo (uso espontâneo em conversação). A transição entre esses dois estados é um dos principais gargalos no processo de aprendizado, frequentemente resultando em frustração e abandono.

Inspirado pelo conceito do "Peixe Babel" de Douglas Adams — um tradutor universal fictício que elimina barreiras linguísticas —, este projeto propõe uma solução tecnológica que auxilia estudantes a superarem essas dificuldades através da automação e personalização.

## Problema

Os estudantes de idiomas enfrentam diversos obstáculos que, quando não endereçados de forma sistemática, reduzem a motivação e atrasam a consolidação do aprendizado. Esses desafios podem ser agrupados em quatro dimensões principais: (i) produção e curadoria de material (criação de flashcards ricos, organizados e atualizados), (ii) prática comunicativa segura e frequente (oportunidade de errar sem julgamento e receber feedback imediato), (iii) conversão de vocabulário passivo em uso ativo (transferência para contextos espontâneos), e (iv) gestão cognitiva do esforço (manter regularidade, evitar sobrecarga e distribuir revisões no tempo). As seções seguintes detalham cada uma dessas frentes e seu impacto direto na jornada do estudante.

Além disso, há fatores como ansiedade linguística, dispersão de ferramentas (múltiplos aplicativos desconectados) e dificuldade em medir progresso real além de contagens de palavras. Tais barreiras explicam a alta taxa de abandono após os estágios iniciais de entusiasmo. Ao compreender esses obstáculos, é possível propor uma solução integrada que automatize o trabalho manual, personalize a prática e meça a evolução de forma significativa.

**Criação manual de flashcards**: É um processo demorado que consome tempo valioso que poderia ser dedicado ao estudo propriamente dito. Além disso, flashcards simples (palavra → tradução) são limitados e não fornecem contexto suficiente.

**Falta de prática conversacional**: A prática de conversação é frequentemente limitada por:

  - Falta de parceiros disponíveis
  - Medo de julgamento e vergonha de errar
  - Dificuldade em encontrar interlocutores no nível adequado
  - Custo elevado de aulas particulares

**Desconexão entre memorização e uso**: Estudantes acumulam vocabulário passivo (palavras que reconhecem) mas têm dificuldade em ativá-lo durante conversação real, criando uma lacuna entre "saber" e "usar".

## Objetivo Geral

Desenvolver um aplicativo móvel que automatize a criação de material de estudo (flashcards) e ofereça sessões de conversação com agentes de Inteligência Artificial adaptadas ao vocabulário individual do usuário, facilitando a transição de conhecimento passivo para habilidade ativa.

## Objetivos Específicos

<ol class="objetivos-especificos">
<li><p><strong>Implementar um motor de enriquecimento automático de flashcards</strong> que gere: definições precisas, frases de exemplo contextualizadas, tradução para o idioma nativo e áudio de pronúncia de alta qualidade.</p></li>
<li><p><strong>Desenvolver um Sistema de Repetição Espaçada (SRS)</strong>, baseado em algoritmos consolidados (SM-2 ou variantes), para otimizar a retenção de vocabulário na memória de longo prazo.</p></li>
<li><p><strong>Integrar um módulo de conversação com modelos de linguagem de grande escala (LLM)</strong> que acesse o banco de dados de flashcards do usuário, construa diálogos utilizando preferencialmente o vocabulário estudado e forneça feedback contextual incentivando o uso ativo das palavras.</p></li>
<li><p><strong>Validar a solução</strong> por meio de testes de usabilidade com usuários reais, métricas de performance (latência, taxa de sucesso de enriquecimento) e avaliação comparativa com métodos tradicionais de estudo.</p></li>
</ol>

## Sistema de Repetição Espaçada

O Sistema de Repetição Espaçada (SRS, do inglês *Spaced Repetition System*) é uma técnica de estudo que distribui as revisões de um mesmo conteúdo ao longo do tempo, em intervalos crescentes. Em vez de repetir uma palavra várias vezes em sequência, o estudante volta a encontrá-la em momentos estrategicamente espaçados, pouco antes de esquecê-la. Essa abordagem se apoia em evidências clássicas da psicologia da memória, como a curva de esquecimento descrita por Ebbinghaus (1885), e em estudos posteriores que demonstram o efeito positivo da prática distribuída na retenção de longo prazo (CEPEDA et al., 2006).

Em termos práticos, um algoritmo de SRS registra o desempenho do usuário em cada revisão (por exemplo, se um item foi considerado “fácil” ou “difícil”) e ajusta automaticamente o intervalo até a próxima exposição daquele _flashcard_. Quando o usuário acerta com segurança, o intervalo aumenta; quando erra ou demonstra dificuldade, o item retorna mais cedo. Karpicke e Roediger (2008) destacam que a recuperação ativa — o esforço de lembrar antes de ver a resposta — é um fator crítico para consolidar o aprendizado, e a repetição espaçada organiza essas oportunidades de recuperação ao longo do tempo.

No contexto deste trabalho, o SRS é utilizado para que o vocabulário estudado com _flashcards_ permaneça acessível na memória de longo prazo, reduzindo esquecimento e preparando terreno para o uso ativo em conversação. A união entre revisão espaçada e prática dialogada permite que palavras inicialmente “passivas” passem a ser recuperadas de forma espontânea em interações com modelos de linguagem de grande escala (LLM), encurtando a distância entre “reconhecer” e “usar” o vocabulário em um idioma não nativo.

## Justificativa

O projeto se justifica por três razões centrais: (1) cresce a demanda por ferramentas de estudo personalizadas (OECD, 2021; Pane et al., 2015); (2) as tecnologias atuais de IA (LLMs), processamento de linguagem natural (NLP - Natural Language Processing) e síntese de texto em voz (TTS - Text-to-Speech) já permitem gerar conteúdo contextual em tempo real (Brown et al., 2020; OpenAI, 2024); (3) há evidências de que a repetição espaçada combinada com prática e recuperação ativa melhora retenção e velocidade de acesso ao vocabulário (Cepeda et al., 2006; Karpicke & Roediger, 2008; Uchihara et al., 2019). A solução proposta enfrenta lacunas dos métodos tradicionais: criação manual lenta, separação entre revisão e uso em diálogo e feedback tardio ou genérico. Ela automatiza o enriquecimento dos materiais e ajusta cada sessão de conversa ao vocabulário que o usuário está consolidando. A união entre SRS e conversação adaptativa acelera a passagem de conhecimento passivo para ativo e tende a elevar indicadores como recall em T+1, T+7 e T+30 e tempo de resposta correto. Assim, a proposta mantém caráter acadêmico e possui aplicação prática imediata.

## Estado Atual e Escopo da Solução

### Escopo

- Aplicativo Flutter (foco em Android; executável também em iOS/Web/Desktop sem otimização dedicada ainda).
- Backend Django + PostgreSQL oferecendo endpoints REST para Flashcards, Revisão (SRS) e Chat (LLM).
- Integração com OpenAI (modelos configuráveis via variável de ambiente `OPENAI_MODEL`).
- Lógica de Spaced Repetition embutida no modelo concreto de card.
- Agregação dinâmica de vocabulário (todas as palavras dos cards) para personalizar instruções ao LLM.
- Infra básica de containerização (docker-compose para API + DB).
- Interface inicial em Português (app) e conteúdo alvo em Inglês.
- Estrutura para expansão de outros tipos de cards através de herança (`BaseCard`).
- Parametrização por variáveis de ambiente (.env / sistema) para chaves e credenciais.

### Capacidades Atuais

- **Chat adaptativo**: respostas em inglês ajustadas ao vocabulário conhecido do usuário.
- **CRUD de Flashcards**: criação, listagem, atualização e exclusão com campos textuais e exemplos JSON.
- **Revisão espaçada**: cálculo e armazenamento dos parâmetros básicos (intervalos, próxima revisão).
- **Instruções dinâmicas ao LLM**: inclui vocabulário do aluno e requer tradução de termos novos.
- **API REST simples**: roteamento DRF separado para flashcards, revisão e chat.
- **Execução multi-plataforma (Flutter)**: um único código para diversas plataformas (não todas testadas).
- **Autenticação base Django disponível**: para futura extensão de escopo multiusuário.

### Limitações Explícitas

- Sem currículo estruturado, trilha de lições ou níveis progressivos.
- Sem tutores humanos / moderação pedagógica.
- Impossibilidade de uso Offline.
- Interface multilíngue restrita (PT-BR UI + EN conteúdo). Sem suporte amplo a outros idiomas.
- Sem controle de quotas/custos de uso da API OpenAI.
- Algoritmo SRS simplificado (sem ajustes finos por desempenho qualitativo do usuário).
- Ausência de relatórios analíticos de progresso ou retenção.
- Sem cache ou otimização de chamadas ao LLM.
- Sem escalabilidade horizontal.

### Limitações Implícitas / Riscos

- Dependência de latência e disponibilidade da OpenAI (single provider).
- Potencial custo crescente conforme volume de conversas (sem caching ou compressão).
- Risco de prompt injection ou abuso (validação de entrada mínima).

### Fora do Escopo

- Gamificação (pontos, conquistas, rankings).
- Suporte a múltiplos idiomas-alvo além de inglês (planejado, não implementado).
- Editor multimídia avançado (áudio, imagem customizada aos cards).
- Modo totalmente offline incluindo chat local ou LLM embarcado.
- Análise de voz (speech-to-text, avaliação de pronúncia).
- Exercícios gramaticais complexos, cloze, múltipla escolha ou produção guiada.
- Analytics avançados (dashboards, relatórios exportáveis completos).

### Oportunidades de Evolução

A Tabela 1 apresenta um resumo das principais oportunidades de evolução identificadas para o sistema, relacionando cada área de melhoria com o benefício esperado para o projeto e seus usuários.

**Tabela 1 – Oportunidades de Evolução**

| Área | Possível Evolução | Benefício |
|------|-------------------|-----------|
| Autenticação | Filtrar vocabulário por usuário, JWT/Token | Conteúdo personalizado real |
| SRS | Tabela separada `ReviewSchedule`, múltiplos algoritmos | Experimentação adaptativa |
| Caching | Cache de instruções e respostas comuns | Redução de custo & latência |
| Observabilidade | Logging estruturado + métricas | Monitoramento confiável |
| Segurança | Restrição de CORS, segredos fora do código, rate limiting | Produção segura |
| Multi-idioma | Novos idiomas alvo (ES, JP) | Escala de público |
| Testes | Cobertura para endpoints críticos | Confiabilidade de release |
| Prompt Engine | Templates versionados, anti-injection | Qualidade e robustez no chat |
| Analytics | Métricas de revisão, dificuldade, retenção | Feedback pedagógico |
| UI/UX | Ajustes específicos para web/desktop | Adoção em múltiplos dispositivos |

<p class="footnote">Fonte: Elaborado pelo autor (2025).</p>

### Resumo

O sistema entrega um núcleo funcional de aprendizado de vocabulário com chat adaptativo e revisão espaçada mínima, priorizando simplicidade e velocidade de iteração. Limitações atuais concentram-se em segurança de produção, personalização por usuário, profundidade pedagógica e escalabilidade. O roadmap natural inclui modularização do SRS, robustecimento de segurança, filtros de vocabulário por usuário, expansão de idiomas e introdução de métricas de aprendizagem.