from flask import Blueprint, request, jsonify
import cx_Oracle

from globals import GLOBAL_VARS

producto = Blueprint("producto", __name__)

# TEST ROUTE PRODUCTO
@producto.route("/")
def home():
    return "producto home"


# GET ALL PRODUCTOS
@producto.route("/getAll")
def getAllProductos():
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getAllProductos",(out_cursor,))
        result = out_cursor.getvalue()
        productos = []
        print(result)

        for row in result:
            producto = {
            "producto_id" : row[0],
            "EAN" : row[1],
            "descripcion" : row[2],
            "precio" : row[3],
            "cantidad" : row[4]
            }
            productos.append(producto)

        #cursor.close()

        return jsonify({'mensaje': 'Todos los productos recuperados', 'productos': productos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar todos los productos', 'error': str(ex)})
    

# GET PRODUCT BY ID
@producto.route("/getById/<id>")
def getProductoById(id):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getProductoByID",(id,out_cursor,))
        result = out_cursor.getvalue()
        productos = []
        print(result)

        for row in result:
            producto = {
            "producto_id" : row[0],
            "EAN" : row[1],
            "descripcion" : row[2],
            "precio" : row[3],
            "cantidad" : row[4]
            }
            productos.append(producto)

        #cursor.close()

        return jsonify({'mensaje': 'Producto recuperado por ID', 'productos': productos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar producto por ID', 'error': str(ex)})
