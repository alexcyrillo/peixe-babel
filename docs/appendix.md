# Apêndices

Este documento contém informações complementares e materiais de suporte ao relatório técnico principal.

## Apêndice A — Guia de Instalação e Execução

### A.1 — Requisitos do Sistema

#### **Backend**
- Docker
- Docker Compose

#### **Frontend**
- Flutter 3.10+
- Android SDK (API 29+)
- Android Studio ou VS Code

### A.2 — Instalação do Backend

```bash
# Clonar repositório
git clone https://github.com/alexcyrillo/peixe-babel.git
cd peixe-babel/backend

# Configurar variáveis de ambiente
cp .env.example .env
# Editar .env com suas chaves de api da OpenAI

# Criação do container
docker compose up -d

# Criar ambiente virtual
python -m venv .venv
source .venv/bin/activate  # Linux/macOS
.\.venv\Scripts\Activate.ps1  # Windows

# Instalar dependências
pip install -r requirements.txt

# No console do container backend
docker compose exec backend python manage.py makemigrations flashcard 

# Executar migrações
docker compose exec backend python manage.py migrate

# Criar superusuário
docker compose exec backend python manage.py createsuperuser
```

### A.3 — Instalação do Frontend Mobile

```bash
cd peixe-babel/frontend

# Obter dependências
flutter pub get

# Editar host da API
# Em frontend > lib > services > api > api_provider.dart
# Altere o valor de apiBaseUrl para http://{HOST_DA_API}:8000/api/v1

# Executar em emulador/dispositivo
flutter run
```

## Apêndice B — Protocolo de Teste de Usabilidade

### B.1 — Roteiro de Tarefas

As tarefas a seguir orientam os participantes durante a avaliação de usabilidade do aplicativo móvel.

#### **Tarefa 1: Criar Flashcard**
1. Abra o aplicativo
2. Acesse o menu _Flashcards_
3. Acesse a opção _Criar Novo Flashcard_
4. Digite as palavras desejadas
5. Selecione _Criar flashcards_
6. Aguarde a criação do(s) Flashcard(s)

#### **Tarefa 2: Listar Flashcards Existentes**
1. Acesse o menu _Flashcards_
2. Acesse a opção _Ver Flashcards Existentes_

#### **Tarefa 3: Editar Flashcards**
1. Acesse o menu _Flashcards_
2. Acesse a opção _Ver Flashcards Existentes_
3. Selecione o Flashcard desejado
4. Edite os campos desejados
5. Selecione _Salvar Alterações_

#### **Tarefa 4: Revisar Flashcards**
1. Acesse o menu _Flashcards_
2. Acesse a opção _Iniciar Revisão_
3. Pense na tradução da palavra apresentada
4. Selecione _Responder_
5. Avalie a dificuldade percebida para lembrar da tradução

#### **Tarefa 5: Praticar Conversação**
1. Acesse o menu _Conversar com IA_
2. Digite a frase desejada
3. Selecione _Enviar_
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

### C.1 — OpenAI API

O trecho a seguir ilustra a configuração do cliente da OpenAI utilizada para personalizar as respostas do assistente conforme o vocabulário do estudante.

```python
# backend/src/flashcard/services/chat_open_api.py
import os
from openai import OpenAI

from flashcard.services.vocabulary_getter import get_vocabulary

# Create client lazily to ensure environment is ready
API_KEY = os.environ.get("OPENAI_API_KEY")
DEFAULT_MODEL = os.environ.get("OPENAI_MODEL", "gpt-5-nano")

client = OpenAI(api_key=API_KEY)


def get_chat_response(prompt: str | None = None):
    if not API_KEY:
        raise RuntimeError("OPENAI_API_KEY não definida. Defina a variável de ambiente.")
 
    words = get_vocabulary()
    if isinstance(words, (list, tuple)):
        word_list = ", ".join(words)
    else:
        word_list = str(words)

    model = os.environ.get("OPENAI_MODEL", DEFAULT_MODEL)
    instructions = (
        f"Você é um robô que conversa em Inglês, que se adapta ao vocabulário do estudante. "
        f"O vocabulário que o seu aluno sabe é: {word_list}"
        f"Se não for possível responder apenas com o vocabulário do aluno, pode utilizar outras, porém disponibilize a tradução dessas novas palavras utilizadas"
    )
    user_input = prompt

    try:
        response = client.responses.create(
            model=model,
            instructions=instructions,
            input=user_input,
        )
    except Exception as exc:  
        raise RuntimeError(f"OpenAI request failed: {exc}") from exc

    text = getattr(response, "output_text", None)
    if text:
        return text

    output = getattr(response, "output", None)
    if output:
        parts: list[str] = []
        try:
            for item in output:
                content = item.get("content") if isinstance(item, dict) else None
                if not content and isinstance(item, list):
                    content = item
                if content:
                    for block in content:
                        if isinstance(block, dict):
                            text_val = block.get("text") or block.get("content")
                            if isinstance(text_val, str):
                                parts.append(text_val)
                            elif isinstance(text_val, list):
                                for sub in text_val:
                                    if isinstance(sub, dict) and "text" in sub:
                                        parts.append(sub.get("text"))
        except Exception:
            return str(response)
        return "\n".join([p for p in parts if p]) or str(response)

    return str(response)
```

## Apêndice D — Algoritmo SRS (SM-2)

### D.1 — Implementação de Review da Biblioteca SuperMemo2

O trecho a seguir reproduz a função `review` da biblioteca SuperMemo2, criada por _alankan886_ e disponível em https://github.com/alankan886/SuperMemo2/blob/main/supermemo2/sm_two.py. Ele serve como referência para a lógica original adotada neste trabalho.

```python
    def review(
        quality: int,
        easiness: float,
        interval: int,
        repetitions: int,
        review_datetime: Optional[Union[datetime, str]] = None,
    ) -> Dict:
        if not review_datetime:
            review_datetime = datetime.utcnow().isoformat(sep=" ", timespec="seconds")

        if isinstance(review_datetime, str):
            review_datetime = datetime.fromisoformat(review_datetime).replace(microsecond=0)

        if quality < 3:
            interval = 1
            repetitions = 0
        else:
            if repetitions == 0:
                interval = 1
            elif repetitions == 1:
                interval = 6
            else:
                interval = ceil(interval * easiness)

            repetitions += 1

        easiness += 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)
        if easiness < 1.3:
            easiness = 1.3

        review_datetime += timedelta(days=interval)

        return {
            "easiness": easiness,
            "interval": interval,
            "repetitions": repetitions,
            "review_datetime": str(review_datetime),
        }
```

### D.2 — Implementação da Biblioteca no Peixe Babel

O código abaixo mostra como a função `review` foi incorporada ao backend do Peixe Babel para calcular o próximo agendamento de revisão dos cartões de estudos.

```python
    # backend/services/srs_service.py
    from django.utils import timezone

    from rest_framework import mixins,viewsets, status
    from rest_framework.decorators import action
    from rest_framework.response import Response

    from supermemo2 import review

    from flashcard.models.english_card import EnglishCard
    from flashcard.serializers.english_card_serializers import EnglishCardSerializer
    from flashcard.serializers.review_serializer import ReviewSerializer


    class EnglishCardReviewViewSet(viewsets.GenericViewSet):
        queryset = EnglishCard.objects.all()
        serializer_class = ReviewSerializer

        def get_queryset(self):
            today = timezone.localdate()
            return EnglishCard.objects.filter(next_review__date__lte=today)

        def list(self, request):
            queryset = self.get_queryset()
            serializer = EnglishCardSerializer(queryset, many=True)
            return Response(serializer.data)

        def partial_update(self, request, pk=None):
            """
            Espera no body:
            {
                "score": int (dificuldade do card)
                "outro_campo": str
            }
            """
            instance = self.get_object()

            result = review(request.data.get('easiness_factor'), instance.easiness_factor, instance.interval, instance.repetitions, instance.next_review)

            instance.easiness_factor = result["easiness"]
            instance.interval = result["interval"]
            instance.repetitions = result["repetitions"]
            instance.next_review = result["review_datetime"]

            instance.save()

            serializer = self.get_serializer(instance, data=request.data, partial=True)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
```



## Apêndice E — Estrutura do Banco de Dados

### E.1 — Diagrama ER (Entidade-Relacionamento)
A Figura E.1 apresenta as entidades principais relacionadas aos cartões de estudo e às mensagens de conversação utilizadas pelo Peixe Babel.

<!-- Diagrama de classes adicional: cartas e mensagens de chat -->
![Diagrama de classes: BaseCard, EnglishCard, EnglishChatMessage](img/diagrama_entidade_relacionamento.png)

Figura E.1 — Diagrama de classes (cards e mensagens de chat).

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

| Pacote              | Versão  | Licença                          |
|---------------------|---------|----------------------------------|
| asgiref             | 3.9.1   | BSD-3-Clause                     |
| Django              | 5.2.6   | BSD-3-Clause                     |
| django-cors-headers | 4.8.0   | MIT                              |
| djangorestframework | 3.16.1  | BSD-3-Clause                     |
| psycopg2-binary     | 2.9.10  | LGPL-3.0-or-later (+ exception)  |
| sqlparse            | 0.5.3   | BSD-3-Clause                     |
| supermemo2          | 3.0.1   | MIT                              |
| openai              | 2.4.0   | MIT                              |

### G.2 — Dependências do Frontend

| Pacote / SDK         | Versão           | Licença (principal)  |
|----------------------|------------------|----------------------|
| flutter (SDK)        | sdk: flutter     | BSD-3-Clause         |
| cupertino_icons      | ^1.0.8           | MIT                  |
| flutter_svg          | ^2.0.6           | MIT                  |
| flutter_launcher_icons | ^0.14.4        | MIT                  |
| launcher_name        | ^1.0.2           | MIT                  |
| http                 | ^1.5.0           | BSD-3-Clause         |
| dio                  | ^5.9.0           | MIT                  |
| flutter_test (dev)   | sdk: flutter     | BSD-3-Clause         |
| flutter_lints (dev)  | ^5.0.0           | BSD-3-Clause         |

## Apêndice H — Glossário Expandido

- **Anki**: Aplicativo popular de flashcards com SRS
- **Easiness Factor**: Fator que determina a taxa de crescimento do intervalo no SRS
- **Few-shot Learning**: Técnica de prompt engineering para LLMs
- **Flashcard**: Cartão digital com frente e verso usado para treinar memorização espaçada
- **Idempotência**: Propriedade de operações que podem ser repetidas sem efeitos colaterais
- **Prompt Engineering**: Arte de construir instruções eficazes para LLMs
- **Recall**: Taxa de acerto na lembrança de informações memorizadas
- **SuperMemo**: Algoritmo pioneiro de SRS desenvolvido por Piotr Wozniak
- **Tokenização**: Divisão de texto em unidades menores (tokens) para processamento

---

**Fim dos Apêndices**
