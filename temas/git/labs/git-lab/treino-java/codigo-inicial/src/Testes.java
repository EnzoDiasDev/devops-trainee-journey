/**
 * Testes do Enzo Bank. Rode com:  java src/Testes.java
 * (ou, com Docker:  docker compose run --rm --build api java src/Testes.java)
 * Para adicionar um teste, cole-o antes da linha "// FIM DOS TESTES".
 */
public class Testes {

    static int falhas = 0;

    public static void main(String[] args) {
        // conta nova começa zerada
        Conta nova = new Conta("Teste");
        verificar("conta nova começa com saldo zero", nova.getSaldo() == 0);

        // depósito
        Conta c1 = new Conta("Teste");
        c1.depositar(100);
        verificar("depósito aumenta o saldo", c1.getSaldo() == 100);

        // saque
        Conta c2 = new Conta("Teste");
        c2.depositar(100);
        c2.sacar(30);
        verificar("saque diminui o saldo", c2.getSaldo() == 70);

        // transferência
        Conta origem = new Conta("Origem");
        Conta destino = new Conta("Destino");
        origem.depositar(200);
        origem.transferir(destino, 50);
        verificar("transferência credita o destino", destino.getSaldo() == 50);

        // FIM DOS TESTES

        System.out.println();
        if (falhas == 0) {
            System.out.println("✅ Todos os testes passaram!");
        } else {
            System.out.println("❌ " + falhas + " teste(s) falharam.");
            System.exit(1);
        }
    }

    static void verificar(String nome, boolean passou) {
        System.out.println((passou ? "  ✔ " : "  ✘ ") + nome);
        if (!passou) {
            falhas++;
        }
    }

    static void deveDarErro(String nome, Runnable acao) {
        try {
            acao.run();
            verificar(nome, false);
        } catch (IllegalArgumentException erro) {
            verificar(nome, true);
        }
    }
}
