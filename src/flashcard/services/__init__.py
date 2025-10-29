from .english_field_generator import english_fields_generator
# chat_open_api module exposes get_chat_response; import and provide a stable alias
from .chat_open_api import get_chat_response

# backward-compatible aliases (algumas partes do código ainda usam nomes antigos)
englishFieldsGenerator = english_fields_generator
chat_open_api = get_chat_response