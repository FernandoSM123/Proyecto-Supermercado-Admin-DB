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