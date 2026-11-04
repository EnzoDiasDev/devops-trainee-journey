# ☁️ AWS Lab

> 📖 **Sobre este lab:** material de estudo que montei com apoio do Claude (assistente de IA), em formato de aulas. Menções a "avisar o Claude" vêm desse fluxo de estudo; você pode ignorá-las.
>
> **Pré-requisitos:** uma conta AWS com **Free Tier** e noções básicas de terminal. A aula [00 — conta segura](ec2/00-conta-segura.md) explica como proteger a conta antes de criar qualquer recurso.
>
> ⚠️ Recursos criados na AWS podem gerar **cobrança**. Siga o bloco **🧹 Limpeza** no fim de cada aula.

Aprender AWS **por serviço**, na prática, numa conta **Free Tier**, sem tomar susto na fatura.
Mesmo formato dos outros labs: cada aula ensina tudo antes de cobrar, e as respostas ficam escondidas.

| Módulo | Serviço | Status |
|--------|---------|--------|
| 1 | [EC2: servidores virtuais](ec2/README.md) | ✅ disponível |
| 2 | IAM: usuários, permissões e o fim do uso da conta root | 🔒 em breve |
| 3 | S3: armazenamento de arquivos | 🔒 em breve |
| 4 | VPC: redes na AWS | 🔒 em breve |
| 5 | RDS: banco de dados gerenciado | 🔒 em breve |
| 6 | Lambda: código sem servidor | 🔒 em breve |

> Terminou um módulo? Avise o Claude para liberar o próximo.

## 💰 A regra número 1 deste lab
**Tudo que você cria, você apaga no fim da aula.** Toda aula termina com um bloco **🧹 Limpeza**, e existe um
[checklist geral de limpeza](ec2/LIMPEZA.md). Na AWS, recurso esquecido vira cobrança (ou consome os seus créditos).

## 📌 Combinados
- **Nomes do console** aparecem em **negrito** e em inglês, exatamente como na tela (o console pode estar em português
  se você mudar o idioma, mas o lab usa inglês, que é como a documentação e o mercado usam).
- O lab foi conferido com a documentação oficial da AWS em **outubro de 2026**. A AWS muda o console com frequência:
  se algum botão estiver diferente, mande um print para o Claude que ele atualiza a aula.
- Comandos de terminal aparecem com `$` na frente (não digite o `$`).
