import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/** Guarda as contas e salva os saldos num arquivo (no container, dentro do volume). */
public class Banco {

    private final Map<String, Conta> contas = new TreeMap<>();
    private final Path arquivo;

    public Banco(Path arquivo) {
        this.arquivo = arquivo;
        carregar();
    }

    public Conta conta(String nome) {
        if (nome == null || nome.isBlank()) {
            throw new IllegalArgumentException("Informe o nome da conta");
        }
        return contas.computeIfAbsent(nome.trim().toLowerCase(), Conta::new);
    }

    public Collection<Conta> todas() {
        return contas.values();
    }

    public void salvar() {
        List<String> linhas = new ArrayList<>();
        for (Conta conta : contas.values()) {
            linhas.add(conta.getTitular() + "=" + conta.getSaldo());
        }
        try {
            Files.createDirectories(arquivo.toAbsolutePath().getParent());
            Files.write(arquivo, linhas);
        } catch (IOException erro) {
            throw new UncheckedIOException(erro);
        }
    }

    private void carregar() {
        if (!Files.exists(arquivo)) {
            return;
        }
        try {
            for (String linha : Files.readAllLines(arquivo)) {
                String[] partes = linha.split("=");
                conta(partes[0]).restaurar(Double.parseDouble(partes[1]));
            }
        } catch (IOException erro) {
            throw new UncheckedIOException(erro);
        }
    }
}
