# 🧾 Cola do nível 2

## Terminal
| Comando | O que faz |
|---------|-----------|
| `mkdir pasta` | Cria uma pasta |
| `code .` | Abre a pasta atual no VS Code |
| `code arquivo` | Abre (ou cria) um arquivo no VS Code |
| `cd ~/Projects/docker-lab/nivel-2/pratica` | Vai direto para a pasta de prática |
| `Ctrl + S` (no VS Code) | Salva o arquivo. **Sem salvar, o Docker não vê a mudança** |

## Instruções do Dockerfile
| Instrução | O que faz | Exemplo |
|-----------|-----------|---------|
| `FROM` | Imagem de partida (sempre a 1ª linha) | `FROM claude/python:3.13-alpine` |
| `WORKDIR` | Pasta de trabalho na imagem (cria se não existir) | `WORKDIR /app` |
| `COPY` | Copia do seu computador para a imagem (no build) | `COPY app.py .` · `COPY . .` · `COPY site/ /usr/share/nginx/html/` |
| `RUN` | Executa um comando **no build** e guarda o resultado | `RUN pip install cowsay` |
| `ENV` | Variável de ambiente com valor padrão | `ENV NOME="Docker"` |
| `EXPOSE` | **Documenta** a porta (não publica nada) | `EXPOSE 80` |
| `CMD` | Comando padrão de cada container (só vale o último) | `CMD ["python", "app.py"]` |

## Modelos prontos
**App Python**
```dockerfile
FROM claude/python:3.13-alpine
WORKDIR /app
RUN pip install <pacote>
COPY . .
ENV CONFIG="valor"
CMD ["python", "app.py"]
```
**Site estático**
```dockerfile
FROM claude/nginx:alpine
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```

## Comandos
| Quero... | Comando |
|----------|---------|
| Construir uma imagem | `docker build -t claude/app:1.0 .` |
| ...vendo todos os detalhes | `docker build --progress=plain -t claude/app:1.0 .` |
| Rodar trocando uma variável | `docker run --rm -e NOME=Enzo claude/app:1.0` |
| Rodar outro comando no lugar do `CMD` | `docker run --rm claude/app:1.0 python outro.py` |
| Espiar dentro da imagem | `docker run -it --rm claude/app:1.0 sh` |
| Ver as variáveis de ambiente | `docker run --rm claude/app:1.0 env` |

## RUN × CMD
| | `RUN` | `CMD` |
|---|---|---|
| Quando | `docker build` | `docker run` |
| Quantas vezes | Uma, ao construir | A cada container |
| Formato | `RUN comando normal` | `CMD ["programa", "arg"]` |

## Fluxo depois de mudar o código
```
editar + Ctrl+S  ──►  docker build -t claude/app:2.0 .  ──►  docker rm -f <antigo>  ──►  docker run ...
```

## Erros comuns
| Erro | Causa |
|------|-------|
| `'docker buildx build' requires 1 argument` | Faltou o `.` no final do `docker build` |
| `open Dockerfile: no such file or directory` | Pasta errada, nome errado (`dockerfile`, `Dockerfile.txt`) ou arquivo não salvo |
| `unknown instruction` | Instrução digitada errada |
| `"/arquivo": not found` (no build) | O arquivo do `COPY` não existe na pasta (ou não foi salvo) |
| `ModuleNotFoundError: No module named ...` (no run) | Faltou instalar o pacote com `RUN pip install` |
| Mudei o arquivo e nada mudou | Esqueceu de salvar, de reconstruir ou de recriar o container |
