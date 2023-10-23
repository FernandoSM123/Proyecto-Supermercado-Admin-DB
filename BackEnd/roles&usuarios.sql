ALTER SESSION SET "_ORACLE_SCRIPT" = true;


/*
TABLESPACE PARA USUARIOS
*/
CREATE TABLESPACE users_data
    DATAFILE 'C:\oracle_ts\Supermercado\users_data.dbf' SIZE 50M
    AUTOEXTEND ON NEXT 50M;


/*
TABLESPACE PARA TABLAS
*/
CREATE TABLESPACE tables_data
    DATAFILE 'C:\oracle_ts\Supermercado\tables_data.dbf' SIZE 50M
    AUTOEXTEND ON NEXT 50M;

/*
ROL CAJERO
*/
CREATE ROLE cajero;

GRANT connect TO cajero;

GRANT SELECT ON dba_role_privs TO cajero;

GRANT SELECT ON dba_users TO cajero;

GRANT
    CREATE SESSION
TO cajero;

GRANT EXECUTE ON sys.buscardatosusuario TO cajero;

/*
ROL GERENTE AREA
*/
CREATE ROLE gerente_area;

GRANT connect TO gerente_area;

GRANT SELECT ON dba_role_privs TO gerente_area;

GRANT SELECT ON dba_users TO gerente_area;

GRANT
    CREATE SESSION
TO gerente_area;

GRANT
    EXECUTE ANY PROCEDURE
TO gerente_area;

GRANT EXECUTE ON sys.buscardatosusuario TO gerente_area;

/*
ROL GERENTE GENERAL
*/
CREATE ROLE gerente_general;

GRANT connect TO gerente_general;

GRANT SELECT ON dba_role_privs TO gerente_general;

GRANT SELECT ON dba_users TO gerente_general;

GRANT
    EXECUTE ANY PROCEDURE
TO gerente_general;

GRANT EXECUTE ON sys.buscardatosusuario TO gerente_general;

/*
ROL PERSONAL SISTEMAS
*/
CREATE ROLE personal_sistemas;

GRANT connect TO personal_sistemas;

GRANT SELECT ON dba_role_privs TO personal_sistemas;

GRANT SELECT ON dba_users TO personal_sistemas;

GRANT
    EXECUTE ANY PROCEDURE
TO personal_sistemas;

GRANT EXECUTE ON sys.buscardatosusuario TO personal_sistemas;

/*
USUARIOS CAJERO
*/
CREATE USER alberto IDENTIFIED BY alberto123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER beto IDENTIFIED BY beto123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER camilo IDENTIFIED BY camilo123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

GRANT cajero TO alberto;

GRANT cajero TO beto;

GRANT cajero TO camilo;

/*
USUARIOS GERENTE AREA
*/
CREATE USER dylan IDENTIFIED BY dylan123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

GRANT gerente_area TO dylan;

/*
USUARIOS GERENTE GENERAL
*/
CREATE USER emilio IDENTIFIED BY emilio123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

GRANT gerente_general TO emilio;

/*
USUARIOS PERSONAL SISTEMAS
*/
CREATE USER fabian IDENTIFIED BY fabian123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

GRANT personal_sistemas TO fabian;



/*
----CREACION DE TABLAS Y SUS PROCEDIMIENTOS
SE CREA UNA SECUENCIA PARA EL AUTO INCREMENTABLE DEL ID DE CAJA
*/
CREATE SEQUENCE caja_id_sequence
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

/*
----SE CREA LA TABLA CAJA
*/
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
  numero_caja_in IN NUMBER,
  cursor_out OUT SYS_REFCURSOR
)
IS
BEGIN
  -- Realiza la consulta de cajas por número de caja
  OPEN cursor_out FOR
  SELECT caja_ID, numero_de_caja
  FROM caja
  WHERE numero_de_caja = numero_caja_in;
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
