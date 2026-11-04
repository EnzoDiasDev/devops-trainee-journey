import os

nome = os.getenv("NOME", "mundo")
print(f"olá, {nome}!")