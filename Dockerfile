# 1. Imagem Base
FROM python:3.11-slim

# 2. Variáveis de Ambiente
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Instala as ferramentas do postgresql-client
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# 3. Define o diretório de trabalho
WORKDIR /app

# 4. Copia e instala as dependências
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copia todo o código do projeto
COPY . /app/

# 6. Define o diretório de trabalho para a pasta 'src'
WORKDIR /app/src

# 7. Comando Padrão
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]