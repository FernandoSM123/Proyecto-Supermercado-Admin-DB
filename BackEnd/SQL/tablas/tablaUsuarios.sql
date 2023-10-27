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

/*
----------- DATOS PARA PRUEBAS ------------
*/

-- SET SERVEROUTPUT ON;

-- VAR mi_cursor REFCURSOR;
-- EXEC BuscarDatosUsuario('ALBERTO', :mi_cursor);
-- PRINT mi_cursor;