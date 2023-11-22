/* SE CREA UNA SECUENCIA PARA EL AUTO INCREMENTABLE DEL ID DE FACTURA */
CREATE SEQUENCE factura_id_sequence
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

/* SE CREA LA TABLA FACTURA */
CREATE TABLE factura (
  factura_Id NUMBER PRIMARY KEY,
  numero_factura NUMBER,
  monto_total NUMBER,
  fecha DATE,
  hora TIMESTAMP,
  cajero_Id NUMBER,
  caja_Id NUMBER,
  FOREIGN KEY (caja_Id) REFERENCES caja (caja_ID)
) TABLESPACE tables_data;


-------------------------------------------------------------------------------------------------
----------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------------------


/* PROCEDIMIENTO PARA INSERTAR UNA FACTURA */
CREATE OR REPLACE PROCEDURE insertFactura (
    p_numero_factura IN NUMBER,
    p_monto_total IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_cajero_Id IN NUMBER,
    p_caja_Id IN NUMBER,
    p_factura_Id OUT NUMBER
)
IS
BEGIN
    SELECT factura_id_sequence.NEXTVAL INTO p_factura_Id FROM DUAL;
    INSERT INTO factura (factura_Id, numero_factura, monto_total, fecha, hora, cajero_Id, caja_Id)
    VALUES (p_factura_Id, p_numero_factura, p_monto_total, p_fecha, p_hora, p_cajero_Id, p_caja_Id);
END insertFactura;
/

/* PROCEDIMIENTO PARA ENLISTAR TODAS LAS FACTURAS */
CREATE OR REPLACE PROCEDURE getAllFactura (
    out_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN out_cursor FOR
        SELECT
                f.factura_Id, 
                f.numero_factura, 
                f.monto_total, 
                f.fecha, 
                f.hora,
                f.caja_Id, 
                f.cajero_id, 
                c.USERNAME as cajero
          FROM Factura f
          JOIN dba_users c ON f.cajero_id = c.USER_ID;
END getAllFactura;
/

CREATE OR REPLACE PROCEDURE getFacturaById (
    in_FacturaID IN NUMBER,
    out_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN out_cursor FOR
        SELECT
                f.factura_Id, 
                f.numero_factura, 
                f.monto_total, 
                f.fecha, 
                f.hora,
                f.caja_Id, 
                f.cajero_id, 
                c.USERNAME as cajero
          FROM Factura f
          JOIN dba_users c ON f.cajero_id = c.USER_ID
         WHERE f.factura_id = in_facturaID;
END getFacturaById;
/

/* PROCEDIMIENTO PARA ACTUALIZAR UNA FACTURA */
CREATE OR REPLACE PROCEDURE updateFactura (
    p_factura_Id IN NUMBER,
    p_numero_factura IN NUMBER,
    p_monto_total IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_cajero_Id IN NUMBER,
    p_caja_Id IN NUMBER
)
AS
BEGIN
    UPDATE factura
    SET numero_factura = p_numero_factura, monto_total = p_monto_total, fecha = p_fecha, hora = p_hora, cajero_Id = p_cajero_Id, caja_Id = p_caja_Id
    WHERE factura_Id = p_factura_Id;
END updateFactura;
/

/* PROCEDIMIENTO PARA ELIMINAR UNA FACTURA */
CREATE OR REPLACE PROCEDURE deleteFactura (
    p_factura_Id IN NUMBER
)
AS
BEGIN
    DELETE FROM factura WHERE factura_Id = p_factura_Id;
END deleteFactura;
/

-------------------------------------------------------------------------------------------------
---------------------------------- DATOS PARA PRUEBAS -------------------------------------------


-- Llamamos al procedimiento para insertar 5 facturas
BEGIN
    insertFactura(1, 1010, TO_DATE('2023-11-04', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-11-04 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 137, 1,0);
    insertFactura(2, 7500, TO_DATE('2023-11-05', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-11-05 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 137, 1,0);
    insertFactura(3, 12890, TO_DATE('2023-11-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-11-06 15:15:00', 'YYYY-MM-DD HH24:MI:SS'), 137, 1,0);
    insertFactura(4, 50467, TO_DATE('2023-11-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-11-07 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 137, 1,0);
    insertFactura(5, 90456, TO_DATE('2023-11-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-11-08 18:20:00', 'YYYY-MM-DD HH24:MI:SS'), 137, 1,0);
END;
/

--Creamos un cursor y enlistamos todas los facturas
VAR mi_cursor REFCURSOR;
EXEC getAllFactura(:mi_cursor);
PRINT mi_cursor;

--Buscamos una factura por su factura_Id
VAR mi_cursor REFCURSOR;
EXEC getFacturaById(17, :mi_cursor);
PRINT mi_cursor;

--Se actualizan los datos de una factura
BEGIN
  updateFactura(2, 9, 50000, TO_DATE('2023-10-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-10-25 12:56:00', 'YYYY-MM-DD HH24:MI:SS'), 137, 2);
END;
/

--Borramos la factura_Id 5;
BEGIN
  deleteFactura(5); 
END;
