# Aula 02 — Colocar seus arquivos na imagem

## 🎯 Nesta aula
- `COPY`: copiar arquivos do seu computador para dentro da imagem.
- Ver com os próprios olhos que o arquivo **viaja dentro da imagem**.

---

## 📖 Aprenda: `COPY`

```dockerfile
COPY ola.py /ola.py
     └─┬──┘ └──┬──┘
    origem   destino
```
| Parte | Significado |
|-------|-------------|
| **origem** | Arquivo no **seu computador**, na pasta onde você rodou o `docker build` |
| **destino** | Onde ele vai ficar **dentro da imagem** (`/ola.py` = na raiz do Linux da imagem) |

O `COPY` acontece durante o **build**: o Docker pega o arquivo e grava uma **cópia** dentro da imagem.

---

## 📖 Aprenda: seu primeiro script Python numa imagem

Você não precisa saber Python: os scripts do lab vêm prontos. Basta saber que `print("...")` mostra um texto.

```bash
$ cd ~/Projects/docker-lab/nivel-2/pratica
$ mkdir aula-02
$ cd aula-02
$ code .
```

Crie o arquivo **`ola.py`**:
```python
print("Olá do Python dentro do container!")
```

Crie o **`Dockerfile`**:
```dockerfile
FROM claude/python:3.13-alpine
COPY ola.py /ola.py
CMD ["python", "/ola.py"]
```
Lendo linha por linha:
1. Parta de uma imagem que **já tem Python**.
2. Copie o meu `ola.py` para dentro dela, em `/ola.py`.
3. Quando um container nascer, rode `python /ola.py`.

```bash
$ docker build -t claude/ola-python:1.0 .
$ docker run --rm claude/ola-python:1.0
```
`Olá do Python dentro do container!` 🐍

### Espiando dentro da imagem
Troque o comando por um terminal e procure o arquivo:
```bash
$ docker run -it --rm claude/ola-python:1.0 sh
# ls /
# cat /ola.py
# exit
```
O `ola.py` está lá dentro, na raiz.

---

## 🔬 Experimento: o arquivo viaja dentro da imagem

Lembra da dúvida "como a imagem sabe dos arquivos no pc de outra pessoa"? Vamos provar.

**1.** Apague o `ola.py` da sua pasta (no VS Code: botão direito no arquivo → *Delete*) e confira:
```bash
$ ls
```
Só sobrou o `Dockerfile`.

**2.** Rode a imagem:
```bash
$ docker run --rm claude/ola-python:1.0
```
**Funciona!** O container usa a cópia que foi guardada na imagem durante o build. A sua pasta não é mais consultada.

**3.** Agora tente construir de novo:
```bash
$ docker build -t claude/ola-python:1.0 .
```
**Erro:** `"/ola.py": not found`. Faz sentido: no **build** o `COPY` precisa do arquivo, e ele não existe mais.

**4.** Crie o `ola.py` de novo (mesmo conteúdo) e construa novamente para deixar tudo certo.

| Momento | Precisa do arquivo na sua pasta? |
|---------|----------------------------------|
| `docker build` (o `COPY` roda aqui) | ✅ Sim |
| `docker run` | ❌ Não. Usa a cópia que está na imagem |

---

## ✍️ Pratique

1. Na pasta `aula-02`, crie um arquivo `tchau.py` com:
   ```python
   print("Tchau! Até a próxima aula.")
   ```
   Altere o Dockerfile para **também** copiar o `tchau.py` para `/tchau.py` (uma linha de `COPY` a mais).
   Mantenha o `CMD` rodando o `ola.py`. Construa como `claude/ola-python:1.1`.
2. Rode a `1.1` normalmente. Qual script rodou?
3. Rode a `1.1` executando o `tchau.py` em vez do padrão (troque o comando no `docker run`).
4. Entre na `1.1` com um terminal e confirme que os dois arquivos estão na raiz.
5. A imagem `1.0` tem o `tchau.py`? Confira entrando nela.

<details><summary>👀 Ver respostas</summary>

1. Dockerfile:
   ```dockerfile
   FROM claude/python:3.13-alpine
   COPY ola.py /ola.py
   COPY tchau.py /tchau.py
   CMD ["python", "/ola.py"]
   ```
   ```bash
   $ docker build -t claude/ola-python:1.1 .
   ```
2. `docker run --rm claude/ola-python:1.1` → o `ola.py` (é o `CMD`).
3. `docker run --rm claude/ola-python:1.1 python /tchau.py`
4. ```bash
   $ docker run -it --rm claude/ola-python:1.1 sh
   # ls /
   # exit
   ```
5. Não. A `1.0` foi construída antes de o `tchau.py` existir. Cada imagem guarda os arquivos **do
   momento em que foi construída**. Confira com `docker run -it --rm claude/ola-python:1.0 sh` e `ls /`.
</details>

---

## 🧠 Memorize

1. O que faz `COPY app.py /app.py`? Qual parte é do seu computador e qual é da imagem?
2. Em que momento o `COPY` acontece: no build ou no run?
3. Apaguei o arquivo original depois do build. O container ainda funciona? E um novo build?
4. Como rodar o script `/outro.py` de uma imagem cujo `CMD` roda outro script?

<details><summary>👀 Ver respostas</summary>

1. Copia o `app.py` do seu computador (origem) para `/app.py` dentro da imagem (destino).
2. No build.
3. O container funciona (usa a cópia da imagem). O novo build falha (`not found`).
4. `docker run --rm <imagem> python /outro.py`
</details>

➡️ Próxima: [Aula 03 — Pasta de trabalho e comandos no build](03-workdir-e-run.md)
