from flask import Flask
from flask_cors import CORS

from usuario import usuario
from producto import producto
from caja import caja
from pfresco import pfresco

app = Flask(__name__)
CORS(app)

#rutas
app.register_blueprint(usuario,url_prefix="/usuario")
app.register_blueprint(producto,url_prefix="/producto")
app.register_blueprint(caja,url_prefix="/caja")
app.register_blueprint(pfresco,url_prefix="/pfresco")

# test route
@app.route("/")
def home():
    return "main home"

# main
if __name__ == "__main__":
    app.run(debug=True)
