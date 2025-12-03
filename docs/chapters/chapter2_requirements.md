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

### Prática de Conversação com IA Adaptativa

**Descrição**: O sistema deve permitir sessões de conversação com agente de IA que utiliza o vocabulário do banco de dados do usuário.

**Fluxo**:

1. Usuário inicia sessão de conversação
2. Sistema recupera vocabulário ativo
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
- Sistema deve tratar falhas de APIs externas com retentativas controladas e fallback sem interromper o uso

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
- Internacionalização: adicionar novos idiomas deve exigir apenas arquivos de tradução

**Métrica**: Code review e análise estática.

## Restrições e Dependências

### Restrições

- Orçamento limitado para APIs externas (preferência por free tiers ou planos básicos)
- Prazo de desenvolvimento: 20 semanas (conforme cronograma do TCC)
- Equipe: 1 desenvolvedor (autor do TCC)

### Dependências Externas

- APIs de dicionário (ex.: Dictionary API, Merriam-Webster)
- API de TTS (ex.: Google Cloud TTS, Amazon Polly)
- API de LLM (ex.: OpenAI GPT, Anthropic Claude)
- Infraestrutura de nuvem (ex.: Railway, Render, AWS free tier)

## Casos de Uso Principais

### Casos de Uso Principais

Os casos de uso a seguir descrevem as interações essenciais do usuário com o sistema. Cada caso de uso é acompanhado pela tarefa de usabilidade correspondente (Tarefa 1–5) que será aplicada nos testes com usuários.

#### UC01 — Criar Flashcard (Tarefa 1)

**Objetivo**: Permitir criação de flashcards enriquecidos automaticamente.

**Ator principal**: Usuário.

**Precondições**: Aplicativo carregado; usuário autenticado (quando autenticação estiver ativa); APIs externas disponíveis ou modo de fallback parcial.

**Gatilho**: Usuário decide registrar novo vocabulário.

**Fluxo Principal**:

1. Usuário abre o aplicativo.
2. Navega até o menu _Flashcards_.
3. Seleciona _Criar Novo Flashcard_.
4. Digita uma ou mais palavras.
5. Aciona _Criar flashcards_.
6. Sistema realiza enriquecimento (definição, exemplos, tradução, áudio) e agenda primeira revisão.
7. Sistema confirma criação.

**Fluxos Alternativos**:

- A1: Falha em API externa → Sistema oferece criação manual dos campos faltantes; ainda agenda revisão inicial.
  
**Pós-condições**: Flashcards persistidos com metadados SRS inicializados.

**Critérios de Sucesso**: Tempo < 5s (P90); dados gerados semanticamente adequados.

#### UC02 — Listar Flashcards (Tarefa 2)

**Objetivo**: Visualizar conjunto de flashcards existentes do usuário.

**Fluxo Principal**:

1. Usuário acessa menu _Flashcards_.
2. Seleciona _Ver Flashcards Existentes_.
3. Sistema exibe lista (paginada ou completa) com dados essenciais.

**Pós-condições**: Lista renderizada sem erros.

**Critérios de Sucesso**: Exibição completa em < 2s; possibilidade de localizar item desejado.

#### UC03 — Editar Flashcard (Tarefa 3)

**Objetivo**: Atualizar conteúdo de um flashcard existente.

**Precondições**: Flashcard existe e pertence ao usuário.

**Fluxo Principal**:

1. Usuário navega para _Flashcards_ > _Ver Flashcards Existentes_.
2. Seleciona o flashcard alvo.
3. Altera campos desejados (ex.: exemplo, tradução).
4. Aciona _Salvar Alterações_.
5. Sistema valida e persiste atualização; mostra feedback.

**Exceção**: E1: Campo inválido → Sistema exibe erro e mantém valores originais.

**Critérios de Sucesso**: Atualização confirmada e refletida na próxima listagem.

#### UC04 — Revisar Flashcards (Tarefa 4)

**Objetivo**: Realizar sessão de repetição espaçada aplicando algoritmo SRS.

**Precondições**: Existir pelo menos um flashcard “devido” na data atual.

**Fluxo Principal**:

1. Usuário abre menu _Flashcards_ e escolhe _Iniciar Revisão_.
2. Sistema apresenta frente (palavra/expressão).
3. Usuário tenta recordar significado/tradução.
4. Usuário revela verso (toque em _Responder_).
5. Usuário avalia dificuldade (fácil/difícil ou escala equivalente).
6. Sistema recalcula intervalo e agenda próxima data.
7. Retorna ao passo 2 até não haver itens devidos.

**Critérios de Sucesso**: Todos itens devidos processados; intervalos atualizados corretamente.

**Métrica Relacionada**: Tempo médio por card; taxa de acerto.

#### UC05 — Praticar Conversação (Tarefa 5)

**Objetivo**: Permitir diálogo em inglês adaptado ao vocabulário conhecido do usuário.

**Precondições**: Conexão ativa; vocabulário carregado.

**Fluxo Principal**:

1. Usuário acessa _Conversar com IA_.
2. Digita primeira frase e envia.
3. Sistema/IA responde utilizando preferencialmente termos do vocabulário do usuário (traduz novos termos quando necessários).
4. Ciclo de troca de mensagens prossegue até o usuário encerrar.
5. Sistema registra histórico.

**Critérios de Sucesso**: Latência de resposta < 2s (P95); proporção de termos conhecidos acima de limiar definido.

#### Relação Tarefas ↔ Casos de Uso

A Tabela 2 estabelece a correspondência entre as tarefas de usabilidade planejadas para os testes com usuários e os casos de uso implementados no sistema, resumindo o objetivo de cada interação.

**Tabela 2 – Lista de Casos de Uso**

| Tarefa | Caso de Uso | Objetivo resumido |
|--------|-------------|-------------------|
| 1 | UC01 Criar Flashcard | Registrar novo vocabulário enriquecido |
| 2 | UC02 Listar Flashcards | Consultar cartões existentes |
| 3 | UC03 Editar Flashcard | Atualizar conteúdo de cartão |
| 4 | UC04 Revisar Flashcards | Aplicar SRS em sessão de revisão |
| 5 | UC05 Praticar Conversação | Dialogar com IA adaptativa |

<p class="footnote">Fonte: Elaborado pelo autor (2025).</p>

---

**Nota**: Esta especificação de requisitos serve como base para as fases de modelagem e implementação descritas nos próximos capítulos.
