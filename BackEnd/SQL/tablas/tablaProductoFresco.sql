/* SE CREA UNA SECUENCIA PARA EL AUTO INCREMENTABLE DEL ID DE PFRESCO */
CREATE SEQUENCE pfresco_id_sequence
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

/* SE CREA LA TABLA PFRESCO */
CREATE TABLE pfresco (
  Pfresco_Id NUMBER PRIMARY KEY,
  PLU NUMBER(5) UNIQUE,
  descripcion VARCHAR2(100),
  peso NUMBER,
  Precio NUMBER
) TABLESPACE tables_data;


-------------------------------------------------------------------------------------------------
----------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------------------


/* PROCEDIMIENTO PARA INSERTAR UN PRODUCTO FRESCO */
CREATE OR REPLACE PROCEDURE InsertPfresco(
  PLU_in NUMBER,
  descripcion_in VARCHAR2,
  peso_in NUMBER,
  Precio_in NUMBER
)
IS
  v_pfresco_id NUMBER;
BEGIN
  -- Obtiene el próximo valor de la secuencia para Pfresco_Id
  SELECT pfresco_id_sequence.NEXTVAL INTO v_pfresco_id FROM DUAL;

  -- Inserta un nuevo registro en la tabla "pfresco"
  INSERT INTO pfresco (Pfresco_Id, PLU, descripcion, peso, Precio)
  VALUES (v_pfresco_id, PLU_in, descripcion_in, peso_in, Precio_in);

  COMMIT; -- Confirma la transacción
EXCEPTION
  WHEN OTHERS THEN
    -- Maneja errores que puedan ocurrir durante la inserción
    DBMS_OUTPUT.PUT_LINE('Error al insertar un nuevo registro en la tabla "pfresco".');
END InsertPfresco;
/

/* PROCEDIMIENTO PARA ENLISTAR TODOS PRODUCTOS FRESCOS */
CREATE OR REPLACE PROCEDURE getAllPfrescos(
  cursor_out OUT SYS_REFCURSOR
)
IS
BEGIN
  -- Realiza la consulta de todos los productos frescos
  OPEN cursor_out FOR
  SELECT Pfresco_Id, PLU, descripcion, peso, Precio
  FROM pfresco;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que la tabla "pfresco" no existe o está vacía
    DBMS_OUTPUT.PUT_LINE('La tabla "pfresco" no existe o no contiene datos.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la consulta
    DBMS_OUTPUT.PUT_LINE('Se produjo un error al consultar la tabla "pfresco".');
END getAllPfrescos;
/

/* PROCEDIMIENTO PARA BUSCAR UN PRODUCTO FRESCO POR ID */
CREATE OR REPLACE PROCEDURE getPfrescoById(
  id IN NUMBER,
  cursor_out OUT SYS_REFCURSOR
)
IS
BEGIN
  -- Realiza la consulta de productos frescos por Pfresco_Id
  OPEN cursor_out FOR
  SELECT Pfresco_Id, PLU, descripcion, peso, Precio
  FROM pfresco
  WHERE Pfresco_Id = id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que no se encuentran registros para el Pfresco_Id especificado
    DBMS_OUTPUT.PUT_LINE('No se encontraron productos frescos para el Pfresco_Id proporcionado.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la consulta
    DBMS_OUTPUT.PUT_LINE('Se produjo un error al consultar los productos frescos por Pfresco_Id.');
END getPfrescoById;
/

/* PROCEDIMIENTO PARA ACTUALIZAR UN PRODUCTO FRESCO */
CREATE OR REPLACE PROCEDURE updatePfresco(
  Pfresco_Id_in NUMBER,
  nuevo_PLU_in NUMBER,
  nueva_descripcion_in VARCHAR2,
  nuevo_peso_in NUMBER,
  nuevo_Precio_in NUMBER
)
IS
BEGIN
  -- Actualiza los datos del producto fresco específico
  UPDATE pfresco
  SET
    PLU = nuevo_PLU_in,
    descripcion = nueva_descripcion_in,
    peso = nuevo_peso_in,
    Precio = nuevo_Precio_in
  WHERE Pfresco_Id = Pfresco_Id_in;

  COMMIT; -- Confirma la transacción
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que no se encuentra el producto fresco con el Pfresco_Id especificado
    DBMS_OUTPUT.PUT_LINE('No se encontró el producto fresco con el Pfresco_Id proporcionado.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la actualización
    DBMS_OUTPUT.PUT_LINE('Error al actualizar el producto fresco.');
END updatePfresco;
/

/* PROCEDIMIENTO PARA ACTUALIZAR UN PRODUCTO FRESCO */
CREATE OR REPLACE PROCEDURE updateDescripcionCantidadPfresco(
  Pfresco_Id_in NUMBER,
  nueva_descripcion_in VARCHAR2,
  nuevo_peso_in NUMBER
)
IS
BEGIN
  -- Actualiza los datos del producto fresco específico
  UPDATE pfresco
  SET
    descripcion = nueva_descripcion_in,
    peso = nuevo_peso_in
  WHERE Pfresco_Id = Pfresco_Id_in;

  COMMIT; -- Confirma la transacción
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que no se encuentra el producto fresco con el Pfresco_Id especificado
    DBMS_OUTPUT.PUT_LINE('No se encontró el producto fresco con el Pfresco_Id proporcionado.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la actualización
    DBMS_OUTPUT.PUT_LINE('Error al actualizar el producto fresco.');
END updateDescripcionCantidadPfresco;
/

/* PROCEDIMIENTO PARA ELIMINAR UN PRODUCTO FRESCO */
CREATE OR REPLACE PROCEDURE deletePfresco(
  Pfresco_Id_in NUMBER
)
IS
BEGIN
  -- Intentamos borrar el registro con el Pfresco_Id especificado
  DELETE FROM pfresco
  WHERE Pfresco_Id = Pfresco_Id_in;

  IF SQL%ROWCOUNT = 1 THEN
    DBMS_OUTPUT.PUT_LINE('Borrado exitoso');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No se pudo borrar el producto fresco');
  END IF;

  COMMIT; -- Confirma la transacción
EXCEPTION
  WHEN OTHERS THEN
    -- Maneja errores que puedan ocurrir durante la eliminación
    DBMS_OUTPUT.PUT_LINE('Error al borrar el producto fresco.');
END deletePfresco;
/

/* PROCEDIMIENTO PARA BUSCAR EL PRECIO POR PLU */
CREATE OR REPLACE PROCEDURE precioPfresco (
    p_PLU NUMBER,
    p_Cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_Cursor FOR
    SELECT descripcion, precio
    FROM pfresco
    WHERE PLU = p_PLU;
END precioPfresco;
/

/* PROCEDIMIENTO PARA BUSCAR TODA LA INFORMACION DE PFRESCO POR PLU */
CREATE OR REPLACE PROCEDURE getPfrescoPorPLU (
    p_PLU NUMBER,
    p_Cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Cursor FOR
    SELECT Pfresco_Id, PLU, descripcion, peso, Precio
    FROM pfresco
    WHERE PLU = p_PLU;
END getPfrescoPorPLU;
/

/* PROCEDIMIENTO PARA BUSCAR TODA LA INFORMACION DE PFRESCO POR DESCRIPCIÓN */
CREATE OR REPLACE PROCEDURE getPfrescoPorDescripcion (
    p_Descripcion IN VARCHAR2,
    p_Pfrescos OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Pfrescos FOR
    SELECT Pfresco_Id, PLU, descripcion, peso, Precio 
    FROM pfresco
    WHERE LOWER(descripcion) LIKE '%' || LOWER(p_Descripcion) || '%';
END getPfrescoPorDescripcion;
/

-------------------------------------------------------------------------------------------------
---------------------------------- DATOS PARA PRUEBAS -------------------------------------------


--Llamamos al procedimiento para insertar 4 productos frescos con diferentes datos
BEGIN
  InsertPfresco(1223, 'Pi�a Hawaiana', 500, 1000.00);  -- Inserta un producto fresco
  InsertPfresco(2123, 'Manzana Roja', 300, 1500.00);    -- Inserta otro producto fresco
  InsertPfresco(3123, 'Fresa Fresca', 250, 2000.00);    -- Inserta otro producto fresco
  InsertPfresco(4123, 'Platano Maduro', 400, 500.00);   -- Inserta otro producto fresco
  InsertPfresco(5123, 'Uva Dulce', 600, 3000.00);       -- Inserta otro producto fresco
END;
/

--Creamos un cursor y enlistamos todos los productos frescos
VAR mi_cursor REFCURSOR;
EXEC getAllPfrescos(:mi_cursor);
PRINT mi_cursor;

--Buscamos un producto fresco por su Pfresco_Id
EXEC getPfrescoById(2, :mi_cursor);
PRINT mi_cursor;

--Se actualizan los datos de un producto fresco
BEGIN
  updatePfresco(1, 12345, 'Piña Dulce', 300, 6.99);  -- Actualiza un producto fresco
END;
/

--Borrarmos un producto fresco
BEGIN
  deletePfresco(5); -- Intenta borrar un producto fresco con Pfresco_Id 8
END;

--Consultamos un el precio de un pfresco por PLU
EXEC precioPfresco(12345, :mi_cursor);
PRINT mi_cursor;

--Consultamos un pfresco por PLU
EXEC getPfrescoPorPLU(56789, :mi_cursor);
PRINT mi_cursor;

--Consultamos un pfresco por descripcion
EXEC getPfrescoPorDescripcion('p', :mi_cursor);
PRINT mi_cursor;
