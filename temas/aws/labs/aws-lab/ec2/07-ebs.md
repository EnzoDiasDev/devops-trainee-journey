# Aula 07 — Discos: volumes EBS e snapshots

## 🎯 Nesta aula
- Criar um **disco extra** (volume EBS), **anexar**, **formatar** e **montar** numa instância.
- Fazer um **snapshot** (backup do disco) e **restaurar**.
- Apagar tudo, porque volume e snapshot **cobram mesmo sem instância**.

Custo: 🟡 **centavos**, desde que você apague volumes e snapshots no fim.

---

## 📖 Aprenda

| Termo | O que é | Paralelo |
|-------|---------|----------|
| **Volume EBS** | Um disco virtual. Mora numa **zona de disponibilidade** (AZ) e só pode ser anexado a instâncias **da mesma AZ** | Um HD externo |
| **Anexar** (*attach*) | Ligar o volume a uma instância | Plugar o HD no USB |
| **Formatar** | Criar um sistema de arquivos no disco vazio (só na primeira vez!) | Formatar um pen drive |
| **Montar** (*mount*) | Fazer o disco aparecer numa pasta do Linux | Abrir o pen drive no Explorer |
| **Snapshot** | Uma **cópia** do volume num momento (backup). Dá para criar volumes novos a partir dele | Uma foto do disco |

> No Free Tier **legado**: até 30 GB de EBS e 1 GB de snapshots por mês são grátis. No **Free plan**, desconta dos créditos.
> Em ambos: **volume e snapshot esquecidos cobram todo mês**.

---

## 🛠️ Parte 1: um disco extra

**1.** Lance a `lab-disco` (Amazon Linux 2023, Free tier eligible, `lab-chave`). Abra a instância e anote a
**Availability Zone** (aba **Networking**), ex.: `us-east-1c`.

**2.** **EC2** → **Elastic Block Store** → **Volumes** → **Create volume**:
- **Volume type**: `gp3`
- **Size (GiB)**: `1`
- **Availability Zone**: **a mesma da instância** (ex.: `us-east-1c`)
- **Create volume**. Espere o estado **Available**.

**3.** Selecione o volume novo → **Actions** → **Attach volume**:
- **Instance**: `lab-disco`
- **Device name**: `/dev/sdf` (o primeiro da lista de sugestões, de `/dev/sdf` a `/dev/sdp`)

→ **Attach volume**. O estado vira **In-use**.

> 💡 O *device name* é o "apelido" do disco no cadastro da AWS. Na `t3`/`t4g` o Linux **não** usa esse nome: o disco
> aparece como `/dev/nvme1n1` (você vai ver no passo 4). Só não use `/dev/xvda`, que é o disco principal da instância.

**4.** Entre na instância (**Instance Connect**) e veja o disco novo:
```bash
$ lsblk
```
```
NAME          SIZE TYPE MOUNTPOINTS
nvme0n1         8G disk
├─nvme0n1p1     8G part /
nvme1n1         1G disk          ← o seu disco novo, ainda sem pasta
```
**5. Formate e monte** (o nome pode ser outro: use o que apareceu com `1G`):
```bash
$ sudo mkfs -t xfs /dev/nvme1n1        # ⚠️ formata: apaga o que tiver no disco. Só no disco NOVO!
$ sudo mkdir /dados                    # cria a pasta onde o disco vai aparecer
$ sudo mount /dev/nvme1n1 /dados       # "pluga" o disco na pasta
$ df -h /dados                         # confere: ~1 GB
$ sudo sh -c 'echo "dados importantes" > /dados/arquivo.txt'
$ cat /dados/arquivo.txt
```
| Comando | O que faz |
|---------|-----------|
| `lsblk` | Lista os discos e partições |
| `mkfs -t xfs <disco>` | Formata com o sistema de arquivos XFS (o padrão do Amazon Linux) |
| `mount <disco> <pasta>` | Faz o disco aparecer na pasta |
| `umount <pasta>` | Desmonta (o contrário) |

> 🚨 **Nunca** rode o `mkfs` no disco principal (`nvme0n1`): ele apagaria o sistema.

---

## 🛠️ Parte 2: snapshot e restauração

**6.** **Volumes** → selecione o disco de 1 GiB → **Actions** → **Create snapshot** → **Description**: `lab backup` →
**Create snapshot**. Acompanhe em **Elastic Block Store** → **Snapshots** até ficar **Completed**.

**7. Simule um desastre:** na instância, `sudo rm /dados/arquivo.txt`, depois `sudo umount /dados`. No console,
**Volumes** → selecione o disco → **Actions** → **Detach volume** → **Detach** → (quando ficar **Available**)
**Actions** → **Delete volume** → **Delete**. O disco foi embora. 😱

**8. Restaure:** **Snapshots** → selecione o `lab backup` → **Actions** → **Create volume from snapshot** →
**Availability Zone**: a da instância → **Create volume**. Depois **Attach volume** na `lab-disco`, com o **Device name** `/dev/sdf` de novo.

**9.** Na instância (**não formate de novo!**, o disco já tem dados):
```bash
$ lsblk
$ sudo mount /dev/nvme1n1 /dados
$ cat /dados/arquivo.txt        # "dados importantes" voltou! 🎉
```
O snapshot foi tirado **antes** do `rm`, então o arquivo está lá.

---

## 🧹 Limpeza (obrigatória)
**10.** Termine a `lab-disco`. (O volume extra **não** é apagado junto: só o disco principal tem *Delete on termination*.)

**11.** **Volumes** → apague os volumes que sobraram (estado **Available**).

**12.** **Snapshots** → selecione `lab backup` → **Actions** → **Delete snapshot** → **Delete**.

**13.** Confira **Volumes** e **Snapshots** vazios (só podem sobrar os da instância que ainda estiver sumindo).

## 🧠 Memorize
1. Posso anexar um volume de `us-east-1a` numa instância de `us-east-1c`?
2. Quando eu uso o `mkfs`? E quando NÃO uso?
3. Para que serve o snapshot?
4. Terminei a instância. O volume extra foi apagado?
5. Que dois recursos desta aula cobram mesmo sem nenhuma instância?

<details><summary>👀 Ver respostas</summary>

1. Não. Volume e instância precisam estar na mesma AZ.
2. Só num disco novo e vazio. Nunca num disco com dados (ou restaurado de snapshot), nem no disco principal.
3. Backup do volume; dá para criar volumes novos a partir dele, até em outra AZ.
4. Não. Só o disco principal tem *Delete on termination* ligado por padrão.
5. Volumes EBS soltos e snapshots.
</details>

➡️ Próxima: [Aula 08 — Sua própria imagem (AMI)](08-ami.md)
