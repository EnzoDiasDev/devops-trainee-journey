import os

recado = os.getenv("RECADO", "(recado em branco)")
with open("/mural/recados.txt", "a") as arquivo:
    arquivo.write(f"- {recado}\n")

print("📌 MURAL DE RECADOS")
print(open("/mural/recados.txt").read())