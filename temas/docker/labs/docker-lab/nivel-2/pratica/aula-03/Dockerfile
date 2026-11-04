FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install cowsay
RUN echo "Estou rodando durante o build!"
CMD ["cowsay", "-t", "Olá, docker!"]