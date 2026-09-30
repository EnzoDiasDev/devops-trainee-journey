# Caderno de estudos git para Treinee DevOps - D5

## Aquecimento

No seu repo, rode <code>git log --oneline --graph --all</code>. Você vai ver o merge com <code>--allow-unrelated-histories</code> que fez lá atrás, com duas linhas de histórico se juntando. Tente explicar esse desenho no caderno; é a primeira ponte com o Learn Git Branching.

*  (HEAD -> main, origin/main) Adiciona estudos do dia 2 de Linux
*  Adiciona estudos do dia 1 de Linux
*  Merge branch 'main' of https://github.com/EnzoDiasDev/devops-trainee-journey
|\ 
| * Add entries to .gitignore for system and secrets
| * Revise README for DevOps Trainee Journey
| * Initial commit
* bd543d6 Dia 1: fundamentos de Linux

**RESPOSTA**: Como o repositório remoto já havia se iniciado com arquivos diferentes dos quais existiam no repositório local (sem contar que localmente eu já tinha feito alguns commits) então foi necessário juntar essas duas "branches" para que não ouvesse conflitos.

**Correção**: O repositório remoto e o local foram criados separadamente, cada um com seu próprio primeiro commit, então não tinham nenhum histórico em comum. O Git bloqueia o merge nesse caso, e o --allow-unrelated-histories libera a junção. Ele não evita conflitos: só não houve conflito porque os arquivos dos dois lados eram diferentes.

## Learn Git Branching

### Nível 2 - Branches no Git

Branches no Git também são incrivelmente leves. Elas são simplesmente referências a um commit específico -- e nada mais. É por isso que muitos entusiastas do Git entoam o mantra:

```ramifique cedo, ramifique sempre```

Devido a não existir sobrecarga de armazenamento / memória associada à criação de branches, é mais fácil dividir logicamente o seu trabalho do que ter branches grandes e gordas.


Comandos do nível 2:
- git checkout <nome-da-branch> = serve para trocar de branch (dá para criar e trocar ao mesmo tempo com a flag -b) ou restaurar arquivos (git checkout -- nome-do-arquivo)
  - Aparentemente o git checkout por ter várias funções e ser sobrecarregado, existe também o comando <code>git switch</code> para trocar de branches


### Nível 3 - Branches e Merge

precisamos aprender uma forma de combinar o trabalho de duas branches diferentes. Isso nos permitirá ramificar, desenvolver um novo recurso, e então combiná-lo de volta.

O primeiro método para combinar trabalho que vamos examinar é o git merge. O merge do Git cria um commit especial que possui dois pais únicos. Um commit com dois pais essencialmente significa "Quero incluir todo o trabalho deste pai aqui com o daquele outro pai ali, e com o do conjunto de todos os seus ancestrais."

Comandos do nível 3:
- git merge <nome-da-branch> = faz a combinação de dois históricos de commits de duas branches diferentes. Você executa na **BRANCH DE DESTINO**, ou seja, a que irá receber as mudanaças.
  - Exemplo:
    ```git
      git checkout main
      git merge feature-login
    ```
    Isso integra todos os commits de featura-login em main