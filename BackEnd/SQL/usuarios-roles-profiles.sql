ALTER SESSION SET "_ORACLE_SCRIPT" = true;

------------------------ Creacion de tablespaces para usuarios ------------------------------

--TABLESPACE PARA USUARIOS
CREATE TABLESPACE users_data
    DATAFILE 'C:\oracle_ts\Supermercado\users_data.dbf' SIZE 50M
    AUTOEXTEND ON NEXT 50M;

--TABLESPACE PARA TABLAS
CREATE TABLESPACE tables_data
    DATAFILE 'C:\oracle_ts\Supermercado\tables_data.dbf' SIZE 50M
    AUTOEXTEND ON NEXT 50M;

---------------------------------- Creacion de roles  -----------------------------------------

--ROL CAJERO
CREATE ROLE cajero;

--ROL GERENTE AREA
CREATE ROLE gerente_area;

--ROL GERENTE GENERAL
CREATE ROLE gerente_general;

--ROL PERSONAL SISTEMAS
CREATE ROLE personal_sistemas;

---------------------------------- Creacion de perfiles  ----------------------------------------

-- Perfil para el rol CAJERO
CREATE PROFILE perfil_cajero LIMIT
  SESSIONS_PER_USER 1
  CPU_PER_SESSION 300000
  CPU_PER_CALL 300000
  CONNECT_TIME 240
  IDLE_TIME 1;

-- Perfil para el rol GERENTE AREA
CREATE PROFILE perfil_gerente_area LIMIT
  SESSIONS_PER_USER 2
  CPU_PER_SESSION 20000
  CPU_PER_CALL 20000
  CONNECT_TIME 240
  IDLE_TIME 5;

-- Perfil para el rol GERENTE GENERAL 
CREATE PROFILE perfil_gerente_general LIMIT
  SESSIONS_PER_USER 3
  CPU_PER_SESSION UNLIMITED
  CPU_PER_CALL UNLIMITED
  CONNECT_TIME UNLIMITED
  IDLE_TIME UNLIMITED;


-- Perfil para el rol PERSONAL SISTEMAS 
CREATE PROFILE perfil_personal_sistemas LIMIT
  SESSIONS_PER_USER 3
  CPU_PER_SESSION UNLIMITED
  CPU_PER_CALL UNLIMITED
  CONNECT_TIME UNLIMITED
  IDLE_TIME UNLIMITED;

-- Asignar el perfil CAJERO al rol CAJERO
ALTER USER alberto PROFILE perfil_cajero;
ALTER USER beto PROFILE perfil_cajero;
ALTER USER camilo PROFILE perfil_cajero;

-- Asignar el perfil GERENTE AREA al rol GERENTE AREA
ALTER USER dylan PROFILE perfil_gerente_area;
ALTER USER karen PROFILE perfil_gerente_area;
ALTER USER tatiana PROFILE perfil_gerente_area;
ALTER USER michael PROFILE perfil_gerente_area;

-- Asignar el perfil GERENTE GENERAL al rol GERENTE GENERAL
ALTER USER emilio PROFILE perfil_gerente_general;
ALTER USER mariana PROFILE perfil_gerente_general;

-- Asignar el perfil PERSONAL SISTEMAS al rol PERSONAL SISTEMAS
ALTER USER fabian PROFILE perfil_personal_sistemas;
ALTER USER roberto PROFILE perfil_personal_sistemas;

---------------------------------- Creacion de usuarios -----------------------------------------

--USUARIOS CAJERO
CREATE USER alberto IDENTIFIED BY alberto123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER beto IDENTIFIED BY beto123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER camilo IDENTIFIED BY camilo123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

-- ASIGNACION DE ROL PARA LOS USUARIOS
GRANT cajero TO alberto;
GRANT cajero TO beto;
GRANT cajero TO camilo;

--USUARIOS GERENTE AREA
CREATE USER dylan IDENTIFIED BY dylan123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER karen IDENTIFIED BY karen123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER tatiana IDENTIFIED BY tatiana123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER michael IDENTIFIED BY michael123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

-- ASIGNACION DE ROL PARA LOS USUARIOS
GRANT gerente_area TO dylan;   -- Gerente de Frescos
-- Estos son los Gerentes a los que se les tiene que asignar los permisos.
GRANT gerente_area TO karen;   -- Gerente de Abarrotes
GRANT gerente_area TO tatiana; -- Gerente de Cuidado personal
GRANT gerente_area TO michael; -- Gerente de Mercancia

--USUARIOS GERENTE GENERAL
CREATE USER emilio IDENTIFIED BY emilio123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER mariana IDENTIFIED BY mariana123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

-- ASIGNACION DE ROL PARA EL USUARIO
GRANT gerente_general TO emilio;
GRANT gerente_general TO mariana;

-- USUARIOS PERSONAL SISTEMAS
CREATE USER fabian IDENTIFIED BY fabian123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

CREATE USER roberto IDENTIFIED BY roberto123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

-- ASIGNACION DE ROL PARA LOS USUARIOS
GRANT personal_sistemas TO fabian;
GRANT personal_sistemas TO roberto;

------------------------- Asignacion de permisos de acceso segun rol ----------------------------

-- PERMISOS PERSONAL DE SISTEMAS

ALTER SESSION SET "_ORACLE_SCRIPT" = true;

GRANT connect TO personal_sistemas;
GRANT SELECT ON dba_role_privs TO personal_sistemas;
GRANT SELECT ON dba_users TO personal_sistemas;
GRANT CREATE SESSION TO personal_sistemas;
GRANT EXECUTE ON sys.buscardatosusuario TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON DetalleFacturaPFresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON insert_DetalleFacturaPFresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON get_DetalleFacturaPFresco TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON DetalleFacturaProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON insert_DetalleFacturaProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON get_DetalleFacturaProducto TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.caja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.BuscarCajas TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.BuscarCaja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.ActualizarCaja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.InsertarCaja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.BorrarCaja TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON factura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAllFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getFacturaById TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.insertFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.updateFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.deleteFactura TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.pfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAllPfrescos TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoById TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.updatePfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.InsertPfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.deletePfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.precioPfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorPLU TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorDescripcion TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.Productos TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAllProductos TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getProductoByID TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.updateProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.insertProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.deleteProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.precioProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getProductosPorCodigo TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getProductosPorDescripcion TO personal_sistemas;

GRANT SELECT ON DBA_AUDIT_TRAIL TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAllAuditInfo TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAuditInfoByUser TO personal_sistemas;

-- PERMISOS CAJEROS

GRANT connect TO cajero;
GRANT SELECT ON dba_role_privs TO cajero;
GRANT SELECT ON dba_users TO cajero;
GRANT CREATE SESSION TO cajero;
GRANT EXECUTE ON sys.buscardatosusuario TO cajero;

GRANT SELECT ON SYS.caja TO cajero;
GRANT EXECUTE, DEBUG ON SYS.BuscarCaja TO cajero;

GRANT SELECT ON SYS.pfresco TO cajero;
GRANT EXECUTE, DEBUG ON SYS.precioPfresco TO cajero;

GRANT SELECT ON SYS.Productos TO cajero;
GRANT EXECUTE ON sys.precioProducto TO cajero;

GRANT INSERT ON SYS.factura TO cajero;
GRANT EXECUTE, DEBUG ON SYS.insertFactura TO cajero;

GRANT SELECT,INSERT ON DetalleFacturaProducto TO cajero;
GRANT EXECUTE, DEBUG ON insert_DetalleFacturaProducto TO cajero;
GRANT EXECUTE, DEBUG ON insert_DetalleFacturaPFresco TO cajero;

GRANT SELECT, INSERT ON DetalleFacturaPFresco TO cajero;
GRANT EXECUTE, DEBUG ON insert_DetalleFacturaPFresco TO cajero;
GRANT EXECUTE, DEBUG ON get_DetalleFacturaPFresco TO cajero;

-- PERMISOS GERENTE DE AREA

GRANT connect TO gerente_area;
GRANT SELECT ON dba_role_privs TO gerente_area;
GRANT SELECT ON dba_users TO gerente_area;
GRANT CREATE SESSION TO gerente_area;
GRANT EXECUTE ON sys.buscardatosusuario TO gerente_area;

GRANT SELECT ON SYS.Productos TO gerente_area;
GRANT EXECUTE ON sys.getProductosPorCodigo TO gerente_area;
GRANT EXECUTE ON sys.getProductosPorDescripcion TO gerente_area;
GRANT EXECUTE ON sys.precioProducto TO gerente_area;
GRANT EXECUTE ON sys.update_descripcion_cantidad TO gerente_area;
-- FALTA EL ACTUALIZAR CANTIDAD Y DESCRIPCION
-- Se debe crear una columna nueva "tipoProducto" en la tabla productos, que diga si un producto es 
-- abarrote, cuidado personal o mercancía. Este cambio afecta el insert y el update, por lo que hay que 
-- actulizar dichos procedimientos. 
-- Luego se tiene que crear 3 procedimientos que solo actualice la descripción y la cantidad, 
-- para cada tipo de producto. Esto se le tiene que asignar a cada gerente de area según su departamento.    

GRANT SELECT ON SYS.pfresco TO gerente_area;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorPLU TO gerente_area;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorDescripcion TO gerente_area;
GRANT EXECUTE, DEBUG ON SYS.precioPfresco TO gerente_area;
GRANT EXECUTE, DEBUG ON SYS.updateDescripcionCantidadPfresco TO gerente_area;

-- PERMISOS GERENTE GENERAL

GRANT connect TO gerente_general;
GRANT SELECT ON dba_role_privs TO gerente_general;
GRANT SELECT ON dba_users TO gerente_general;
GRANT CREATE SESSION TO gerente_general;
GRANT EXECUTE ON sys.buscardatosusuario TO gerente_general;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.Productos TO gerente_general;
GRANT EXECUTE ON sys.getAllProductos TO gerente_general;
GRANT EXECUTE ON sys.getProductoByID TO gerente_general;
GRANT EXECUTE ON sys.updateProducto TO gerente_general;
GRANT EXECUTE ON sys.insertProducto TO gerente_general;
GRANT EXECUTE ON sys.deleteProducto TO gerente_general;
GRANT EXECUTE ON SYS.precioProducto TO gerente_general;
GRANT EXECUTE ON SYS.getProductosPorCodigo TO gerente_general;
GRANT EXECUTE ON SYS.getProductosPorDescripcion TO gerente_general;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.pfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getAllPfrescos TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoById TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.updatePfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.InsertPfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.deletePfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.precioPfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorPLU TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorDescripcion TO gerente_general;
