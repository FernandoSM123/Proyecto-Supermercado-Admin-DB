SELECT tablespace_name FROM dba_tablespaces; --ver tablespaces
SELECT * from dba_role_privs; --ver roles
SELECT * from dba_users; --ver usuarios

SELECT owner
FROM all_procedures
WHERE object_name = 'BUSCARDATOSUSUARIO';

DROP USER alberto CASCADE;