# Aula 08 — Sua própria imagem (AMI)

## 🎯 Nesta aula
- Criar uma **AMI** a partir de uma instância já configurada.
- Lançar instâncias **prontas** a partir dela, sem *user data*.
- Apagar direito: **deregister** a AMI **e** apagar o **snapshot** dela (a armadilha desta aula).

Custo: 🟡 **centavos**, desde que você apague AMI **e** snapshot.

---

## 📖 Aprenda

Até aqui você usou AMIs da AWS (Amazon Linux). Você também pode criar a **sua**: uma "foto" de uma instância já configurada
(com nginx instalado, sua página etc.). Toda instância nova criada a partir dela **nasce pronta**.

```
 instância configurada ──Create image──► AMI ──Launch instance──► instâncias iguais, já prontas
                                          │
                                          └── por baixo, a AMI guarda um SNAPSHOT do disco (que cobra!)
```
> Paralelo com o Docker: é como fazer `docker commit` de um container que você configurou na mão. Funciona, mas o jeito
> profissional é automatizar (user data, ou ferramentas como Packer). Saber criar AMI ajuda a entender como as imagens funcionam.

---

## 🛠️ Passo a passo

**1.** Lance a `lab-modelo` com o site da aula 04 (user data do nginx) e um security group com HTTP liberado. Confira o site.

**2.** Entre na instância e personalize a página:
```bash
$ sudo sh -c 'echo "<h1>Vim de uma AMI própria! 📀</h1>" > /usr/share/nginx/html/index.html'
```

**3. Crie a imagem.** Selecione a `lab-modelo` → **Actions** → **Image and templates** → **Create image**:
- **Image name**: `lab-ami-site`
- **Create image**.

A instância **reinicia** durante a criação (para o disco ficar consistente). Isso é normal.

**4.** Acompanhe em **EC2** → **Images** → **AMIs**: o status vai de **Pending** para **Available** (alguns minutos).
Em **Elastic Block Store** → **Snapshots**, apareceu um snapshot novo: é o disco da AMI.

**5. Lance a partir dela.** **Launch instance**:
- **Name**: `lab-clone`
- **Application and OS Images** → aba **My AMIs** → **Owned by me** → `lab-ami-site`
- Instance type **Free tier eligible**, `lab-chave`, o **mesmo security group** com HTTP
- **Sem** user data
- **Launch instance**

**6.** Abra o IP da `lab-clone`: aparece **"Vim de uma AMI própria! 📀"** sem você ter configurado nada. 🎉

---

## 🧹 Limpeza (obrigatória, e não esqueça o snapshot!)
**7.** Termine `lab-modelo` e `lab-clone`.

**8.** **AMIs** → selecione `lab-ami-site` → **Actions** → **Deregister AMI** → confirme.

**9.** **Snapshots** → o snapshot da AMI **continua lá** (deregister não apaga!). Selecione → **Actions** → **Delete snapshot**.

> 🚨 Essa é a armadilha: muita gente faz o *deregister*, acha que limpou, e o snapshot fica cobrando por meses.

**10.** Confira **AMIs** (em **Owned by me**), **Snapshots** e **Instances** vazios.

## 🧠 Memorize
1. O que é uma AMI própria e para que serve?
2. Por que a instância reinicia ao criar a imagem?
3. Onde escolho a minha AMI ao lançar uma instância?
4. Fiz o *Deregister AMI*. Terminei a limpeza?

<details><summary>👀 Ver respostas</summary>

1. Uma imagem criada a partir de uma instância configurada; instâncias novas já nascem prontas.
2. Para o disco ficar consistente na "foto" (nada sendo escrito no meio).
3. **Application and OS Images** → **My AMIs** → **Owned by me**.
4. Não. Falta apagar o **snapshot** da AMI em **Elastic Block Store → Snapshots**.
</details>

➡️ Próxima: [Aula 09 — Docker na EC2](09-docker-na-ec2.md)
