from flask import Blueprint, request, jsonify
import cx_Oracle

from globals import GLOBAL_VARS

auditoria = Blueprint("auditoria", __name__)

# TEST ROUTE AUDITORIA
@auditoria.route("/")
def home():
    return "Producto Auditoria home"


# GET ALL AUDITORIAS
# Este método no requiere ningún parametro
# La ruta para consultar es /auditoria/getAll
@auditoria.route("/getAll")
def getAllAuditorias():
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getAllAuditInfo",(out_cursor,))
        result = out_cursor.getvalue()
        auditorias = []

        for row in result:
            auditoria = {
            "user_name" : row[0],
            "date" : row[1],
            "action" : row[2],
            "sql" : row[3]
            }
            auditorias.append(auditoria)

        return jsonify({'mensaje': 'Todas las auditorias recuperados', 'auditorias': auditorias}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar todos los auditorias', 'error': str(ex)}), 404
    
# GET AUDITORIA BY USER NAME
# La ruta para este metodo es /auditoria/getByUserName/username 
# El parametro id en la ruta es el numero a consultar 
# Ejemplo: http://127.0.0.1:5000/auditoria/getByUserName/fabian
@auditoria.route("/getByUserName/<username>")
def getPfrescoById(username):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getAuditInfoByUser",(username ,out_cursor,))
        result = out_cursor.getvalue()
        auditorias = []

        for row in result:
            auditoria = {
                "user_name" : row[0],
                "date" : row[1],
                "action" : row[2],
                "sql" : row[3]
            }
            auditorias.append(auditoria)

        return jsonify({'mensaje': 'Auditorias recuperadas por nombre de usuario', 'auditorias': auditorias}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar las auditorias por nombre de usuario', 'error': str(ex)}), 404