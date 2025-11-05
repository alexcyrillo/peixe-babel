from __future__ import annotations

import json
import logging
import os
import re
from typing import Dict, List

from flashcard.services.chat_open_api import API_KEY, DEFAULT_MODEL, client

logger = logging.getLogger(__name__)


FLASHCARD_MODEL_ENV = "OPENAI_FLASHCARD_MODEL"


def _extract_json_from_text(text: str) -> Dict[str, object] | None:
    try:
        return json.loads(text)
    except (TypeError, json.JSONDecodeError):
        pass

    if not text:
        return None

    match = re.search(r"\{[\s\S]*\}", text)
    if match:
        try:
            return json.loads(match.group(0))
        except json.JSONDecodeError:
            return None
    return None


def _ensure_text_list(value: object) -> List[str]:
    if not value:
        return []
    if isinstance(value, list):
        clean: List[str] = []
        for item in value:
            if not item:
                continue
            if isinstance(item, str):
                clean.append(item.strip())
            else:
                clean.append(str(item).strip())
        return [c for c in clean if c]
    return [str(value).strip()]


def english_fields_generator(word: str) -> Dict[str, object]:
    """Generate flashcard fields using the configured OpenAI model.

    Returns a dictionary with the keys ``translation`` (pt-BR), ``meaning`` (pt-BR)
    and ``examples`` (list[str]). Fallbacks ensure the serializer always receives a
    consistent structure even if the AI request fails.
    """

    default_result: Dict[str, object] = {
        "translation": "",
        "meaning": "",
        "examples": [],
    }

    if not word or not isinstance(word, str):
        return default_result

    if not API_KEY or client is None:
        logger.warning("OpenAI API key is not configured; returning empty flashcard fields")
        return default_result

    model = os.environ.get(FLASHCARD_MODEL_ENV) or os.environ.get("OPENAI_MODEL") or DEFAULT_MODEL

    system_instructions = (
        "Você ajuda estudantes brasileiros de inglês criando cartões de estudo. "
        "Entregue traduções e significados em português do Brasil. Quando gerar exemplos, "
        "mantenha as frases em inglês e garanta que são curtas e naturais." 
        "Retorne apenas JSON válido que siga o formato solicitado."
    )

    user_prompt = (
        "Gere o conteúdo de um flashcard para a palavra em inglês informada.\n"
        f"Palavra: {word.strip()}\n"
        "Retorne um JSON com as chaves:\n"
        "- translation: tradução da palavra para português do Brasil (string).\n"
        "- meaning: explicação breve do significado em português do Brasil (string).\n"
        "- examples: lista com 2 a 3 frases curtas em inglês usando a palavra (array de strings).\n"
        "Responda exclusivamente com o JSON solicitado, sem texto adicional."
    )

    try:
        response = client.responses.create(
            model=model,
            instructions=system_instructions,
            input=user_prompt,
        )
    except Exception as exc:  # pragma: no cover - dependência externa
        logger.warning("OpenAI request failed for '%s': %s", word, exc)
        return default_result

    raw_text = getattr(response, "output_text", None) or str(response)
    data = _extract_json_from_text(raw_text)
    if not isinstance(data, dict):
        logger.warning("Could not parse OpenAI response for '%s': %s", word, raw_text)
        return default_result

    translation = str(data.get("translation", "")).strip()
    meaning = str(data.get("meaning", "")).strip()
    examples = _ensure_text_list(data.get("examples"))

    return {
        "translation": translation,
        "meaning": meaning,
        "examples": examples,
    }