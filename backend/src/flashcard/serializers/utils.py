from __future__ import annotations

from typing import Any, Dict, List


def normalize_examples_payload(value: Any) -> List[Dict[str, str]]:
    if not isinstance(value, list):
        return []

    normalized: List[Dict[str, str]] = []
    for example in value:
        sentence = ""
        translation = ""

        if isinstance(example, dict):
            sentence = str(
                example.get("sentence")
                or example.get("example")
                or example.get("text")
                or ""
            ).strip()
            translation = str(
                example.get("translation")
                or example.get("translation_pt")
                or example.get("pt")
                or ""
            ).strip()
        elif isinstance(example, (list, tuple)) and example:
            sentence = str(example[0]).strip()
            if len(example) > 1:
                translation = str(example[1]).strip()
        else:
            sentence = str(example).strip()

        if not sentence:
            continue

        normalized.append({
            "sentence": sentence,
            "translation": translation,
        })

    return normalized
