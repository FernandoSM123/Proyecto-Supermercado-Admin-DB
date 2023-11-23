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
SELECT username, timestamp, action_name, SQL_TEXT FROM DBA_AUDIT_TRAIL;
SELECT * from DBA_AUDIT_TRAIL;

--DELETE DATOS TABLAS
delete from productos;
delete from pfresco;
delete from factura;
delete from DetalleFacturaProducto;
delete from DetalleFacturaPFresco;

--DELETE TABLAS
DROP TABLE DetalleFacturaProducto;
DROP TABLE DetalleFacturaPFresco;
DROP TABLE factura;
DROP TABLE productos;
DROP TABLE pfresco;

--DROP USERS
DROP USER alberto CASCADE;

--DROP SEQUENCES
DROP SEQUENCE producto_id_sequence;
DROP SEQUENCE pfresco_id_sequence;

DROP SEQUENCE factura_id_sequence;

DROP SEQUENCE detalleFacturaProducto_seq;
DROP SEQUENCE detalleFacturaPFresco_seq;