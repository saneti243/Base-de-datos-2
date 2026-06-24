DECLARE
    CURSOR cur_clientes IS
        SELECT numrun_cli,
               dvrun_cli,
               appaterno_cli || ' ' || apmaterno_cli || ' ' || pnombre_cli ||
                   CASE WHEN snombre_cli IS NOT NULL THEN ' ' || snombre_cli ELSE '' END
                   AS nombre_cliente
        FROM   CLIENTE
        ORDER  BY numrun_cli;
    v_numrun_cli        CLIENTE.numrun_cli%TYPE;
    v_dvrun_cli         CLIENTE.dvrun_cli%TYPE;
    v_nombre_cliente    VARCHAR2(100);

    v_cantidad_arriendos  NUMBER(5)  := 0;
    v_total_dias          NUMBER(6)  := 0;
    v_monto_total         NUMBER(14) := 0;
    v_puntaje             NUMBER(7)  := 0;
    v_categoria_fidelidad VARCHAR2(10);
    v_anno_proceso        NUMBER(4) := EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -12));
    v_total_procesados    NUMBER(5) := 0;
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCORING_CLIENTE';
    OPEN cur_clientes;
    LOOP
        FETCH cur_clientes INTO v_numrun_cli, v_dvrun_cli, v_nombre_cliente;
        EXIT WHEN cur_clientes%NOTFOUND;
        SELECT COUNT(*)
        INTO   v_cantidad_arriendos
        FROM   ARRIENDO_MOTO
        WHERE  numrun_cli = v_numrun_cli
          AND  EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno_proceso;
        SELECT NVL(SUM(dias_solicitados), 0)
        INTO   v_total_dias
        FROM   ARRIENDO_MOTO
        WHERE  numrun_cli = v_numrun_cli
          AND  EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno_proceso;
        SELECT NVL(SUM(m.valor_arriendo_dia * a.dias_solicitados), 0)
        INTO   v_monto_total
        FROM   ARRIENDO_MOTO a
               JOIN MOTOCICLETA m ON a.placa = m.placa
        WHERE  a.numrun_cli = v_numrun_cli
          AND  EXTRACT(YEAR FROM a.fecha_ini_arriendo) = v_anno_proceso;
        v_puntaje := ROUND(
                        (v_cantidad_arriendos * 10)
                      + (v_total_dias * 3)
                      + (v_monto_total / 50000)
                     );         
        IF v_puntaje >= 150 THEN
            v_categoria_fidelidad := 'Oro';
        ELSIF v_puntaje >= 60 THEN
            v_categoria_fidelidad := 'Plata';
        ELSIF v_puntaje >= 1 THEN
            v_categoria_fidelidad := 'Bronce';
        ELSE
            v_categoria_fidelidad := 'Nuevo';
        END IF;
        
        v_total_procesados := v_total_procesados + 1;
        INSERT INTO SCORING_CLIENTE (
            numrun_cli,
            dvrun_cli,
            nombre_cliente,
            anno_proceso,
            cantidad_arriendos,
            total_dias,
            monto_total,
            puntaje,
            categoria_fidelidad
        ) VALUES (
            v_numrun_cli,
            v_dvrun_cli,
            v_nombre_cliente,
            v_anno_proceso,
            v_cantidad_arriendos,
            v_total_dias,
            v_monto_total,
            v_puntaje,
            v_categoria_fidelidad
        );

    END LOOP;
    CLOSE cur_clientes;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso de scoring finalizado correctamente.');
    DBMS_OUTPUT.PUT_LINE('Año de proceso: ' || v_anno_proceso);
    DBMS_OUTPUT.PUT_LINE('Clientes procesados: ' || v_total_procesados);
EXCEPTION
    WHEN OTHERS THEN
        IF cur_clientes%ISOPEN THEN
            CLOSE cur_clientes;
        END IF;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
END;
/

SELECT numrun_cli,
       dvrun_cli,
       nombre_cliente,
       anno_proceso,
       cantidad_arriendos,
       total_dias,
       monto_total,
       puntaje,
       categoria_fidelidad
FROM   SCORING_CLIENTE
ORDER  BY numrun_cli;