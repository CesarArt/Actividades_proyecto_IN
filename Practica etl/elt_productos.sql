CREATE PROCEDURE etlProductos()
BEGIN
DROP TABLE IF EXISTS productos;
CREATE TABLE productos(
    id_producto VARCHAR(20) PRIMARY KEY,
    descripcion_producto VARCHAR(50),
    descripcion_categoria CHAR(20));

INSERT INTO dw_nova.productos
SELECT
    sm.stockid AS 'id_producto',
    sm.description AS 'descripcion_producto',
    sc.categorydescription AS 'descripcion_categoria'
FROM infofesc_werp.stockmaster sm
INNER JOIN infofesc_werp.stockcategory sc
ON sm.categoryid = sc.categoryid
GROUP BY
1,2,3;
END;