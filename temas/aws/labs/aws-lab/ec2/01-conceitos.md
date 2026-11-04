# Aula 01 — Conceitos

## 🎯 Nesta aula
As palavras que aparecem em **todas** as telas de EC2. Sem console ainda: só entender. Custo: **zero**.

---

## 📖 Aprenda: as peças de uma instância

```
                       ┌──────────── Região us-east-1 ─────────────┐
                       │  ┌─────── Zona de disponibilidade a ────┐ │
   você ──► IP público ─┼─►│  🔥 Security group (firewall)       │ │
   (SSH, navegador)    │  │     ┌──────────────────────────┐    │ │
                       │  │     │ 🖥️ INSTÂNCIA (t3.micro)  │    │ │
                       │  │     │  criada a partir de uma  │    │ │
                       │  │     │  📀 AMI (Amazon Linux)   │    │ │
                       │  │     │  ──────────────────────  │    │ │
                       │  │     │  💽 Volume EBS (disco)   │    │ │
                       │  │     └──────────────────────────┘    │ │
                       │  └───────────────────────────────────────┘ │
                       └─────────────────────────────────────────────┘
```

| Termo | O que é | Paralelo com o Docker Lab |
|-------|---------|----------------------------|
| **Instância** | Um computador virtual rodando na AWS | Um **container** (mas é uma máquina inteira, com sistema operacional próprio) |
| **AMI** (*Amazon Machine Image*) | O "molde" do disco: sistema operacional + programas | Uma **imagem** |
| **Tipo de instância** (`t3.micro`...) | O "tamanho": CPU, memória, rede | — |
| **EBS** (*Elastic Block Store*) | O **disco** da instância. Sobrevive a desligar a máquina | Um **volume** |
| **Security group** | O **firewall**: quais portas aceitam conexão, e de quem | O `-p` do `docker run`, mas com controle de quem pode entrar |
| **Key pair** | Par de chaves SSH para entrar na instância | A sua chave SSH do GitLab |
| **IP público** | Endereço para acessar a instância pela internet | `localhost:8080` |
| **Região** / **Zona de disponibilidade (AZ)** | Região = cidade da AWS; AZ = um data center dentro dela (`us-east-1a`, `us-east-1b`...) | — |
| **User data** | Script que roda **uma vez**, quando a instância liga pela primeira vez | O `RUN`/`CMD` de um Dockerfile, mais ou menos |

### Lendo o nome de um tipo de instância
```
 t  3  .  micro
 │  │     └── tamanho: nano < micro < small < medium < large < xlarge...
 │  └──────── geração (quanto maior, mais nova)
 └─────────── família: t = uso geral "com picos" (barata), c = CPU, m = equilibrada, r = memória
```
`t4g.micro` → o **g** é de **Graviton**, processador ARM da AWS (mais barato, mas os programas precisam ser feitos para ARM).

---

## 📖 Aprenda: os estados de uma instância (e quando cobra)

```
 pending ──► running ──► stopping ──► stopped ──► (start) ──► pending ──► running
                │                         │
                └──── shutting-down ──► terminated   (apagada para sempre)
```
| Estado | Significa | Cobra a **instância**? | Cobra o **disco (EBS)**? |
|--------|-----------|------------------------|--------------------------|
| `running` | Ligada | ✅ Sim, por segundo | ✅ Sim |
| `stopped` | Desligada (dá para ligar de novo) | ❌ Não | ✅ **Sim!** O disco continua existindo |
| `terminated` | **Apagada** | ❌ Não | ❌ Não (o disco principal é apagado junto, por padrão) |

> 🚨 **Desligar (stop) não é apagar.** Uma instância parada esquecida continua cobrando o disco. No fim de cada aula,
> o certo é **terminar** (apagar).

E o **IP público**? Desde 2024 a AWS **cobra por endereço IPv4 público** (cerca de US$ 0,005 por hora). Para quem tem
o Free Tier **legado**, as primeiras 750 horas por mês são grátis; no **Free plan**, isso desconta dos créditos.
É pouco, mas é mais um motivo para **não deixar nada ligado à toa**.

---

## 🧠 Memorize
1. Qual o paralelo entre AMI e instância no Docker?
2. O que é o EBS?
3. Para que serve o security group?
4. Uma instância `stopped` gera custo? E uma `terminated`?
5. O que significa o "g" em `t4g.micro`?
6. O que é *user data*?

<details><summary>👀 Ver respostas</summary>

1. AMI = imagem; instância = container (uma máquina virtual completa, na verdade).
2. O disco da instância.
3. É o firewall: define quais portas e quais origens podem se conectar.
4. Parada: não cobra a instância, mas **cobra o disco EBS**. Terminada: não cobra (o disco principal é apagado junto).
5. Processador Graviton (ARM) da AWS.
6. Um script que roda na primeira inicialização da instância.
</details>

➡️ Próxima: [Aula 02 — Sua primeira instância](02-primeira-instancia.md)
