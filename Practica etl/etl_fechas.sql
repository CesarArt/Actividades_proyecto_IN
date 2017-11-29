-- Creación de la tabla
DELIMITER $$

CREATE PROCEDURE etlFechas()
BEGIN
    DROP TABLE IF EXISTS fechas;
    CREATE TABLE fechas (
        id_fecha DATE,
        year_int INT,
        month_num INT,

        month_text_spanish VARCHAR(15),
        month_text_english VARCHAR(15),

        month_text_short_spanish VARCHAR(3),
        month_text_short_english VARCHAR(3),

        quarter_num INT,
        quarter_text_spanish VARCHAR(20),
        quarter_text_english VARCHAR(20),
        quarter_text_short_spanish VARCHAR(3),
        quarter_text_short_english VARCHAR(3)
    );

    INSERT INTO fechas
        SELECT
        so.orddate,

        YEAR(so.orddate),
        MONTH(so.orddate),

        -- month_text_spanish
        CASE WHEN MONTH(so.orddate) IN (1) THEN 'Enero'
        WHEN MONTH(so.orddate) IN (2) THEN 'Febrero'
        WHEN MONTH(so.orddate) IN (3) THEN 'Marzo'
        WHEN MONTH(so.orddate) IN (4) THEN 'Abril'
        WHEN MONTH(so.orddate) IN (5) THEN 'Mayo'
        WHEN MONTH(so.orddate) IN (6) THEN 'Junio'
        WHEN MONTH(so.orddate) IN (7) THEN 'Julio'
        WHEN MONTH(so.orddate) IN (8) THEN 'Agosto'
        WHEN MONTH(so.orddate) IN (9) THEN 'Septiembre'
        WHEN MONTH(so.orddate) IN (10) THEN 'Octubre'
        WHEN MONTH(so.orddate) IN (11) THEN 'Noviembre'
        WHEN MONTH(so.orddate) IN (12) THEN 'Diciembre'
        END,

        MONTHNAME(so.orddate),

        -- month_text_short_spanish
        CASE WHEN MONTH(so.orddate) IN (1) THEN REVERSE(SUBSTR(REVERSE('Enero'), -3))
        WHEN MONTH(so.orddate) IN (2) THEN REVERSE(SUBSTR(REVERSE('Febrero'), -3))
        WHEN MONTH(so.orddate) IN (3) THEN REVERSE(SUBSTR(REVERSE('Marzo'), -3))
        WHEN MONTH(so.orddate) IN (4) THEN REVERSE(SUBSTR(REVERSE('Abril'), -3))
        WHEN MONTH(so.orddate) IN (5) THEN REVERSE(SUBSTR(REVERSE('Mayo'), -3))
        WHEN MONTH(so.orddate) IN (6) THEN REVERSE(SUBSTR(REVERSE('Junio'), -3))
        WHEN MONTH(so.orddate) IN (7) THEN REVERSE(SUBSTR(REVERSE('Julio'), -3))
        WHEN MONTH(so.orddate) IN (8) THEN REVERSE(SUBSTR(REVERSE('Agosto'), -3))
        WHEN MONTH(so.orddate) IN (9) THEN REVERSE(SUBSTR(REVERSE('Septiembre'), -3))
        WHEN MONTH(so.orddate) IN (10) THEN REVERSE(SUBSTR(REVERSE('Octubre'), -3))
        WHEN MONTH(so.orddate) IN (11) THEN REVERSE(SUBSTR(REVERSE('Noviembre'), -3))
        WHEN MONTH(so.orddate) IN (12) THEN REVERSE(SUBSTR(REVERSE('Diciembre'), -3))
        END,

        REVERSE(SUBSTR(REVERSE(MONTHNAME(so.orddate)), -3)),

        -- quarter_num
        CASE WHEN MONTH(so.orddate) IN (1,2,3) THEN '1'
        WHEN MONTH(so.orddate) IN (4,5,6) THEN '2'
        WHEN MONTH(so.orddate) IN (7,8,9) THEN '3'
        WHEN MONTH(so.orddate) IN (10,11,12) THEN '4'
        END,

        -- quarter_text_spanish
        CASE WHEN MONTH(so.orddate) IN (1,2,3) THEN '1erTrimestre'
        WHEN MONTH(so.orddate) IN (4,5,6) THEN '2doTrimestre'
        WHEN MONTH(so.orddate) IN (7,8,9) THEN '3erTrimestre'
        WHEN MONTH(so.orddate) IN (10,11,12) THEN '4toTrimestre'
        END,

        -- quarter_text_english
        CASE WHEN MONTH(so.orddate) IN (1,2,3) THEN '1stQuarter'
        WHEN MONTH(so.orddate) IN (4,5,6) THEN '2ndQuarter'
        WHEN MONTH(so.orddate) IN (7,8,9) THEN '3rdQuarter'
        WHEN MONTH(so.orddate) IN (10,11,12) THEN '4thQuarter'
        END,

        -- quarter_text_short_spanish
        CASE WHEN MONTH(so.orddate) IN (1,2,3) THEN '1T'
        WHEN MONTH(so.orddate) IN (4,5,6) THEN '2T'
        WHEN MONTH(so.orddate) IN (7,8,9) THEN '3T'
        WHEN MONTH(so.orddate) IN (10,11,12) THEN '4T'
        END,

        -- quarter_text_short_english
        CASE WHEN MONTH(so.orddate) IN (1,2,3) THEN '1Q'
        WHEN MONTH(so.orddate) IN (4,5,6) THEN '2Q'
        WHEN MONTH(so.orddate) IN (7,8,9) THEN '3Q'
        WHEN MONTH(so.orddate) IN (10,11,12) THEN '4Q'
        END

        FROM infofesc_werp.salesorders so; 
END $$
DELIMITER ;