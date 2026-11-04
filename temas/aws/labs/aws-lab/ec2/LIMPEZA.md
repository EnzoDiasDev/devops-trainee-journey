# 🧹 Checklist de limpeza do EC2

Rode no fim de **toda** aula e sempre que estiver em dúvida. Faça **na ordem** (algumas coisas só podem ser apagadas
depois de outras).

**Região:** confira que está em **US East (N. Virginia)**. No fim, confira **todas** pelo **EC2 Global View**.

| # | Onde (menu da esquerda do EC2) | O que fazer | Por que cobra |
|---|-------------------------------|-------------|---------------|
| 1 | **Network & Security → Elastic IPs** | Selecione → **Actions** → **Disassociate Elastic IP address** (se associado) → **Actions** → **Release Elastic IP addresses** | Cobra por hora enquanto existir, **mesmo sem uso** |
| 2 | **Instances** | Selecione todas → **Instance state** → **Terminate (delete) instance** → **Terminate (delete)** | Instância ligada cobra por segundo; parada cobra o disco |
| 3 | **Images → AMIs** (filtro **Owned by me**) | Selecione → **Actions** → **Deregister AMI** | A AMI segura um snapshot |
| 4 | **Elastic Block Store → Snapshots** | Selecione os seus → **Actions** → **Delete snapshot** | Cobra por GB por mês |
| 5 | **Elastic Block Store → Volumes** | Os que estão **Available** (soltos) → **Actions** → **Delete volume** | Cobra por GB por mês, mesmo solto |
| 6 | **Network & Security → Security Groups** | Apague os `launch-wizard-*` e os seus (**Actions** → **Delete security groups**). **Não** apague o `default` | Não cobra, mas acumula bagunça |
| 7 | **Network & Security → Key Pairs** | Opcional: apague os que não vai mais usar | Não cobra |
| 8 | Busca do topo → **EC2 Global View** | Confirme **zero** instâncias, volumes e Elastic IPs em **todas** as regiões | Recursos em outras regiões não aparecem na tela normal |
| 9 | Busca do topo → **Billing and Cost Management** | No dia seguinte, confira se não apareceu custo inesperado (ou consumo estranho de créditos) | A fatura demora algumas horas para atualizar |

> 💡 Terminou uma instância e ela ainda aparece como `terminated`? É normal: ela some sozinha em pouco tempo, e não cobra
> nada nesse estado. Se um security group "está em uso" por ela, espere ela sumir para apagar.
