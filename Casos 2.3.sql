--CASO  1
CREATE INDEX IDX_PROD_INV_CLIENTES 
ON PRODUCTO_INVERSION_CLIENTE (COD_PROD_INV);
CREATE OR REPLACE VIEW V_CLIENTES_CON_MAS_PROD_INV AS
SELECT EXTRACT(YEAR FROM SYSDATE) "AÑO TRIBUTARIO",
       TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || SUBSTR(c.snombre,1,1) || '. ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       COUNT(pic.nro_cliente) "TOTAL PROD. INV AFECTOS IMPTO",
       LPAD(TO_CHAR(SUM(pic.monto_total_ahorrado),'$999G999G999'),21, ' ') "MONTO TOTAL AHORRADO"
FROM cliente c JOIN producto_inversion_cliente pic
ON c.nro_cliente=pic.nro_cliente
WHERE pic.cod_prod_inv IN(30,35,40,45,50,55)
GROUP BY numrun, c.dvrun, c.pnombre, c.snombre, c.appaterno, c.apmaterno
HAVING COUNT(c.nro_cliente) IN (SELECT MAX(COUNT(*))
                                FROM producto_inversion_cliente
                                GROUP BY nro_cliente)
WITH READ ONLY;

SELECT * FROM V_CLIENTES_CON_MAS_PROD_INV 
ORDER BY "RUN CLIENTE";

--CASO 2   ESTARÁN DE CUMPLEAÑOS EL SIGUIENTE MES
DROP INDEX IDX_DATO_CLIENTE;

CREATE INDEX IDX_DATO_CLIENTE 
ON CLIENTE (EXTRACT(MONTH FROM FECHA_NACIMIENTO));

CREATE OR REPLACE VIEW V_CLIENTES_CUMPLES_MES AS
SELECT TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       TO_CHAR(c.fecha_nacimiento,'dd " de " MONTH') "DIA DE CUMPLEAÑOS"
FROM cliente c
WHERE EXTRACT(MONTH FROM c.fecha_nacimiento) = EXTRACT(MONTH FROM SYSDATE) + 1
WITH READ ONLY;

--CASO  3
DROP INDEX IDX_CREDITO_CLIENTE;

CREATE INDEX IDX_CREDITO_CLIENTE 
ON CREDITO_CLIENTE (MONTO_CREDITO);

CREATE OR REPLACE VIEW V_CRED_MAYOR_PROM AS
SELECT TO_CHAR(crc.fecha_otorga_cred,'MMYYYY') "MES TRANSACCIÓN",
       c.nombre_credito "TIPO CREDITO",
       SUM(crc.monto_credito) "MONTO SOLICITADO CREDITO",
       SUM(CASE WHEN crc.monto_credito BETWEEN 100000 AND 1000000 THEN ROUND(crc.monto_credito*0.01)
            WHEN crc.monto_credito BETWEEN 1000001 AND 2000000 THEN ROUND(crc.monto_credito*0.02)
            WHEN crc.monto_credito BETWEEN 2000001 AND 4000000 THEN ROUND(crc.monto_credito*0.03)
            WHEN crc.monto_credito BETWEEN 4000001 AND 6000000 THEN ROUND(crc.monto_credito*0.04)
       ELSE ROUND(crc.monto_credito*0.07) END) "APORTE A LA SBIF"
FROM credito_cliente crc JOIN credito c
ON crc.cod_credito=c.cod_credito
WHERE crc.monto_credito > (SELECT ROUND(AVG(monto_credito))
                          FROM credito_cliente)
GROUP BY TO_CHAR(crc.fecha_otorga_cred,'MMYYYY'), c.nombre_credito
WITH READ ONLY;
--CASO  4
--Sentencia  Clientes_Prod_Inv_SII
DROP INDEX IDX_PROD_INV_CLIENTES_ANUAL;
DROP INDEX IDX_PROD_CLIENTES_DEPEN;

CREATE INDEX IDX_PROD_INV_CLIENTES_ANUAL 
ON PRODUCTO_INVERSION_CLIENTE (EXTRACT(YEAR FROM FECHA_SOLIC_PROD));

CREATE INDEX IDX_PROD_CLIENTES_DEPEN 
ON CLIENTE (COD_TIPO_CONTRATO);

SELECT TO_CHAR(c.numrun,'09G999G999') || '-' || UPPER(c.dvrun) "RUN CLIENTE",
       INITCAP(c.pnombre || ' ' || c.snombre || ' ' || c.appaterno || ' ' || c.apmaterno) "NOMBRE CLIENTE",
       pi.nombre_prod_inv "PRODUCTO DE INVERSION",
       pic.monto_total_ahorrado "MONTO TOTAL AHORRADO"
FROM cliente c JOIN producto_inversion_cliente pic
ON c.nro_cliente = pic.nro_cliente
JOIN producto_inversion pi
ON pic.cod_prod_inv=pi.cod_prod_inv
WHERE EXTRACT(YEAR FROM pic.fecha_solic_prod) = EXTRACT(YEAR FROM SYSDATE)
AND c.cod_tipo_contrato = 1
ORDER BY c.appaterno;