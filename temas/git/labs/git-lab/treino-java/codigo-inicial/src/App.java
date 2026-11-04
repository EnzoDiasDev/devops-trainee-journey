import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/** API HTTP do Enzo Bank. Tudo funciona pelo navegador, com endereços simples. */
public class App {

    static final String NOME = System.getenv().getOrDefault("BANCO_NOME", "Enzo Bank");
    static final String TOKEN_ADMIN = System.getenv().getOrDefault("TOKEN_ADMIN", "");
    static Banco banco;

    public static void main(String[] args) throws IOException {
        banco = new Banco(Path.of(System.getenv().getOrDefault("ARQUIVO_DADOS", "dados/contas.txt")));
        HttpServer servidor = HttpServer.create(new InetSocketAddress(8080), 0);

        rota(servidor, "/", p -> inicio());
        rota(servidor, "/saldo", p -> {
            Conta conta = banco.conta(p.get("conta"));
            return "Saldo de " + conta.getTitular() + ": " + Conta.formatar(conta.getSaldo());
        });
        rota(servidor, "/depositar", p -> {
            Conta conta = banco.conta(p.get("conta"));
            conta.depositar(valor(p));
            return "Depósito feito. Saldo de " + conta.getTitular() + ": " + Conta.formatar(conta.getSaldo());
        });
        rota(servidor, "/sacar", p -> {
            Conta conta = banco.conta(p.get("conta"));
            conta.sacar(valor(p));
            return "Saque feito. Saldo de " + conta.getTitular() + ": " + Conta.formatar(conta.getSaldo());
        });
        rota(servidor, "/transferir", p -> {
            Conta origem = banco.conta(p.get("de"));
            Conta destino = banco.conta(p.get("para"));
            origem.transferir(destino, valor(p));
            return "Transferência feita. Saldo de " + origem.getTitular() + ": " + Conta.formatar(origem.getSaldo());
        });
        rota(servidor, "/extrato", p -> extrato(banco.conta(p.get("conta"))));
        rota(servidor, "/admin/contas", p -> {
            if (TOKEN_ADMIN.isEmpty() || !TOKEN_ADMIN.equals(p.get("token"))) {
                throw new IllegalArgumentException("Token de administrador inválido");
            }
            StringBuilder lista = new StringBuilder("Todas as contas:\n");
            for (Conta conta : banco.todas()) {
                lista.append("  ").append(conta.getTitular()).append(": ")
                        .append(Conta.formatar(conta.getSaldo())).append("\n");
            }
            return lista.toString();
        });

        servidor.start();
        System.out.println(NOME + " no ar na porta 8080");
    }

    static String inicio() {
        return "🏦 " + NOME + "\n"
                + "\n"
                + "Experimente no navegador:\n"
                + "  /saldo?conta=ana\n"
                + "  /depositar?conta=ana&valor=100\n"
                + "  /sacar?conta=ana&valor=30\n"
                + "  /transferir?de=ana&para=bruno&valor=10\n"
                + "  /extrato?conta=ana\n";
    }

    static String extrato(Conta conta) {
        StringBuilder texto = new StringBuilder("Extrato de " + conta.getTitular() + ":\n");
        for (String linha : conta.getExtrato()) {
            texto.append("  ").append(linha).append("\n");
        }
        texto.append("  Saldo: ").append(Conta.formatar(conta.getSaldo()));
        return texto.toString();
    }

    static double valor(Map<String, String> p) {
        try {
            return Double.parseDouble(p.get("valor"));
        } catch (NullPointerException | NumberFormatException erro) {
            throw new IllegalArgumentException("Informe um valor numérico, ex.: &valor=100");
        }
    }

    // ---------- daqui para baixo: detalhes do servidor HTTP (não precisa mexer) ----------

    static void rota(HttpServer servidor, String caminho, Function<Map<String, String>, String> acao) {
        servidor.createContext(caminho, troca -> {
            String resposta;
            int status = 200;
            try {
                resposta = acao.apply(parametros(troca.getRequestURI().getRawQuery()));
                banco.salvar();
            } catch (IllegalArgumentException erro) {
                resposta = "Operação recusada: " + erro.getMessage();
                status = 400;
            }
            byte[] corpo = (resposta + "\n").getBytes(StandardCharsets.UTF_8);
            troca.getResponseHeaders().set("Content-Type", "text/plain; charset=utf-8");
            troca.sendResponseHeaders(status, corpo.length);
            try (OutputStream saida = troca.getResponseBody()) {
                saida.write(corpo);
            }
        });
    }

    static Map<String, String> parametros(String query) {
        Map<String, String> mapa = new HashMap<>();
        if (query == null) {
            return mapa;
        }
        for (String par : query.split("&")) {
            String[] partes = par.split("=", 2);
            if (partes.length == 2) {
                mapa.put(partes[0], URLDecoder.decode(partes[1], StandardCharsets.UTF_8));
            }
        }
        return mapa;
    }
}
