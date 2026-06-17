--Caso 1--
SET SERVEROUTPUT ON; --Sirve para ver 
DECLARE
    v_anno_proceso       NUMBER(4) := 2026;
    v_comuna_1           VARCHAR2(30) := 'María Pinto';
    v_comuna_2           VARCHAR2(30) := 'Curacaví';
    v_comuna_3           VARCHAR2(30) := 'Talagante';
    v_comuna_4           VARCHAR2(30) := 'El Monte';
    v_comuna_5           VARCHAR2(30) := 'Buin';
    v_extra_1            NUMBER(6) := 20000;
    v_extra_2            NUMBER(6) := 25000;
    v_extra_3            NUMBER(6) := 30000;
    v_extra_4            NUMBER(6) := 35000;
    v_extra_5            NUMBER(6) := 40000;

    v_porc_normal        NUMBER(2);
    v_valor_normal       NUMBER(6);
    v_valor_extra        NUMBER(6);
    v_valor_total        NUMBER(6);
    v_nombre_completo    VARCHAR2(60);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE PROY_MOVILIZACION';

  
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 115, '-'));
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ANNO', 6) || 
        RPAD('ID', 5) || 
        RPAD('RUN', 12) || 
        RPAD('NOMBRE EMPLEADO', 32) || 
        RPAD('COMUNA', 15) || 
        RPAD('SUELDO', 10) || 
        RPAD('%_NOR', 6) || 
        RPAD('V_NORM', 8) || 
        RPAD('V_EXTRA', 8) || 
        RPAD('TOTAL', 8)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 115, '-'));

    FOR reg IN (
        SELECT e.id_emp, e.numrun_emp, e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, e.sueldo_base, c.nombre_comuna
        FROM empleado e
        JOIN comuna c ON e.id_comuna = c.id_comuna
        ORDER BY e.id_emp ASC
    ) LOOP
        v_porc_normal := TRUNC(reg.sueldo_base / 100000);
        v_valor_normal := reg.sueldo_base * (v_porc_normal / 100);

        IF reg.nombre_comuna = v_comuna_1 THEN
            v_valor_extra := v_extra_1;
        ELSIF reg.nombre_comuna = v_comuna_2 THEN
            v_valor_extra := v_extra_2;
        ELSIF reg.nombre_comuna = v_comuna_3 THEN
            v_valor_extra := v_extra_3;
        ELSIF reg.nombre_comuna = v_comuna_4 THEN
            v_valor_extra := v_extra_4;
        ELSIF reg.nombre_comuna = v_comuna_5 THEN
            v_valor_extra := v_extra_5;
        ELSE
            v_valor_extra := 0;
        END IF;

        v_valor_total := v_valor_normal + v_valor_extra;
        v_nombre_completo := INITCAP(reg.pnombre_emp || ' ' || reg.appaterno_emp || ' ' || reg.apmaterno_emp);

        INSERT INTO proy_movilizacion (
            anno_proceso, id_emp, numrun_emp, dvrun_emp, nombre_empleado, nombre_comuna, sueldo_base,
            porc_movil_normal, valor_movil_normal, valor_movil_extra, valor_total_movil
        ) VALUES (
            v_anno_proceso, reg.id_emp, reg.numrun_emp, reg.dvrun_emp, v_nombre_completo, reg.nombre_comuna, reg.sueldo_base,
            v_porc_normal, v_valor_normal, v_valor_extra, v_valor_total
        );

        
        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(v_anno_proceso), 6) || 
            RPAD(TO_CHAR(reg.id_emp), 5) || 
            RPAD(TO_CHAR(reg.numrun_emp) || '-' || reg.dvrun_emp, 12) || 
            RPAD(SUBSTR(v_nombre_completo, 1, 30), 32) || 
            RPAD(SUBSTR(reg.nombre_comuna, 1, 14), 15) || 
            RPAD(TO_CHAR(reg.sueldo_base), 10) || 
            RPAD(TO_CHAR(v_porc_normal), 6) || 
            RPAD(TO_CHAR(v_valor_normal), 8) || 
            RPAD(TO_CHAR(v_valor_extra), 8) || 
            RPAD(TO_CHAR(v_valor_total), 8)
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 115, '-'));
    COMMIT;
END;
/

--Caso 2--
DECLARE
    v_nombre_usuario VARCHAR2(20);
    v_clave_usuario  VARCHAR2(20);
    v_est_civil      VARCHAR2(1);
    v_primer_nombre  VARCHAR2(25);
    v_largo_pnombre  NUMBER(2);
    v_ultimo_dig_sb  VARCHAR2(1);
    v_annos_trab     NUMBER(3);
    v_letra_x        VARCHAR2(1);
    v_tercer_run     VARCHAR2(1);
    v_anno_nac_mas2  NUMBER(4);
    v_tres_dig_sb    NUMBER(3);
    v_letras_ape     VARCHAR2(2);
    v_nombre_comp    VARCHAR2(60);
    v_mes_ano_db     VARCHAR2(6);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE USUARIO_CLAVE';

    v_mes_ano_db := TO_CHAR(SYSDATE, 'MMYYYY');

    FOR reg IN (
        SELECT e.id_emp, e.numrun_emp, e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, e.sueldo_base, e.fecha_nac, e.fecha_contrato, ec.nombre_estado_civil
        FROM empleado e
        JOIN estado_civil ec ON e.id_estado_civil = ec.id_estado_civil
        ORDER BY e.id_emp ASC
    ) LOOP
        v_primer_nombre := UPPER(reg.pnombre_emp);
        v_largo_pnombre := LENGTH(reg.pnombre_emp);
        v_ultimo_dig_sb := SUBSTR(TO_CHAR(reg.sueldo_base), -1);
        v_annos_trab := TRUNC(MONTHS_BETWEEN(SYSDATE, reg.fecha_contrato) / 12);
        
        IF v_annos_trab < 10 THEN
            v_letra_x := 'X';
        ELSE
            v_letra_x := '';
        END IF;

        IF reg.nombre_estado_civil = 'ACUERDO DE UNION CIVIL' THEN
            v_est_civil := 'a';
        ELSE
            v_est_civil := LOWER(SUBSTR(reg.nombre_estado_civil, 1, 1));
        END IF;

        v_nombre_usuario := v_est_civil || INITCAP(SUBSTR(v_primer_nombre, 1, 3)) || TO_CHAR(v_largo_pnombre) || '*' || v_ultimo_dig_sb || reg.dvrun_emp || TO_CHAR(v_annos_trab) || v_letra_x;

        v_tercer_run := SUBSTR(TO_CHAR(reg.numrun_emp), 3, 1);
        v_anno_nac_mas2 := EXTRACT(YEAR FROM reg.fecha_nac) + 2;
        v_tres_dig_sb := TO_NUMBER(SUBSTR(TO_CHAR(reg.sueldo_base), -3)) - 1;
        
        IF reg.nombre_estado_civil IN ('CASADO', 'ACUERDO DE UNION CIVIL') THEN
            v_letras_ape := LOWER(SUBSTR(reg.appaterno_emp, 1, 2));
        ELSIF reg.nombre_estado_civil IN ('DIVORCIADO', 'SOLTERO') THEN
            v_letras_ape := LOWER(SUBSTR(reg.appaterno_emp, 1, 1) || SUBSTR(reg.appaterno_emp, -1));
        ELSIF reg.nombre_estado_civil = 'VIUDO' THEN
            v_letras_ape := LOWER(SUBSTR(reg.appaterno_emp, LENGTH(reg.appaterno_emp) - 2, 2));
        ELSIF reg.nombre_estado_civil = 'SEPARADO' THEN
            v_letras_ape := LOWER(SUBSTR(reg.appaterno_emp, -2));
        END IF;

        v_clave_usuario := v_tercer_run || TO_CHAR(v_anno_nac_mas2) || LPAD(TO_CHAR(v_tres_dig_sb), 3, '0') || v_letras_ape || TO_CHAR(reg.id_emp) || v_mes_ano_db;
        v_nombre_comp := INITCAP(reg.pnombre_emp || ' ' || reg.appaterno_emp || ' ' || reg.apmaterno_emp);

        INSERT INTO usuario_clave (
            id_emp, numrun_emp, dvrun_emp, nombre_empleado, nombre_usuario, clave_usuario
        ) VALUES (
            reg.id_emp, reg.numrun_emp, reg.dvrun_emp, v_nombre_comp, v_nombre_usuario, v_clave_usuario
        );
    END LOOP;
    COMMIT;
END;
/

--Caso 3--
SET SERVEROUTPUT ON;
DECLARE
    v_anno_proceso    NUMBER(4) := 2026;
    v_porc_rebaja     NUMBER(4,1) := 22.5;
    v_total_arriendos NUMBER(4);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE HIST_ARRIENDO_ANUAL_CAMION';

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 85, '-'));
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ANNO', 6) || 
        RPAD('ID_CAMION', 11) || 
        RPAD('PATENTE', 10) || 
        RPAD('VALOR_ARR', 12) || 
        RPAD('VALOR_GAR', 12) || 
        RPAD('TOTAL_VECES', 12)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 85, '-'));

    FOR reg IN (
        SELECT id_camion, nro_patente, valor_arriendo_dia, valor_garantia_dia
        FROM camion
        ORDER BY id_camion ASC
    ) LOOP
        SELECT COUNT(*)
        INTO v_total_arriendos
        FROM arriendo_camion
        WHERE id_camion = reg.id_camion
          AND EXTRACT(YEAR FROM fecha_ini_arriendo) = (v_anno_proceso - 1);

        INSERT INTO hist_arriendo_anual_camion (
            anno_proceso, id_camion, nro_patente, valor_arriendo_dia, valor_garactia_dia, total_veces_arrendado
        ) VALUES (
            v_anno_proceso, reg.id_camion, reg.nro_patente, reg.valor_arriendo_dia, reg.valor_garantia_dia, v_total_arriendos
        );

        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(v_anno_proceso), 6) || 
            RPAD(TO_CHAR(reg.id_camion), 11) || 
            RPAD(reg.nro_patente, 10) || 
            RPAD(TO_CHAR(reg.valor_arriendo_dia), 12) || 
            RPAD(NVL(TO_CHAR(reg.valor_garantia_dia), '(null)'), 12) || 
            RPAD(TO_CHAR(v_total_arriendos), 12)
        );

        IF v_total_arriendos < 4 THEN
            UPDATE camion
            SET valor_arriendo_dia = valor_arriendo_dia * (1 - (v_porc_rebaja / 100)),
                valor_garantia_dia = valor_garantia_dia * (1 - (v_porc_rebaja / 100))
            WHERE id_camion = reg.id_camion;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 85, '-'));
    COMMIT;
END;
/

--Caso 4--
SET SERVEROUTPUT ON;
DECLARE
    v_ganancia_total   NUMBER(12) := 200000000;
    v_porc_distribuir  NUMBER(3) := 30;
    v_anno_proceso     NUMBER(4) := 2026;
    
    v_tramo_inf_1      NUMBER(7) := 320000;
    v_tramo_sup_1      NUMBER(7) := 600000;
    v_porc_tramo_1     NUMBER(3) := 35;
    
    v_tramo_inf_2      NUMBER(7) := 600001;
    v_tramo_sup_2      NUMBER(7) := 1300000;
    v_porc_tramo_2     NUMBER(3) := 25;
    
    v_tramo_inf_3      NUMBER(7) := 1300001;
    v_tramo_sup_3      NUMBER(7) := 1800000;
    v_porc_tramo_3     NUMBER(3) := 20;
    
    v_tramo_inf_4      NUMBER(7) := 1800001;
    v_tramo_sup_4      NUMBER(7) := 2200000;
    v_porc_tramo_4     NUMBER(3) := 15;
    
    v_tramo_inf_5      NUMBER(7) := 2200001;
    v_porc_tramo_5     NUMBER(3) := 5;

    v_monto_a_repartir NUMBER(12);
    v_cant_t1 NUMBER(4) := 0; v_cant_t2 NUMBER(4) := 0; v_cant_t3 NUMBER(4) := 0; v_cant_t4 NUMBER(4) := 0; v_cant_t5 NUMBER(4) := 0;
    v_bono_t1 NUMBER(10) := 0; v_bono_t2 NUMBER(10) := 0; v_bono_t3 NUMBER(10) := 0; v_bono_t4 NUMBER(10) := 0; v_bono_t5 NUMBER(10) := 0;
    v_bono_final       NUMBER(10);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE BONIF_POR_UTILIDAD';

    v_monto_a_repartir := v_ganancia_total * (v_porc_distribuir / 100);

    SELECT COUNT(*) INTO v_cant_t1 FROM empleado WHERE sueldo_base BETWEEN v_tramo_inf_1 AND v_tramo_sup_1;
    SELECT COUNT(*) INTO v_cant_t2 FROM empleado WHERE sueldo_base BETWEEN v_tramo_inf_2 AND v_tramo_sup_2;
    SELECT COUNT(*) INTO v_cant_t3 FROM empleado WHERE sueldo_base BETWEEN v_tramo_inf_3 AND v_tramo_sup_3;
    SELECT COUNT(*) INTO v_cant_t4 FROM empleado WHERE sueldo_base BETWEEN v_tramo_inf_4 AND v_tramo_sup_4;
    SELECT COUNT(*) INTO v_cant_t5 FROM empleado WHERE sueldo_base >= v_tramo_inf_5;

    IF v_cant_t1 > 0 THEN v_bono_t1 := (v_monto_a_repartir * (v_porc_tramo_1 / 100)) / v_cant_t1; END IF;
    IF v_cant_t2 > 0 THEN v_bono_t2 := (v_monto_a_repartir * (v_porc_tramo_2 / 100)) / v_cant_t2; END IF;
    IF v_cant_t3 > 0 THEN v_bono_t3 := (v_monto_a_repartir * (v_porc_tramo_3 / 100)) / v_cant_t3; END IF;
    IF v_cant_t4 > 0 THEN v_bono_t4 := (v_monto_a_repartir * (v_porc_tramo_4 / 100)) / v_cant_t4; END IF;
    IF v_cant_t5 > 0 THEN v_bono_t5 := (v_monto_a_repartir * (v_porc_tramo_5 / 100)) / v_cant_t5; END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ANNO', 6) || 
        RPAD('ID_EMP', 8) || 
        RPAD('SUELDO_BASE', 15) || 
        RPAD('VALOR_BONIF_UTILIDAD', 22)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));

    FOR reg IN (
        SELECT id_emp, sueldo_base 
        FROM empleado 
        ORDER BY id_emp ASC
    ) LOOP
        IF reg.sueldo_base BETWEEN v_tramo_inf_1 AND v_tramo_sup_1 THEN
            v_bono_final := v_bono_t1;
        ELSIF reg.sueldo_base BETWEEN v_tramo_inf_2 AND v_tramo_sup_2 THEN
            v_bono_final := v_bono_t2;
        ELSIF reg.sueldo_base BETWEEN v_tramo_inf_3 AND v_tramo_sup_3 THEN
            v_bono_final := v_bono_t3;
        ELSIF reg.sueldo_base BETWEEN v_tramo_inf_4 AND v_tramo_sup_4 THEN
            v_bono_final := v_bono_t4;
        ELSIF reg.sueldo_base >= v_tramo_inf_5 THEN
            v_bono_final := v_bono_t5;
        ELSE
            v_bono_final := 0;
        END IF;

        INSERT INTO bonif_por_utilidad (
            anno_proceso, id_emp, sueldo_base, valor_bonif_utilidad
        ) VALUES (
            v_anno_proceso, reg.id_emp, reg.sueldo_base, v_bono_final
        );

        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(v_anno_proceso), 6) || 
            RPAD(TO_CHAR(reg.id_emp), 8) || 
            RPAD(TO_CHAR(reg.sueldo_base), 15) || 
            RPAD(TO_CHAR(v_bono_final), 22)
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
    COMMIT;
END;
/

--Caso 5--
SET SERVEROUTPUT ON;
DECLARE
    v_anno_tributario   NUMBER(4) := 2026;
    v_porc_colacion     NUMBER(3) := 20;
    v_porc_movil_norm   NUMBER(3) := 12;
    v_porc_bono_bien    NUMBER(3) := 12;
    v_porc_bono_arri    NUMBER(3) := 5;

    v_cargo             VARCHAR2(30);
    v_meses_trabajados  NUMBER(2);
    v_annos_trabajados  NUMBER(2);
    v_es_encargado      BOOLEAN;
    v_cant_camiones     NUMBER(4);
    
    v_pct_antiguedad    NUMBER(3) := 0;
    v_pct_salud         NUMBER(4,1);
    v_pct_afp           NUMBER(4,1);
    
    v_bono_antig_mens   NUMBER(15);
    v_bono_especial_mens NUMBER(15);
    v_movil_mens        NUMBER(15);
    v_colacion_mens     NUMBER(15);
    v_salud_mens        NUMBER(15);
    v_afp_mens          NUMBER(15);
    
    v_sueldo_bruto_mens NUMBER(15);
    v_renta_imp_mens    NUMBER(15);

    v_sueldo_base_anual NUMBER(15);
    v_bono_annos_anual  NUMBER(15);
    v_bono_especial_anual NUMBER(15);
    v_movil_anual       NUMBER(15);
    v_colacion_anual    NUMBER(15);
    v_desctos_legales_anual NUMBER(15);
    v_sueldo_bruto_anual NUMBER(15);
    v_renta_imp_anual   NUMBER(15);
    
    v_id_emp_enc        VARCHAR2(20);
    v_run_str           VARCHAR2(10);
    v_run_enc           VARCHAR2(20);
    v_sueldo_base_enc   NUMBER(15);
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INFO_SII';

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 180, '-'));
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ANNO', 5) || RPAD('ID', 5) || RPAD('RUN_ENCR', 22) || RPAD('CARGO', 25) || 
        RPAD('MES', 4) || RPAD('ANOS', 5) || RPAD('S_BASE_M', 10) || RPAD('S_BASE_A', 10) || 
        RPAD('B_ANOS', 8) || RPAD('B_ESPEC', 9) || RPAD('MOVIL', 9) || RPAD('COLAC', 8) || 
        RPAD('DESCTO', 8) || RPAD('BRUTO', 9) || RPAD('IMPONIBLE', 10)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 180, '-'));

    FOR reg IN (
        SELECT e.id_emp, e.numrun_emp, e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp,
               e.sueldo_base, e.fecha_contrato, e.cod_tipo_sal, e.cod_afp, c.nombre_comuna
        FROM empleado e
        JOIN comuna c ON e.id_comuna = c.id_comuna
        ORDER BY e.id_emp ASC
    ) LOOP
        v_annos_trabajados := TRUNC(MONTHS_BETWEEN(TO_DATE('31-12-' || TO_CHAR(v_anno_tributario - 1), 'DD-MM-YYYY'), reg.fecha_contrato) / 12);
        IF v_annos_trabajados < 0 THEN v_annos_trabajados := 0; END IF;

        IF EXTRACT(YEAR FROM reg.fecha_contrato) < (v_anno_tributario - 1) THEN
            v_meses_trabajados := 12;
        ELSIF EXTRACT(YEAR FROM reg.fecha_contrato) = (v_anno_tributario - 1) THEN
            v_meses_trabajados := 12 - EXTRACT(MONTH FROM reg.fecha_contrato) + 1;
        ELSE
            v_meses_trabajados := 0;
        END IF;

        SELECT COUNT(*) INTO v_cant_camiones FROM camion WHERE id_emp = reg.id_emp;
        
        IF v_cant_camiones > 0 THEN
            v_es_encargado := TRUE;
            v_cargo := 'Encargado de Arriendos';
        ELSE
            v_es_encargado := FALSE;
            v_cargo := 'Labores Administrativas';
        END IF;

        BEGIN
            SELECT porcentaje INTO v_pct_antiguedad
            FROM tramo_antiguedad
            WHERE anno_vig = (v_anno_tributario - 1)
              AND v_annos_trabajados BETWEEN tramo_inf AND tramo_sup;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_pct_antiguedad := 0;
        END;

        SELECT porc_descto_salud INTO v_pct_salud FROM tipo_salud WHERE cod_tipo_sal = reg.cod_tipo_sal;
        SELECT porc_descto_afp INTO v_pct_afp FROM afp WHERE cod_afp = reg.cod_afp;

        v_bono_antig_mens := reg.sueldo_base * (v_pct_antiguedad / 100);
        v_colacion_mens := reg.sueldo_base * (v_porc_colacion / 100);

        IF reg.nombre_comuna = 'María Pinto' THEN v_movil_mens := reg.sueldo_base * 0.32;
        ELSIF reg.nombre_comuna = 'Curacaví' THEN v_movil_mens := reg.sueldo_base * 0.37;
        ELSIF reg.nombre_comuna = 'Talagante' THEN v_movil_mens := reg.sueldo_base * 0.42;
        ELSIF reg.nombre_comuna = 'El Monte' THEN v_movil_mens := reg.sueldo_base * 0.47;
        ELSIF reg.nombre_comuna = 'Buin' THEN v_movil_mens := reg.sueldo_base * 0.52;
        ELSE v_movil_mens := reg.sueldo_base * (v_porc_movil_norm / 100);
        END IF;

        v_sueldo_bruto_mens := reg.sueldo_base + v_bono_antig_mens + v_movil_mens + v_colacion_mens;

        IF v_es_encargado THEN
            SELECT COUNT(*) INTO v_cant_camiones 
            FROM arriendo_camion ac
            JOIN camion ca ON ac.id_camion = ca.id_camion
            WHERE ca.id_emp = reg.id_emp 
              AND ac.fecha_ini_arriendo BETWEEN TO_DATE('01-01-'||TO_CHAR(v_anno_tributario-1),'DD-MM-YYYY') AND TO_DATE('31-12-'||TO_CHAR(v_anno_tributario-1),'DD-MM-YYYY');
            v_bono_especial_mens := reg.sueldo_base * ((v_cant_camiones * v_porc_bono_arri) / 100);
        ELSE
            v_bono_especial_mens := v_sueldo_bruto_mens * (v_porc_bono_bien / 100);
        END IF;

        v_salud_mens := reg.sueldo_base * (v_pct_salud / 100);
        v_afp_mens := reg.sueldo_base * (v_pct_afp / 100);
        
        v_sueldo_base_anual := reg.sueldo_base * v_meses_trabajados;
        v_bono_annos_anual := v_bono_antig_mens * v_meses_trabajados;
        v_movil_anual := v_movil_mens * v_meses_trabajados;
        v_colacion_anual := v_colacion_mens * v_meses_trabajados;
        v_sueldo_bruto_anual := v_sueldo_bruto_mens * v_meses_trabajados;
        v_desctos_legales_anual := (v_salud_mens + v_afp_mens) * v_meses_trabajados;

        IF v_es_encargado THEN
            v_bono_especial_anual := v_bono_especial_mens;
            v_renta_imp_anual := (v_sueldo_base_anual + v_bono_annos_anual + v_bono_especial_anual) - v_desctos_legales_anual;
        ELSE
            v_bono_especial_anual := v_bono_especial_mens * v_meses_trabajados;
            v_renta_imp_anual := (v_sueldo_base_anual + v_bono_annos_anual + v_bono_especial_anual) - v_desctos_legales_anual;
        END IF;

        v_id_emp_enc := TO_CHAR(reg.id_emp);
        v_run_str := LPAD(TO_CHAR(reg.numrun_emp), 8, '0');
        v_run_enc := LPAD(v_id_emp_enc, 2, '0') || ' ' || SUBSTR(v_run_str, 1, 2) || '.' || SUBSTR(v_run_str, 3, 3) || '.' || SUBSTR(v_run_str, 6, 3) || '-' || reg.dvrun_emp || TO_CHAR(reg.id_emp + 33);
        v_sueldo_base_enc := TO_NUMBER(TO_CHAR(reg.sueldo_base) || '900');

        INSERT INTO info_sii (
            anno_tributario, id_emp, run_empleado, nombre_empleado, cargo, meses_trabajados, annos_trabajados,
            sueldo_base_mensual, sueldo_base_anual, bono_annos_anual, bono_especial_anual, movilizacion_anual,
            colacion_anual, desctos_legales, sueldo_bruto_anual, renta_imponible_anual
        ) VALUES (
            v_anno_tributario, reg.id_emp, v_run_enc, UPPER(reg.pnombre_emp || ' ' || reg.appaterno_emp || ' ' || reg.apmaterno_emp),
            v_cargo, v_meses_trabajados, v_annos_trabajados, v_sueldo_base_enc, v_sueldo_base_anual, v_bono_annos_anual,
            v_bono_especial_anual, v_movil_anual, v_colacion_anual, v_desctos_legales_anual, v_sueldo_bruto_anual, v_renta_imp_anual
        );

        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(v_anno_tributario), 5) || RPAD(TO_CHAR(reg.id_emp), 5) || RPAD(v_run_enc, 22) || RPAD(SUBSTR(v_cargo, 1, 23), 25) || 
            RPAD(TO_CHAR(v_meses_trabajados), 4) || RPAD(TO_CHAR(v_annos_trabajados), 5) || RPAD(TO_CHAR(v_sueldo_base_enc), 10) || RPAD(TO_CHAR(v_sueldo_base_anual), 10) || 
            RPAD(TO_CHAR(v_bono_annos_anual), 8) || RPAD(TO_CHAR(v_bono_especial_anual), 9) || RPAD(TO_CHAR(v_movil_anual), 9) || RPAD(TO_CHAR(v_colacion_anual), 8) || 
            RPAD(TO_CHAR(v_desctos_legales_anual), 8) || RPAD(TO_CHAR(v_sueldo_bruto_anual), 9) || RPAD(TO_CHAR(v_renta_imp_anual), 10)
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 180, '-'));
    COMMIT;
END;
/