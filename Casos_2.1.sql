--Caso 1--
INSERT INTO BONIF_ARRIENDOS_MENSUAL (
    ANNO_MES, 
    NUMRUN_EMP, 
    NOMBRE_EMPLEADO, 
    SUELDO_BASE, 
    TOTAL_ARRIENDOS_MENSUAL, 
    BONIF_POR_ARRIENDOS
)
SELECT 
    TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM')),
    e.numrun_emp,
    e.pnombre_emp || ' ' || NVL(e.snombre_emp, '') || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp,
    e.sueldo_base,
    COUNT(a.id_arriendo),
    ROUND(e.sueldo_base * (COUNT(a.id_arriendo) / 100))
FROM EMPLEADO e
JOIN CAMION c ON e.numrun_emp = c.numrun_emp
JOIN ARRIENDO_CAMION a ON c.nro_patente = a.nro_patente
WHERE TO_CHAR(a.fecha_ini_arriendo, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM')
GROUP BY 
    e.numrun_emp, 
    e.pnombre_emp, 
    e.snombre_emp, 
    e.appaterno_emp, 
    e.apmaterno_emp, 
    e.sueldo_base
HAVING COUNT(a.id_arriendo) > (
    SELECT AVG(COUNT(arr.id_arriendo))
    FROM EMPLEADO emp
    JOIN CAMION cam ON emp.numrun_emp = cam.numrun_emp
    JOIN ARRIENDO_CAMION arr ON cam.nro_patente = arr.nro_patente
    WHERE TO_CHAR(arr.fecha_ini_arriendo, 'YYYYMM') = TO_CHAR(SYSDATE, 'YYYYMM')
    GROUP BY emp.numrun_emp
)
ORDER BY e.appaterno_emp ASC;

COMMIT;

--Caso 2--
INSERT INTO CLIENTES_ARRIENDOS_MENOS_PROM (
    ANNO_PROCESO, 
    NOMBRE_CLIENTE, 
    TOTAL_ARRIENDOS
)
SELECT 
    EXTRACT(YEAR FROM SYSDATE),
    c.pnombre_cli || ' ' || NVL(c.snombre_cli, '') || ' ' || c.appaterno_cli || ' ' || c.apmaterno_cli,
    COUNT(a.id_arriendo)
FROM CLIENTE c
LEFT JOIN ARRIENDO_CAMION a 
    ON c.numrun_cli = a.numrun_cli 
    AND EXTRACT(YEAR FROM a.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY 
    c.numrun_cli, 
    c.pnombre_cli, 
    c.snombre_cli, 
    c.appaterno_cli, 
    c.apmaterno_cli
HAVING COUNT(a.id_arriendo) < (
    SELECT AVG(COUNT(arr.id_arriendo))
    FROM CLIENTE cli
    LEFT JOIN ARRIENDO_CAMION arr 
        ON cli.numrun_cli = arr.numrun_cli 
        AND EXTRACT(YEAR FROM arr.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
    GROUP BY cli.numrun_cli
)
ORDER BY c.appaterno_cli ASC;

UPDATE CLIENTE
SET id_categoria_cli = 100
WHERE numrun_cli IN (
    SELECT c.numrun_cli
    FROM CLIENTE c
    LEFT JOIN ARRIENDO_CAMION a 
        ON c.numrun_cli = a.numrun_cli 
        AND EXTRACT(YEAR FROM a.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
    GROUP BY c.numrun_cli
    HAVING COUNT(a.id_arriendo) < (
        SELECT AVG(COUNT(arr.id_arriendo))
        FROM CLIENTE cli
        LEFT JOIN ARRIENDO_CAMION arr 
            ON cli.numrun_cli = arr.numrun_cli 
            AND EXTRACT(YEAR FROM arr.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
        GROUP BY cli.numrun_cli
    )
);

COMMIT;

--Caso 3--
CREATE TABLE CLIENTES_SIN_ARRIENDOS AS SELECT * FROM CLIENTE WHERE 1=0;

INSERT INTO CLIENTES_SIN_ARRIENDOS
SELECT * FROM CLIENTE
WHERE numrun_cli NOT IN (
    SELECT numrun_cli 
    FROM ARRIENDO_CAMION 
    WHERE fecha_ini_arriendo IS NOT NULL 
      AND EXTRACT(YEAR FROM fecha_ini_arriendo) BETWEEN EXTRACT(YEAR FROM SYSDATE) - 2 AND EXTRACT(YEAR FROM SYSDATE) - 1
);

DELETE FROM CLIENTE
WHERE numrun_cli IN (
    SELECT numrun_cli FROM CLIENTES_SIN_ARRIENDOS
);

COMMIT;

--Caso 4--
INSERT INTO HIST_ARRIENDO_ANUAL_CAMION (
    ANNO_PROCESO, 
    NRO_PATENTE, 
    VALOR_ARRIENDO_DIA, 
    VALOR_GARACTIA_DIA, 
    TOTAL_RECES_ARRENDADO
)
SELECT 
    EXTRACT(YEAR FROM SYSDATE),
    c.nro_patente,
    c.valor_arriendo_dia,
    c.valor_garantia_dia,
    COUNT(a.id_arriendo)
FROM CAMION c
LEFT JOIN ARRIENDO_CAMION a 
    ON c.nro_patente = a.nro_patente 
    AND EXTRACT(YEAR FROM a.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY 
    c.nro_patente, 
    c.valor_arriendo_dia, 
    c.valor_garantia_dia
ORDER BY c.nro_patente ASC;

UPDATE CAMION
SET 
    valor_arriendo_dia = ROUND(valor_arriendo_dia * 0.775),
    valor_garantia_dia = ROUND(valor_garantia_dia * 0.775)
WHERE nro_patente IN (
    SELECT c.nro_patente
    FROM CAMION c
    LEFT JOIN ARRIENDO_CAMION a 
        ON c.nro_patente = a.nro_patente 
        AND EXTRACT(YEAR FROM a.fecha_ini_arriendo) = EXTRACT(YEAR FROM SYSDATE)
    GROUP BY c.nro_patente
    HAVING COUNT(a.id_arriendo) < 4
);

COMMIT;

--Caso 5--
INSERT INTO INFORMACION_SII (
    NUMRUN_EMP,
    DVRUN_EMP,
    ANNO_TRIBUTARIO,
    NOMBRE_EMP,
    MESES_TRABAJADOS_ANNO,
    ANNOS_TRABAJADOS,
    SUELDO_BASE_MENSUAL,
    SUELDO_BASE_ANUAL,
    BONO_POR_ANNOS_ANUAL,
    MOVILIZACIÓN_ANUAL,
    COLACIÓN_ANUAL,
    SUELDO_BRUTO_ANUAL,
    RENTA_IMPONIBLE_ANUAL
)
SELECT 
    e.numrun_emp,
    e.dvrun_emp,
    EXTRACT(YEAR FROM SYSDATE),
    e.pnombre_emp || ' ' || NVL(e.snombre_emp, '') || ' ' || e.appaterno_emp || ' ' || e.apmaterno_emp,
    CASE 
        WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 THEN 12
        WHEN EXTRACT(YEAR FROM e.fecha_contrato) = EXTRACT(YEAR FROM SYSDATE) - 1 
        THEN ROUND(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato), 1)
        ELSE 0
    END,
    CASE 
        WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 
        THEN TRUNC(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato) / 12)
        ELSE 0
    END,
    e.sueldo_base,
    e.sueldo_base * (
        CASE 
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 THEN 12
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) = EXTRACT(YEAR FROM SYSDATE) - 1 
            THEN ROUND(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato), 1)
            ELSE 0
        END
    ),
    (e.sueldo_base * (
        CASE 
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 
            THEN TRUNC(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato) / 12)
            ELSE 0
        END
    ) / 100) * (
        CASE 
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 THEN 12
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) = EXTRACT(YEAR FROM SYSDATE) - 1 
            THEN ROUND(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato), 1)
            ELSE 0
        END
    ),
    (e.sueldo_base * 0.12) * (
        CASE 
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 THEN 12
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) = EXTRACT(YEAR FROM SYSDATE) - 1 
            THEN ROUND(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato), 1)
            ELSE 0
        END
    ),
    (e.sueldo_base * 0.20) * (
        CASE 
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 THEN 12
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) = EXTRACT(YEAR FROM SYSDATE) - 1 
            THEN ROUND(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato), 1)
            ELSE 0
        END
    ),
    (e.sueldo_base + 
     (e.sueldo_base * (
         CASE 
             WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 
             THEN TRUNC(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato) / 12)
             ELSE 0
         END
     ) / 100) + 
     (e.sueldo_base * 0.12) + 
     (e.sueldo_base * 0.20)) * (
        CASE 
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 THEN 12
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) = EXTRACT(YEAR FROM SYSDATE) - 1 
            THEN ROUND(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato), 1)
            ELSE 0
        END
    ),
    (e.sueldo_base + 
     (e.sueldo_base * (
         CASE 
             WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 
             THEN TRUNC(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato) / 12)
             ELSE 0
         END
     ) / 100)) * (
        CASE 
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) < EXTRACT(YEAR FROM SYSDATE) - 1 THEN 12
            WHEN EXTRACT(YEAR FROM e.fecha_contrato) = EXTRACT(YEAR FROM SYSDATE) - 1 
            THEN ROUND(MONTHS_BETWEEN(TO_DATE('31/12/' || (EXTRACT(YEAR FROM SYSDATE) - 1), 'DD/MM/YYYY'), e.fecha_contrato), 1)
            ELSE 0
        END
    )
FROM EMPLEADO e
WHERE EXTRACT(YEAR FROM e.fecha_contrato) <= EXTRACT(YEAR FROM SYSDATE) - 1
ORDER BY e.numrun_emp ASC;

COMMIT;