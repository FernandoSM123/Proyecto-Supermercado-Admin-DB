SET SERVEROUTPUT ON;

--Devolver rol y id usuario en un cursor
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

--=============================

--EJECUTAR BUSCAR DATOS USUARIO
VAR mi_cursor REFCURSOR;

-- Llamar al procedimiento para buscar un usuario por nombre
EXEC BuscarDatosUsuario('ALBERTO', :mi_cursor);

-- Recuperar los resultados del cursor
PRINT mi_cursor;
