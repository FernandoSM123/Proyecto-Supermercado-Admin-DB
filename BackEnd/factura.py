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
        facturaID = 0
        print(result)

        for row in result:
            facturaID = row[0]
            productos = getProductosFactura(facturaID) #obtener productos factura
            productosFrescos = getProductosFrescosFactura(facturaID) #obtener productos frescos factura
            
            factura = {
                "factura_id" : row[0],
                "numero_factura" : row[1],
                "monto_total" : row[2],
                "fecha" : row[3].strftime('%Y-%m-%d'),   #Le damos formato a la fecha
                "hora" : row[4].strftime('%I:%M:%S %p'), #Le damos formato a la hora
                "numero de caja" : row[5],
                "cajero_id" : row[6],
                "cajero" : row[7],
                "productos": productos,
                "productosFrescos": productosFrescos
            }
            facturas.append(factura)
        

        #cursor.close()

        return jsonify({'mensaje': 'Todas las facturas recuperadas', 
                        'facturas': facturas}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar todas las facturas', 'error': str(ex)}), 404

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
        facturaID = 0
        print(result)

        for row in result:
            facturaID = row[0]
            productos = getProductosFactura(facturaID) #obtener productos factura
            productosFrescos = getProductosFrescosFactura(facturaID) #obtener productos frescos factura
            factura = {
                "factura_id" : row[0],
                "numero_factura" : row[1],
                "monto_total" : row[2],
                "fecha" : row[3].strftime('%Y-%m-%d'),   #Le damos formato a la fecha
                "hora" : row[4].strftime('%I:%M:%S %p'), #Le damos formato a la hora
                "numero de caja" : row[5],
                "cajero_id" : row[6],
                "cajero" : row[7],
                "productos": productos,
                "productosFrescos": productosFrescos
            }
            facturas.append(factura)

        #cursor.close()

        return jsonify({'mensaje': 'Factura recuperada por ID', 'Factura': facturas}), 200
    except Exception as ex:
        return jsonify({'mensaje': 'Error al recuperar la factura por ID', 'error': str(ex)}), 404

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
        return jsonify({'mensaje': 'Error al actualizar la factura fresco por Id', 'error': str(ex)}), 404
    
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
    productos = data.get('productos')
    pfrescos = data.get('productosFrescos')

    try:

        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        id_factura = cursor.var(cx_Oracle.NUMBER) #id de la factura a insertar
        cursor.callproc("SYS.insertFactura", (num_factura, monto_total, fecha, hora, cajero_id, caja_id,id_factura))
        print("id factura:",int(id_factura.getvalue()))
        cursor.execute("COMMIT")
        insertProductosFactura(int(id_factura.getvalue()),productos) #guardar productos de la factura
        insertProductosFrescosFactura(int(id_factura.getvalue()),pfrescos) #guardar productos frescos de la factura
        
        return jsonify({'mensaje': 'Factura insertada'}), 200
    except ValueError:
        return jsonify({'mensaje': 'Error al insertar la factura', 'error': 'Uno de los valores no es válido.'}), 404
    except Exception as ex:
        return jsonify({'mensaje': 'Error al insertar la factura', 'error': str(ex)}), 404

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
    

#OBTENER PRODUCTOS ASOCIADOS A UNA FACTURA
def getProductosFactura(id_factura):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.get_DetalleFacturaProducto",(id_factura,out_cursor,))
        result = out_cursor.getvalue()
        productos = []

        for row in result:
                producto = {
                    "EAN" : row[0],
                    "descripcion" : row[1],
                    "precio" : row[2],
                    "cantidad" : row[3],
                    "subtotal" : row[4]
                }
                productos.append(producto)
        return productos
    except Exception as e:
        return e

#OBTENER PRODUCTOS FRESCOS ASOCIADOS A UNA FACTURA
def getProductosFrescosFactura(id_factura):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()
        out_cursor = cursor.var(cx_Oracle.CURSOR)

        cursor.callproc("SYS.get_DetalleFacturaPFresco",(id_factura,out_cursor,))
        result = out_cursor.getvalue()
        productosFrescos = []

        for row in result:
                productoFresco = {
                    "PLU" : row[0],
                    "descripcion" : row[1],
                    "precio" : row[2],
                    "peso" : row[3],
                    "subtotal" : row[4]
                }
                productosFrescos.append(productoFresco)
        return productosFrescos
    except Exception as e:
        return e

#INSERTAR DETALLES FACTURA DE PRODUCTO
def insertProductosFactura(id_factura,productos):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()

        for producto in productos:
            cursor.callproc("SYS.insert_DetalleFacturaProducto",(id_factura,
                                                                producto["producto_id"],
                                                                producto["cantidad"]))
            cursor.execute("COMMIT")
    except Exception as e:
        return e
    
#INSERTAR DETALLES FACTURA DE PRODUCTO FRESCO
def insertProductosFrescosFactura(id_factura,pfrescos):
    try:
        cursor = GLOBAL_VARS["DB_CONNECTION"].cursor()

        for pfresco in pfrescos:
            cursor.callproc("SYS.insert_DetalleFacturaPFresco",(id_factura,
                                                                pfresco["pfresco_id"],
                                                                pfresco["peso"]))
            cursor.execute("COMMIT")
    except Exception as e:
        return e