CREATE OR REPLACE VIEW V_TOTAL_CREDITOS_CLIENTE AS
SELECT 
    c.numrun || '-' || c.dvrun AS "RUN CLIENTE",
    c.pnombre || ' ' || NVL(c.snombre, '') || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '') AS "NOMBRE CLIENTE",
    COUNT(cc.nro_solic_credito) AS "CREDITOS SOLICITADOS"
FROM SYN_CLIENTE c
JOIN SYN_CREDITO_CLIENTE cc ON c.nro_cliente = cc.nro_cliente
GROUP BY c.numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno;

GRANT SELECT ON V_TOTAL_CREDITOS_CLIENTE TO BDY1102_P9_3;