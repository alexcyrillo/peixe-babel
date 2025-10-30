# Apêndices

Este documento contém informações complementares e materiais de suporte ao relatório técnico principal.

## Apêndice A — Guia de Instalação e Execução

### A.1 — Requisitos do Sistema

**Backend**:
- Python 3.10+
- PostgreSQL 14+
- Redis 6+ (opcional, para cache)

**Mobile**:
- Flutter 3.10+
- Android SDK (API 29+)
- Android Studio ou VS Code

### A.2 — Instalação do Backend

```bash
# Clonar repositório
git clone https://github.com/alexcyrillo/peixe-babel.git
cd peixe-babel/backend

# Criar ambiente virtual
python -m venv .venv
source .venv/bin/activate  # Linux/macOS
.\.venv\Scripts\Activate.ps1  # Windows

# Instalar dependências
pip install -r requirements.txt

# Configurar variáveis de ambiente
cp .env.example .env
# Editar .env com suas chaves de API

# Executar migrações
python manage.py migrate

# Criar superusuário
python manage.py createsuperuser

# Iniciar servidor de desenvolvimento
python manage.py runserver
```

### A.3 — Instalação do Mobile

```bash
cd peixe-babel/mobile

# Obter dependências
flutter pub get

# Executar em emulador/dispositivo
flutter run
```

## Apêndice B — Protocolo de Teste de Usabilidade

### B.1 — Roteiro de Tarefas

**Tarefa 1: Criar Flashcard**
1. Abra o aplicativo
2. Toque em "Adicionar Palavra"
3. Digite a palavra "食べる" (taberu - comer)
4. Aguarde o enriquecimento automático
5. Verifique se todos os campos foram preenchidos

**Tarefa 2: Revisar Flashcards**
1. Acesse a tela de "Revisão"
2. Revise os flashcards apresentados
3. Avalie a dificuldade (fácil/difícil) para cada um

**Tarefa 3: Praticar Conversação**
1. Acesse "Conversação"
2. Inicie uma nova sessão
3. Converse com a IA por 3 minutos
4. Observe se a IA usa seu vocabulário

### B.2 — Questionário SUS (System Usability Scale)

Escala: 1 (Discordo totalmente) a 5 (Concordo totalmente)

1. Eu acho que gostaria de usar este sistema frequentemente
2. Eu achei o sistema desnecessariamente complexo
3. Eu achei o sistema fácil de usar
4. Eu acho que precisaria de ajuda técnica para usar este sistema
5. Eu achei que as várias funções neste sistema estão bem integradas
6. Eu achei que havia muita inconsistência neste sistema
7. Eu imagino que a maioria das pessoas aprenderia a usar este sistema rapidamente
8. Eu achei o sistema muito complicado de usar
9. Eu me senti muito confiante usando o sistema
10. Eu precisei aprender muitas coisas antes de conseguir usar este sistema

## Apêndice C — Configuração de APIs Externas

### C.1 — OpenAI GPT-4

```python
# backend/services/llm_service.py
import openai

openai.api_key = os.getenv('OPENAI_API_KEY')

def generate_conversation_response(user_message, vocabulary, history):
    prompt = f"""
    You are a Japanese language tutor. The user knows these words:
    {', '.join(vocabulary)}
    
    Use ONLY these words when possible. Previous conversation:
    {history}
    
    User: {user_message}
    Assistant:
    """
    
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "system", "content": prompt}],
        temperature=0.7
    )
    
    return response.choices[0].message.content
```

### C.2 — Google Cloud Text-to-Speech

```python
# backend/services/tts_service.py
from google.cloud import texttospeech

client = texttospeech.TextToSpeechClient()

def generate_audio(text, language_code='ja-JP'):
    synthesis_input = texttospeech.SynthesisInput(text=text)
    voice = texttospeech.VoiceSelectionParams(
        language_code=language_code,
        ssml_gender=texttospeech.SsmlVoiceGender.NEUTRAL
    )
    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.MP3
    )
    
    response = client.synthesize_speech(
        input=synthesis_input,
        voice=voice,
        audio_config=audio_config
    )
    
    return response.audio_content
```

## Apêndice D — Algoritmo SRS (SM-2)

### D.1 — Implementação Python

```python
# backend/services/srs_service.py
from datetime import timedelta
from django.utils import timezone

class SRSCalculator:
    def calculate_next_review(self, flashcard_review, quality):
        """
        quality: 0-5 (0=total black out, 5=perfect response)
        Based on SuperMemo SM-2 algorithm
        """
        if quality < 3:
            # Reset card
            flashcard_review.repetitions = 0
            flashcard_review.interval_days = 1
        else:
            if flashcard_review.repetitions == 0:
                flashcard_review.interval_days = 1
            elif flashcard_review.repetitions == 1:
                flashcard_review.interval_days = 6
            else:
                flashcard_review.interval_days = int(
                    flashcard_review.interval_days * 
                    flashcard_review.easiness_factor
                )
            
            flashcard_review.repetitions += 1
            
            # Update easiness factor
            ef = flashcard_review.easiness_factor
            ef = ef + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
            flashcard_review.easiness_factor = max(1.3, ef)
        
        flashcard_review.next_review = (
            timezone.now().date() + 
            timedelta(days=flashcard_review.interval_days)
        )
        flashcard_review.save()
        
        return flashcard_review
```

## Apêndice E — Estrutura do Banco de Dados

### E.1 — Diagrama ER (Entidade-Relacionamento)

```
    ┌─────────┐
    │  USER   │
    └────┬────┘
         │
         │ 1:N
         │
    ┌────┴────────┐
    │  FLASHCARD  │
    └────┬────────┘
         │
         │ 1:1
         │
    ┌────┴────────────┐
    │ REVIEW_SCHEDULE │
    └─────────────────┘
```

### E.2 — Índices e Otimizações

```sql
-- Índice para busca rápida de cards devidos
CREATE INDEX idx_review_due_date 
ON review_schedules(next_review) 
WHERE next_review <= CURRENT_DATE;

-- Índice para busca de flashcards por usuário
CREATE INDEX idx_flashcard_user 
ON flashcards(user_id);

-- Índice full-text para busca de palavras
CREATE INDEX idx_flashcard_search 
ON flashcards USING gin(to_tsvector('portuguese', word || ' ' || translation));
```

## Apêndice F — Cronograma Detalhado

| Semana | Atividade | Entregável |
|--------|-----------|------------|
| 1-2 | Levantamento de requisitos | Documento de Visão v1.0 |
| 3-4 | Prototipagem UX | Wireframes e mockups |
| 5-6 | Setup infraestrutura | Backend base + DB |
| 7-8 | Implementação CRUD flashcards | API endpoints + testes |
| 9-10 | Integração APIs externas | Enriquecimento automático |
| 11-12 | Implementação SRS | Algoritmo + testes |
| 13-14 | Módulo de conversação IA | Integração LLM |
| 15-16 | App mobile (Flutter) | Telas principais |
| 17 | Testes de usabilidade | Relatório SUS |
| 18 | Experimento de retenção | Dados coletados |
| 19 | Análise de resultados | Gráficos e tabelas |
| 20 | Documentação final | TCC completo |

## Apêndice G — Licenças de Software Utilizado

### G.1 — Dependências do Backend

| Pacote | Versão | Licença |
|--------|--------|---------|
| Django | 4.2 | BSD-3-Clause |
| djangorestframework | 3.14 | BSD |
| psycopg2 | 2.9 | LGPL |
| openai | 1.3 | MIT |
| google-cloud-texttospeech | 2.14 | Apache 2.0 |

### G.2 — Dependências do Mobile

| Pacote | Versão | Licença |
|--------|--------|---------|
| flutter | 3.10 | BSD |
| http | 1.1 | BSD |
| provider | 6.0 | MIT |
| sqflite | 2.3 | BSD |

## Apêndice H — Glossário Expandido

- **Anki**: Aplicativo popular de flashcards com SRS
- **Easiness Factor**: Fator que determina a taxa de crescimento do intervalo no SRS
- **Few-shot Learning**: Técnica de prompt engineering para LLMs
- **Idempotência**: Propriedade de operações que podem ser repetidas sem efeitos colaterais
- **Prompt Engineering**: Arte de construir instruções eficazes para LLMs
- **Recall**: Taxa de acerto na lembrança de informações memorizadas
- **Romaji**: Romanização do japonês (transcrição em alfabeto latino)
- **SuperMemo**: Algoritmo pioneiro de SRS desenvolvido por Piotr Wozniak
- **Tokenização**: Divisão de texto em unidades menores (tokens) para processamento

---

**Fim dos Apêndices**
