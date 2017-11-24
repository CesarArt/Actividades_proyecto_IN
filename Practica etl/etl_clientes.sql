SELECT
    CONCAT(dm.debtorno, cb.branchcode) AS 'id_cliente',
    dm.name AS 'nombre_cliente',
    dm.address4 AS 'estado_cliente',
    CONCAT_WS(', ', cb.brname, cb.braddress4) AS 'Sucursal'
FROM debtorsmaster dm
INNER JOIN custbranch cb
ON dm.debtorno = cb.debtorno
GROUP BY
1,2,3,4,5;

----------------------
SELECT
    CONCAT(dm.debtorno, cb.branchcode) AS 'id_cliente',
    dm.name AS 'nombre_cliente',
    dm.address4 AS 'estado_cliente',
    cb.brname AS 'nombre_sucursal',
    cb.braddress4 AS 'estado_sucursal'
FROM debtorsmaster dm
INNER JOIN custbranch cb
ON dm.debtorno = cb.debtorno
GROUP BY
1,2,3,4,5;



-- Fuente: https://stackoverflow.com/questions/3399657/select-insert-across-multiple-databases-with-mysql

CREATE PROCEDURE etlClientes()
BEGIN
DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes(
    id_cliente VARCHAR(20),
    nombre_cliente VARCHAR(40),
    estado_cliente VARCHAR(50),
    nombre_sucursal VARCHAR(40),
    estado_sucursal VARCHAR(50));

INSERT INTO dw_nova.clientes
SELECT
    CONCAT(dm.debtorno, cb.branchcode) AS 'id_cliente',
    dm.name AS 'nombre_cliente',
    dm.address4 AS 'estado_cliente',
    cb.brname AS 'nombre_sucursal',
    cb.braddress4 AS 'estado_sucursal'
FROM infofesc_werp.debtorsmaster dm
INNER JOIN infofesc_werp.custbranch cb
ON dm.debtorno = cb.debtorno
GROUP BY
1,2,3,4,5;
END;
