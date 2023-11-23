--SEQUENCE PARA DETALLE FACTURA PRODUCTO ID
CREATE SEQUENCE  detalleFacturaProducto_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

--#1 TABLA PARA ALMACENAR DETALLES DE UNA FACTURA (PRODUCTO)
CREATE TABLE DetalleFacturaProducto (
    detalleFacturaProducto_ID NUMBER PRIMARY KEY,
    FacturaID NUMBER,
    ProductoID NUMBER,
    Cantidad NUMBER,
    CONSTRAINT fk_factura FOREIGN KEY (FacturaID) REFERENCES factura(factura_Id),
    CONSTRAINT fk_producto FOREIGN KEY (ProductoID) REFERENCES Productos(Producto_ID)
) TABLESPACE tables_data;


--ALTER FOREIGN KEYS
ALTER TABLE DetalleFacturaProducto
DROP CONSTRAINT fk_factura;

ALTER TABLE DetalleFacturaProducto
ADD CONSTRAINT fk_factura FOREIGN KEY (FacturaID) REFERENCES factura(factura_Id)
ON DELETE CASCADE;

ALTER TABLE DetalleFacturaProducto
DROP CONSTRAINT fk_producto;

ALTER TABLE DetalleFacturaProducto
ADD CONSTRAINT fk_producto FOREIGN KEY (ProductoID) REFERENCES Productos(Producto_ID)
ON DELETE CASCADE;

--#2 INSERTAR DETALLE FACTURA (PRODUCTO)
CREATE OR REPLACE PROCEDURE insert_DetalleFacturaProducto (
    in_FacturaID IN NUMBER,
    in_ProductoID IN NUMBER,
    in_Cantidad IN NUMBER
)
IS
    in_detalleFacturaProductoID NUMBER;
BEGIN
    SELECT detalleFacturaProducto_seq.NEXTVAL INTO in_detalleFacturaProductoID FROM DUAL;
    INSERT INTO DetalleFacturaProducto (detalleFacturaProducto_ID, FacturaID, ProductoID,Cantidad)
    VALUES (in_detalleFacturaProductoID,in_FacturaID, in_ProductoID,in_Cantidad);
    
    --realizar descuento del stock (Producto)
    UPDATE Productos SET cantidad = cantidad - in_Cantidad WHERE Producto_ID = in_ProductoID;
END insert_DetalleFacturaProducto;
/

--#3 GET DETALLES FACTURA POR ID FACTURA (PRODUCTOS)
CREATE OR REPLACE PROCEDURE get_DetalleFacturaProducto (
    in_FacturaID IN NUMBER,
    out_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN out_cursor FOR
        SELECT
               p.EAN,
               p.Descripcion,
               p.Precio,
               dfp.Cantidad AS cantidad_Comprada,
               (dfp.Cantidad * p.Precio) AS Subtotal
          FROM DetalleFacturaProducto dfp
          JOIN Productos p ON dfp.ProductoID = p.Producto_ID
         WHERE dfp.FacturaID = in_facturaID;
END get_DetalleFacturaProducto;
/

--#4 Trigger para descontar productos del stock
--create or replace trigger tr_actualizarStockProductos
--after insert on DetalleFacturaProducto
--for each row
--begin
--    UPDATE Productos
--    SET cantidad = cantidad - :new.Cantidad
--    WHERE Producto_ID = :new.ProductoID;
--end tr_actualizarStockProductos;
--/

--#5 CALCULAR MONTO DE FACTURA CON BASE A PRODUCTOS
CREATE OR REPLACE PROCEDURE CalcularMontoFacturaProducto(
    in_facturaID IN NUMBER
)
AS
    new_monto NUMBER := 0;
BEGIN
    SELECT SUM(p.precio * dfp.Cantidad)
    INTO new_monto
    FROM DetalleFacturaProducto dfp
    JOIN Productos p ON dfp.ProductoID = p.Producto_ID
    WHERE dfp.FacturaID = in_facturaID;

    IF new_monto IS NULL THEN
        new_monto := 0;
    END IF;

    -- Actualizar el monto total en la tabla 'factura'
    UPDATE factura
    SET monto_total = monto_total + new_monto
    WHERE factura_Id = in_facturaID;
    COMMIT;
END CalcularMontoFacturaProducto;
/


/*
----------- DATOS PARA PRUEBAS ------------
*/

--INSERTAR
BEGIN
  insert_DetalleFacturaProducto(17,12,10);
  insert_DetalleFacturaProducto(17,13,10);
END;
/

--GET DETALLES FACTURA POR ID FACTURA
VAR mi_cursor REFCURSOR;
EXEC get_DetalleFacturaProducto(1,:mi_cursor);
PRINT mi_cursor;

--CALCULAR MONTO FACTURA PRODUCTO
EXEC CalcularMontoFacturaProducto(3);