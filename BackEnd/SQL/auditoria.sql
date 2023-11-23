alter session set "_ORACLE_SCRIPT"=true;
alter system set AUDIT_TRAIL=db, extended scope=spfile;

-- Habilitar la auditoria para cada perfil CAJERO
GRANT AUDIT ANY TO alberto;
AUDIT ALL BY alberto BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY alberto BY ACCESS;

GRANT AUDIT ANY TO beto;
AUDIT ALL BY beto BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY beto BY ACCESS;

GRANT AUDIT ANY TO camilo;
AUDIT ALL BY camilo BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY camilo BY ACCESS;

-- Habilitar la auditoria para cada GERENTE AREA
GRANT AUDIT ANY TO dylan;
AUDIT ALL BY dylan BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY dylan BY ACCESS;

GRANT AUDIT ANY TO karen;
AUDIT ALL BY karen BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY karen BY ACCESS;

GRANT AUDIT ANY TO tatiana;
AUDIT ALL BY tatiana BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY tatiana BY ACCESS;

GRANT AUDIT ANY TO michael;
AUDIT ALL BY michael BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY michael BY ACCESS;

-- Habilitar la auditoria para cada GERENTE GENERAL
GRANT AUDIT ANY TO emilio;
AUDIT ALL BY emilio BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY emilio BY ACCESS;

GRANT AUDIT ANY TO mariana;
AUDIT ALL BY mariana BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY mariana BY ACCESS;

-- Habilitar la auditoria para cada PERSONAL SISTEMAS
GRANT AUDIT ANY TO fabian;
AUDIT ALL BY fabian BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY fabian BY ACCESS;

GRANT AUDIT ANY TO roberto;
AUDIT ALL BY roberto BY ACCESS;
AUDIT SELECT TABLE, INSERT TABLE, UPDATE TABLE, DELETE TABLE BY roberto BY ACCESS;

commit;
SHUTDOWN IMMEDIATE;
STARTUP;

-- Se Habilitan a los usurios del personal de sistemas para ver las auditorías. 
-- Usando el usuario sys
alter session set "_ORACLE_SCRIPT"=true;
GRANT SELECT_CATALOG_ROLE TO fabian;
GRANT SELECT ON DBA_AUDIT_TRAIL TO fabian;
GRANT SELECT ON CDB_AUDIT_TRAIL TO fabian;

GRANT SELECT_CATALOG_ROLE TO roberto;
GRANT SELECT ON DBA_AUDIT_TRAIL TO roberto;
GRANT SELECT ON CDB_AUDIT_TRAIL TO roberto;



-------------------------------------------------------------------------------------------------
----------------------------- PROCEDIMIENTOS ALMACENADOS ----------------------------------------

-- PROCEDIMIENTO PARA ENLISTAR TODA LA INFORMACIÓN DE AUDITORÍA
CREATE OR REPLACE PROCEDURE getAllAuditInfo(
  cursor_out OUT SYS_REFCURSOR
)
IS
BEGIN
  -- Realiza la consulta de toda la información de auditoría
  OPEN cursor_out FOR
  SELECT username, timestamp, action_name, SQL_TEXT
  FROM DBA_AUDIT_TRAIL;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Maneja el caso en que no se encuentran registros en la auditoría
    DBMS_OUTPUT.PUT_LINE('No se encontró información de auditoría.');
  WHEN OTHERS THEN
    -- Maneja otros errores que puedan ocurrir durante la consulta
    DBMS_OUTPUT.PUT_LINE('Se produjo un error al consultar la información de auditoría.');
END getAllAuditInfo;
/

-- PROCEDIMIENTO PARA OBTENER INFORMACIÓN DE AUDITORÍA POR NOMBRE DE USUARIO
CREATE OR REPLACE PROCEDURE getAuditInfoByUser(
  p_username IN VARCHAR2,
  cursor_out OUT SYS_REFCURSOR
)
IS
    v_username VARCHAR2(30);
BEGIN
    -- Convertir el parámetro a mayúsculas
    v_username := UPPER(p_username);

    -- Realizar la consulta en la tabla DBA_AUDIT_TRAIL
    OPEN cursor_out FOR
    SELECT username, timestamp, action_name, SQL_TEXT
    FROM DBA_AUDIT_TRAIL
    WHERE username = v_username;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Maneja el caso en que no se encuentran registros para el nombre de usuario especificado
        DBMS_OUTPUT.PUT_LINE('No se encontró información de auditoría para el usuario proporcionado.');
    WHEN OTHERS THEN
        -- Maneja otros errores que puedan ocurrir durante la consulta
        DBMS_OUTPUT.PUT_LINE('Se produjo un error al consultar la información de auditoría por nombre de usuario.');
END getAuditInfoByUser;
/


-------------------------------------------------------------------------------------------------
---------------------------------- DATOS PARA PRUEBAS -------------------------------------------


-- Ejemplo de uso
VAR mi_cursor REFCURSOR;
EXEC getAllAuditInfo(:mi_cursor);
PRINT mi_cursor;

EXEC getAuditInfoByUser('fabian', :mi_cursor);
PRINT mi_cursor;
/