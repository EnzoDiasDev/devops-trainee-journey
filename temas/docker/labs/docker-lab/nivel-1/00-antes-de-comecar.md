# Aula 00 — Antes de começar

## 🎯 Nesta aula
- O mínimo de terminal para fazer o lab.
- O que é **imagem** e o que é **container** (a ideia mais importante do Docker).

---

## 📖 Aprenda: o terminal

O terminal é onde você digita comandos. No seu caso, abra o **Ubuntu** pelo menu Iniciar do Windows
(ou pelo terminal integrado do VS Code).

### As 3 teclas que mais importam
| Tecla | O que faz |
|-------|-----------|
| `Enter` | Executa o comando que você digitou |
| `↑` (seta para cima) | Traz de volta o comando anterior. Aperte várias vezes para voltar mais |
| `Ctrl + C` | **Interrompe** o comando que está rodando (use quando o terminal "travar" mostrando algo sem parar) |

### Copiar e colar no terminal
No terminal, `Ctrl + C` **não copia**: ele interrompe. Para copiar e colar use:
- `Ctrl + Shift + C` → copiar
- `Ctrl + Shift + V` → colar
- ou clique com o botão direito do mouse

### 3 comandos de terminal que você vai usar
| Comando | O que faz | Exemplo |
|---------|-----------|---------|
| `ls` | **Lista** os arquivos e pastas onde você está | `ls` |
| `cd` | **Entra** numa pasta | `cd Projects` |
| `cd ..` | **Volta** uma pasta | `cd ..` |
| `cd ~` | Volta para a sua pasta inicial (use quando se perder) | `cd ~` |
| `clear` | Limpa a tela (nada é apagado, só a tela fica limpa) | `clear` |

Experimente:
```bash
$ ls
$ cd Projects
$ ls
$ cd ..
$ clear
```

> Lembre: o `$` só indica que é um comando. **Não digite o `$`.**

---

## 📖 Aprenda: imagem × container

Pense em **receita de bolo** e **bolo**:

| | Docker | Analogia |
|---|--------|----------|
| **Imagem** | Um pacote pronto com um programa e tudo que ele precisa para funcionar | A **receita** |
| **Container** | O programa **rodando**, criado a partir da imagem | O **bolo** feito com a receita |

Coisas importantes que saem dessa analogia:
- Com **uma** receita você faz **vários** bolos → com **uma** imagem você cria **vários** containers.
- Comer um bolo não estraga a receita → **apagar um container não apaga a imagem**.
- Cada bolo é independente → mexer num container não muda os outros.

### Por que isso é útil?
Sem Docker, para rodar um programa você precisa instalar ele e tudo de que ele depende no seu
computador (e torcer para as versões combinarem). Com Docker, a imagem já vem com tudo dentro:
você só manda rodar. Funciona igual no seu computador, no do seu colega e no servidor.

---

## 📖 Aprenda: o comando `docker`

Todo comando do Docker começa com a palavra `docker`, seguida do que você quer fazer:

```
docker  version
└─┬──┘  └──┬──┘
 programa  o que fazer
```

Teste se o Docker está funcionando:
```bash
$ docker version
```
Se aparecerem duas partes, **Client** e **Server**, está tudo certo. ✅

> Se aparecer `Cannot connect to the Docker daemon`, o Docker está desligado. Ligue com:
> ```bash
> $ systemctl --user start docker
> ```

---

## ✍️ Pratique

1. Abra o terminal, entre na pasta `Projects` e liste o que tem dentro.
2. Entre na pasta `docker-lab` (ela fica dentro de `Projects`) e liste o que tem dentro.
3. Volte uma pasta.
4. Use a seta `↑` para repetir o `ls` sem digitar de novo.
5. Rode `docker version` e limpe a tela em seguida.

<details><summary>👀 Ver respostas</summary>

```bash
$ cd Projects
$ ls
$ cd docker-lab
$ ls
$ cd ..
# aperte ↑ até aparecer "ls" e dê Enter
$ docker version
$ clear
```
</details>

---

## 🧠 Memorize

1. Qual a diferença entre imagem e container?
2. Apagar um container apaga a imagem dele?
3. Qual tecla interrompe um comando que está rodando?
4. Qual comando volta uma pasta?

<details><summary>👀 Ver respostas</summary>

1. Imagem é o pacote pronto (a receita). Container é o programa rodando a partir dela (o bolo).
2. Não.
3. `Ctrl + C`.
4. `cd ..`
</details>

➡️ Próxima: [Aula 01 — Primeiro container](01-primeiro-container.md)
