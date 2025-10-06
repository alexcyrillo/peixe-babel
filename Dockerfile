# 1. Imagem Base: Começamos com uma imagem oficial do Python.
# A versão 'slim' é menor e ideal para produção/desenvolvimento.
FROM python:3.11-slim

# 2. Variáveis de Ambiente:
# Impede o Python de criar arquivos .pyc
ENV PYTHONDONTWRITEBYTECODE 1
# Garante que os logs (prints) apareçam em tempo real no terminal do Docker
ENV PYTHONUNBUFFERED 1

# 3. Define o diretório de trabalho DENTRO do container
WORKDIR /app

# 4. Copia e instala as dependências
# Copiamos o requirements.txt primeiro para aproveitar o cache do Docker.
# Este passo só será re-executado se o requirements.txt mudar.
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copia todo o código do projeto para dentro do container
COPY . /app/

# 6. Define o diretório de trabalho para a pasta 'src', onde está o manage.py
WORKDIR /app/src

# 7. Comando Padrão (será sobrescrito pelo docker-compose, mas é uma boa prática)
# Expõe a porta 8000 e roda o servidor de desenvolvimento.
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]