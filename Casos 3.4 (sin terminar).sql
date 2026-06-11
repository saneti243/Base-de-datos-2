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