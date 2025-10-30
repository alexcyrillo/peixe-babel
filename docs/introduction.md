# 1. Introdução e Objetivos do Projeto

## 1.1 Contexto

O aprendizado de idiomas é um processo complexo e prolongado que envolve não apenas a memorização de vocabulário, mas também a capacidade de utilizar esse conhecimento de forma espontânea em situações reais de comunicação. Estudantes frequentemente enfrentam dois desafios principais: (i) a criação e manutenção de material de estudo eficiente e (ii) a prática de conversação em um ambiente seguro e adaptado ao seu nível de proficiência.

A literatura sobre aquisição de línguas distingue entre conhecimento passivo (reconhecimento de palavras ao ler ou ouvir) e conhecimento ativo (uso espontâneo em conversação). A transição entre esses dois estados é um dos principais gargalos no processo de aprendizado, frequentemente resultando em frustração e abandono.

Inspirado pelo conceito do "Peixe Babel" de Douglas Adams — um tradutor universal fictício que elimina barreiras linguísticas —, este projeto propõe uma solução tecnológica que auxilia estudantes a superarem essas dificuldades através da automação e personalização.

## 1.2 Problema

Os estudantes de idiomas enfrentam diversos obstáculos:

- **Criação manual de flashcards**: É um processo demorado que consome tempo valioso que poderia ser dedicado ao estudo propriamente dito. Além disso, flashcards simples (palavra → tradução) são limitados e não fornecem contexto suficiente.

- **Falta de prática conversacional**: A prática de conversação é frequentemente limitada por:
  - Falta de parceiros disponíveis
  - Medo de julgamento e vergonha de errar
  - Dificuldade em encontrar interlocutores no nível adequado
  - Custo elevado de aulas particulares

- **Desconexão entre memorização e uso**: Estudantes acumulam vocabulário passivo (palavras que reconhecem) mas têm dificuldade em ativá-lo durante conversação real, criando uma lacuna entre "saber" e "usar".

## 1.3 Objetivo Geral

Desenvolver um aplicativo móvel que automatize a criação de material de estudo (flashcards enriquecidos) e ofereça sessões de conversação com agentes de Inteligência Artificial adaptadas ao vocabulário individual do usuário, facilitando a transição de conhecimento passivo para habilidade ativa.

## 1.4 Objetivos Específicos

1. **Implementar um motor de enriquecimento automático de flashcards** que, a partir de uma palavra ou frase fornecida pelo usuário, gere automaticamente:
   - Definições precisas
   - Frases de exemplo contextualizadas
   - Tradução para o idioma nativo
   - Áudio de pronúncia de alta qualidade

2. **Desenvolver um sistema de repetição espaçada (SRS)** baseado em algoritmos consolidados (SM-2 ou variantes) para otimizar a retenção de vocabulário na memória de longo prazo.

3. **Integrar um módulo de conversação com LLM** que:
   - Acesse o banco de dados de flashcards do usuário
   - Construa diálogos utilizando preferencialmente o vocabulário que o usuário está estudando
   - Forneça feedback contextual e incentive o uso ativo das palavras memorizadas

4. **Validar a solução** através de:
   - Testes de usabilidade com usuários reais
   - Métricas de performance (latência, taxa de sucesso de enriquecimento)
   - Avaliação comparativa com métodos tradicionais de estudo

## 1.5 Justificativa

O projeto se justifica pela demanda crescente por ferramentas de aprendizado personalizadas e pela oportunidade de aplicar tecnologias emergentes (LLMs, APIs de NLP, TTS) para resolver problemas reais na educação. A combinação de SRS com conversação adaptativa representa uma abordagem inovadora que pode acelerar significativamente o processo de aquisição de proficiência em idiomas.

## 1.6 Escopo

O projeto abrange:
- Aplicativo móvel nativo para Android
- Backend REST API para orquestração de serviços
- Integração com APIs externas (dicionários, TTS, LLM)
- Suporte inicial para português (interface) e japonês (idioma-alvo)

Limitações explícitas:
- Não fornece currículo estruturado ou lições predefinidas
- Não inclui interação com tutores humanos
- Funcionalidade offline limitada (apenas revisão de flashcards já sincronizados)