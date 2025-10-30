# Requisitos Funcionais e Não Funcionais

Este capítulo apresenta a especificação detalhada dos requisitos do sistema, baseada no Documento de Visão do projeto. Os requisitos estão organizados em funcionais (o que o sistema faz) e não funcionais (atributos de qualidade).

## Requisitos Funcionais

### Criação de Flashcards Inteligente

**Descrição**: O sistema deve permitir que o usuário insira uma palavra ou frase no idioma-alvo e automaticamente enriquecer essa entrada com informações complementares.

**Entradas**: Palavra ou frase no idioma-alvo (texto).

**Processamento**:

- Consultar APIs de dicionário para obter definições precisas
- Gerar frases de exemplo contextualizadas usando LLM
- Obter tradução para o idioma nativo do usuário
- Gerar áudio de pronúncia via API TTS

**Saídas**: Flashcard completo com todos os campos preenchidos, persistido no banco de dados e agendado no SRS.

**Critérios de Aceitação**:

- O processo deve ser concluído em menos de 5 segundos (90% dos casos)
- Definições devem ser apropriadas ao contexto
- Frases de exemplo devem ser gramaticalmente corretas

### Sistema de Repetição Espaçada (SRS)

**Descrição**: O sistema deve implementar um algoritmo SRS para apresentar flashcards ao usuário no momento ideal de revisão.

**Funcionalidades**:

- Calcular o próximo intervalo de revisão baseado na resposta do usuário (fácil/difícil)
- Apresentar apenas os flashcards devidos no dia
- Manter histórico de revisões e taxas de acerto

**Critérios de Aceitação**:

- Algoritmo deve seguir princípios do SM-2 ou equivalente
- Usuário deve poder revisar flashcards offline (dados sincronizados previamente)

### Prática de Conversação com IA Adaptativa

**Descrição**: O sistema deve permitir sessões de conversação com agente de IA que utiliza o vocabulário do banco de dados do usuário.

**Fluxo**:

1. Usuário inicia sessão de conversação
2. Sistema recupera vocabulário ativo (flashcards estudados recentemente)
3. Sistema constrói prompt para LLM com instruções e vocabulário permitido
4. Usuário e IA trocam mensagens em tempo real
5. Sistema registra histórico da conversa

**Critérios de Aceitação**:

- Respostas da IA devem chegar em menos de 2 segundos
- IA deve priorizar uso do vocabulário do usuário
- Sistema deve prevenir uso de linguagem inapropriada

### Gerenciamento de Flashcards

**Descrição**: O usuário deve poder visualizar, editar e excluir flashcards criados.

**Funcionalidades**:

- Listar todos os flashcards do usuário
- Editar campos de um flashcard existente
- Excluir flashcard (com confirmação)
- Pesquisar flashcards por palavra ou tradução

### Sincronização de Dados

**Descrição**: O sistema deve sincronizar o progresso do usuário (flashcards, histórico de revisões, sessões de conversação) entre dispositivos.

**Funcionalidades**:

- Sincronização automática ao abrir o app (se conectado)
- Sincronização manual sob demanda
- Resolução de conflitos (última modificação vence)

## Requisitos Não Funcionais

### Usabilidade e Experiência do Usuário

**Descrição**: O aplicativo deve ser intuitivo e agradável de usar.

**Critérios**:

- Interface deve seguir guidelines do Material Design (Android)
- Fluxo principal (adicionar palavra → revisar → conversar) deve ser evidente
- Ações-chave devem exigir no máximo 3 toques
- Sistema deve fornecer feedback visual imediato para todas as ações

**Métrica**: SUS (System Usability Scale) score acima de 70 em testes com usuários.

### Desempenho e Responsividade

**Descrição**: O sistema deve responder rapidamente para manter o usuário engajado.

**Critérios**:

- Respostas da IA durante conversação: < 2 segundos (P95)
- Criação de flashcard (enriquecimento): < 5 segundos (P90)
- Transição entre telas: < 300ms
- Sincronização de dados: < 10 segundos para até 1000 flashcards

**Métrica**: Latências medidas via APM (Application Performance Monitoring).

### Disponibilidade e Confiabilidade

**Descrição**: O sistema deve estar disponível quando o usuário precisar estudar.

**Critérios**:

- Uptime do backend: 99.5% (permitido ~3.6h de downtime/mês)
- Revisão de flashcards deve funcionar offline (dados já sincronizados)
- Sistema deve lidar graciosamente com falhas de APIs externas (fallback, retry)

**Métrica**: Monitoramento de uptime via health checks e alertas.

### Segurança e Privacidade

**Descrição**: Dados do usuário devem ser protegidos e tratados conforme LGPD.

**Critérios**:

- Comunicação via HTTPS (TLS 1.2+)
- Autenticação via JWT com refresh tokens
- Senhas armazenadas com hash bcrypt (ou argon2)
- Dados pessoais criptografados em repouso
- Política de privacidade clara e termo de consentimento

**Métrica**: Auditoria de segurança e conformidade com checklist LGPD.

### Escalabilidade

**Descrição**: A arquitetura deve suportar crescimento da base de usuários.

**Critérios**:

- Backend deve escalar horizontalmente (adicionar instâncias)
- Banco de dados deve suportar particionamento por usuário
- Sistema de filas para processamento assíncrono de enriquecimento

**Métrica**: Testes de carga simulando 10x a base inicial de usuários.

### Compatibilidade

**Descrição**: O aplicativo deve rodar nas versões mais comuns dos dispositivos-alvo.

**Critérios**:

- Android: versões 10, 11, 12, 13 (APIs 29-33)
- Resolução: suportar de 4" a 7" (smartphones e tablets pequenos)
- Acessibilidade: suporte a TalkBack e tamanhos de fonte ajustáveis

### Manutenibilidade e Extensibilidade

**Descrição**: O código deve ser modular e documentado para facilitar manutenção e evolução.

**Critérios**:

- Arquitetura limpa com separação de camadas (apresentação, domínio, dados)
- Cobertura de testes: mínimo 70% para lógica de negócio
- Documentação de APIs (OpenAPI/Swagger)
- Internacionalização: adicionar novos idiomas deve exigir apenas arquivos de tradução

**Métrica**: Code review e análise estática (lint, type checking).

## Restrições e Dependências

### Restrições

- Orçamento limitado para APIs externas (preferência por free tiers ou planos básicos)
- Prazo de desenvolvimento: 20 semanas (conforme cronograma do TCC)
- Equipe: 1 desenvolvedor (autor do TCC)

### Dependências Externas

- APIs de dicionário (ex.: Dictionary API, Merriam-Webster)
- API de TTS (ex.: Google Cloud TTS, Amazon Polly)
- API de LLM (ex.: OpenAI GPT-4, Anthropic Claude)
- Infraestrutura de nuvem (ex.: Railway, Render, AWS free tier)

## Casos de Uso Principais

### Criar Flashcard

**Ator**: Usuário  
**Fluxo Principal**:
1. Usuário abre tela de criação
2. Usuário insere palavra/frase no idioma-alvo
3. Sistema enriquece automaticamente (definição, exemplos, áudio, tradução)
4. Sistema salva flashcard e agenda primeira revisão
5. Sistema exibe confirmação

**Fluxo Alternativo**: Se API falhar, sistema permite criação manual dos campos.

### Revisar Flashcards

**Ator**: Usuário  
**Fluxo Principal**:
1. Usuário abre tela de revisão
2. Sistema apresenta flashcards devidos (frente)
3. Usuário tenta lembrar a resposta
4. Usuário revela resposta (verso)
5. Usuário avalia dificuldade (fácil/difícil)
6. Sistema ajusta próxima data de revisão
7. Repetir 2-6 até não haver mais flashcards devidos

### Praticar Conversação

**Ator**: Usuário  
**Fluxo Principal**:
1. Usuário inicia sessão de conversação
2. Sistema carrega vocabulário ativo do usuário
3. IA inicia conversa com saudação
4. Usuário responde via texto
5. IA responde usando vocabulário do usuário
6. Repetir 4-5 até usuário encerrar sessão
7. Sistema salva histórico da conversa

**Fluxo Alternativo**: Se usuário ficar sem resposta, IA pode fornecer sugestões.

---

**Nota**: Esta especificação de requisitos serve como base para as fases de modelagem e implementação descritas nos próximos capítulos.
