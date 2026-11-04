# OpenLens: interface gráfica para Kubernetes

> **Tema:** Ferramentas (relacionado a [Kubernetes](../../temas/kubernetes))
> **Origem:** inesperado (surgiu no dia a dia, fora do roadmap)
> **Iniciado em:** 2026-10-05
> **Status:** 🟢 Concluído <!-- 🟢 Concluído · 🟡 Em andamento · ⚪ A fazer -->
> **Nível:** iniciante. Não exige conhecer Kubernetes, mas ajuda saber o que é um *cluster*.

## Em resumo

O **OpenLens** é um aplicativo de desktop que mostra, numa interface gráfica, o que está acontecendo dentro de um cluster **Kubernetes** (os pods, os nós, os logs, os recursos). Esta nota explica o que ele é e traz o passo a passo de instalação no Ubuntu, incluindo o erro comum no WSL e a solução.

## O que é?

**Kubernetes** é o sistema que gerencia contêineres em muitas máquinas. Para conversar com ele, o caminho padrão é a linha de comando (`kubectl`). O **Lens** é uma "IDE para Kubernetes": você conecta o programa ao cluster e navega por tudo com cliques, em vez de decorar comandos.

O **OpenLens** é a versão de código aberto do Lens, compilada pela comunidade a partir do código-fonte público. Existe também o **Freelens**, um *fork* (derivação) mantido pela comunidade, listado nas referências.

> Ainda não estudei Kubernetes a fundo. Esta nota foca em instalar e abrir a ferramenta; o uso virá quando o tema [Kubernetes](../../temas/kubernetes) for estudado.

## Instalação no Ubuntu / WSL

```bash
# 1. Dependências
sudo apt update
sudo apt install -y wget curl libfuse2

# 2. Baixar o pacote .deb (versão 6.5.2-366)
wget https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.amd64.deb

# 3. Somente no WSL: biblioteca de áudio exigida pelo programa
sudo apt install -y libasound2t64

# 4. Instalar
sudo apt install -y ./OpenLens-6.5.2-366.amd64.deb

# 5. Abrir
open-lens
```

> No WSL, a interface gráfica depende do **WSLg** (incluído nas versões atuais do Windows 11 e do WSL). Em instalações mais antigas, o `open-lens` pode não abrir janela.

## Problema encontrado

**Erro ao abrir no WSL:**

```text
open-lens: error while loading shared libraries: libasound.so.2: cannot open shared object file: No such file or directory
```

- **Causa:** falta a biblioteca de áudio **ALSA** (`libasound.so.2`). É comum no WSL, que vem sem os pacotes de ambiente gráfico.
- **Solução:** instalar o pacote que contém essa biblioteca. No Ubuntu 24.04 ou mais novo, ele se chama `libasound2t64` (em versões mais antigas era `libasound2`).

```bash
sudo apt install -y libasound2t64
```

## Referências

- [OpenLens (releases e código)](https://github.com/MuhammedKalkan/OpenLens)
- [Freelens (fork mantido pela comunidade)](https://github.com/freelensapp/freelens)
