ALTER SESSION SET "_ORACLE_SCRIPT" = true;

/*
PERMISOS CAJERO
*/

GRANT connect TO cajero;

GRANT SELECT ON dba_role_privs TO cajero;

GRANT SELECT ON dba_users TO cajero;

GRANT CREATE SESSION TO cajero;

GRANT EXECUTE ON sys.buscardatosusuario TO cajero;


/*
PERMISOS GERENTE DE AREA
*/

GRANT connect TO gerente_area;

GRANT SELECT ON dba_role_privs TO gerente_area;

GRANT SELECT ON dba_users TO gerente_area;

GRANT CREATE SESSION TO gerente_area;

GRANT EXECUTE ON sys.buscardatosusuario TO gerente_area;

/*
PERMISOS GERENTE GENERAL
*/

GRANT connect TO gerente_general;

GRANT SELECT ON dba_role_privs TO gerente_general;

GRANT SELECT ON dba_users TO gerente_general;

GRANT EXECUTE ON sys.buscardatosusuario TO gerente_general;

/*
PERMISOS PERSONAL SISTEMAS
*/

GRANT connect TO personal_sistemas;

GRANT SELECT ON dba_role_privs TO personal_sistemas;

GRANT SELECT ON dba_users TO personal_sistemas;

GRANT EXECUTE ON sys.buscardatosusuario TO personal_sistemas;

GRANT EXECUTE ON sys.getAllProductos TO personal_sistemas;

GRANT EXECUTE ON sys.getProductoByID TO personal_sistemas;