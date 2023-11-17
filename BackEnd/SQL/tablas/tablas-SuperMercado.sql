/* SE CREA EL TABLE SPACE QUE ALVERGARA LAS TABLAS DEL SUPERMERCADO */
CREATE TABLESPACE tables_data
    DATAFILE 'C:\oracle_ts\Supermercado\tables_data.dbf' SIZE 50M
    AUTOEXTEND ON NEXT 50M;

---------------------------------- Tabla Caja  -----------------------------------------

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
/

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
/

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
/

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
/

---------------------------------- Tabla Factura  -----------------------------------------

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
    p_caja_Id IN NUMBER
)
IS
    p_factura_Id NUMBER;
BEGIN
    SELECT factura_id_sequence.NEXTVAL INTO p_factura_Id FROM DUAL;
    INSERT INTO factura (factura_Id, numero_factura, monto_total, fecha, hora, cajero_Id, caja_Id)
    VALUES (p_factura_Id, p_numero_factura, p_monto_total, p_fecha, p_hora, p_cajero_Id, p_caja_Id);
END insertFactura;
/

/* PROCEDIMIENTO PARA ENLISTAR TODAS LAS FACTURAS */
CREATE OR REPLACE PROCEDURE getAllFactura (
    p_Facturas OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Facturas FOR
    SELECT factura_Id, numero_factura, monto_total, fecha, hora, cajero_Id, caja_Id FROM factura;
END getAllFactura;
/

CREATE OR REPLACE PROCEDURE getFacturaById (
    p_Factura_Id IN NUMBER,
    p_Factura OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_Factura FOR
    SELECT factura_Id, numero_factura, monto_total, fecha, hora, cajero_Id, caja_Id FROM factura WHERE factura_Id = p_Factura_Id;
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

---------------------------------- Tabla Productos  -----------------------------------------

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
    Cantidad NUMBER
) TABLESPACE tables_data;

--#2 INSERTAR PRODUCTO
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
    p_Cantidad IN NUMBER
)
AS
BEGIN
    UPDATE Productos
    SET EAN = p_EAN, Descripcion = p_Descripcion, Precio = p_Precio, Cantidad = p_Cantidad
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

---------------------------------- Tabla Pfresco --------------------------------------------

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

---------------------------------- Tabla Detalle Factura PFresco  -----------------------------------------

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


-------------------------------------------------------------------------------------------------
----------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------------------


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

---------------------------------- Tabla Detalle Factura Producto -----------------------------------------

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


-------------------------------------------------------------------------------------------------
----------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------------------


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

---------------------------------- Usuarios -----------------------------------------
-------------------------------------------------------------------------------------------------
----------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------------------

--DEVOLVER DATOS DE UN USUARIO POR EL NOMBRE
CREATE OR REPLACE PROCEDURE BuscarDatosUsuario(
  nombre_usuario IN VARCHAR2,
  cursor OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN cursor FOR
  SELECT u.user_id, r.granted_role
  FROM dba_users u
  JOIN dba_role_privs r ON u.username = r.grantee
  WHERE u.username = nombre_usuario;
END BuscarDatosUsuario;
/


