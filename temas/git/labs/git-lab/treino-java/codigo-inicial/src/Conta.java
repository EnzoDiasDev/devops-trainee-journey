import java.util.ArrayList;
import java.util.List;

public class Conta {

    private final String titular;
    private double saldo;
    private final List<String> extrato = new ArrayList<>();

    public Conta(String titular) {
        this.titular = titular;
    }

    public String getTitular() {
        return titular;
    }

    public double getSaldo() {
        return saldo;
    }

    public List<String> getExtrato() {
        return extrato;
    }

    public void depositar(double valor) {
        saldo += valor;
        extrato.add("Depósito: " + formatar(valor));
    }

    public void sacar(double valor) {
        saldo -= valor;
        extrato.add("Saque: " + formatar(valor));
    }

    public void transferir(Conta destino, double valor) {
        double taxa = 0.0;
        sacar(valor + taxa);
        destino.depositar(valor);
    }

    /** Usado ao carregar os dados salvos: volta o saldo sem registrar uma operação nova. */
    void restaurar(double saldoSalvo) {
        saldo = saldoSalvo;
        extrato.add("Saldo anterior: " + formatar(saldoSalvo));
    }

    static String formatar(double valor) {
        return String.format("R$ %.2f", valor);
    }
}
