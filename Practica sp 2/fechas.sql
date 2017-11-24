-- Estas variables son usadas al momento de llamar al procedimiento
-- Sus valores pueden ser sustituidos por cualquier formato de fecha aceptada por el motor de la base de datos.
-- Ejemplo: CALL CreateAndGetDateList(@initial_date, @final_date);
SET @initial_date = DATE(NOW());
SET @final_date = DATE("2017-12-31");


----        Procedimientos almacenados

-- Creación de la tabla y obtención de datos.
-- Es la llamada de los dos procedimientos almacenados necesarios para crear esto.
DELIMETER $$
CREATE PROCEDURE CreateAndGetDateList(
    IN _fromdate DATE,
    IN _todate DATE)
BEGIN
    -- Crear tabla
    CALL CreateDatesTable(_fromdate, _todate);

    -- Seleccion de los datos
    CALL GetDateList();
END; $$
DELIMETER ;



-- Creación de la tabla
DELIMITER $$
CREATE PROCEDURE CreateDatesTable(
    IN _fromdate DATE,
    IN _todate DATE)
BEGIN
	DROP TABLE IF EXISTS fechas;
    CREATE TABLE fechas (
        dte DATE,

        year_int INT,
        month_int INT,
        day_int INT,

        year_text_num VARCHAR(4),
        month_text_num VARCHAR(2),

        month_text_text_n_es INT,
        -- month_text_text_3l_es VARCHAR(3),

        month_text_text_n_en VARCHAR(15),
        month_text_text_3l_en VARCHAR(3),

        day_text VARCHAR(2),

        date_amd_num INT,
        date_amd_text VARCHAR(8),

        day_week_num INT,
        -- day_week_l_esp VARCHAR(1),
        -- day_week_n_es VARCHAR(15),
        -- day_week_3l_es VARCHAR(3),
        day_week_es INT,

        day_week_l_en VARCHAR(2),
        day_week_n_en VARCHAR(15),
        day_week_3l_en VARCHAR(3),

        week_num INT,
        trim_num INT,
        trim_n VARCHAR(20),
        trim_n2l VARCHAR(2),
        trim_n2l_en VARCHAR(2),

        weekend_date DATE,
        year_weekend_date_num INT,
        month_weekend_date_num INT,
        day_weekend_date_num INT,
        year_weekend_date_text VARCHAR(4),
        month_weekend_date_text VARCHAR(2),
        
        -- month_weekend_date_n_es VARCHAR(15),
        -- month_weekend_date_3l_es VARCHAR(3),
        month_weekend_date_es INT,
        month_weekend_date_n_en VARCHAR(15),
        month_weekend_date_3l_en VARCHAR(3),
        day_weekend_date_text VARCHAR(2),

        date_weekend_amd_num INT,
        date_weekend_amd_text VARCHAR(8)
    );

    DROP TABLE IF EXISTS month_translations;
    CREATE TABLE month_translations(
        month_num INT PRIMARY KEY,
        name VARCHAR(15),
        name_3l VARCHAR(3)
    );

    DROP TABLE IF EXISTS day_translations;
    CREATE TABLE day_translations(
        day_num INT PRIMARY KEY,
        name VARCHAR(15),
        name_1l VARCHAR(1),
        name_3l VARCHAR(3)
    );    

    ALTER TABLE fechas
    ADD FOREIGN KEY(month_text_text_n_es)
    REFERENCES month_translations(month_num)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    ADD FOREIGN KEY(month_weekend_date_es)
    REFERENCES month_translations(month_num)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

    ALTER TABLE fechas
    ADD FOREIGN KEY(day_week_es)
    REFERENCES day_translations(day_num)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

    INSERT INTO day_translations VALUES
    (1, "Domingo", "D", "Dom"),
    (2, "Lunes", "L", "Lun"),
    (3, "Martes", "M", "Mar"),
    (4, "Miercoles", "X", "Mier"),
    (5, "Jueves", "J", "Jue"),
    (6, "Viernes", "V", "Vie"),
    (7, "Sabado", "S", "Sab");

    INSERT INTO month_translations VALUES
    (1, "Enero", "Ene"),
    (2, "Febrero", "Feb"),
    (3, "Marzo", "Mar"),
    (4, "Abril", "Abr"),
    (5, "Mayo", "May"),
    (6, "Junio", "Jun"),
    (7, "Julio", "Jul"),
    (8, "Agosto", "Ago"),
    (9, "Septiembre", "Sep"),
    (10, "Octubre", "Oct"),
    (11, "Noviembre", "Nov"),
    (12, "Diciembre", "Dic");

    SET @counter := -1;
    WHILE (@counter < DATEDIFF(DATE(_todate), DATE(_fromdate))) DO
        SET @new_date = DATE_ADD(_fromdate, INTERVAL @counter:=@counter + 1 DAY);

        SET @weekend_date = DATE_ADD(@new_date, INTERVAL (7 - DAYOFWEEK(@new_date)) DAY);

        INSERT INTO fechas (
            dte,

            year_int,
            month_int,
            day_int,

            year_text_num,
            month_text_num,

            month_text_text_n_es,

            month_text_text_n_en,
            month_text_text_3l_en,

            day_text,
            
            date_amd_num,
            date_amd_text,

            day_week_num,
            day_week_es,
            day_week_l_en,
            day_week_n_en,
            day_week_3l_en,

            week_num,

            trim_num,
            trim_n,
            trim_n2l,
            trim_n2l_en,

            weekend_date,
            year_weekend_date_num,
            month_weekend_date_num,
            day_weekend_date_num,

            year_weekend_date_text,
            month_weekend_date_text,
            
            month_weekend_date_es,
            month_weekend_date_n_en,
            month_weekend_date_3l_en,
            day_weekend_date_text,

            date_weekend_amd_num,
            date_weekend_amd_text
        )
        VALUES
        (
            @new_date,

            YEAR(@new_date),
            MONTH(@new_date),
            DAY(@new_date),

            YEAR(@new_date),
            MONTH(@new_date),

            MONTH(@new_date),

            MONTHNAME(@new_date),
            REVERSE(SUBSTR(REVERSE(MONTHNAME(@new_date)), -3)),

            DAY(@new_date),

            DATE(@new_date) + 0,
            DATE(@new_date) + 0,

            DAYOFWEEK(@new_date),
            DAYOFWEEK(@new_date),
            REVERSE(SUBSTR(REVERSE(DAYNAME(@new_date)), -2)),
            DAYNAME(@new_date),
            REVERSE(SUBSTR(REVERSE(MONTHNAME(@new_date)), -3)),

            WEEKOFYEAR(@new_date),

            -- trim_num
            CASE WHEN MONTH(@new_date) IN (1,2,3) THEN '1'
            WHEN MONTH(@new_date) IN (4,5,6) THEN '2'
            WHEN MONTH(@new_date) IN (7,8,9) THEN '3'
            WHEN MONTH(@new_date) IN (10,11,12) THEN '4'
            END,

            -- trim_n
            CASE WHEN MONTH(@new_date) IN (1,2,3) THEN '1erTrimestre'
            WHEN MONTH(@new_date) IN (4,5,6) THEN '2doTrimestre'
            WHEN MONTH(@new_date) IN (7,8,9) THEN '3erTrimestre'
            WHEN MONTH(@new_date) IN (10,11,12) THEN '4toTrimestre'
            END,

            -- trim_n2l
            CASE WHEN MONTH(@new_date) IN (1,2,3) THEN '1T'
            WHEN MONTH(@new_date) IN (4,5,6) THEN '2T'
            WHEN MONTH(@new_date) IN (7,8,9) THEN '3T'
            WHEN MONTH(@new_date) IN (10,11,12) THEN '4T'
            END,

            -- trim_n2l_en
            CASE WHEN MONTH(@new_date) IN (1,2,3) THEN '1Q'
            WHEN MONTH(@new_date) IN (4,5,6) THEN '2Q'
            WHEN MONTH(@new_date) IN (7,8,9) THEN '3Q'
            WHEN MONTH(@new_date) IN (10,11,12) THEN '4Q'
            END,

            @weekend_date,
            YEAR(@weekend_date),
            MONTH(@weekend_date),
            DAY(@weekend_date),

            YEAR(@weekend_date),
            MONTH(@weekend_date),

            MONTH(@weekend_date),
            MONTHNAME(@weekend_date),
            REVERSE(SUBSTR(REVERSE(MONTHNAME(@weekend_date)), -3)),
            DAY(@weekend_date),

            DATE(@weekend_date) + 0,
            DATE(@weekend_date) + 0
        );

        SET @new_date = NULL;
    END WHILE;
END$$
DELIMITER ;



-- Obtener datos de la tabla
-- Obtiene los datos de la tabla creada previamente y les da un formato
DELIMITER $$
CREATE PROCEDURE GetDateList()
BEGIN
	SELECT
        dr.dte AS "Fecha",
        dr.year_int AS "AñoNum",
        dr.month_int AS "MesNum",
        dr.day_int AS "DiaNum",

        dr.year_text_num AS "AñoNum",
        dr.month_text_num AS "MesNum",

        mt.name AS "mesNEsp",
        mt.name_3l AS "mes3LEsp",

        dr.month_text_text_n_en AS "MesNEng",
        dr.month_text_text_3l_en AS "Mes3LEng",

        dr.day_text AS "DayText",
        
        dr.date_amd_num AS "FechaAMD",
        dr.date_amd_text AS "FechaAMDText",

        dr.day_week_num AS "DiaSemNum",
        dt.name AS "DiaSemNeng",
        dt.name_1l AS "DiaSemLEng",
        dt.name_3l AS "DiaSem3LEng",
        dr.day_week_l_en AS "DiaSemLEng",
        dr.day_week_n_en AS "DiaSemNeng",
        dr.day_week_3l_en AS "DiaSem3LEng",

        dr.week_num AS "Semana",
        dr.trim_num AS "TrimNum",
        dr.trim_n AS "TrimN",
        dr.trim_n2l AS "TrimN2L",
        dr.trim_n2l_en AS "TrimN2LEng",

        dr.weekend_date AS "FechaFinSemana",
        dr.year_weekend_date_num AS "FFSañoNum",
        dr.month_weekend_date_num AS "FFSmesNum",
        dr.day_weekend_date_num AS "FFSdiaNum",
        dr.year_weekend_date_text AS "FFSAñoTxt",
        dr.month_weekend_date_text AS "FFSMesTxt",
        
        mth.name AS "FFSmesNEsp",
        mth.name_3l AS "FFSmes3LEsp",
        
        dr.month_weekend_date_n_en AS "FFSmesNEng",
        dr.month_weekend_date_3l_en AS "FFSmes3LEng",
        dr.day_weekend_date_text AS "FFSDiaTxt",

        dr.date_weekend_amd_num AS "FFSFechAMD",
        dr.date_weekend_amd_text AS "FFSFechAMDTXT"
    FROM fechas dr
    INNER JOIN month_translations mt
    ON mt.month_num = dr.month_text_text_n_es
    INNER JOIN month_translations mth
    ON mth.month_num = dr.month_weekend_date_es
    INNER JOIN day_translations dt
    ON dt.day_num = dr.day_week_es
    GROUP BY dte;
END$$
DELIMITER ;