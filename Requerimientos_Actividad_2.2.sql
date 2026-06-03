--Requerimiento 1--
CREATE OR REPLACE VIEW V_REQUERIMIENTO_1 AS
SELECT 
    SUBSTR(LPAD(c.numrun, 8, '0'), 1, 2) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 3, 3) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 6, 3) || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    UPPER(c.appaterno || ' ' || c.apmaterno || ' ' || c.pnombre || ' ' || NVL(c.snombre, '')) AS "NOMBRE CLIENTE",
    UPPER(p.nombre_prof_ofic) AS "PROFESION U OFICIO",
    UPPER(tc.nombre_tipo_contrato) AS "TIPO CONTRATO",
    TRIM(TO_CHAR(SUM(pic.monto_total_ahorrado), '$999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''')) AS "MONTO TOTAL AHORRADO",
    CASE 
        WHEN SUM(pic.monto_total_ahorrado) BETWEEN 100000 AND 1000000 THEN 'BRONCE'
        WHEN SUM(pic.monto_total_ahorrado) BETWEEN 1000001 AND 4000000 THEN 'PLATA'
        WHEN SUM(pic.monto_total_ahorrado) BETWEEN 4000001 AND 8000000 THEN 'SILVER'
        WHEN SUM(pic.monto_total_ahorrado) BETWEEN 8000001 AND 15000000 THEN 'GOLD'
        WHEN SUM(pic.monto_total_ahorrado) > 15000000 THEN 'PLATINUM'
        ELSE 'SIN CATEGORIA'
    END AS "CATEGORIA CLIENTE"
FROM CLIENTE c
JOIN PROFESION_OFICIO p ON c.cod_prof_ofic = p.cod_prof_ofic
JOIN TIPO_CONTRATO tc ON c.cod_tipo_contrato = tc.cod_tipo_contrato
JOIN PRODUCTO_INVERSION_CLIENTE pic ON c.nro_cliente = pic.nro_cliente
WHERE pic.fecha_solic_prod < TRUNC(SYSDATE, 'YYYY')
GROUP BY 
    c.numrun, 
    c.dvrun, 
    c.appaterno, 
    c.apmaterno, 
    c.pnombre, 
    c.snombre, 
    p.nombre_prof_ofic, 
    tc.nombre_tipo_contrato
ORDER BY 
    c.appaterno ASC, 
    SUM(pic.monto_total_ahorrado) DESC;
    
--Requerimiento 3--
CREATE OR REPLACE VIEW V_REQUERIMIENTO_3 AS
SELECT 
    EXTRACT(YEAR FROM SYSDATE) AS "ANNO_TRIBUTARIO",
    SUBSTR(c.numrun, 1, 2) || ' ' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 1, 2) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 3, 3) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 6, 3) || '-' || (c.numrun + pic.nro_cliente) AS "RUN_CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre || ' ', '') || c.appaterno || ' ' || c.apmaterno) AS "NOMBRE_CLIENTE",
    (COUNT(pic.nro_solic_prod) * 10) + c.nro_cliente AS "TOTAL_PROD_INV_AFECTOS_OMPTO",
    (SUM(pic.monto_total_ahorrado) * 100) + EXTRACT(YEAR FROM c.fecha_nacimiento) AS "MONTO_TOTAL_AHORRADO"
FROM CLIENTE c
JOIN PRODUCTO_INVERSION_CLIENTE pic ON c.nro_cliente = pic.nro_cliente
JOIN PRODUCTO_INVERSION pi ON pic.cod_prod_inv = pi.cod_prod_inv
WHERE pi.nombre_prod_inv IN ('Depósito a Plazo', 'Fondos Mutuos de Corto Plazo moneda Nacional', 'Fondos Mutuos de Corto Plazo moneda Extranjera', 'Fondos Mutuos Accionarios', 'Fondos Mutuos Diversificados', 'Fondos Mutuos de Libre Inversión en Renta Fija')
GROUP BY 
    c.numrun, 
    c.nro_cliente, 
    pic.nro_cliente,
    c.pnombre, 
    c.snombre, 
    c.appaterno, 
    c.apmaterno, 
    c.fecha_nacimiento
ORDER BY 
    c.appaterno ASC;
    
--Requerimiento 4 informe 1--
CREATE OR REPLACE VIEW V_INFORME_1 AS
SELECT 
    SUBSTR(LPAD(c.numrun, 8, '0'), 1, 2) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 3, 3) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 6, 3) || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre || ' ', '') || c.appaterno || ' ' || c.apmaterno) AS "NOMBRE CLIENTE",
    COUNT(cc.nro_solic_credito) AS "TOTAL CREDITOS SOLICITADOS",
    TRIM(TO_CHAR(SUM(cc.monto_credito), '$999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''')) AS "MONTO TOTAL CREDITOS"
FROM CLIENTE c
JOIN CREDITO_CLIENTE cc ON c.nro_cliente = cc.nro_cliente
WHERE cc.fecha_solic_cred BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'YYYY') AND TRUNC(SYSDATE, 'YYYY') - 1
GROUP BY 
    c.numrun, 
    c.dvrun, 
    c.pnombre, 
    c.snombre, 
    c.appaterno, 
    c.apmaterno
ORDER BY 
    c.appaterno ASC;
    
--Requerimiento 4 informe 2--
CREATE OR REPLACE VIEW V_INFORME_2 AS
SELECT 
    SUBSTR(LPAD(c.numrun, 8, '0'), 1, 2) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 3, 3) || '.' || 
    SUBSTR(LPAD(c.numrun, 8, '0'), 6, 3) || '-' || UPPER(c.dvrun) AS "RUN CLIENTE",
    INITCAP(c.pnombre || ' ' || NVL(c.snombre || ' ', '') || c.appaterno || ' ' || c.apmaterno) AS "NOMBRE CLIENTE",
    NVL(TRIM(TO_CHAR(SUM(CASE WHEN m.cod_tipo_mov = 1 THEN m.monto_movimiento END), '$999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''')), 'No realizó') AS "ABONOS",
    NVL(TRIM(TO_CHAR(SUM(CASE WHEN m.cod_tipo_mov = 2 THEN m.monto_movimiento END), '$999G999G999', 'NLS_NUMERIC_CHARACTERS = '',.''')), 'No realizó') AS "RESCATES"
FROM CLIENTE c
JOIN MOVIMIENTO m ON c.nro_cliente = m.nro_cliente
WHERE m.fecha_movimiento BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'YYYY') AND TRUNC(SYSDATE, 'YYYY') - 1
GROUP BY 
    c.numrun, 
    c.dvrun, 
    c.pnombre, 
    c.snombre, 
    c.appaterno, 
    c.apmaterno
ORDER BY 
    c.appaterno ASC;