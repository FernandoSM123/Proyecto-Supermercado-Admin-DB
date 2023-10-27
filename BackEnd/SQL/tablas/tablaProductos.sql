--SEQUENCE PARA PRODUCTO ID
CREATE SEQUENCE producto_id_sequence
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

--TABLA PARA ALMACENAR PRODUCTOS
CREATE TABLE Productos (
    Producto_ID NUMBER PRIMARY KEY,
    EAN NUMBER(13,0),
    Descripcion VARCHAR2(50),
    Precio NUMBER,
    Cantidad NUMBER
) TABLESPACE tables_data;

--INSERTAR PRODUCTO
CREATE OR REPLACE PROCEDURE insertProducto (
    p_EAN IN NUMBER,
    p_Descripcion IN VARCHAR2,
    p_Precio IN NUMBER,
    p_Cantidad IN NUMBER
)
IS
    p_Producto_ID NUMBER;
BEGIN
    SELECT producto_id_sequence.NEXTVAL INTO p_Producto_ID FROM DUAL;
    INSERT INTO Productos (Producto_ID, EAN, Descripcion, Precio, Cantidad)
    VALUES (p_Producto_ID, p_EAN, p_Descripcion, p_Precio, p_Cantidad);
END insertProducto;
/

--GET PRODUCTO BY ID
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

--GET ALL PRODUCTOS
CREATE OR REPLACE PROCEDURE getAllProductos (
    p_Productos OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Productos FOR
    SELECT * FROM Productos;
END getAllProductos;
/

--UPDATE PRODUCTO BY ID
CREATE OR REPLACE PROCEDURE updateProducto (
    p_Producto_ID IN NUMBER,
    p_EAN IN NUMBER,
    p_Descripcion IN VARCHAR2,
    p_Precio IN NUMBER,
    p_Cantidad IN NUMBER
)
AS
BEGIN
    UPDATE Productos
    SET EAN = p_EAN, Descripcion = p_Descripcion, Precio = p_Precio, Cantidad = p_Cantidad
    WHERE Producto_ID = p_Producto_ID;
END UpdateProducto;
/

--DELETE PRODUCTOR BY ID
CREATE OR REPLACE PROCEDURE deleteProducto (
    p_Producto_ID IN NUMBER
)
AS
BEGIN
    DELETE FROM Productos WHERE Producto_ID = p_Producto_ID;
END DeleteProducto;
/

/*
----------- DATOS PARA PRUEBAS ------------
*/

----DATOS DE PRUEBA
--BEGIN
--  InsertProducto(1808124003091, 'Lid - 0090 Clear', 9579.83, 99);  
--  InsertProducto(4370783586295, 'Muffin Carrot - Individual', 9252.61, 56);  
--  InsertProducto(5105235176997, 'Beets', 8220.79, 76);  
--  InsertProducto(3934608083093, 'Dc - Sakura Fu', 7342.32, 93);  
--  InsertProducto(2708092159052, 'Spic And Span All Purpose', 8121.94, 99);  
--  InsertProducto(5778929407214, 'Hand Towel', 6050.67, 60);  
--  InsertProducto(3484270445743, 'Salt - Seasoned', 7026.46, 70);  
--  InsertProducto(6276827953045, 'Lamb - Sausage Casings', 7641.73, 53);  
--  InsertProducto(9045603140164, 'Pepper - Roasted Red', 2878.86, 87);  
--  InsertProducto(6975935603398, 'Chinese Foods - Plain Fried Rice', 2974.55, 93);  
--END;
--/
--
----GET PRODUCTO PRUEBA
--VAR mi_cursor REFCURSOR;
--EXEC getProductoByID(1,:mi_cursor);
--PRINT mi_cursor;
--
----GET ALL PRODUCTOS PRUEBA
--VAR mi_cursor REFCURSOR;
--EXEC getAllProductos(:mi_cursor);
--PRINT mi_cursor;
--
----UPDATE PRODUCTO PRUEBA
--BEGIN
--  updateProducto(10,6975935603398, 'COMIDA CHINA', 2974.55, 93);
--END;
--/
--
----DELETE PRODUCTO PRUEBA
--BEGIN
--  deleteProducto(10);
--END;
--/

