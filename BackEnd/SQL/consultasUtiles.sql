SELECT tablespace_name FROM dba_tablespaces; --ver tablespaces
SELECT * from dba_role_privs; --ver roles
SELECT * from dba_users; --ver usuarios

SELECT owner
FROM all_procedures
WHERE object_name = 'BUSCARDATOSUSUARIO';

--SELECTS
select * from productos;
select * from pfresco;
select * from factura;
select * from caja;
select * from DetalleFacturaProducto;
select * from DetalleFacturaPFresco;

--DELETE DATOS TABLAS
delete from productos;
delete from factura;
delete from DetalleFacturaProducto;
delete from DetalleFacturaPFresco;

--DELETE TABLAS
DROP TABLE DetalleFactura;

--DROP USERS
DROP USER alberto CASCADE;

--DROP SEQUENCES
DROP SEQUENCE detalleFacturaProducto_seq;
DROP SEQUENCE factura_id_sequence;