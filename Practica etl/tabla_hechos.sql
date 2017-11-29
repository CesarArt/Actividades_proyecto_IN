CREATE PROCEDURE cargaTablaHechos()
BEGIN

DROP TABLE IF EXISTS Ventas;
CREATE TABLE Ventas(
    id_producto VARCHAR(20),
    numero_cliente VARCHAR(20),
    fecha DATE,
    importe_venta DOUBLE,
    unidades_vendidas DOUBLE,
    venta_neta DOUBLE,
    PRIMARY KEY(id_producto, numero_cliente, fecha));

    ALTER TABLE Ventas
    ADD FOREIGN KEY(id_producto)
    REFERENCES productos(id_producto)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    ADD FOREIGN KEY(numero_cliente)
    REFERENCES clientes(id_cliente)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    ADD FOREIGN KEY(fecha)
    REFERENCES fechas(id_fecha)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

INSERT INTO Ventas 
    SELECT 
        sod.stkcode,
        CONCAT(so.debtorno, so.branchcode),
        so.orddate,
        SUM(sod.unitprice * sod.quantity),
        SUM(sod.quantity),
        SUM((sod.unitprice * sod.quantity) - (sm.lastcost * sod.quantity))
    FROM infofesc_werp.salesorders so 
    INNER JOIN infofesc_werp.salesorderdetails sod
    ON sod.orderno = so.orderno
    INNER JOIN infofesc_werp.stockmaster sm
    ON sod.stkcode = sm.stockid
    GROUP BY 1,2,3;
END