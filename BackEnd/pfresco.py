from flask import Blueprint, request, jsonify
import cx_Oracle

from globals import GLOBAL_VARS

pfresco = Blueprint("pfresco", __name__)

# TEST ROUTE PFRESCO
@pfresco.route("/")
def home():
    return "Producto Fresco home"

# GET ALL CAJAS
# Este método no requiere ningún parametro
# La ruta para consultar es /caja/getAll
@pfresco.route("/getAll")
def getAllPfrescos():
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getAllPfrescos",(out_cursor,))
        result = out_cursor.getvalue()
        pfrescos = []
        print(result)

        for row in result:
            pfresco = {
            "pFresco_id" : row[0],
            "pul" : row[1],
            "descripcion" : row[2],
            "peso" : row[3],
            "precio" : row[4]
            }
            pfrescos.append(pfresco)

        #cursor.close()

        return jsonify({'mensaje': 'Todas los pfrescos recuperados', 'pfrescos': pfrescos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar todos los pfrescos', 'error': str(ex)})

# GET PFRESCO BY ID
# La ruta para este metodo es /pfresco/getById/id 
# El parametro id en la ruta es el numero a consultar 
# Ejemplo: http://127.0.0.1:5000/pfresco/getById/1
@pfresco.route("/getById/<id>")
def getPfrescoById(id):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getPfrescoById",(id,out_cursor,))
        result = out_cursor.getvalue()
        pfrescos = []
        print(result)

        for row in result:
            pfresco = {
                "Pfresco_Id": row[0],
                "PLU": row[1],
                "descripcion": row[2],
                "peso": row[3],
                "Precio": row[4]
            }
            pfrescos.append(pfresco)

        #cursor.close()

        return jsonify({'mensaje': 'Producto fresco recuperado por ID', 'Pfresco': pfrescos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar le Producto fresco por ID', 'error': str(ex)})

# UPDATE PFRESCO BY ID
# La ruta de este metodo es /pfresco/update 
# Este metodo recibe un json con estos parametros: 
# pfresco_id, plu, descripcion, peso y precio 
# pfresco_id es el unico dato que no se actualiza.
@pfresco.route("/update", methods=["POST"])
def updatePfresco():
    data = request.get_json()
    Pfresco_Id = data.get('pfresco_Id')
    new_PLU = data.get('plu')
    new_descripcion = data.get('descripcion')
    new_peso = data.get('peso')
    new_Precio = data.get('precio')

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.updatePfresco", (Pfresco_Id, new_PLU, new_descripcion, new_peso, new_Precio))
        cursor.execute("COMMIT")
        
        return jsonify({'mensaje': 'Producto fresco actualizado por Id'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al actualizar el producto fresco por Id', 'error': str(ex)})

@pfresco.route("/insert", methods=["POST"])
def insertPfresco():
    data = request.get_json()
    plu = data.get('plu')
    descripcion = data.get('descripcion')
    peso = data.get('peso')
    precio = data.get('precio')

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.InsertPfresco", (plu, descripcion, peso, precio))
        cursor.execute("COMMIT")
        
        return jsonify({'mensaje': 'Producto fresco insertado'}), 200
    except ValueError:
        return jsonify({'mensaje': 'Error al insertar el producto fresco', 'error': 'Uno de los valores no es válido.'})
    except Exception as ex:
        return jsonify({'mensaje': 'Error al insertar el producto fresco', 'error': str(ex)})


@pfresco.route("/delete", methods=["POST"])
def deletePfresco():
    data = request.get_json()
    pfresco_Id = data.get('pfresco_Id')

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.deletePfresco", (pfresco_Id,))
        cursor.execute("COMMIT")
        
        return jsonify({'mensaje': 'Producto fresco eliminado'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al eliminar el producto fresco', 'error': str(ex)})
