from flask import Blueprint, request, jsonify
from datetime import datetime
import cx_Oracle

from globals import GLOBAL_VARS

factura = Blueprint("factura", __name__)

# TEST ROUTE FACTURA
@factura.route("/")
def home():
    return "Factura home"

# GET ALL FACTURA
# Este método no requiere ningún parametro
# La ruta para consultar es /factura/getAll
@factura.route("/getAll")
def getAllFacturas():
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getAllFactura",(out_cursor,))
        result = out_cursor.getvalue()
        facturas = []
        print(result)

        for row in result:
            factura = {
            "factura_id" : row[0],
            "numero_factura" : row[1],
            "monto_total" : row[2],
            "fecha" : row[3].strftime('%Y-%m-%d'),   #Le damos formato a la fecha
            "hora" : row[4].strftime('%I:%M:%S %p'), #Le damos formato a la hora
            "cajero_id" : row[5],
            "caja_id" : row[6]
            }
            facturas.append(factura)

        #cursor.close()

        return jsonify({'mensaje': 'Todas las facturas recuperadas', 'facturas': facturas}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar todas las facturas', 'error': str(ex)})

# GET FACTURA BY ID
# La ruta para este metodo es /factura/getById/id 
# El parametro id en la ruta es el numero a consultar 
# Ejemplo: http://127.0.0.1:5000/factura/getById/1
@factura.route("/getById/<id>")
def getFacturaById(id):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getFacturaById",(id,out_cursor,))
        result = out_cursor.getvalue()
        facturas = []
        print(result)

        for row in result:
            factura = {
                "factura_id" : row[0],
                "numero_factura" : row[1],
                "monto_total" : row[2],
                "fecha" : row[3].strftime('%Y-%m-%d'),   #Le damos formato a la fecha
                "hora" : row[4].strftime('%I:%M:%S %p'), #Le damos formato a la hora
                "cajero_id" : row[5],
                "caja_id" : row[6]
            }
            facturas.append(factura)

        #cursor.close()

        return jsonify({'mensaje': 'Factura recuperada por ID', 'Factura': facturas}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar la factura por ID', 'error': str(ex)})

# UPDATE FACTURA BY ID
# La ruta de este metodo es /factura/update 
# Este metodo recibe un json con estos parametros: 
# factura_id, numero_factura, monto_total, fecha, hora, cajero_id y caja_id
# factura_id es el unico dato que no se actualiza.
@factura.route("/update", methods=["PUT"])
def updateFactura():
    data = request.get_json()
    factura_Id = data.get('factura_id')
    new_num_factura = data.get('numero_factura')
    new_monto_total = data.get('monto_total')
    new_fecha = datetime.strptime(data.get('fecha'), '%Y-%m-%d')
    new_hora = datetime.strptime(data.get('hora'), '%Y-%m-%d %H:%M:%S')
    new_cajero_id = data.get('cajero_id')
    new_caja_id = data.get('caja_id')

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.updateFactura", (factura_Id, new_num_factura, new_monto_total, new_fecha, new_hora, new_cajero_id, new_caja_id))
        cursor.execute("COMMIT")
        
        return jsonify({'mensaje': 'Factura actualizada por Id'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al actualizar la factura fresco por Id', 'error': str(ex)})
    
# INSERT FACTURA
# La ruta para este metodo es /factura/insert 
# Este metodo recibe un json con estos parametros: 
# numero_factura, monto_total, fecha, hora, cajero_id y caja_id
# Ejemplo: http://127.0.0.1:5000/factura/insert
@factura.route("/insert", methods=["POST"])
def insertFactura():
    data = request.get_json()
    num_factura = data.get('numero_factura')
    monto_total = data.get('monto_total')
    fecha = datetime.strptime(data.get('fecha'), '%Y-%m-%d')
    hora = datetime.strptime(data.get('hora'), '%Y-%m-%d %H:%M:%S')
    cajero_id = data.get('cajero_id')
    caja_id = data.get('caja_id')

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.insertFactura", (num_factura, monto_total, fecha, hora, cajero_id, caja_id))
        cursor.execute("COMMIT")
        
        return jsonify({'mensaje': 'Factura insertada'}), 200
    except ValueError:
        return jsonify({'mensaje': 'Error al insertar la factura', 'error': 'Uno de los valores no es válido.'})
    except Exception as ex:
        return jsonify({'mensaje': 'Error al insertar la factura', 'error': str(ex)})

# DELETE FACTURA BY ID 
# La ruta para este metodo es /factura/delete 
# Este metodo recibe un json con un parametro factura_id  
# Ejemplo: http://127.0.0.1:5000/factura/delete/id
@factura.route("/delete/<id>", methods=["DELETE"])
def deletePfresco(id):

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.deleteFactura", (id,))
        cursor.execute("COMMIT")
        
        return jsonify({'mensaje': 'Factura eliminado'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al eliminar la factura', 'error': str(ex)})
