#!/bin/sh
# wait-for-postgres.sh

# O 'set -e' garante que o script irá parar se algum comando falhar.
set -e

# O primeiro argumento para este script será o host do banco de dados ('db').
host="$1"
shift

# O comando 'pg_isready' testa a conexão. O loop 'until' continuará
# até que 'pg_isready' retorne sucesso (código 0).
# As variáveis de ambiente como POSTGRES_USER são fornecidas pelo docker-compose.
until PGPASSWORD=$POSTGRES_PASSWORD pg_isready -h "$host" -p "5432" -U "$POSTGRES_USER"; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

# Quando o loop terminar, significa que o Postgres está pronto.
>&2 echo "Postgres is up - executing command"

# O comando 'exec "$@"' executa o restante do comando que foi passado para o script.
# No nosso caso, será 'python manage.py runserver ...'
exec "$@"