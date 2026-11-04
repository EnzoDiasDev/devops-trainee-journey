import os

import psycopg
from flask import Flask

app = Flask(__name__)


@app.route("/")
def inicio():
    with psycopg.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user="postgres",
        password=os.getenv("DB_SENHA", ""),
        connect_timeout=3,
    ) as conexao:
        conexao.execute("CREATE TABLE IF NOT EXISTS visitas (quando TIMESTAMP DEFAULT now())")
        conexao.execute("INSERT INTO visitas DEFAULT VALUES")
        total = conexao.execute("SELECT count(*) FROM visitas").fetchone()[0]
    return f"<h1>Contador da FlushStore! 🦈</h1><p>Você é a visita número {total}.</p>"