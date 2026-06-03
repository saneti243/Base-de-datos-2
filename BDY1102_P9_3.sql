CREATE OR REPLACE VIEW V_DATOS_CLIENTES AS
SELECT 
    c.numrun || '-' || c.dvrun AS "RUN CLIENTE",
    c.pnombre || ' ' || NVL(c.snombre, '') || ' ' || c.appaterno || ' ' || NVL(c.apmaterno, '') AS "NOMBRE CLIENTE",
    c.direccion || ',' || co.nombre_comuna AS "Dirección Cliente"
FROM SYN_CLIENTE c
JOIN SYN_COMUNA co 
  ON c.cod_region = co.cod_region 
 AND c.cod_provincia = co.cod_provincia 
 AND c.cod_comuna = co.cod_comuna;


GRANT SELECT ON V_DATOS_CLIENTES TO BDY1102_P9_4;