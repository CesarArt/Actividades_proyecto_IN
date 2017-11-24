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
    INTO OUTFILE "C:\\Users\\Samuel\\Desktop\\doc.csv"
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\n'
    FROM daterange dr
    INNER JOIN month_translations mt
    ON mt.month_num = dr.month_text_text_n_es
    INNER JOIN month_translations mth
    ON mth.month_num = dr.month_weekend_date_es
    INNER JOIN day_translations dt
    ON dt.day_num = dr.day_week_es
    GROUP BY dte;