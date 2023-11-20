from flask import Blueprint, request, jsonify
import cx_Oracle

from globals import GLOBAL_VARS

caja = Blueprint("caja", __name__)

# TEST ROUTE CAJA
@caja.route("/")
def home():
    return "caja home"

# GET ALL CAJAS
# Este método no requiere ningún parametro
# La ruta para consultar es /caja/getAll
@caja.route("/getAll")
def getAllCajas():
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.BuscarCajas",(out_cursor,))
        result = out_cursor.getvalue()
        cajas = []

        for row in result:
            caja = {
            "caja_id" : row[0],
            "numero_caja" : row[1]
            }
            cajas.append(caja)

        return jsonify({'mensaje': 'Todas las cajas recuperadas', 'cajas': cajas}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar todas las cajas', 'error': str(ex)})

# GET CAJA BY ID
# La ruta para este metodo es /caja/getById/id 
# El parametro id en la ruta es el numero a consultar 
# Ejemplo: http://127.0.0.1:5000/caja/getById/1
@caja.route("/getById/<id>")
def getCajaById(id):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.BuscarCaja",(id,out_cursor,))
        result = out_cursor.getvalue()
        cajas = []

        for row in result:
            caja = {
            "caja_id" : row[0],
            "numero_caja" : row[1]
            }
            cajas.append(caja)

        return jsonify({'mensaje': 'Caja recuperada por ID', 'cajas': cajas}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar la caja por ID', 'error': str(ex)})
    

# UPDATE CAJA BY ID
# La ruta de este metodo es /caja/update
# Este metodo recibe un json con dos parametros caja_id el 
# y numero_de_caja este será el dato a actualizar
@caja.route("/update", methods=["PUT"])
def updateCaja():
    data = request.get_json()
    id = data.get('caja_id')
    numero_caja = data.get('numero_de_caja')

    try:
        id = int(id)
        numero_caja = int(numero_caja)

        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.ActualizarCaja",(id, numero_caja))
        cursor.execute("COMMIT")

        return jsonify({'mensaje': 'Caja actualizada por ID'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al actulizar la caja por ID', 'error': str(ex)})

# INSERT CAJA 
# La ruta para este metodo es /caja/insert 
# Este metodo recibe un json con un parametro numero_de_caja  
# Ejemplo: http://127.0.0.1:5000/caja/insert
@caja.route("/insert", methods=["POST"])
def insertCaja():
    data = request.get_json()
    numero_caja = data.get('numero_de_caja')

    try:
        # Asegúrate de que numero_caja sea un número
        numero_caja = int(numero_caja)

        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.InsertarCaja", (numero_caja,))
        cursor.execute("COMMIT")

        return jsonify({'mensaje': 'Caja insertada'}), 200
    except ValueError:
        return jsonify({'mensaje': 'Error al insertar la caja', 'error': 'El valor de numero_de_caja no es un número entero válido.'})
    except Exception as ex:
        return jsonify({'mensaje': 'Error al insertar la caja', 'error': str(ex)})

# DELETE CAJA BY ID 
# La ruta para este metodo es /caja/delete 
# Este metodo recibe un json con un parametro caja_id  
# Ejemplo: http://127.0.0.1:5000/caja/delete/id
@caja.route("/delete/<id>", methods=["DELETE"])
def deleteCaja(id):

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.BorrarCaja", (id,))
        cursor.execute("COMMIT")

        return jsonify({'mensaje': 'Caja eliminada'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al eliminar la caja', 'error': str(ex)})

