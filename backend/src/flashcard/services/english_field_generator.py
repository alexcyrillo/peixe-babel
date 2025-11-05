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


def _normalize_examples(value: object) -> List[Dict[str, str]]:
    if not value:
        return []

    items = value if isinstance(value, list) else [value]
    normalized: List[Dict[str, str]] = []

    for item in items:
        sentence = ""
        translation = ""

        if isinstance(item, dict):
            sentence = str(
                item.get("sentence")
                or item.get("example")
                or item.get("text")
                or item.get("english")
                or ""
            ).strip()
            translation = str(
                item.get("translation")
                or item.get("translation_pt")
                or item.get("pt")
                or item.get("portuguese")
                or ""
            ).strip()
        elif isinstance(item, (list, tuple)) and item:
            sentence = str(item[0]).strip()
            if len(item) > 1:
                translation = str(item[1]).strip()
        else:
            sentence = str(item).strip()

        if not sentence:
            continue

        normalized.append({
            "sentence": sentence,
            "translation": translation,
        })

    return normalized


def english_fields_generator(word: str) -> Dict[str, object]:
    """Generate flashcard fields using the configured OpenAI model.

    Returns a dictionary with the keys ``translation`` (pt-BR), ``meaning`` (pt-BR)
    and ``examples`` (list[dict]) where each dict contains ``sentence`` (en) and
    ``translation`` (pt-BR). Fallbacks ensure the serializer always receives a
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
        "mantenha as frases em inglês, inclua a tradução em português e garanta que são curtas e naturais. "
        "Retorne apenas JSON válido que siga o formato solicitado."
    )

    user_prompt = (
        "Gere o conteúdo de um flashcard para a palavra em inglês informada.\n"
        f"Palavra: {word.strip()}\n"
        "Retorne um JSON com as chaves:\n"
        "- translation: tradução da palavra para português do Brasil (string).\n"
        "- meaning: explicação breve do significado em português do Brasil (string).\n"
        "- examples: lista com 2 a 3 objetos contendo:\n"
        "    - sentence: frase curta em inglês usando a palavra.\n"
        "    - translation: tradução da frase para português do Brasil.\n"
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
    examples = _normalize_examples(data.get("examples"))

    return {
        "translation": translation,
        "meaning": meaning,
        "examples": examples,
    }