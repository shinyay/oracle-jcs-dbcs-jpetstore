DROP USER petstore cascade;

CREATE USER petstore IDENTIFIED BY "PETSTORE_PASSWORD" ;
GRANT DBA TO petstore;
exit;
