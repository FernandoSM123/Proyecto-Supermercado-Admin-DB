from flask import Blueprint, request, jsonify
import cx_Oracle

from globals import GLOBAL_VARS

producto = Blueprint("producto", __name__)

# TEST ROUTE PRODUCTO
@producto.route("/")
def home():
    return "producto home"


# GET ALL PRODUCTOS
# http://127.0.0.1:5000/producto/getAll
@producto.route("/getAll", methods=["GET"])
def getAllProductos():
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getAllProductos", (out_cursor,))
        result = out_cursor.getvalue()

        current_user = GLOBAL_VARS["DB_CONNECTION"].username
        categoria = gerenteCategoria.get(current_user, "otro")
        productos = []

        for row in result:
            producto = {
                "producto_id": row[0],
                "EAN": row[1],
                "descripcion": row[2],
                "precio": row[3],
                "cantidad": row[4]
            }
            productos.append(producto)

        #filtrar productos por categoria
        # if(categoria != "otro"):
        #     productos = [producto for producto in productos if producto['categoria'] == categoria]

        # cursor.close()

        return jsonify({'mensaje': 'Todos los productos recuperados', 'productos': productos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar todos los productos', 'error': str(ex)})


# GET PRODUCTOS BY ID
# http://127.0.0.1:5000/producto/getById/id
@producto.route("/getById/<id>", methods=["GET"])
def getProductoById(id):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getProductoByID", (id, out_cursor,))
        result = out_cursor.getvalue()
        productos = []

        for row in result:
            producto = {
                "producto_id": row[0],
                "EAN": row[1],
                "descripcion": row[2],
                "precio": row[3],
                "cantidad": row[4]
            }
            productos.append(producto)

        # cursor.close()

        return jsonify({'mensaje': 'Producto recuperado por ID', 'productos': productos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar producto por ID', 'error': str(ex)})

# INSERT PRODUCTO
# recibe json como parametro
# http://127.0.0.1:5000/producto/insert
@producto.route("/insert", methods=["POST"])
def insertPfresco():
    data = request.get_json()
    ean = data.get('ean')
    descripcion = data.get('descripcion')
    precio = data.get('precio')
    cantidad = data.get('cantidad')

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.insertProducto",
                        (ean, descripcion, precio, cantidad))
        cursor.execute("COMMIT")

        return jsonify({'mensaje': 'Producto insertado correctamente'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al insertar producto', 'error': str(ex)})

# UPDATE PRODUCTO
# recibe json
# http://127.0.0.1:5000/producto/update
@producto.route("/update", methods=["PUT"])
def update():
    data = request.get_json()
    producto_id = data.get('producto_id')
    ean = data.get('ean')
    descripcion = data.get('descripcion')
    precio = data.get('precio')
    cantidad = data.get('cantidad')

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.updateProducto", (producto_id,
                        ean, descripcion, precio, cantidad))
        cursor.execute("COMMIT")

        return jsonify({'mensaje': 'Producto actualizado correctamente'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al actualizar producto', 'error': str(ex)})


# DELETE PRODUCTO
# recibe id del producto a eliminar como parametro
# http://127.0.0.1:5000/producto/delete/id
@producto.route("/delete/<id>", methods=["DELETE"])
def delete(id):

    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        cursor.callproc("SYS.deleteProducto", (id,))
        cursor.execute("COMMIT")

        return jsonify({'mensaje': 'Producto eliminado correctamente'}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al eliminar el producto', 'error': str(ex)})
    

# GET PRECIO PRODUCTO
#recibe ean del producto a consultar
# http://127.0.0.1:5000/producto/getPrecio
@producto.route("/getPrecio/<ean>", methods=["GET"])
def getPrecioProducto(ean):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.precioProducto", (ean,out_cursor,))
        result = out_cursor.getvalue()
        productos = []

        for row in result:
            producto = {
                "descripcion": row[0],
                "precio": row[1]
            }
            productos.append(producto)

        # cursor.close()

        return jsonify({'mensaje': 'Precio del producto recuperado', 'producto': productos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar precio del producto', 'error': str(ex)})
    

# GET PRODUCTO POR EAN
#recibe ean del producto a consultar
# http://127.0.0.1:5000/producto/getPorCodigo/ean
@producto.route("/getPorCodigo/<ean>", methods=["GET"])
def getProductoPorCodigo(ean):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getProductosPorCodigo", (ean,out_cursor,))
        result = out_cursor.getvalue()
        productos = []

        for row in result:
            producto = {
                "producto_id": row[0],
                "EAN": row[1],
                "descripcion": row[2],
                "precio": row[3],
                "cantidad": row[4]
            }
            productos.append(producto)

        # cursor.close()

        return jsonify({'mensaje': 'Producto recuperado por codigo', 'producto': productos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar producto por codigo', 'error': str(ex)})


# GET PRODUCTO POR DESCRIPCION
#recibe descripcion del producto a consultar
# http://127.0.0.1:5000/producto/getPorDescripcion/descripcion
@producto.route("/getPorDescripcion/<descripcion>", methods=["GET"])
def getProductoPorDescripcion(descripcion):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.getProductosPorDescripcion", (descripcion,out_cursor,))
        result = out_cursor.getvalue()
        productos = []

        for row in result:
            producto = {
                "producto_id": row[0],
                "EAN": row[1],
                "descripcion": row[2],
                "precio": row[3],
                "cantidad": row[4]
            }
            productos.append(producto)

        # cursor.close()

        return jsonify({'mensaje': 'Productos recuperados por descripcion', 'productos': productos}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar productos por descripcion', 'error': str(ex)})


#GERENTE DE CADA CATEGORIA DE PRODUCTOS
gerenteCategoria = {
    "karen": "abarrotes",
    "tatiana": "cuidado personal",
    "michael": "mercancia",
    "dylan": "frescos"
}


