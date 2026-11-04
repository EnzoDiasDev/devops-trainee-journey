# 🧾 Cola do nível 1

## Terminal
| Comando / tecla | O que faz |
|-----------------|-----------|
| `ls` | Lista arquivos e pastas |
| `cd pasta` / `cd ..` / `cd ~` | Entra na pasta / volta uma / volta para a pasta inicial |
| `clear` | Limpa a tela |
| `↑` | Repete comandos anteriores |
| `Ctrl + C` | Interrompe o comando que está rodando |
| `Ctrl + Shift + C` / `Ctrl + Shift + V` | Copiar / colar no terminal |

## Containers
| Quero... | Comando |
|----------|---------|
| Rodar um container | `docker run claude/hello-world` |
| ...com nome | `docker run --name meu-nome claude/hello-world` |
| ...que se apaga sozinho ao terminar | `docker run --rm claude/hello-world` |
| ...em segundo plano, com porta | `docker run -d --name site -p 8081:80 claude/nginx:alpine` |
| ...e entrar num terminal dentro | `docker run -it --rm claude/alpine:3.22 sh` |
| Ver os ligados | `docker ps` |
| Ver todos | `docker ps -a` |
| Desligar | `docker stop site` |
| Ligar de novo | `docker start site` |
| Apagar (desligado) | `docker rm site` |
| Apagar (ligado) | `docker rm -f site` |
| Apagar vários | `docker rm -f site1 site2` |
| Ver o log | `docker logs site` |
| Ver só o final do log | `docker logs --tail 10 site` |
| Acompanhar o log ao vivo (sair: `Ctrl + C`) | `docker logs -f site` |
| Entrar num container ligado | `docker exec -it site sh` |

## Dentro do container
| Comando | O que faz |
|---------|-----------|
| `ls` | Lista arquivos |
| `cat arquivo` | Mostra o conteúdo do arquivo |
| `echo "texto"` | Mostra o texto |
| `echo "texto" > arquivo` | Grava o texto no arquivo (substitui o conteúdo) |
| `hostname` | Mostra o nome da máquina (o ID do container) |
| `exit` | Sai do container |

## Imagens
| Quero... | Comando |
|----------|---------|
| Ver as imagens | `docker images` |
| Baixar | `docker pull busybox:1.37` |
| Dar outro nome (padrão do lab) | `docker tag busybox:1.37 claude/busybox:1.37` |
| Apagar | `docker rmi busybox:1.37` |

## Anatomia
```
docker run  -d  --name site  -p 8081:80  claude/nginx:alpine  sh
           └──────────── opções ───────┘ └──── imagem ─────┘ └ programa (opcional)
                                  │  │
                  porta do computador  porta do container
```

## Erros comuns
| Erro | Causa | Solução |
|------|-------|---------|
| `Cannot connect to the Docker daemon` | Docker desligado | `systemctl --user start docker` |
| `name ... is already in use` | Já existe container com esse nome | Use outro nome ou apague o antigo |
| `port is already allocated` / `address already in use` | Porta do computador ocupada | Troque o número da esquerda no `-p` |
| `container is running` (no `docker rm`) | Tentou apagar container ligado | `docker stop` antes, ou `docker rm -f` |
| `unable to delete ... is using its referenced image` | Algum container (mesmo parado) usa a imagem | Apague o container antes |
| `pull access denied ... repository does not exist` | A imagem não está no computador e não existe no Docker Hub | Confira o nome; para `claude/`, refaça `pull` + `tag` |
