ALTER SESSION SET "_ORACLE_SCRIPT" = true;

/* PERMISOS CAJERO */

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

/* PERMISOS GERENTE DE AREA */

GRANT connect TO gerente_area;
GRANT SELECT ON dba_role_privs TO gerente_area;
GRANT SELECT ON dba_users TO gerente_area;
GRANT CREATE SESSION TO gerente_area;
GRANT EXECUTE ON sys.buscardatosusuario TO gerente_area;

GRANT SELECT ON SYS.Productos TO gerente_area;
GRANT EXECUTE ON sys.getProductosPorCodigo TO gerente_area;
GRANT EXECUTE ON sys.getProductosPorDescripcion TO gerente_area;
GRANT EXECUTE ON sys.precioProducto TO gerente_area;

GRANT SELECT ON SYS.pfresco TO gerente_area;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorPLU TO gerente_area;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorDescripcion TO gerente_area;
GRANT EXECUTE, DEBUG ON SYS.precioPfresco TO gerente_area;

/* PERMISOS GERENTE GENERAL */

GRANT connect TO gerente_general;
GRANT SELECT ON dba_role_privs TO gerente_general;
GRANT SELECT ON dba_users TO gerente_general;
GRANT CREATE SESSION TO gerente_general;
GRANT EXECUTE ON sys.buscardatosusuario TO gerente_general;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.Productos TO gerente_general;
GRANT EXECUTE ON sys.getAllProductos TO gerente_general;
GRANT EXECUTE ON sys.getProductoByID TO gerente_general;
GRANT EXECUTE ON sys.insertProducto TO gerente_general;
GRANT EXECUTE ON sys.deleteProducto TO gerente_general;
GRANT EXECUTE ON sys.updateProducto TO gerente_general;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.pfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getAllPfrescos TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoById TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.updatePfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.InsertPfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.deletePfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.precioPfresco TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorPLU TO gerente_general;
GRANT EXECUTE, DEBUG ON SYS.getPfrescoPorDescripcion TO gerente_general;

/* PERMISOS PERSONAL SISTEMAS */
GRANT ALL PRIVILEGES TO personal_sistemas;
GRANT connect TO personal_sistemas;
GRANT SELECT ON dba_role_privs TO personal_sistemas;
GRANT SELECT ON dba_users TO personal_sistemas;
GRANT EXECUTE ON sys.buscardatosusuario TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.Productos TO personal_sistemas;
GRANT EXECUTE ON sys.getAllProductos TO personal_sistemas;
GRANT EXECUTE ON sys.getProductoByID TO personal_sistemas;
GRANT EXECUTE ON sys.insertProducto TO personal_sistemas;
GRANT EXECUTE ON sys.deleteProducto TO personal_sistemas;
GRANT EXECUTE ON sys.updateProducto TO personal_sistemas;

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

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.factura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.insertFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getAllFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.getFacturaById TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.updateFactura TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.deleteFactura TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.DetalleFacturaProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.insert_DetalleFacturaProducto TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.get_DetalleFacturaProducto TO personal_sistemas;

GRANT SELECT, INSERT, UPDATE, DELETE ON SYS.DetalleFacturaPFresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.insert_DetalleFacturaPFresco TO personal_sistemas;
GRANT EXECUTE, DEBUG ON SYS.get_DetalleFacturaPFresco TO personal_sistemas;