from flask import Flask, request, jsonify
from flask_cors import CORS
import cx_Oracle

app = Flask(__name__)
CORS(app) 

# variable global DB
DB_CONNECTION = None

# default route
@app.route("/")
def home():
    return "Home"


# login
@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    usuario = data.get('usuario')
    clave = data.get('clave')

    try:
        global DB_CONNECTION
        DB_CONNECTION = cx_Oracle.connect(
            user=usuario,
            password=clave,
            dsn='localhost:1521/xe',
            encoding='UTF-8',
            # mode = cx_Oracle.SYSDBA
        )
        cursor = DB_CONNECTION.cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        # obtener id y rol de usuario
        cursor.callproc("SYS.BuscarDatosUsuario",
                        (usuario.upper(), out_cursor))

        # Recuperar los resultados del cursor de salida
        result = out_cursor.getvalue()

        userData = {}
        for row in result:
            userData["id"] = row[0]
            userData["usuario"] = usuario
            userData["rol"] = row[1]
        cursor.close()

        return jsonify({'mensaje': 'Conexion con la DB exitosa', 'usuario': userData}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al conectar con la DB', 'error': str(ex)})

# logout
@app.route("/logout")
def logout():
    try:
        global DB_CONNECTION
        DB_CONNECTION.close()
        DB_CONNECTION = None

        return jsonify({'mensaje': 'Logout exitoso'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al hacer logout', 'error': str(ex)})


# main
if __name__ == "__main__":
    app.run(debug=True)
