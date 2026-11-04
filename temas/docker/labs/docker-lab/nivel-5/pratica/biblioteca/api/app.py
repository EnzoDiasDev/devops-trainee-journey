import os

import psycopg
from flask import Flask, jsonify, request
from markupsafe import escape

app = Flask(__name__)


@app.after_request
def liberar_portal(resposta):
    resposta.headers["Access-Control-Allow-Origin"] = os.getenv(
        "PORTAL_ORIGEM", "http://localhost:8086"
    )
    return resposta


def conectar():
    return psycopg.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user="postgres",
        password=os.getenv("DB_SENHA", ""),
        connect_timeout=3,
    )


def preparar_tabela(conexao):
    conexao.execute("CREATE TABLE IF NOT EXISTS livros (titulo TEXT)")
    conexao.execute(
        "ALTER TABLE livros ADD COLUMN IF NOT EXISTS "
        "registrado_em TIMESTAMPTZ DEFAULT now()"
    )


@app.route("/")
def acervo():
    with conectar() as conexao:
        preparar_tabela(conexao)
        livros = conexao.execute(
            "SELECT titulo, to_char(registrado_em, 'DD/MM/YYYY HH24:MI:SS') "
            "FROM livros ORDER BY registrado_em"
        ).fetchall()
    itens = "".join(
        f"<li>{escape(titulo)} <small>({registrado_em or 'sem data'})</small></li>"
        for titulo, registrado_em in livros
    )
    return f"<h1>📚 Acervo</h1><p>{len(livros)} livro(s)</p><ul>{itens}</ul>"


@app.route("/livros", methods=["POST"])
def adicionar_livro():
    dados = request.get_json(silent=True) or request.form
    titulo = (dados.get("titulo") or "").strip()
    if not titulo:
        return jsonify(erro="O campo 'titulo' é obrigatório"), 400

    with conectar() as conexao:
        preparar_tabela(conexao)
        conexao.execute("INSERT INTO livros (titulo) VALUES (%s)", (titulo,))
    return jsonify(titulo=titulo), 201