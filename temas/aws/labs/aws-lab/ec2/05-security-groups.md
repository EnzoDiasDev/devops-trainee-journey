# Aula 05 — Security groups: o firewall da instância

## 🎯 Nesta aula
- Como funcionam as regras de entrada (**inbound**) e saída (**outbound**).
- Trocar o "SSH aberto para o mundo" por **só o seu IP** + o **Instance Connect**.
- Ver uma regra mudar o acesso **na hora**.
- Apagar security groups que sobraram.

Custo: **centavos** (uma instância por ~30 minutos).

---

## 📖 Aprenda: regras

Um **security group** é uma lista de regras do tipo **"aceite conexões na porta X vindas de Y"**:

| Campo | Exemplo | Significa |
|-------|---------|-----------|
| **Type** | `SSH` (porta 22), `HTTP` (80), `HTTPS` (443) | O serviço / porta |
| **Source** | `0.0.0.0/0` | **Qualquer lugar** da internet (IPv4) |
| | `203.0.113.10/32` | **Só esse IP** (o `/32` quer dizer "exatamente este endereço") |
| | `com.amazonaws.us-east-1.ec2-instance-connect` | Uma **prefix list**: a lista de IPs do serviço EC2 Instance Connect, mantida pela AWS |

Regras importantes:
- **Tudo que não está liberado é bloqueado.** Não existe regra de "negar": só de "permitir".
- **Inbound** = quem pode **entrar**. **Outbound** = para onde a instância pode **sair** (o padrão libera tudo).
- É **stateful**: se uma conexão entrou, a resposta sai sozinha, sem precisar de regra de saída.
- Mudanças valem **na hora**, sem reiniciar nada.
- Um security group pode ser usado por **várias** instâncias.

### Por que SSH "Anywhere" é ruim?
Robôs varrem a internet o tempo todo tentando entrar pela porta 22. Com **Anywhere (0.0.0.0/0)**, todos eles podem tentar.
Com **My IP**, só a sua rede chega na porta 22.

> ⚠️ Mas se você deixar **só** o seu IP, o **Instance Connect do navegador** para de funcionar: ele chega na sua instância a
> partir dos IPs **da AWS**, e não do seu. Por isso a regra certa é: **seu IP + a prefix list do Instance Connect**.

> 🏢 Em uma rede corporativa, o "seu IP" é o IP de **saída da rede** (compartilhado por todos os que a usam). Se você
> mudar de rede (por exemplo, trabalhar de casa), o IP muda e você precisa atualizar a regra.

---

## 🛠️ Passo a passo

**1.** Lance a `lab-firewall` como na aula 04 (Amazon Linux 2023, Free tier eligible, key pair `lab-chave`,
**Allow HTTP traffic from the internet** marcado, mesmo *user data* do nginx). Confira que o site abre.

**2. Ache o security group dela:** abra a instância → aba **Security** → clique no nome do security group
(algo como `launch-wizard-3`). Você cai em **EC2 → Network & Security → Security Groups**.

**3.** Veja a aba **Inbound rules**: há uma regra **SSH / 0.0.0.0/0** e uma **HTTP / 0.0.0.0/0**.

**4. Feche o SSH.** **Edit inbound rules**:
- Na regra **SSH**, troque o **Source** para o **seu IP**. A coluna **Source** tem **duas caixas**: a da esquerda é uma
  lista (*Custom*, *Anywhere-IPv4*, *Anywhere-IPv6*, **My IP**) e a da direita é de digitar/buscar. Escolha **My IP** na
  da esquerda.
  > Se o **My IP** não aparecer: descubra seu IP rodando `curl https://checkip.amazonaws.com` no WSL (ou abrindo esse
  > endereço no navegador), deixe a caixa da esquerda em **Custom** e digite na da direita o IP com **`/32`** no fim,
  > por exemplo `203.0.113.10/32`. Tem o mesmo efeito.
- **Add rule** → **Type**: `SSH` → no campo de **Source**, digite `ec2-instance-connect` e escolha
  **`com.amazonaws.us-east-1.ec2-instance-connect`** (a de IPv4).
- **Save rules**.

**5. Teste:**
- **Connect** → **EC2 Instance Connect** → funciona? ✅ (por causa da prefix list)
- SSH pelo terminal (`ssh -i ~/.ssh/lab-chave.pem ec2-user@<IP>`) → funciona se a sua rede libera a porta 22 ✅

**6. Prove que vale na hora.** **Edit inbound rules** → **Delete** na regra **HTTP** → **Save rules**. Atualize o site no
navegador: ele para de abrir (fica carregando até dar erro). Adicione de volta (**Add rule** → **HTTP** → **Anywhere-IPv4**)
e veja o site voltar, sem reiniciar nada.

---

## 🧹 Limpeza (obrigatória)
**7.** Termine a `lab-firewall`.

**8. Apague os security groups que sobraram.** O assistente cria um `launch-wizard-N` a cada lançamento. Eles não cobram,
mas viram bagunça. **Security Groups** → selecione os `launch-wizard-*` → **Actions** → **Delete security groups** → confirme.
- Não dá para apagar um grupo **em uso** por uma instância (nem por uma `terminated` que ainda aparece na lista: espere ela sumir).
- O grupo chamado **`default`** não pode ser apagado: ele é da rede padrão. Deixe ele lá.

---

## ✍️ Pratique
1. Crie um security group **antes** de lançar a instância: **Security Groups** → **Create security group**:
   **Security group name** `lab-web`, uma **Description**, e **Inbound rules**: HTTP de Anywhere-IPv4, SSH de **My IP** e SSH da prefix
   list do Instance Connect. **Create security group**.
2. Lance uma instância com o site da aula 04 usando **Select existing security group** → `lab-web`.
3. Confirme: site abre, Instance Connect funciona.
4. Limpe: termine a instância e, quando ela sumir da lista, apague o `lab-web` e os `launch-wizard-*`.

## 🧠 Memorize
1. O que significa `0.0.0.0/0` numa regra?
2. Existe regra de "negar" num security group?
3. Por que o Instance Connect do navegador parou ao deixar o SSH só para "My IP"?
4. Preciso reiniciar a instância depois de mudar uma regra?
5. Por que não consigo apagar um security group?

<details><summary>👀 Ver respostas</summary>

1. Qualquer endereço IPv4 da internet.
2. Não. Só regras de permissão; o resto é bloqueado.
3. O Instance Connect conecta a partir dos IPs da AWS. É preciso liberar a prefix list `com.amazonaws.<região>.ec2-instance-connect`.
4. Não, vale na hora.
5. Ele está em uso por alguma instância (inclusive uma terminada que ainda aparece), ou é o grupo `default`.
</details>

➡️ Próxima: [Aula 06 — Parar, iniciar e o IP que muda](06-ciclo-de-vida-e-ip.md)
