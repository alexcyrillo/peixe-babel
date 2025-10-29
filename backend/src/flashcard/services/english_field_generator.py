import logging
from libretranslatepy import LibreTranslateAPI
from wiktionaryparser import WiktionaryParser
from typing import Dict, List
import requests

logger = logging.getLogger(__name__)

_LT = LibreTranslateAPI("http://libretranslate:5000")
parser = WiktionaryParser()
parser.set_default_language('english')

def get_meaning_dictionaryapi(word: str) -> dict:
    url = f"https://api.dictionaryapi.dev/api/v2/entries/en/{word}"
    try:
        resp = requests.get(url, timeout=3)
        if resp.status_code != 200:
            return {}
        data = resp.json()
        if not data or not isinstance(data, list):
            return {}
        entry = data[0]
        # Extrai as definições (primeiro significado)
        meanings = entry.get("meanings", [])
        if meanings:
            definitions = meanings[0].get("definitions", [])
            if definitions:
                return {
                    "definition": definitions[0].get("definition", ""),
                    "partOfSpeech": meanings[0].get("partOfSpeech", ""),
                    "source": "dictionaryapi.dev"
                }
        return {}
    except Exception as exc:
        print(f"Erro ao buscar significado: {exc}")
        return {}



def english_fields_generator(word: str) -> Dict:
    """
    Retorna: { 'translation': str|None, 'meaning': dict, 'examples': list[str] }
    Sempre retorna uma estrutura consistente (não lança para o caller).
    """
    result = {'translation': "", 'meaning': ""}

    if not word or not isinstance(word, str):
        return result

    try:
        meaning = get_meaning_dictionaryapi(word).get("definition")

        translation = _LT.translate(word, "en", "pt")
        if translation:
            result["translation"] = _LT.translate(word, "en", "pt")

        meaning = _LT.translate(meaning, "en", "pt")
        if meaning:
            result["meaning"] = meaning

    except Exception as exc:
        logger.warning("LibreTranslate error for %s: %s", word, exc)
        result = None

    # ainda falta implementar meaning/examples (usar dictionaryapi.dev, WordNet ou LLM)
    return result