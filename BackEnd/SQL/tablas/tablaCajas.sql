/* SE CREA UNA SECUENCIA PARA EL AUTO INCREMENTABLE DEL ID DE CAJA */
CREATE SEQUENCE caja_id_sequence
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

/* ----SE CREA LA TABLA CAJA */
CREATE TABLE caja (caja_ID NUMBER PRIMARY KEY, numero_de_caja NUMBER) TABLESPACE tables_data;

/*INGRESA UNA NUEVA CAJA*/
CREATE OR REPLACE PROCEDURE InsertarCaja(
  numero_de_caja_in NUMBER
)
IS
  v_caja_id NUMBER;
BEGIN
  -- Obtiene el próximo valor de la secuencia para caja_ID
  SELECT caja_id_sequence.NEXTVAL INTO v_caja_id FROM DUAL;

  -- Inserta un nuevo valor en la tabla "caja"
  INSERT INTO caja (caja_ID, numero_de_caja)
  VALUES (v_caja_id, numero_de_caja_in);

  COMMIT; -- Confirma la transacción
EXCEPTION
  WHEN OTHERS THEN
    -- Maneja errores que puedan ocurrir durante la inserción
    DBMS_OUTPUT.PUT_LINE('Error al insertar un nuevo valor en la tabla "caja".');
END InsertarCaja;


/*ENLISTA TODAS LAS CAJAS CREADAS*/
CREATE OR REPLACE PROCEDURE BuscarCajas(
  cursor_out OUT SYS_REFCURSOR
)
IS
BEGIN
  -- Realiza la consulta de todas las cajas existentes
  OPEN cursor_out FOR
  SELECT caja_ID, numero_de_caja
  FROM caja;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que la tabla "caja" no existe o está vacía
    DBMS_OUTPUT.PUT_LINE('La tabla "caja" no existe o no contiene datos.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la consulta
    DBMS_OUTPUT.PUT_LINE('Se produjo un error al consultar la tabla "caja".');
END BuscarCajas;

/*BUSCA UNA CAJA POR NUMERO*/
CREATE OR REPLACE PROCEDURE BuscarCaja(
  id IN NUMBER,
  cursor_out OUT SYS_REFCURSOR
)
IS
BEGIN
  -- Realiza la consulta de cajas por número de caja
  OPEN cursor_out FOR
  SELECT caja_ID, numero_de_caja
  FROM caja
  WHERE caja_ID = id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que no se encuentran registros para el número de caja especificado
    DBMS_OUTPUT.PUT_LINE('No se encontraron cajas para el número de caja proporcionado.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la consulta
    DBMS_OUTPUT.PUT_LINE('Se produjo un error al consultar las cajas por número de caja.');
END BuscarCaja;


/*ACTUALIZA EL NUMERO DE CAJA SEGÚN EL ID DE LA CAJA*/
CREATE OR REPLACE PROCEDURE ActualizarCaja(
  caja_ID_in NUMBER,
  nuevo_numero_de_caja_in NUMBER
)
IS
BEGIN
  -- Actualiza el número de caja para el registro específico
  UPDATE caja
  SET numero_de_caja = nuevo_numero_de_caja_in
  WHERE caja_ID = caja_ID_in;

  COMMIT; -- Confirma la transacción
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que no se encuentra el registro con el caja_ID especificado
    DBMS_OUTPUT.PUT_LINE('No se encontró la caja con el ID proporcionado.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la actualización
    DBMS_OUTPUT.PUT_LINE('Error al actualizar la caja.');
END ActualizarCaja;
/

CREATE OR REPLACE PROCEDURE BorrarCaja(
  caja_ID_in NUMBER
)
IS
BEGIN
  -- Intentamos borrar el registro con el caja_ID especificado
  DELETE FROM caja
  WHERE caja_ID = caja_ID_in;

  IF SQL%ROWCOUNT = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Borrado exitoso');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No se pudo borrar la caja');
  END IF;

  COMMIT; -- Confirma la transacción
EXCEPTION
  WHEN OTHERS THEN
    -- Maneja errores que puedan ocurrir durante la eliminación
    DBMS_OUTPUT.PUT_LINE('Error al borrar la caja.');
END BorrarCaja;


/* ----------- DATOS PARA PRUEBAS ------------ */

-- Llamamos al procedimiento para insertar 4 cajas con diferentes números de caja
BEGIN
  InsertarCaja(1);  -- Inserta una caja con número_de_caja 1
  InsertarCaja(2);  -- Inserta una caja con número_de_caja 2
  InsertarCaja(3);  -- Inserta una caja con número_de_caja 3
  InsertarCaja(4);  -- Inserta una caja con número_de_caja 4
  InsertarCaja(6);  -- Inserta una caja con número_de_caja 5
  InsertarCaja(8);  -- Inserta una caja con número_de_caja 6
END;
/

--Creamos un cursor y enlistamos todas las cajas
VAR mi_cursor REFCURSOR;
EXEC BuscarCajas(:mi_cursor);
PRINT mi_cursor;

--Buscamos la caja dos
EXEC BuscarCaja(2, :mi_cursor);
PRINT mi_cursor;

--Se actualiza los numeros de cajas para los ids 5 y 6.
BEGIN
  ActualizarCaja(5, 5);
  ActualizarCaja(6, 6);
END;
/

--Borrar la caja número 5
--Puede que el mensaje de confirmacion no se vea en SQL Developer
SET SERVEROUTPUT ON;

DECLARE
  exito BOOLEAN;
BEGIN
  BorrarCaja(5, exito);
  IF exito THEN
    DBMS_OUTPUT.PUT_LINE('Borrado exitoso'); 
  ELSE
    DBMS_OUTPUT.PUT_LINE('No se pudo borrar la caja');
  END IF;
END;
-- /