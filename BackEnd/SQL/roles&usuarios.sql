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

-- ASIGNACION DE ROL PARA LOS USUARIOS
GRANT gerente_area TO dylan;
GRANT gerente_area TO karen;

--USUARIOS GERENTE GENERAL
CREATE USER emilio IDENTIFIED BY emilio123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

-- ASIGNACION DE ROL PARA EL USUARIO
GRANT gerente_general TO emilio;

-- USUARIOS PERSONAL SISTEMAS
CREATE USER fabian IDENTIFIED BY fabian123
    DEFAULT TABLESPACE users_data
    TEMPORARY TABLESPACE temp;

-- ASIGNACION DE ROL PARA LOS USUARIOS
GRANT personal_sistemas TO fabian;

------------------------- Asignacion de permisos de acceso segun rol ----------------------------
-- Pendiente hacer todos

ALTER SESSION SET "_ORACLE_SCRIPT" = true;
GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.Productos TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAllProductos TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getProductoByID TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.updateProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.insertProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.deleteProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.precioProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getProductosPorCodigo TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getProductosPorDescripcion TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.caja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.BuscarCajas TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.BuscarCaja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.ActualizarCaja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.InsertarCaja TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.BorrarCaja TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.pfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAllPfrescos TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoById TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.updatePfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.InsertPfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.deletePfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.precioPfresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorPLU TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorDescripcion TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON factura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON getAllFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON getFacturaById TO personal_sistemas;
GRANT EXECUTE, DEBUG ON insertFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON updateFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON deleteFactura TO personal_sistemas;

