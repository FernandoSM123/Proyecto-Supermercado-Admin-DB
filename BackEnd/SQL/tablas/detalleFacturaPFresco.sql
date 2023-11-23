--SEQUENCE PARA DETALLE FACTURA PRODUCTO FRESCO ID
CREATE SEQUENCE  detalleFacturaPFresco_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  
--#1 TABLA PARA ALMACENAR DETALLES DE UNA FACTURA (PRODUCTO FRESCO)
CREATE TABLE DetalleFacturaPFresco (
    detalleFacturaPFresco_ID NUMBER PRIMARY KEY,
    FacturaID NUMBER,
    PFrescoID NUMBER,
    peso NUMBER,
    CONSTRAINT fk_factura2 FOREIGN KEY (FacturaID) REFERENCES factura(factura_Id),
    CONSTRAINT fk_pfresco FOREIGN KEY (PFrescoID) REFERENCES pfresco(Pfresco_Id)
) TABLESPACE tables_data;

--ALTER FOREIGN KEYS
ALTER TABLE DetalleFacturaPFresco
DROP CONSTRAINT fk_factura2;

ALTER TABLE DetalleFacturaPFresco
ADD CONSTRAINT fk_factura2 FOREIGN KEY (FacturaID) REFERENCES factura(factura_Id)
ON DELETE CASCADE;

ALTER TABLE DetalleFacturaPFresco
DROP CONSTRAINT fk_pfresco;

ALTER TABLE DetalleFacturaPFresco
ADD CONSTRAINT fk_pfresco FOREIGN KEY (PFrescoID) REFERENCES pfresco(Pfresco_Id)
ON DELETE CASCADE;


--#2 INSERTAR DETALLE FACTURA (PRODUCTO FRESCO)
CREATE OR REPLACE PROCEDURE insert_DetalleFacturaPFresco (
    in_FacturaID IN NUMBER,
    in_PFrescoID IN NUMBER,
    in_Peso IN NUMBER
)
IS
    in_detalleFacturaPFrescoID NUMBER;
BEGIN
    SELECT detalleFacturaPFresco_seq.NEXTVAL INTO in_detalleFacturaPFrescoID FROM DUAL;
    INSERT INTO DetalleFacturaPFresco (detalleFacturaPFresco_ID, FacturaID,PFrescoID,Peso)
    VALUES (in_detalleFacturaPFrescoID,in_FacturaID,in_PFrescoID,in_Peso);
    
    --realizar descuento del stock (PFresco)
    UPDATE pfresco SET peso = peso - in_peso WHERE Pfresco_Id = in_PFrescoID;
END insert_DetalleFacturaPFresco;
/

--#3 GET DETALLES FACTURA POR ID FACTURA (PRODUCTOS FRESCOS)
CREATE OR REPLACE PROCEDURE get_DetalleFacturaPFresco (
    in_FacturaID IN NUMBER,
    out_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN out_cursor FOR
        SELECT
               p.PLU,
               p.Descripcion,
               p.Precio,
               dfpf.peso AS gramos_comprados,
               (dfpf.peso * p.Precio) AS Subtotal
          FROM DetalleFacturaPFresco dfpf
          JOIN PFresco p ON dfpf.PFrescoID = p.Pfresco_Id
         WHERE dfpf.FacturaID = in_facturaID;
END get_DetalleFacturaPFresco;
/

--#4 CALCULAR MONTO DE FACTURA CON BASE A PRODUCTOS FRESCOS
CREATE OR REPLACE PROCEDURE CalcularMontoFacturaPFresco(
    in_facturaID IN NUMBER
)
AS
    new_monto NUMBER := 0;
BEGIN
    SELECT SUM(p.precio * dfpf.peso)
    INTO new_monto
    FROM DetalleFacturaPFresco dfpf
    JOIN PFresco p ON dfpf.PFrescoID = p.Pfresco_Id
    WHERE dfpf.FacturaID = in_facturaID;

    IF new_monto IS NULL THEN
        new_monto := 0;
    END IF;

    -- Actualizar el monto total en la tabla 'factura'
    UPDATE factura
    SET monto_total = monto_total + new_monto
    WHERE factura_Id = in_facturaID;
END CalcularMontoFacturaPFresco;
/

/*
----------- DATOS PARA PRUEBAS ------------
*/

--INSERTAR
BEGIN
  insert_DetalleFacturaPFresco(17,1,10);
  insert_DetalleFacturaPFresco(17,2,10);
END;
/

--GET DETALLES FACTURA POR ID FACTURA
VAR mi_cursor REFCURSOR;
EXEC get_DetalleFacturaPFresco(17,:mi_cursor);
PRINT mi_cursor;