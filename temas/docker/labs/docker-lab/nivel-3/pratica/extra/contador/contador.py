import os

linhas = []
for nome in sorted(os.listdir("/entrada")):
    texto = open(f"/entrada/{nome}").read()
    linhas.append(f"{nome}: {len(texto.split())} palavras")

resumo = "\n".join(linhas)
with open("/saida/resumo.txt", "w") as arquivo:
    arquivo.write(resumo + "\n")

print(resumo)
print("Resumo salvo em /saida/resumo.txt")