# Aula 02 — Sua primeira instância

## 🎯 Nesta aula
Lançar uma instância usando os padrões do assistente, encontrar e entender a instância, e **apagá-la**.
Custo: **centavos** (alguns minutos ligada), dentro do Free Tier.

> Baseado no tutorial oficial *"Launch my very first Amazon EC2 instance"* da AWS.

---

## 📖 Aprenda: o assistente de lançamento

Hoje o assistente (*launch instance wizard*) é uma **página única**, com seções empilhadas e um painel **Summary** à
direita:

| Seção | Para quê |
|-------|----------|
| **Name and tags** | O nome da instância |
| **Application and OS Images (Amazon Machine Image)** | A AMI (sistema operacional) |
| **Instance type** | O tamanho |
| **Key pair (login)** | A chave para entrar por SSH |
| **Network settings** | Rede, IP público e security group |
| **Configure storage** | O disco (EBS) |
| **Advanced details** | Opções avançadas, incluindo **User data** (lá embaixo) |
| **Summary** (à direita) | Resumo, quantidade de instâncias e o botão **Launch instance** |

---

## 🛠️ Passo a passo

**1.** Confira a região no topo: **US East (N. Virginia)**.

**2.** Busque **EC2** na barra do topo e abra. No painel (**EC2 Dashboard**), clique em **Launch instance**.

**3. Name and tags** → **Name**: `lab-primeira`

**4. Application and OS Images** → aba **Quick Start** → **Amazon Linux**. Confirme que a AMI selecionada é
**Amazon Linux 2023 AMI** e que ela tem a etiqueta **Free tier eligible**.

**5. Instance type** → confira se o tipo escolhido tem a etiqueta **Free tier eligible**:
- **Free plan** (conta nova): `t3.micro` (se vier outro elegível, também serve).
- **Conta legado**: `t2.micro` ou `t3.micro`.

> ⚠️ **Conta legado + `t3.micro`:** a `t3.micro` liga em modo **Unlimited** por padrão, que **pode cobrar** CPU extra se
> a máquina ficar muito ocupada. Para ficar 100% seguro, em **Advanced details** → **Credit specification**, escolha
> **Standard**. (No Free plan não há esse risco de cobrança: só consome créditos.)

**6. Key pair (login)** → em **Key pair name**, escolha **Proceed without a key pair (Not recommended)**. Hoje não vamos
entrar na máquina (isso é a aula 03).

**7.** Deixe **Network settings** e **Configure storage** como estão (os padrões são seguros para um teste).

**8.** No **Summary**, confira **Number of instances: 1** e clique em **Launch instance**. Aparece um banner **Success**. 🎉

---

## 🛠️ Encontrando e entendendo a instância

**9.** Clique em **Instances** no menu da esquerda (ou no link do banner). Veja a sua `lab-primeira`.

**10.** Observe a coluna **Instance state**: `Pending` → `Running`. E a coluna **Status check**: espere aparecer
**3/3 checks passed** (as checagens de saúde da AWS).

**11.** Clique no **Instance ID** (começa com `i-`) para abrir os detalhes. Encontre:
- **Instance type** (ex.: `t3.micro`);
- **Public IPv4 address** (ex.: `3.85.12.34`);
- **Availability Zone** (ex.: `us-east-1c`), na aba **Networking**;
- **Launch time**, na aba **Details**;
- a tag **Name**, na aba **Tags**;
- o **volume** (disco) na aba **Storage**: tamanho (8 GiB) e tipo (gp3).

---

## 🧹 Limpeza (obrigatória)

**12.** Com a instância selecionada: **Instance state** (canto superior direito) → **Terminate (delete) instance** →
confirme em **Terminate (delete)**.

**13.** O estado vira `Shutting-down` e depois `Terminated`. A instância ainda aparece na lista por um tempo e depois
some sozinha. Isso é normal.

**14. Free plan:** confira o widget **Explore AWS** na Console Home: a atividade **"Launch an instance using Amazon EC2"**
deve contar a seu favor (+ US$ 20). Pode levar um tempo para atualizar.

> 🔎 **E o security group?** O assistente criou um chamado `launch-wizard-1`. Security group **não cobra nada**, mas
> vamos aprender a limpar na aula 05.

---

## ✍️ Pratique (repita para fixar)
1. Lance de novo, agora com o nome `lab-repeticao`, e **sem** olhar o passo a passo.
2. Descubra a **AZ** e o **IP público** dela.
3. Termine a instância.
4. Abra o **EC2 Global View** e confirme que não há nenhuma instância `running` ou `stopped` em nenhuma região.

## 🧠 Memorize
1. Em qual seção do assistente fica o **User data**?
2. Onde aparece a etiqueta que garante que a opção é gratuita?
3. Qual o caminho para apagar uma instância?
4. O que significa `3/3 checks passed`?
5. Depois de terminada, a instância some da lista na hora?

<details><summary>👀 Ver respostas</summary>

1. **Advanced details** (no final).
2. **Free tier eligible**, na AMI e no tipo de instância.
3. **Instance state** → **Terminate (delete) instance** → **Terminate (delete)**.
4. As checagens de saúde da AWS passaram: a instância está pronta.
5. Não: ela fica visível como `Terminated` por um tempo e depois some.
</details>

➡️ Próxima: [Aula 03 — Entrar na instância](03-conectar.md)
