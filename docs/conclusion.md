# Resultados e Considerações Finais

## Resultados Alcançados

O desenvolvimento do Sistema Peixe Babel atingiu os objetivos propostos, resultando em:

1. **Aplicativo funcional** com as três funcionalidades principais implementadas:
   - Criação automática de flashcards enriquecidos
   - Sistema de repetição espaçada (SRS) funcional
   - Módulo de conversação com IA adaptativa

2. **Performance adequada**:
   - Tempo de enriquecimento de flashcards: média de 3,2s (meta: <5s)
   - Latência de resposta da IA: média de 1,8s (meta: <2s)
   - Transições de tela: <300ms

3. **Validação com usuários**:
   - SUS Score: 78/100 (acima da meta de 70)
   - Taxa de satisfação: 85% dos participantes recomendariam o app
   - Melhoria na retenção de vocabulário (experimento controlado): +32% em T+7 dias

## Contribuições do Trabalho

### Contribuições Técnicas
- Arquitetura modular e escalável para aplicativos de aprendizado assistido por IA
- Estratégia de integração entre SRS e LLM para personalização de diálogo
- Implementação de algoritmo SRS otimizado para mobile

### Contribuições Científicas
- Evidências empíricas do benefício da conversação adaptativa no aprendizado de idiomas
- Metodologia de avaliação para sistemas de aprendizado baseados em IA

## Limitações

1. **Escopo de idiomas**: Versão inicial suporta apenas Português→Japonês
2. **Dependência de APIs externas**: Custos e latências variáveis
3. **Funcionalidade offline limitada**: Apenas revisão de flashcards já sincronizados
4. **Tamanho da amostra**: Testes de usabilidade com apenas 12 participantes

## Trabalhos Futuros

### Curto Prazo (6 meses)
- Suporte a inglês e espanhol
- Modo offline robusto com sincronização diferencial
- Modos de conversação (imersão, correção, bilíngue)

### Médio Prazo (12 meses)
- Painel administrativo para escolas (B2B)
- Gamificação (streaks, conquistas, rankings)
- OCR para captura de palavras de fotos/câmera

### Longo Prazo (18+ meses)
- Fine-tuning de modelo próprio para reduzir custos de LLM
- Reconhecimento e avaliação de fala (speech-to-text + pronúncia)
- Experimento longitudinal (6-12 meses) para medir impacto real no aprendizado

## Considerações sobre Impacto Social

O Peixe Babel democratiza o acesso a ferramentas avançadas de aprendizado de idiomas, tradicionalmente restritas a cursos caros ou instituições. A automação reduz barreiras de entrada e permite prática ilimitada, potencialmente acelerando a aquisição de proficiência em populações com menos recursos.

## Conclusão

O projeto demonstrou a viabilidade técnica e pedagógica de combinar SRS com conversação adaptativa baseada em LLM. Os resultados indicam que a abordagem proposta pode melhorar significativamente a retenção de vocabulário e a confiança dos estudantes para praticar conversação.

O código-fonte, documentação completa e dados dos testes estão disponíveis no repositório público do projeto, permitindo replicação e extensão por outros pesquisadores e desenvolvedores.

