# Módulo 1 — EC2: servidores virtuais na AWS

**EC2** (*Elastic Compute Cloud*) é o serviço que aluga **computadores virtuais** na nuvem. Você escolhe o sistema,
o tamanho e a rede, liga em minutos, usa e desliga quando não precisar mais.

| Aula | Assunto | Tempo | Custo |
|------|---------|-------|-------|
| [00](00-conta-segura.md) | Antes de tudo: sua conta Free Tier, região, MFA e alerta de gastos | 30 min | 🟢 zero |
| [01](01-conceitos.md) | Conceitos: instância, AMI, tipo, região, EBS, security group... | 20 min | 🟢 zero |
| [02](02-primeira-instancia.md) | Sua primeira instância: lançar, explorar e apagar | 20 min | 🟢 centavos |
| [03](03-conectar.md) | Entrar na instância: pelo navegador e por SSH | 40 min | 🟢 centavos |
| [04](04-servidor-web.md) | Um site no ar com *User data* | 30 min | 🟢 centavos |
| [05](05-security-groups.md) | Security groups: o firewall da instância | 30 min | 🟢 centavos |
| [06](06-ciclo-de-vida-e-ip.md) | Parar, iniciar e o IP que muda (Elastic IP) | 30 min | 🟡 cuidado |
| [07](07-ebs.md) | Discos: volumes EBS e snapshots | 40 min | 🟡 cuidado |
| [08](08-ami.md) | Sua própria imagem (AMI) | 30 min | 🟡 cuidado |
| [09](09-docker-na-ec2.md) | Docker na EC2 (juntando com o Docker Lab) | 30 min | 🟢 centavos |
| [10](10-desafio-final.md) | Desafio final + limpeza total + prova | 60 min | 🟢 centavos |

📄 [COLA.md](COLA.md) · 🧹 [LIMPEZA.md](LIMPEZA.md) · 📈 [PROGRESSO.md](PROGRESSO.md)

> 🟢 cabe no Free Tier se você limpar no fim da aula · 🟡 tem um recurso que **cobra mesmo parado** se ficar esquecido

## Antes de começar
- Uma conta AWS (você já tem) e um navegador.
- O terminal do Ubuntu (WSL) para a aula 03 (SSH).
- **Faça a aula 00 primeiro.** Ela protege o seu bolso.

## Como estudar
Cada aula tem **📖 Aprenda**, **✍️ Pratique**, **🧹 Limpeza** e **🧠 Memorize**. Abra os `.md` no VS Code com
`Ctrl + Shift + V` para ver as respostas escondidas.
