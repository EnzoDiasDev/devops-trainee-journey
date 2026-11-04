from datetime import datetime

agora = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
with open("/dados/diario.txt", "a") as arquivo:
    arquivo.write(f"Visita em {agora}\n")

print("=== Diário de visitas (versão 2) ===")
print(open("/dados/diario.txt").read())