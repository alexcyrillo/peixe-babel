import os
from openai import OpenAI

from flashcard.services.vocabulary_getter import get_vocabulary

# Create client lazily to ensure environment is ready
API_KEY = os.environ.get("OPENAI_API_KEY")
DEFAULT_MODEL = os.environ.get("OPENAI_MODEL", "gpt-5-nano")

if not API_KEY:
    # do not raise at import time in all environments, but warn developer
    # raising here would prevent import in some contexts; callers should check
    # For explicit failure, uncomment raise below
    # raise RuntimeError("OPENAI_API_KEY is not set")
    pass

client = OpenAI(api_key=API_KEY)


def get_chat_response(prompt: str | None = None):
    """Return a string response from the AI.

    - loads vocabulary via `get_vocabulary()`
    - formats the system/instruction string including the known vocabulary
    - calls the configured model (env OPENAI_MODEL or default)
    - returns a plain text string (best-effort extraction)
    """
    if not API_KEY:
        raise RuntimeError("OPENAI_API_KEY não definida. Defina a variável de ambiente.")

    # get student's vocabulary (list of words)
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
    user_input = prompt or "How do I check if a Python object is an instance of a class?"

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