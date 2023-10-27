from flask import Flask
from flask_cors import CORS

from usuario import usuario
from producto import producto

app = Flask(__name__)
CORS(app)

#rutas
app.register_blueprint(usuario,url_prefix="/usuario")
app.register_blueprint(producto,url_prefix="/producto")

# test route
@app.route("/")
def home():
    return "main home"

# main
if __name__ == "__main__":
    app.run(debug=True)
