# Aula 06 — Parar, iniciar e o IP que muda

## 🎯 Nesta aula
- **Stop**, **Start**, **Reboot** e o que acontece com o disco e o IP.
- **Elastic IP**: um IP público fixo, e por que ele é a maior armadilha de custo deste módulo.

Custo: 🟡 **centavos, desde que você libere o Elastic IP no fim.**

---

## 📖 Aprenda: o que muda em cada ação

| Ação (menu **Instance state**) | A máquina | O disco (EBS) | O IP público | Cobra |
|--------------------------------|-----------|---------------|--------------|-------|
| **Reboot instance** | Reinicia | Mantém | **Mantém** | Como ligada |
| **Stop instance** | Desliga | **Mantém** (seus arquivos ficam) | **Perde**: ao ligar de novo, vem **outro** IP | Só o disco |
| **Start instance** | Liga de novo | O mesmo | **Novo** IP | Como ligada |
| **Terminate (delete) instance** | Apagada | Apagado (o disco principal) | Liberado | Nada |

> O IP público "normal" é **emprestado**: a AWS devolve para o estoque quando a máquina para. Para um site, isso é um
> problema, porque o endereço muda.

## 📖 Aprenda: Elastic IP

Um **Elastic IP** é um IP público que fica **reservado na sua conta** até você liberar. Você o **associa** a uma instância
e ele não muda mais, mesmo depois de stop/start.

| | IP público normal | Elastic IP |
|---|---|---|
| Muda no stop/start | ✅ Muda | ❌ Fixo |
| Cobra | Sim (por hora, enquanto existe) | **Sim, por hora, enquanto existir na conta, mesmo sem uso** |

> 🚨 **A armadilha:** apagar a instância **não** apaga o Elastic IP. Ele fica na conta, sem uso, **cobrando por hora**
> (ou consumindo créditos) para sempre, até você **liberar (Release)**. É o recurso esquecido mais comum de quem começa.

---

## 🛠️ Parte 1: stop e start

**1.** Lance a `lab-ciclo` com o site da aula 04 (e o security group `lab-web`, se você criou, ou um novo com HTTP).
Anote o **Public IPv4 address**.

**2.** Entre pelo **Instance Connect** e crie um arquivo:
```bash
$ echo "eu sobrevivo ao stop" > ~/teste.txt
```

**3.** **Instance state** → **Stop instance** → **Stop**. Espere **Stopped**. Repare: o campo **Public IPv4 address** ficou vazio.

**4.** **Instance state** → **Start instance**. Espere **Running**. O IP é **outro**? E o site, abre no IP novo?

**5.** Entre de novo e rode `cat ~/teste.txt`: o arquivo continua lá (está no disco EBS).

## 🛠️ Parte 2: Elastic IP

**6.** **EC2** → **Network & Security** → **Elastic IPs** → **Allocate Elastic IP address** → **Allocate**.

**7.** Com o IP selecionado: **Actions** → **Associate Elastic IP address** → **Instance**: `lab-ciclo` → **Associate**.

**8.** Volte à instância: o **Public IPv4 address** agora é o Elastic IP. Abra o site nele.

**9.** Faça **Stop** e **Start** de novo. O IP continua o **mesmo**? ✅

---

## 🧹 Limpeza (obrigatória, e NESTA ORDEM)
**10.** **Elastic IPs** → selecione → **Actions** → **Disassociate Elastic IP address** → **Disassociate**.

**11.** **Actions** → **Release Elastic IP addresses** → **Release**. A lista de Elastic IPs deve ficar **vazia**.

**12.** Termine a `lab-ciclo`.

**13.** Confira no **EC2 Global View** que não sobrou nada.

> 💡 Se você terminar a instância antes, o Elastic IP fica **desassociado**. Basta ir direto ao passo 11 (**Release**).

---

## ✍️ Pratique
1. Responda olhando o console: depois de um **Reboot**, o IP muda?
2. Uma instância **parada** há uma semana. O que ela está custando?
3. Repita a parte 2 do começo ao fim, sem olhar, incluindo a limpeza na ordem certa.

<details><summary>👀 Ver respostas</summary>

1. Não. Só stop/start troca o IP (reboot mantém).
2. O disco EBS (e um Elastic IP, se houver algum associado ou não). A máquina em si não cobra parada.
3. Allocate → Associate → teste → Disassociate → Release → Terminate.
</details>

## 🧠 Memorize
1. O que acontece com o IP público num stop/start? E num reboot?
2. O que acontece com os arquivos do disco num stop?
3. O que é um Elastic IP?
4. Terminei a instância. O Elastic IP foi junto?
5. Qual o último passo para não pagar por um Elastic IP?

<details><summary>👀 Ver respostas</summary>

1. Stop/start: troca de IP. Reboot: mantém.
2. Ficam: o disco EBS continua existindo.
3. Um IP público fixo, reservado na conta até ser liberado.
4. Não! Ele fica na conta, desassociado e cobrando.
5. **Release Elastic IP addresses**.
</details>

➡️ Próxima: [Aula 07 — Discos: EBS e snapshots](07-ebs.md)
