DECLARE
    c_iva               CONSTANT NUMBER(3,2) := 0.19;
    v_pct_ajuste        AJUSTE_CLIENTE.pct_ajuste%TYPE;
    v_monto_bruto       NUMBER(12);
    v_monto_ajuste      NUMBER(12);
    v_tipo_ajuste       VARCHAR2(10);
    v_monto_neto        NUMBER(12);
    v_iva               NUMBER(12);
    v_total_factura     NUMBER(12);

    CURSOR c_arriendos IS
        SELECT a.id_arriendo,
               a.cod_equipo,
               a.numrun_cli,
               c.id_tipo_cli,
               a.dias_solicitados,
               e.valor_arriendo_dia
          FROM ARRIENDO_EQUIPO_AV a
          JOIN EQUIPO_AV          e ON e.cod_equipo = a.cod_equipo
          JOIN CLIENTE            c ON c.numrun_cli = a.numrun_cli
         WHERE EXTRACT(MONTH FROM a.fecha_ini_arriendo) = 3
           AND EXTRACT(YEAR  FROM a.fecha_ini_arriendo) = 2026
         ORDER BY a.id_arriendo;

BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE FACTURA_ARRIENDO';

    FOR r_arriendo IN c_arriendos LOOP

        SELECT pct_ajuste
          INTO v_pct_ajuste
          FROM AJUSTE_CLIENTE
         WHERE id_tipo_cli = r_arriendo.id_tipo_cli;

        v_monto_bruto  := ROUND(r_arriendo.valor_arriendo_dia * r_arriendo.dias_solicitados);
        v_monto_ajuste := ROUND(v_monto_bruto * v_pct_ajuste / 100);

        IF v_pct_ajuste < 0 THEN
            v_tipo_ajuste := 'Descuento';
        ELSE
            v_tipo_ajuste := 'Recargo';
        END IF;

        v_monto_neto    := v_monto_bruto + v_monto_ajuste;
        v_iva           := ROUND(v_monto_neto * c_iva);
        v_total_factura := v_monto_neto + v_iva;

        INSERT INTO FACTURA_ARRIENDO (
            id_arriendo, cod_equipo, numrun_cli, id_tipo_cli,
            dias_solicitados, valor_arriendo_dia, monto_bruto,
            pct_ajuste, monto_ajuste, tipo_ajuste,
            monto_neto, iva, total_factura
        ) VALUES (
            r_arriendo.id_arriendo, r_arriendo.cod_equipo, r_arriendo.numrun_cli, r_arriendo.id_tipo_cli,
            r_arriendo.dias_solicitados, r_arriendo.valor_arriendo_dia, v_monto_bruto,
            v_pct_ajuste, v_monto_ajuste, v_tipo_ajuste,
            v_monto_neto, v_iva, v_total_factura
        );

    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso de facturación de arriendos ejecutado correctamente.');

END;
/

SELECT *
  FROM FACTURA_ARRIENDO
 ORDER BY id_arriendo;