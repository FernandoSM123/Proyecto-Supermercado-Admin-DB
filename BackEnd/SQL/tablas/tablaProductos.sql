--SEQUENCE PARA PRODUCTO ID
CREATE SEQUENCE producto_id_sequence
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

--#1 TABLA PARA ALMACENAR PRODUCTOS
CREATE TABLE Productos (
    Producto_ID NUMBER PRIMARY KEY,
    EAN NUMBER(13,0),
    Descripcion VARCHAR2(50),
    Precio NUMBER,
    Cantidad NUMBER,
    Area VARCHAR2(50)
) TABLESPACE tables_data;

--#2 INSERTAR PRODUCTO
CREATE OR REPLACE PROCEDURE insertProducto (
    p_EAN IN NUMBER,
    p_Descripcion IN VARCHAR2,
    p_Precio IN NUMBER,
    p_Cantidad IN NUMBER,
    p_area IN VARCHAR2
)
IS
    p_Producto_ID NUMBER;
BEGIN
    SELECT producto_id_sequence.NEXTVAL INTO p_Producto_ID FROM DUAL;
    INSERT INTO Productos (Producto_ID, EAN, Descripcion, Precio,Cantidad,Area)
    VALUES (p_Producto_ID, p_EAN, p_Descripcion, p_Precio, p_Cantidad,p_area);
END insertProducto;
/

--#3 GET PRODUCTO BY ID
CREATE OR REPLACE PROCEDURE getProductoByID (
    p_Producto_ID IN NUMBER,
    p_Producto OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Producto FOR
    SELECT * FROM Productos WHERE Producto_ID = p_Producto_ID;
END getProductoByID;
/

--#4 GET ALL PRODUCTOS
CREATE OR REPLACE PROCEDURE getAllProductos (
    p_Productos OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Productos FOR
    SELECT * FROM Productos;
END getAllProductos;
/

--#5 UPDATE PRODUCTO BY ID
CREATE OR REPLACE PROCEDURE updateProducto (
    p_Producto_ID IN NUMBER,
    p_EAN IN NUMBER,
    p_Descripcion IN VARCHAR2,
    p_Precio IN NUMBER,
    p_Cantidad IN NUMBER,
    p_area IN VARCHAR2
)
AS
BEGIN
    UPDATE Productos
    SET EAN = p_EAN, 
    Descripcion = p_Descripcion, 
    Precio = p_Precio, 
    Cantidad = p_Cantidad,
    area = p_area
    WHERE Producto_ID = p_Producto_ID;
END UpdateProducto;
/

--#6 DELETE PRODUCTOR BY ID
CREATE OR REPLACE PROCEDURE deleteProducto (
    p_Producto_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM Productos WHERE Producto_ID = p_Producto_ID;
END DeleteProducto;
/

--#7 CONSULTAR PRECIO PRODUCTO POR EAN
CREATE OR REPLACE PROCEDURE precioProducto (
    p_EAN NUMBER,
    p_Cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_Cursor FOR
    SELECT Descripcion, Precio
    FROM Productos
    WHERE EAN = p_EAN;
END precioProducto;
/

--#8 CONSULTAR PRODUCTOS POR EAN
CREATE OR REPLACE PROCEDURE getProductosPorCodigo (
    p_EAN NUMBER,
    p_Productos OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Productos FOR
    SELECT * FROM Productos
    WHERE EAN = p_EAN;
END getProductosPorCodigo;
/

--#9 CONSULTAR PRODUCTOS POR DESCRIPCION
CREATE OR REPLACE PROCEDURE getProductosPorDescripcion (
    p_Descripcion IN VARCHAR2,
    p_Productos OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Productos FOR
    SELECT * FROM Productos
    WHERE LOWER(Descripcion) LIKE '%' || LOWER(p_Descripcion) || '%';
END getProductosPorDescripcion;
/

--#10 actualizar cantidad y descripcion por area
CREATE OR REPLACE PROCEDURE update_descripcion_cantidad(
    p_producto_id IN NUMBER,
    p_cantidad IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_area IN VARCHAR2,
    p_usuario IN VARCHAR2
)
IS
BEGIN
    IF p_area = 'abarrotes' AND p_usuario = 'karen' THEN
        UPDATE Productos
        SET cantidad = p_cantidad,
        descripcion = p_descripcion
        WHERE producto_id = p_producto_id;
    ELSIF p_area = 'cuidado personal' AND p_usuario = 'tatiana' THEN
        UPDATE Productos
        SET cantidad = p_cantidad,
        descripcion = p_descripcion
        WHERE producto_id = p_producto_id;
     ELSIF p_area = 'mercanc�as' AND p_usuario = 'michael' THEN
        UPDATE Productos
        SET cantidad = p_cantidad,
        descripcion = p_descripcion
        WHERE producto_id = p_producto_id;
    ELSE
        NULL;
    END IF;
    
    COMMIT;
END update_descripcion_cantidad;
/

/*
----------- DATOS PARA PRUEBAS ------------
*/

BEGIN
InsertProducto(1808124003091, 'Papel higi�nico', 1500.00, 99, 'Abarrotes');
InsertProducto(4370783586295, 'Pasta de dientes colgate', 1000.00, 56, 'Cuidado personal');
InsertProducto(5105235176997, 'Jab�n de ba�o', 500.00, 76, 'Cuidado personal');
InsertProducto(3934608083093, 'Champ�', 2500.00, 93, 'Cuidado personal');
InsertProducto(2708092159052, 'Arroz', 1500.00, 99, 'Abarrotes');
InsertProducto(5778929407214, 'Frijoles en lata', 800.00, 60, 'Abarrotes');
InsertProducto(3484270445743, 'Aceite de cocina', 2000.00, 70, 'Abarrotes');
InsertProducto(6276827953045, 'Detergente l�quido', 1500.00, 53, 'Mercanc�as');
InsertProducto(9045603140164, 'Cereal de masmelos', 2500.00, 87, 'Abarrotes');
InsertProducto(6975935603398, 'Leche en polvo', 1500.00, 93, 'Abarrotes');
InsertProducto(1234567890123, 'Aceitunas rellenas de pimiento', 1200.00, 25, 'Abarrotes');
InsertProducto(1234567890124, 'Cepillo de dientes', 800.00, 80, 'Cuidado personal');
InsertProducto(1234567890125, 'Galletas saladas', 2000.00, 40, 'Abarrotes');
InsertProducto(1234567890126, 'Cereal de chocolate', 3000.00, 65, 'Mercanc�as');
InsertProducto(1234567890127, 'Salsa de tomate', 1500.00, 55, 'Abarrotes');
InsertProducto(1234567890128, 'Pa�uelos desechables', 1800.00, 70, 'Mercanc�as');
InsertProducto(1234567890129, 'Pasta dental para ni�os', 1200.00, 90, 'Cuidado personal');
InsertProducto(1234567890130, 'Botella de vino tinto', 5000.00, 30, 'Abarrotes');
InsertProducto(1234567890131, 'Papel toalla', 2500.00, 75, 'Mercanc�as');
InsertProducto(1234567890132, 'Caf� instant�neo', 3500.00, 45, 'Abarrotes');
END;
/

--GET PRODUCTO PRUEBA
VAR mi_cursor REFCURSOR;
EXEC getProductoByID(42,:mi_cursor);
PRINT mi_cursor;

--GET ALL PRODUCTOS PRUEBA
VAR mi_cursor REFCURSOR;
EXEC getAllProductos(:mi_cursor);
PRINT mi_cursor;

--UPDATE PRODUCTO PRUEBA
BEGIN
  updateProducto(1,1808124003091, 'Papel higi�nico', 1500.00,99,'Abarrotes');
END;
/

--DELETE PRODUCTO PRUEBA
BEGIN
  deleteProducto(1);
END;
/

--GET PRECIO PRODUCTO
VAR mi_cursor REFCURSOR;
EXEC precioProducto(1808124003091,:mi_cursor);
PRINT mi_cursor;

--GET PRODUCTOS POR EAN
VAR mi_cursor REFCURSOR;
EXEC getProductosPorCodigo(1808124003091,:mi_cursor);
PRINT mi_cursor;

--GET PRODUCTOS POR DESCRIPCION
VAR mi_cursor REFCURSOR;
EXEC getProductosPorDescripcion('p',:mi_cursor);
PRINT mi_cursor;

