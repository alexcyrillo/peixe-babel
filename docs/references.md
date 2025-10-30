# Referências e Anexos Técnicos

## Referências Bibliográficas

### Aprendizado de Idiomas e SRS

1. **Ebbinghaus, H.** (1885). *Memory: A Contribution to Experimental Psychology*. Teachers College, Columbia University.

2. **Wozniak, P. A., & Gorzelańczyk, E. J.** (1994). Optimization of repetition spacing in the practice of learning. *Acta Neurobiologiae Experimentalis*, 54, 59-62.

3. **Karpicke, J. D., & Roediger, H. L.** (2008). The critical importance of retrieval for learning. *Science*, 319(5865), 966-968.

4. **Nation, I. S. P.** (2001). *Learning Vocabulary in Another Language*. Cambridge University Press.

### Processamento de Linguagem Natural e LLMs

5. **Vaswani, A., et al.** (2017). Attention is All You Need. *Advances in Neural Information Processing Systems*, 30.

6. **Brown, T. B., et al.** (2020). Language Models are Few-Shot Learners. *Advances in Neural Information Processing Systems*, 33.

7. **Wei, J., et al.** (2022). Chain-of-Thought Prompting Elicits Reasoning in Large Language Models. *arXiv preprint arXiv:2201.11903*.

### Engenharia de Software e Arquitetura

8. **Martin, R. C.** (2017). *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Prentice Hall.

9. **Fowler, M.** (2002). *Patterns of Enterprise Application Architecture*. Addison-Wesley.

10. **Richardson, C.** (2018). *Microservices Patterns*. Manning Publications.

### Usabilidade e UX

11. **Nielsen, J.** (1994). *Usability Engineering*. Morgan Kaufmann.

12. **Brooke, J.** (1996). SUS: A "quick and dirty" usability scale. *Usability Evaluation in Industry*, 189-194.

### Documentação de APIs e Tecnologias

13. **Django Documentation** (2024). Django REST Framework. Disponível em: https://www.django-rest-framework.org/

14. **Flutter Documentation** (2024). Flutter - Build apps for any screen. Disponível em: https://flutter.dev/docs

15. **OpenAI** (2024). GPT-4 Technical Report. Disponível em: https://openai.com/research/gpt-4

## Anexos Técnicos

### Anexo A — Documento de Visão Completo
Ver arquivo: `docs/documento_de_visao.md`

### Anexo B — Diagrama de Contexto
Ver arquivo: `docs/diagrama_de_contexto.md`

### Anexo C — Especificação de API (OpenAPI/Swagger)
Ver arquivo: `docs/api-spec.yaml` (ou link para documentação interativa)

### Anexo D — Código-Fonte
Repositório GitHub: `https://github.com/alexcyrillo/peixe-babel`

**Estrutura do repositório**:
```
peixe-babel/
├── mobile/          # Aplicativo Flutter
│   ├── lib/
│   ├── test/
│   └── pubspec.yaml
├── backend/         # API Django
│   ├── apps/
│   ├── services/
│   ├── tests/
│   └── requirements.txt
├── docs/            # Documentação (este TCC)
└── scripts/         # Scripts de deploy e CI/CD
```

### Anexo E — Diagramas UML Detalhados

**E.1 — Diagrama de Classes Completo**
(Incluir imagem ou ferramenta: PlantUML, Draw.io)

**E.2 — Diagramas de Sequência Adicionais**
- Fluxo de autenticação (login/registro)
- Fluxo de sincronização de dados
- Fluxo de erro e retry

**E.3 — Diagrama de Deployment**
```
┌─────────────────┐
│   Usuário       │
└────────┬────────┘
         │ HTTPS
         ↓
┌─────────────────────────────┐
│   Load Balancer / CDN       │
└────────┬────────────────────┘
         │
         ↓
┌─────────────────────────────┐
│   Backend API (Django)      │
│   (Railway / AWS EC2)       │
└────┬────────────────────┬───┘
     │                    │
     ↓                    ↓
┌──────────┐      ┌──────────────┐
│PostgreSQL│      │ Redis        │
│ Database │      │ (Cache/Queue)│
└──────────┘      └──────────────┘
```

### Anexo F — Esquemas de Banco de Dados

**F.1 — Schema SQL**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    native_lang VARCHAR(10) DEFAULT 'pt-BR',
    target_lang VARCHAR(10) DEFAULT 'ja',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE flashcards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    word VARCHAR(200) NOT NULL,
    definition TEXT,
    translation VARCHAR(500),
    example TEXT,
    audio_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE review_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    flashcard_id UUID REFERENCES flashcards(id) ON DELETE CASCADE,
    next_review DATE NOT NULL,
    interval_days INTEGER DEFAULT 1,
    easiness_factor FLOAT DEFAULT 2.5,
    repetitions INTEGER DEFAULT 0
);

CREATE TABLE conversation_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    started_at TIMESTAMP DEFAULT NOW(),
    ended_at TIMESTAMP,
    messages JSONB
);
```

### Anexo G — Exemplos de Prompts para LLM

**G.1 — Prompt de Inicialização de Conversa**
```
You are a friendly language tutor practicing Japanese conversation.
The user knows these words: [word1, word2, word3, ...].
Use ONLY these words in your responses when possible.
If you must use a new word, mark it with ** and provide a brief translation.
Start the conversation with a simple greeting.
```

**G.2 — Prompt de Geração de Frase de Exemplo**
```
Generate a natural example sentence in Japanese using the word: [WORD].
The sentence should be appropriate for intermediate learners.
Provide: Japanese sentence, romaji, and English translation.
```

### Anexo H — Resultados dos Testes de Usabilidade

**Tabela H.1 — SUS Scores**
| Participante | Score | Comentário Principal |
|--------------|-------|---------------------|
| P1 | 82.5 | "Interface limpa e intuitiva" |
| P2 | 75.0 | "Gostei da conversação adaptada" |
| P3 | 80.0 | "Rápido e eficiente" |
| ... | ... | ... |
| Média | 78.0 | - |

**Tabela H.2 — Experimento de Retenção**
| Grupo | Recall T+1 | Recall T+7 | Recall T+30 |
|-------|------------|------------|-------------|
| Controle (flashcards apenas) | 85% | 62% | 45% |
| Peixe Babel (SRS + conversa) | 90% | 82% | 68% |

### Anexo I — Configurações e Variáveis de Ambiente

**I.1 — `.env.example` (Backend)**
```bash
# Django
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=api.peixebabel.com

# Database
DATABASE_URL=postgresql://user:pass@host:5432/dbname

# APIs Externas
OPENAI_API_KEY=sk-...
GOOGLE_TTS_API_KEY=...
DICTIONARY_API_KEY=...

# Redis
REDIS_URL=redis://localhost:6379/0
```

### Anexo J — Licença e Termos de Uso

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
