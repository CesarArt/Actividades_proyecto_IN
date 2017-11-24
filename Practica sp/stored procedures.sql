-- Práctica 1 Stored Procedures
-- Samuel Báez Herrera

-- 1. Crear un SP que nos indique el total en importe (cantidad x precio) de cada cliente por categoría.

DELIMETER //
CREATE PROCEDURE GetClientTotalImport()
    BEGIN
    SELECT 
        cl.nombre AS 'Cliente',
        ca.desc_categoria AS 'Categoria',
        ca.desc_subcategoria AS 'Subategoria',
        SUM(v.cant * v.precio) AS 'Importe'
    FROM ventas v
    INNER JOIN clientes cl
    ON v.id_cliente = cl.id_cliente
    INNER JOIN productos p
    ON v.id_producto = p.id_producto
    INNER JOIN categorias ca
    ON p.id_subcategoria = ca.id_subcategoria
    GROUP BY
        cl.nombre,
        ca.desc_categoria,
        ca.desc_subcategoria
    ORDER BY
        cl.nombre ASC;
    END; //
DELIMETER ;

-- 2. Usando parámetros tipo IN crear un SP que muestre el total de venta en importe por cliente de un vendedor indicado por parámetro.

DELIMETER //
CREATE PROCEDURE GetSellTotal(IN empleadoId int(11))
BEGIN
    -- Muestra empleado seleccionado
    SELECT
        e.nombre AS "Empleado seleccionado"
    FROM empleados e
    WHERE e.id_empleado = empleadoId;

    SELECT
        cl.nombre AS 'Cliente',
        SUM(v.cant * v.precio) AS 'Importe'
    FROM ventas v
    INNER JOIN clientes cl
    ON cl.id_cliente = v.id_cliente
    WHERE v.id_empleado = empleadoId
    GROUP BY
        cl.nombre;
END; //
DELIMETER;

-- 3. Utilizando parámetros tipo IN y OUT generar un SP que entregue un listado de las ventas realizadas de un vendedor enviado por parámetro pero que ademas en dos variables me indique total de ventas en unidades y total de venta en pesos.

DELIMETER //
CREATE PROCEDURE GetSells(
    IN empleadoId int(11),
    OUT units int(11),
    OUT total int(11))
BEGIN
    -- Ventas
    SELECT
        v.id_venta AS 'ID de venta',
        v.id_factura AS 'Factura',
        cl.nombre AS 'Cliente de la venta',
        e.nombre AS 'Vendedor'
    FROM ventas v
    INNER JOIN clientes cl
    ON cl.id_cliente = v.id_cliente
    INNER JOIN empleados e
    ON e.id_empleado = v.id_empleado
    WHERE v.id_empleado = empleadoId
    GROUP BY
        v.id_venta,
        v.id_factura,
        cl.nombre;

    -- Variables
    SELECT
        SUM(v.cant) AS 'Unidades vendidas',
        SUM(v.cant * v.precio) AS 'Monto total de ventas'
    INTO units, total
    FROM ventas v
    WHERE v.id_empleado = empleadoId;
END; //
DELIMETER;