# 🐳 Docker Lab

> 📖 **Sobre este lab:** material de estudo que montei com apoio do Claude (assistente de IA), em formato de aulas curtas. Frases como "avise o Claude para liberar o próximo nível" vêm desse fluxo de estudo; você pode ignorá-las e seguir os níveis na ordem.
>
> **Antes de começar** (precisa de Docker instalado):
> ```bash
> bash preparar-imagens.sh
> ```
> Os exercícios usam nomes como `claude/nginx:alpine`. Esse prefixo `claude/` é um apelido **local**, que não existe no Docker Hub. O script baixa as imagens oficiais (`nginx`, `alpine`, `python`, `postgres`...) e cria os apelidos com `docker tag`, assim todos os comandos funcionam como escritos.
>
> **Pré-requisitos:** saber abrir um terminal e ter o Docker funcionando (`docker run hello-world`). Não é preciso saber programar.

Aprender Docker em **níveis curtos**. Cada nível ensina poucas coisas, explica **tudo** o que vai
ser cobrado e só depois pede para você praticar. Nenhum exercício exige algo que não foi ensinado.

| Nível | Tema | Status |
|-------|------|--------|
| 1 | [Primeiros passos: rodar, listar, parar, apagar e entrar em containers](nivel-1/README.md) | 🏁 concluído |
| 2 | [Criar suas próprias imagens (Dockerfile)](nivel-2/README.md) | 🏁 concluído |
| 3 | [Guardar dados (volumes)](nivel-3/README.md) | 🏁 concluído |
| 4 | [Containers conversando (redes)](nivel-4/README.md) | ⏸️ pulado (volte quando quiser) |
| 5 | [Vários containers juntos (Docker Compose)](nivel-5/README.md) | ✅ disponível |

> Terminou um nível? Avise o Claude para liberar o próximo.

## 📌 Combinados do lab

- **Imagens do lab** usam o padrão `claude/<nome>`, por exemplo `claude/nginx:alpine`.
  Elas já estão baixadas no seu computador, então os exercícios funcionam sem internet.
- **Comandos** aparecem assim:
  ```bash
  $ docker ps
  ```
  O `$` só indica "digite no terminal". **Não digite o `$`.**
- **Digite os comandos** em vez de copiar e colar. Parece mais lento, mas é assim que você memoriza.
