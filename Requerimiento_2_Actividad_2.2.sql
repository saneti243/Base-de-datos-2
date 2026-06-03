--Requerimiento 2--
CREATE OR REPLACE VIEW V_REQUERIMIENTO_2 AS
SELECT 
    TO_CHAR(cc.fecha_otorga_cred, 'MMYYYY') AS "MES TRANSACCIÓN",
    UPPER(cr.nombre_credito) AS "TIPO CREDITO",
    SUM(cc.monto_credito) AS "MONTO SOLICITADO CREDITO",
    SUM(cc.monto_credito * (ap.porc_entrega_sbif / 100)) AS "APORTE A LA SBIF"
FROM BDY1102_P7_1.CREDITO_CLIENTE cc
JOIN BDY1102_P7_1.CREDITO cr ON cc.cod_credito = cr.cod_credito
JOIN BDY1102_P7_1.APORTE_A_SBIF ap ON cc.monto_credito BETWEEN ap.monto_credito_desde AND ap.monto_credito_hasta
WHERE cc.fecha_otorga_cred BETWEEN TRUNC(ADD_MONTHS(SYSDATE, -12), 'YYYY') AND TRUNC(SYSDATE, 'YYYY') - 1
GROUP BY 
    TO_CHAR(cc.fecha_otorga_cred, 'MMYYYY'), 
    cr.nombre_credito
ORDER BY 
    "MES TRANSACCIÓN" ASC, 
    "TIPO CREDITO" ASC;