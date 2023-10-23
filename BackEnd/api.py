from flask import Flask, request, jsonify
from flask_cors import CORS
import cx_Oracle

import os
import jwt
from datetime import datetime, timedelta
from functools import wraps

app = Flask(__name__)
CORS(app)

# variable global DB
DB_CONNECTION = None

# default route


@app.route("/")
def home():
    return "Home"


ALG_KEY = os.getenv("ALG_KEY")
SECRET_KEY = os.getenv("SECRET_KEY")


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        # jwt is passed in the request header
        if 'Authorization' in request.headers:
            token = request.headers['Authorization']
        # return 401 if token is not passed
        if not token:
            return jsonify({'message': 'Token is missing !!'}), 401

        token = token[7:]

        try:
            # decoding the payload to fetch the stored details
            current_user = jwt.decode(token, SECRET_KEY, algorithm=ALG_KEY)

        except Exception as e:
            print(e)
            return jsonify({
                'message': 'Token is invalid !!'
            }), 401
        # returns the current logged in users context to the routes
        return f(current_user, *args, **kwargs)

    return decorated


def search_user(user, password):

    global DB_CONNECTION

    DB_CONNECTION = cx_Oracle.connect(
        user=user,
        password=password,
        dsn='localhost:1521/xe',
        encoding='UTF-8',
        # mode = cx_Oracle.SYSDBA
    )
    cursor = DB_CONNECTION.cursor()
    out_cursor = cursor.var(cx_Oracle.CURSOR)

    # obtener id y rol de usuario
    cursor.callproc("SYS.BuscarDatosUsuario",
                    (user.upper(), out_cursor))

    # Recuperar los resultados del cursor de salida
    result = out_cursor.getvalue()

    user_data = {}

    for row in result:
        user_data["id"] = row[0]
        user_data["usuario"] = user
        user_data["rol"] = row[1]

    cursor.close()

    return user_data


@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    user = data.get('usuario')
    password = data.get('clave')

    try:
        user_data = search_user(user, password)

        token = jwt.encode({
            'id': user_data["id"],
            'user': user_data["usuario"],
            'rol': user_data["rol"],
            'exp': datetime.utcnow() + timedelta(minutes=30)
        }, SECRET_KEY, ALG_KEY)

        return jsonify({'mensaje': 'Conexion con la DB exitosa', 'usuario': user_data, 'token': token}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al conectar con la DB', 'error': str(ex)})


@app.route("/logout")
def logout():
    try:
        global DB_CONNECTION
        DB_CONNECTION.close()
        DB_CONNECTION = None

        return jsonify({'mensaje': 'Logout exitoso'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al hacer logout', 'error': str(ex)})


@app.get("/home")
@token_required
def protected_message():
    return {"summary": "Ok"}


# main
if __name__ == "__main__":
    app.run(debug=True)
