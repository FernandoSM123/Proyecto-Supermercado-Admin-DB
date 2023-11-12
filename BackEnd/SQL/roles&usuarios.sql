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
ALTER USER cajero PROFILE perfil_cajero;

-- Asignar el perfil GERENTE AREA al rol GERENTE AREA
ALTER USER gerente_area PROFILE perfil_gerente_area;

-- Asignar el perfil GERENTE GENERAL al rol GERENTE GENERAL
ALTER USER gerente_general PROFILE perfil_gerente_general;

-- Asignar el perfil PERSONAL SISTEMAS al rol PERSONAL SISTEMAS
ALTER USER personal_sistemas PROFILE perfil_personal_sistemas;

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

