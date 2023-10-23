/*----------- DATOS PARA PRUEBAS ------------*/
---TABLA CAJA
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
/

