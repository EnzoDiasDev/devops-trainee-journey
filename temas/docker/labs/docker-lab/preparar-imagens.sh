#!/usr/bin/env bash
# Prepara as imagens-base usadas nos labs de Docker e Git.
#
# Os exercícios usam nomes como `claude/nginx:alpine`. Esse prefixo `claude/` é um
# apelido LOCAL (não existe no Docker Hub): este script baixa a imagem oficial e cria
# o apelido com `docker tag`, para que todos os comandos dos exercícios funcionem.
#
# Uso:  bash preparar-imagens.sh
set -euo pipefail

# formato: "imagem-oficial  apelido-usado-nos-labs"
IMAGENS=(
  "nginx:alpine                    claude/nginx:alpine"
  "alpine:3.22                     claude/alpine:3.22"
  "busybox:1.37                    claude/busybox:1.37"
  "hello-world:latest              claude/hello-world:latest"
  "python:3.13-alpine              claude/python:3.13-alpine"
  "postgres:18-alpine              claude/postgres:18-alpine"
  "redis:8                         claude/redis:8"
  "eclipse-temurin:25-jdk-alpine   claude/temurin:25-jdk-alpine"
)

for linha in "${IMAGENS[@]}"; do
  read -r oficial apelido <<< "$linha"
  echo "==> $oficial  ->  $apelido"
  docker pull "$oficial"
  docker tag "$oficial" "$apelido"
done

echo
echo "Pronto. Confira com:  docker images | grep '^claude/'"
