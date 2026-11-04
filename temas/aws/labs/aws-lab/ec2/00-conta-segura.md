# Aula 00 — Antes de tudo: sua conta Free Tier

## 🎯 Nesta aula
- Descobrir **qual tipo de Free Tier** a sua conta tem (isso muda o que é grátis!).
- Escolher a **região**.
- Proteger a conta com **MFA**.
- Criar um **alerta de gastos** (Zero spend budget).
- Conhecer o **EC2 Global View** para achar recursos esquecidos.

Custo desta aula: **zero**.

---

## 📖 Aprenda: existem DOIS tipos de Free Tier

Em **15 de julho de 2025** a AWS mudou o Free Tier. O que vale para você depende da **data em que a conta foi criada**:

| | Conta criada **antes** de 15/07/2025 ("legado") | Conta criada **a partir de** 15/07/2025 ("Free plan") |
|---|---|---|
| Como funciona | Limites mensais grátis por **12 meses** (ex.: 750 horas/mês de instância) | **Créditos**: US$ 100 ao criar a conta + até **US$ 100** completando atividades |
| Duração | 12 meses | **6 meses** ou até acabarem os créditos (o que vier primeiro) |
| Tipos de instância grátis (**Free tier eligible**) | `t2.micro`, `t3.micro` | `t3.micro`, `t3.small`, `t4g.micro`, `t4g.small`, `c7i-flex.large`, `m7i-flex.large` |
| Passou do limite | Cobra no cartão (preço normal) | **Não passa**: o uso desconta dos créditos e o plano não deixa exceder |
| Quando acaba | Vira conta normal (paga) | A conta é **suspensa**. Você tem **90 dias** para mudar para o plano pago, senão a AWS **apaga a conta e tudo dentro** |

### Descubra o seu
1. Entre no console: https://console.aws.amazon.com
2. Na página inicial (**Console Home**), procure um quadro de **créditos / Free plan** ou o widget **Explore AWS**.
   - Se aparecer → você tem o **Free plan** (créditos).
   - Se não aparecer → provavelmente é **legado**. Confirme no **Billing and Cost Management** (procure "Billing" na
     barra de busca do topo) → **Free Tier**.
3. Anote no [PROGRESSO.md](PROGRESSO.md): tipo do plano e data de criação da conta.

> 💡 **Free plan:** o widget **Explore AWS** dá **US$ 20 por atividade**. Duas delas você vai fazer neste módulo:
> **criar um orçamento (Budgets)** (nesta aula) e **lançar uma instância EC2** (aula 02). São créditos extras de graça.

> ⚠️ **Conta legado:** o que passar dos limites gratuitos **cobra no cartão**. Este lab sempre usa opções dentro do
> limite, mas a limpeza no fim de cada aula é **obrigatória** para você.

---

## 📖 Aprenda: região

A AWS tem data centers no mundo todo, agrupados em **regiões** (ex.: `us-east-1` = Norte da Virgínia, EUA;
`sa-east-1` = São Paulo). Cada recurso que você cria **mora numa região**, e o console mostra **só a região selecionada**
(canto superior direito).

| Região | Vantagem | Desvantagem |
|--------|----------|-------------|
| **US East (N. Virginia)** `us-east-1` | Mais barata (os créditos rendem mais), tem tudo | Mais longe (um pouco mais de latência) |
| **South America (São Paulo)** `sa-east-1` | Perto de você | Preços bem mais altos |

**Recomendação do lab: use `us-east-1` (N. Virginia) em todas as aulas.** Assim tudo fica num lugar só, e é mais fácil
achar e apagar.

> 🚨 A armadilha clássica: criar algo numa região, trocar de região sem perceber, e achar que "sumiu". Continua lá,
> consumindo. Por isso existe o **EC2 Global View** (abaixo).

---

## 🛠️ Passo 1: MFA na conta root

A conta com que você se cadastrou (e-mail + senha) é a **root**: ela pode **tudo**, inclusive apagar a conta. Se alguém
roubar essa senha, pode criar máquinas caras em seu nome. **MFA** (autenticação em dois fatores) exige também um código
do celular.

1. Canto superior direito → clique no **nome da sua conta** → **Security credentials**.
2. Em **Multi-factor authentication (MFA)** → **Assign MFA device**.
3. Dê um nome (ex.: `celular`), escolha **Authenticator app**, e siga a tela: escaneie o QR code com um app
   autenticador (Google Authenticator, Microsoft Authenticator...) e digite **dois códigos seguidos**.

> 🔜 No módulo de **IAM** você vai criar um usuário próprio e parar de usar a root no dia a dia. Por enquanto, root + MFA.

## 🛠️ Passo 2: alerta de gastos (Zero spend budget)

Um **orçamento** que manda um **e-mail** assim que a conta gastar **qualquer centavo além do gratuito**.

1. Na barra de busca do topo, digite **Budgets** e abra (fica dentro do **Billing and Cost Management**).
2. **Create budget**.
3. Em **Budget setup**, escolha **Use a template (simplified)**.
4. Em **Templates**, escolha **Zero spend budget**.
5. Em **Email recipients**, coloque o seu e-mail.
6. **Create budget**.

> Free plan: isso conta como a atividade **"Set up a cost budget using AWS Budgets"** do **Explore AWS** (+ US$ 20).
> Confira no widget depois.

## 🛠️ Passo 3: conheça o EC2 Global View

Ele mostra **instâncias e outros recursos de EC2 de TODAS as regiões** numa tela só.
1. Na busca do topo, digite **EC2 Global View** e abra.
2. Por enquanto deve estar tudo zerado. Guarde esse caminho: ele aparece em toda **🧹 Limpeza**.

---

## ✍️ Pratique
1. Qual o tipo do seu Free Tier e quando ele acaba?
2. Troque a região para **US East (N. Virginia)** `us-east-1`.
3. Confirme que o MFA está ativo (em **Security credentials**, o dispositivo aparece na lista).
4. Confirme que o orçamento existe (**Budgets** → aparece o *Zero spend budget*).

## 🧠 Memorize
1. Qual a diferença entre o Free Tier "legado" e o "Free plan"?
2. Numa conta Free plan, o que acontece quando acabam os 6 meses?
3. Por que é perigoso criar recursos em regiões diferentes sem perceber?
4. O que o *Zero spend budget* faz?
5. Por que colocar MFA na root?

<details><summary>👀 Ver respostas</summary>

1. Legado (antes de 15/07/2025): limites mensais grátis por 12 meses, e o excesso é cobrado. Free plan: créditos (US$ 100 + até 100), 6 meses, sem passar do limite.
2. A conta é suspensa; há 90 dias para mudar para o plano pago antes de a AWS apagar a conta e os dados.
3. O console só mostra a região selecionada: o recurso "some" da tela mas continua existindo (e gastando). O EC2 Global View mostra todas.
4. Manda e-mail assim que houver qualquer gasto além do Free Tier.
5. A root pode tudo; MFA impede que uma senha vazada baste para invadir.
</details>

➡️ Próxima: [Aula 01 — Conceitos](01-conceitos.md)
