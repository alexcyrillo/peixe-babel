# Referências e Anexos Técnicos

## Referências Bibliográficas

### Aprendizado de Idiomas e SRS

1. **Ebbinghaus, H.** (1885). *Memory: A Contribution to Experimental Psychology*. Teachers College, Columbia University.

2. **Wozniak, P. A., & Gorzelańczyk, E. J.** (1994). Optimization of repetition spacing in the practice of learning. *Acta Neurobiologiae Experimentalis*, 54, 59-62.

3. **Karpicke, J. D., & Roediger, H. L.** (2008). The critical importance of retrieval for learning. *Science*, 319(5865), 966-968.

4. **Cepeda, N. J., Pashler, H., Vul, E., Wixted, J. T., & Rohrer, D.** (2006). Distributed practice in verbal recall tasks: A review and quantitative synthesis. *Psychological Bulletin*, 132(3), 354–380.

5. **Uchihara, T., Saito, K., & Keung, Y. C.** (2019). Roles of repetition in second language oral fluency development. *Language Learning*, 69(3), 652–688.

6. **Pane, J. F., Steiner, E. D., Baird, M. D., & Hamilton, L. S.** (2015). Promoting Grit, Tenacity, and Perseverance. *RAND Corporation Report*.

7.  **OECD** (2021). *Digital Education Outlook 2021: Digital Transformation in Education*. OECD Publishing.

8.  **Nation, I. S. P.** (2001). *Learning Vocabulary in Another Language*. Cambridge University Press.

### Processamento de Linguagem Natural e LLMs

8. **Vaswani, A., et al.** (2017). Attention is All You Need. *Advances in Neural Information Processing Systems*, 30.

9. **Brown, T. B., et al.** (2020). Language Models are Few-Shot Learners. *Advances in Neural Information Processing Systems*, 33.

10. **OpenAI** (2024). GPT-4 Technical Report. Disponível em: https://openai.com/research/gpt-4

11. **Wei, J., et al.** (2022). Chain-of-Thought Prompting Elicits Reasoning in Large Language Models. *arXiv preprint arXiv:2201.11903*.

### Engenharia de Software e Arquitetura

8. **Martin, R. C.** (2017). *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Prentice Hall.

9. **Fowler, M.** (2002). *Patterns of Enterprise Application Architecture*. Addison-Wesley.


### Documentação de APIs e Tecnologias

13. **Django Documentation** (2024). Django REST Framework. Disponível em: https://www.django-rest-framework.org/

14. **Flutter Documentation** (2024). Flutter - Build apps for any screen. Disponível em: https://flutter.dev/docs

10. **OpenAI** (2024). GPT-4 Technical Report. Disponível em: https://openai.com/research/gpt-4

11. **alankan886**. SuperMemo2 (v3.0.1). GitHub repository. Disponível em: https://github.com/alankan886/SuperMemo2. Acesso em: 13 nov. 2025.

### Anexo A — Documento de Visão Completo
Ver arquivo: `docs/documento_de_visao.md`

### Anexo B — Diagrama de Contexto
Ver arquivo: `docs/diagrama_de_contexto.md`

### Anexo C — Especificação de API
Acessar API: `http://{HOST_DA_API}:8000/api/v1/`

### Anexo D — Código-Fonte
Repositório GitHub: `https://github.com/alexcyrillo/peixe-babel`

**Estrutura do repositório**:
```
peixe-babel/
├── README.md
├── .gitignore
├── backend/
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── .env.example
│   ├── db_init/
│   │   └── init.sql
│   ├── scripts/
│   │   └── wait-for-postgres.sh
│   └── src/
│       ├── peixe_babel/
│       │   ├── __init__.py
│       │   ├── asgi.py
│       │   ├── settings.py
│       │   ├── urls.py
│       │   └── wsgi.py
│       └── flashcard/
│           ├── __init__.py
│           ├── admin.py
│           ├── apps.py
│           ├── urls.py
│           ├── tests.py
│           ├── models/
│           │   ├── base_card.py
│           │   ├── english_card.py
│           │   └── chat_message.py
│           ├── serializers/
│           │   ├── english_card_serializers.py
│           │   ├── english_chat_serializer.py
│           │   ├── review_serializer.py
│           │   └── utils.py
│           ├── services/
│           │   ├── chat_open_api.py
│           │   ├── english_field_generator.py
│           │   └── vocabulary_getter.py
│           └── views/
│               ├── english_ai_chat_view_set.py
│               ├── english_card_review_view_set.py
│               └── english_card_view_set.py
├── docs/
│   ├── diagrama_de_contexto.md
│   ├── documento_de_visao.md
│   └── img/
└── frontend/
    ├── README.md
    ├── .gitignore
    ├── .metadata
    ├── analysis_options.yaml
    ├── pubspec.yaml
    ├── pubspec.lock
    ├── android/
    ├── ios/
    ├── web/
    ├── linux/
    ├── macos/
    ├── windows/
    ├── assets/
    │   └── images/
    └── lib/
        ├── main.dart
        ├── pages/
        │   ├── conversation_page.dart
        │   ├── main_flashcard_page.dart
        │   ├── main_page.dart
        │   └── flashcard/
        │       ├── create_flashcard_page.dart
        │       ├── flashcard_card_page.dart
        │       ├── list_flashcard_page.dart
        │       └── review_flashcard_page.dart
        ├── services/
        │   └── api/
        │       ├── api_provider.dart
        │       ├── chat_api.dart
        │       └── flashcard_api.dart
        ├── src/
        ├── theme/
        └── widgets/
```

### Anexo E — Diagramas UML Detalhados

#### **E.1 — Diagrama de Contexto**

![Diagrama de Contexto do Sistema e atores externos](img/diagrama_contexto.png)

#### **E.2 — Diagrama de Casos de Uso**

![Diagrama de Casos de Uso: criar, revisar, conversar, sincronizar, editar](img/diagrama_casos_uso.png)

#### **E.3 — Diagrama de Classes**

![Diagrama de Classes: entidades de flashcard, mensagem de chat e relações](img/diagrama_classes.png)

#### **E.4 — Diagramas de Sequência**

##### E.4.1 — Criação de Flashcard
  
![Diagrama de Sequência: fluxo de criação e enriquecimento de flashcard](img/diagrama_seq_criar_flashcard.png)

#####  E.4.2 — Revisão de Flashcard (SRS)
  
![Diagrama de Sequência: fluxo de revisão SRS e atualização de intervalo](img/diagrama_seq_revisao.png)

##### E.4.3 — Conversação com IA
  
![Diagrama de Sequência: diálogo com IA adaptado ao vocabulário do usuário](img/diagrama_seq_chat.png)

#### **E.5 — Diagrama de Estados**

![Diagrama de Estados: transições do flashcard no SRS](img/diagrama_estados_flashcard.png)

#### **E.6 — Diagrama de Componentes**

![Diagrama de Componentes: app Flutter, API Django, PostgreSQL e integrações](img/diagrama_componentes.png)


### Anexo F — Exemplos de Prompts para LLM

#### F.1 — Prompt de Conversa 

```text
Você é um robô que conversa em Inglês, que se adapta ao vocabulário do estudante. O vocabulário que o seu aluno sabe é: <LISTA_DE_PALAVRAS>Se não for possível responder apenas com o vocabulário do aluno, pode utilizar outras, porém disponibilize a tradução dessas novas palavras utilizadas
```
Notas:
- `<LISTA_DE_PALAVRAS>` é construída a partir das palavras (`word`) dos flashcards cadastrados.


#### F.2 — Prompts de Geração de Campos de Flashcard 

```text
Você ajuda estudantes brasileiros de inglês criando cartões de estudo. Entregue traduções e significados em português do Brasil. Quando gerar exemplos, mantenha as frases em inglês, inclua a tradução em português e garanta que são curtas e naturais. Retorne apenas JSON válido que siga o formato solicitado.
```

##### User Prompt
```text
Gere o conteúdo de um flashcard para a palavra em inglês informada.
Palavra: <WORD>
Retorne um JSON com as chaves:
- translation: tradução da palavra para português do Brasil (string).
- meaning: explicação breve do significado em português do Brasil (string).
- examples: lista com 2 a 3 objetos contendo:
    - sentence: frase curta em inglês usando a palavra.
    - translation: tradução da frase para português do Brasil.
Responda exclusivamente com o JSON solicitado, sem texto adicional.
```

#### F.3 — Referências de Código
- Conversa: função `get_chat_response()`.
- Vocabulário dinâmico: função `get_vocabulary()`.
- Geração de campos: função `english_fields_generator()`.

### Anexo G — Configurações e Variáveis de Ambiente

#### **G.1 — `.env.example` (Backend)**

```bash
COMPOSE_PROJECT_NAME=peixe-babel
POSTGRES_DB_NAME=peixe_babel_db
POSTGRES_USER=peixe_babel_user
POSTGRES_PASSWORD=troque-esta-senha
OPENAI_API_KEY=key-api-open-api
```

### Anexo H — Licença e Termos de Uso

**Licença**: MIT License (código aberto)

**Política de Privacidade**: Resumo
- Dados coletados: email, flashcards, histórico de revisões, sessões de conversação
- Uso: exclusivamente para funcionalidade do aplicativo
- Compartilhamento: apenas com APIs necessárias (anonimizado quando possível)
- Retenção: dados mantidos enquanto conta ativa; exclusão sob demanda
- Conformidade: LGPD (Brasil)

---

## Glossário

- **Flashcard**: Cartão de estudo com frente (palavra) e verso (definição, exemplos)
- **SRS (Spaced Repetition System)**: Sistema de repetição espaçada que otimiza intervalos de revisão
- **LLM (Large Language Model)**: Modelo de linguagem de grande escala (ex.: GPT-4)
- **TTS (Text-to-Speech)**: Síntese de voz a partir de texto
- **API (Application Programming Interface)**: Interface para integração entre sistemas
- **REST**: Estilo arquitetural para APIs web baseado em HTTP
- **JWT (JSON Web Token)**: Formato de token para autenticação stateless
- **Clean Architecture**: Padrão arquitetural que prioriza separação de responsabilidades
- **SM-2 (SuperMemo 2)**: Algoritmo clássico de repetição espaçada
