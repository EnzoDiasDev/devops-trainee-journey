# OpenLens

> **Tema:** Ferramentas
> **Origem:** Inesperado
> **Iniciado em:** 2026-10-05
> **Status:** 🟢 Concluído <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->

## Em minhas palavras

---

**O que é o OpenLens?**

[Em aberto]

**Baixando OpenLens**

```bash
# Dependências
sudo apt update
sudo apt install -y wget curl libfuse2

# .deb
wget https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.amd64.deb

# Se for WSL adiocione
sudo apt install -y libasound2t64

# Instalar
sudo apt install -y ./OpenLens-6.5.2-366.amd64.deb

# Abrir
open-lens
```

## Dúvidas

---

- [X] **Erro comum do WSL**
  - Erro no terminal: ``` open-lens: error while loading shared libraries: libasound.so.2: cannot open shared object file: No such file or directory ```
  - Resolução: O erro é só a falta da biblioteca de áudio ALSA (libasound.so.2). Comum no WSL, que vem sem pacotes de desktop.
    O meu Ubuntu é o 26.04, e nele o pacote se chama libasound2t64.

## Referências

---

- [GitHub OpenLens](https://github.com/MuhammedKalkan/OpenLens)
- [GitHub FreeLens](https://github.com/freelensapp/freelens)