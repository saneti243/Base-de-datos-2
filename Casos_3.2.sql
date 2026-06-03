--Caso 1--
--Variable sirve para guardar valores y se puedan utilizar a lo largo del codigo-
VARIABLE b_anno_proceso NUMBER;
VARIABLE b_comuna_adic VARCHAR2(30);
VARIABLE b_valor_adic NUMBER;
VARIABLE b_run_emp NUMBER;
--Exec (Execute)
EXEC :b_anno_proceso := EXTRACT(YEAR FROM SYSDATE);
EXEC :b_comuna_adic := 'Curacaví';
EXEC :b_valor_adic := 25000;

EXEC :b_run_emp := 11846972;
--Preparo localmente las variables para usarlas durante el código--
DECLARE
    v_dv               empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_completo  VARCHAR2(100);
    v_sueldo_base      empleado.sueldo_base%TYPE;
    v_nombre_comuna    comuna.nombre_comuna%TYPE;
    v_porc_normal      NUMBER; 
    v_valor_normal     NUMBER(6);
    v_valor_extra      NUMBER(6) := 0;
    v_total_movil      NUMBER(6);
BEGIN
    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, e.sueldo_base, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, v_sueldo_base, v_nombre_comuna
    FROM empleado e
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp;

    v_nombre_completo := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_porc_normal := TRUNC(v_sueldo_base / 100000);
    v_valor_normal := TRUNC(v_sueldo_base * (v_porc_normal / 100));

    IF UPPER(v_nombre_comuna) = UPPER(:b_comuna_adic) THEN
        v_valor_extra := :b_valor_adic;
    ELSE
        v_valor_extra := 0;
    END IF;

    v_total_movil := v_valor_normal + v_valor_extra;

    INSERT INTO proy_movilizacion VALUES (
        :b_anno_proceso, :b_run_emp, v_dv, v_nombre_completo, v_sueldo_base,
        v_porc_normal, v_valor_normal, v_valor_extra, v_total_movil
    );
    COMMIT;
END;
/

EXEC :b_run_emp := 12272880;

DECLARE
    v_dv               empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_completo  VARCHAR2(100);
    v_sueldo_base      empleado.sueldo_base%TYPE;
    v_nombre_comuna    comuna.nombre_comuna%TYPE;
    v_porc_normal      NUMBER;
    v_valor_normal     NUMBER(6);
    v_valor_extra      NUMBER(6) := 0;
    v_total_movil      NUMBER(6);
BEGIN
    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, e.sueldo_base, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, v_sueldo_base, v_nombre_comuna
    FROM empleado e
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp;

    v_nombre_completo := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_porc_normal := TRUNC(v_sueldo_base / 100000);
    v_valor_normal := TRUNC(v_sueldo_base * (v_porc_normal / 100));

    IF UPPER(v_nombre_comuna) = UPPER(:b_comuna_adic) THEN
        v_valor_extra := :b_valor_adic;
    ELSE
        IF UPPER(v_nombre_comuna) = 'BUIN' THEN 
            v_valor_extra := 40000;
        ELSE 
            v_valor_extra := 0;
        END IF;
    END IF;

    v_total_movil := v_valor_normal + v_valor_extra;

    INSERT INTO proy_movilizacion VALUES (
        :b_anno_proceso, :b_run_emp, v_dv, v_nombre_completo, v_sueldo_base,
        v_porc_normal, v_valor_normal, v_valor_extra, v_total_movil
    );
    COMMIT;
END;
/

EXEC :b_run_emp := 12113369;

DECLARE
    v_dv               empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_completo  VARCHAR2(100);
    v_sueldo_base      empleado.sueldo_base%TYPE;
    v_nombre_comuna    comuna.nombre_comuna%TYPE;
    v_porc_normal      NUMBER;
    v_valor_normal     NUMBER(6);
    v_valor_extra      NUMBER(6) := 0;
    v_total_movil      NUMBER(6);
BEGIN
    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, e.sueldo_base, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, v_sueldo_base, v_nombre_comuna
    FROM empleado e
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp;

    v_nombre_completo := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_porc_normal := TRUNC(v_sueldo_base / 100000);
    v_valor_normal := TRUNC(v_sueldo_base * (v_porc_normal / 100));

    IF UPPER(v_nombre_comuna) = UPPER(:b_comuna_adic) THEN
        v_valor_extra := :b_valor_adic;
    ELSE
        v_valor_extra := 0;
    END IF;

    v_total_movil := v_valor_normal + v_valor_extra;

    INSERT INTO proy_movilizacion VALUES (
        :b_anno_proceso, :b_run_emp, v_dv, v_nombre_completo, v_sueldo_base,
        v_porc_normal, v_valor_normal, v_valor_extra, v_total_movil
    );
    COMMIT;
END;
/

EXEC :b_run_emp := 11999100;

DECLARE
    v_dv               empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_completo  VARCHAR2(100);
    v_sueldo_base      empleado.sueldo_base%TYPE;
    v_nombre_comuna    comuna.nombre_comuna%TYPE;
    v_porc_normal      NUMBER;
    v_valor_normal     NUMBER(6);
    v_valor_extra      NUMBER(6) := 0;
    v_total_movil      NUMBER(6);
BEGIN
    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, e.sueldo_base, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, v_sueldo_base, v_nombre_comuna
    FROM empleado e
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp;

    v_nombre_completo := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_porc_normal := TRUNC(v_sueldo_base / 100000);
    v_valor_normal := TRUNC(v_sueldo_base * (v_porc_normal / 100));

    IF UPPER(v_nombre_comuna) = UPPER(:b_comuna_adic) THEN
        v_valor_extra := :b_valor_adic;
    ELSE
        IF UPPER(v_nombre_comuna) = 'TALAGANTE' THEN 
            v_valor_extra := 30000;
        ELSE 
            v_valor_extra := 0;
        END IF;
    END IF;

    v_total_movil := v_valor_normal + v_valor_extra;

    INSERT INTO proy_movilizacion VALUES (
        :b_anno_proceso, :b_run_emp, v_dv, v_nombre_completo, v_sueldo_base,
        v_porc_normal, v_valor_normal, v_valor_extra, v_total_movil
    );
    COMMIT;
END;
/

EXEC :b_run_emp := 12868553;

DECLARE
    v_dv               empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_completo  VARCHAR2(100);
    v_sueldo_base      empleado.sueldo_base%TYPE;
    v_nombre_comuna    comuna.nombre_comuna%TYPE;
    v_porc_normal      NUMBER;
    v_valor_normal     NUMBER(6);
    v_valor_extra      NUMBER(6) := 0;
    v_total_movil      NUMBER(6);
BEGIN
    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, e.sueldo_base, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, v_sueldo_base, v_nombre_comuna
    FROM empleado e
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp;

    v_nombre_completo := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_porc_normal := TRUNC(v_sueldo_base / 100000);
    v_valor_normal := TRUNC(v_sueldo_base * (v_porc_normal / 100));

    IF UPPER(v_nombre_comuna) = UPPER(:b_comuna_adic) THEN
        v_valor_extra := :b_valor_adic;
    ELSE
        IF UPPER(v_nombre_comuna) = 'MARÍA PINTO' OR UPPER(v_nombre_comuna) = 'MARIA PINTO' THEN 
            v_valor_extra := 20000;
        ELSE 
            v_valor_extra := 0;
        END IF;
    END IF;

    v_total_movil := v_valor_normal + v_valor_extra;

    INSERT INTO proy_movilizacion VALUES (
        :b_anno_proceso, :b_run_emp, v_dv, v_nombre_completo, v_sueldo_base,
        v_porc_normal, v_valor_normal, v_valor_extra, v_total_movil
    );
    COMMIT;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_reporte IS 
        SELECT anno_proceso, numrun_emp || '-' || dvrun_emp AS run_completo,
               nombre_empleado, sueldo_base, porc_movil_normal, 
               valor_movil_normal, valor_movil_extra, valor_total_movil
        FROM proy_movilizacion
        ORDER BY sueldo_base ASC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('====================================================================================================================');
    DBMS_OUTPUT.PUT_LINE('                                     INFORME DE SIMULACIÓN DE MOVILIZACIÓN ANUAL                                    ');
    DBMS_OUTPUT.PUT_LINE('====================================================================================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('AÑO', 6) || 
        RPAD('RUN', 13) || 
        RPAD('NOMBRE EMPLEADO', 32) || 
        RPAD('SUELDO BASE', 13) || 
        RPAD('% MOV', 7) || 
        RPAD('V. NORMAL', 11) || 
        RPAD('V. EXTRA', 11) || 
        'TOTAL MOVIL'
    );
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------');

    FOR r IN c_reporte LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(r.anno_proceso), 6) ||
            RPAD(r.run_completo, 13) ||
            RPAD(SUBSTR(r.nombre_empleado, 1, 30), 32) ||
            RPAD(TO_CHAR(r.sueldo_base), 13) ||
            RPAD(TO_CHAR(r.porc_movil_normal), 7) ||
            RPAD(TO_CHAR(r.valor_movil_normal), 11) ||
            RPAD(TO_CHAR(r.valor_movil_extra), 11) ||
            TO_CHAR(r.valor_total_movil)
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('====================================================================================================================');
END;
/

--Caso 2--

TRUNCATE TABLE usuario_clave;

VARIABLE b_run_emp_c2 NUMBER;

EXEC :b_run_emp_c2 := 12648200;

DECLARE
    v_dv           empleado.dvrun_emp%TYPE;
    v_pnombre      empleado.pnombre_emp%TYPE;
    v_appaterno    empleado.appaterno_emp%TYPE;
    v_apmaterno    empleado.apmaterno_emp%TYPE;
    v_nombre_emp   VARCHAR2(100);
    v_sueldo       empleado.sueldo_base%TYPE;
    v_fecha_cont   empleado.fecha_contrato%TYPE;
    v_fecha_nac    empleado.fecha_nac%TYPE;
    v_est_civil    estado_civil.nombre_estado_civil%TYPE;
    v_comuna       comuna.nombre_comuna%TYPE;
    v_mes_anno     NUMBER(6);
    v_antiguedad   NUMBER(3);
    v_usuario      VARCHAR2(30);
    v_clave        VARCHAR2(30);
    v_letras_ape   VARCHAR2(2);
BEGIN
    v_mes_anno := TO_NUMBER(TO_CHAR(SYSDATE, 'MMYYYY'));

    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, 
           e.sueldo_base, e.fecha_contrato, e.fecha_nac, ec.nombre_estado_civil, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, 
         v_sueldo, v_fecha_cont, v_fecha_nac, v_est_civil, v_comuna
    FROM empleado e
    JOIN estado_civil ec ON e.id_estado_civil = ec.id_estado_civil
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp_c2;

    v_nombre_emp := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_cont) / 12);

    v_usuario := SUBSTR(v_pnombre, 1, 3) || TO_CHAR(LENGTH(v_pnombre)) || '*' || 
                 SUBSTR(TO_CHAR(v_sueldo), -1) || v_dv || TO_CHAR(v_antiguedad);
    IF v_antiguedad < 10 THEN
        v_usuario := v_usuario || 'X';
    END IF;

    IF v_est_civil IN ('CASADO', 'ACUERDO DE UNION CIVIL') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 2);
    ELSIF v_est_civil IN ('DIVORCIADO', 'SOLTERO') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 1) || SUBSTR(v_appaterno, -1);
    ELSIF v_est_civil = 'VIUDO' THEN
        v_letras_ape := SUBSTR(v_appaterno, LENGTH(v_appaterno) - 2, 2);
    ELSIF v_est_civil = 'SEPARADO' THEN
        v_letras_ape := SUBSTR(v_appaterno, -2);
    END IF;

    v_clave := SUBSTR(TO_CHAR(:b_run_emp_c2), 3, 1) || 
               TO_CHAR(EXTRACT(YEAR FROM v_fecha_nac) + 2) ||
               LPAD(TO_CHAR(TO_NUMBER(SUBSTR(TO_CHAR(v_sueldo), -3)) - 1), 3, '0') ||
               LOWER(v_letras_ape) || 
               TO_CHAR(v_mes_anno) || 
               SUBSTR(v_comuna, 1, 1);

    v_clave := REPLACE(v_clave, 'ñ', 'n');

    INSERT INTO usuario_clave VALUES (
        v_mes_anno, :b_run_emp_c2, v_dv, v_nombre_emp, UPPER(v_usuario), v_clave
    );
    COMMIT;
END;
/

EXEC :b_run_emp_c2 := 12260812;

DECLARE
    v_dv           empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_emp  VARCHAR2(100);
    v_sueldo      empleado.sueldo_base%TYPE;
    v_fecha_cont  empleado.fecha_contrato%TYPE;
    v_fecha_nac   empleado.fecha_nac%TYPE;
    v_est_civil   estado_civil.nombre_estado_civil%TYPE;
    v_comuna      comuna.nombre_comuna%TYPE;
    v_mes_anno     NUMBER(6);
    v_antiguedad   NUMBER(3);
    v_usuario      VARCHAR2(30);
    v_clave        VARCHAR2(30);
    v_letras_ape   VARCHAR2(2);
BEGIN
    v_mes_anno := TO_NUMBER(TO_CHAR(SYSDATE, 'MMYYYY'));

    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, 
           e.sueldo_base, e.fecha_contrato, e.fecha_nac, ec.nombre_estado_civil, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, 
         v_sueldo, v_fecha_cont, v_fecha_nac, v_est_civil, v_comuna
    FROM empleado e
    JOIN estado_civil ec ON e.id_estado_civil = ec.id_estado_civil
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp_c2;

    v_nombre_emp := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_cont) / 12);

    v_usuario := SUBSTR(v_pnombre, 1, 3) || TO_CHAR(LENGTH(v_pnombre)) || '*' || 
                 SUBSTR(TO_CHAR(v_sueldo), -1) || v_dv || TO_CHAR(v_antiguedad);
    IF v_antiguedad < 10 THEN
        v_usuario := v_usuario || 'X';
    END IF;

    IF v_est_civil IN ('CASADO', 'ACUERDO DE UNION CIVIL') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 2);
    ELSIF v_est_civil IN ('DIVORCIADO', 'SOLTERO') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 1) || SUBSTR(v_appaterno, -1);
    ELSIF v_est_civil = 'VIUDO' THEN
        v_letras_ape := SUBSTR(v_appaterno, LENGTH(v_appaterno) - 2, 2);
    ELSIF v_est_civil = 'SEPARADO' THEN
        v_letras_ape := SUBSTR(v_appaterno, -2);
    END IF;

    v_clave := SUBSTR(TO_CHAR(:b_run_emp_c2), 3, 1) || 
               TO_CHAR(EXTRACT(YEAR FROM v_fecha_nac) + 2) ||
               LPAD(TO_CHAR(TO_NUMBER(SUBSTR(TO_CHAR(v_sueldo), -3)) - 1), 3, '0') ||
               LOWER(v_letras_ape) || 
               TO_CHAR(v_mes_anno) || 
               SUBSTR(v_comuna, 1, 1);

    v_clave := REPLACE(v_clave, 'ñ', 'n');

    INSERT INTO usuario_clave VALUES (
        v_mes_anno, :b_run_emp_c2, v_dv, v_nombre_emp, UPPER(v_usuario), v_clave
    );
    COMMIT;
END;
/

EXEC :b_run_emp_c2 := 12456905;

DECLARE
    v_dv           empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_emp  VARCHAR2(100);
    v_sueldo      empleado.sueldo_base%TYPE;
    v_fecha_cont  empleado.fecha_contrato%TYPE;
    v_fecha_nac   empleado.fecha_nac%TYPE;
    v_est_civil   estado_civil.nombre_estado_civil%TYPE;
    v_comuna      comuna.nombre_comuna%TYPE;
    v_mes_anno     NUMBER(6);
    v_antiguedad   NUMBER(3);
    v_usuario      VARCHAR2(30);
    v_clave        VARCHAR2(30);
    v_letras_ape   VARCHAR2(2);
BEGIN
    v_mes_anno := TO_NUMBER(TO_CHAR(SYSDATE, 'MMYYYY'));

    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, 
           e.sueldo_base, e.fecha_contrato, e.fecha_nac, ec.nombre_estado_civil, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, 
         v_sueldo, v_fecha_cont, v_fecha_nac, v_est_civil, v_comuna
    FROM empleado e
    JOIN estado_civil ec ON e.id_estado_civil = ec.id_estado_civil
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp_c2;

    v_nombre_emp := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_cont) / 12);

    v_usuario := SUBSTR(v_pnombre, 1, 3) || TO_CHAR(LENGTH(v_pnombre)) || '*' || 
                 SUBSTR(TO_CHAR(v_sueldo), -1) || v_dv || TO_CHAR(v_antiguedad);
    IF v_antiguedad < 10 THEN
        v_usuario := v_usuario || 'X';
    END IF;

    IF v_est_civil IN ('CASADO', 'ACUERDO DE UNION CIVIL') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 2);
    ELSIF v_est_civil IN ('DIVORCIADO', 'SOLTERO') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 1) || SUBSTR(v_appaterno, -1);
    ELSIF v_est_civil = 'VIUDO' THEN
        v_letras_ape := SUBSTR(v_appaterno, LENGTH(v_appaterno) - 2, 2);
    ELSIF v_est_civil = 'SEPARADO' THEN
        v_letras_ape := SUBSTR(v_appaterno, -2);
    END IF;

    v_clave := SUBSTR(TO_CHAR(:b_run_emp_c2), 3, 1) || 
               TO_CHAR(EXTRACT(YEAR FROM v_fecha_nac) + 2) ||
               LPAD(TO_CHAR(TO_NUMBER(SUBSTR(TO_CHAR(v_sueldo), -3)) - 1), 3, '0') ||
               LOWER(v_letras_ape) || 
               TO_CHAR(v_mes_anno) || 
               SUBSTR(v_comuna, 1, 1);

    v_clave := REPLACE(v_clave, 'ñ', 'n');

    INSERT INTO usuario_clave VALUES (
        v_mes_anno, :b_run_emp_c2, v_dv, v_nombre_emp, UPPER(v_usuario), v_clave
    );
    COMMIT;
END;
/

EXEC :b_run_emp_c2 := 11649964;

DECLARE
    v_dv           empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_emp  VARCHAR2(100);
    v_sueldo      empleado.sueldo_base%TYPE;
    v_fecha_cont  empleado.fecha_contrato%TYPE;
    v_fecha_nac   empleado.fecha_nac%TYPE;
    v_est_civil   estado_civil.nombre_estado_civil%TYPE;
    v_comuna      comuna.nombre_comuna%TYPE;
    v_mes_anno     NUMBER(6);
    v_antiguedad   NUMBER(3);
    v_usuario      VARCHAR2(30);
    v_clave        VARCHAR2(30);
    v_letras_ape   VARCHAR2(2);
BEGIN
    v_mes_anno := TO_NUMBER(TO_CHAR(SYSDATE, 'MMYYYY'));

    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, 
           e.sueldo_base, e.fecha_contrato, e.fecha_nac, ec.nombre_estado_civil, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, 
         v_sueldo, v_fecha_cont, v_fecha_nac, v_est_civil, v_comuna
    FROM empleado e
    JOIN estado_civil ec ON e.id_estado_civil = ec.id_estado_civil
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp_c2;

    v_nombre_emp := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_cont) / 12);

    v_usuario := SUBSTR(v_pnombre, 1, 3) || TO_CHAR(LENGTH(v_pnombre)) || '*' || 
                 SUBSTR(TO_CHAR(v_sueldo), -1) || v_dv || TO_CHAR(v_antiguedad);
    IF v_antiguedad < 10 THEN
        v_usuario := v_usuario || 'X';
    END IF;

    IF v_est_civil IN ('CASADO', 'ACUERDO DE UNION CIVIL') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 2);
    ELSIF v_est_civil IN ('DIVORCIADO', 'SOLTERO') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 1) || SUBSTR(v_appaterno, -1);
    ELSIF v_est_civil = 'VIUDO' THEN
        v_letras_ape := SUBSTR(v_appaterno, LENGTH(v_appaterno) - 2, 2);
    ELSIF v_est_civil = 'SEPARADO' THEN
        v_letras_ape := SUBSTR(v_appaterno, -2);
    END IF;

    v_clave := SUBSTR(TO_CHAR(:b_run_emp_c2), 3, 1) || 
               TO_CHAR(EXTRACT(YEAR FROM v_fecha_nac) + 2) ||
               LPAD(TO_CHAR(TO_NUMBER(SUBSTR(TO_CHAR(v_sueldo), -3)) - 1), 3, '0') ||
               LOWER(v_letras_ape) || 
               TO_CHAR(v_mes_anno) || 
               SUBSTR(v_comuna, 1, 1);

    v_clave := REPLACE(v_clave, 'ñ', 'n');

    INSERT INTO usuario_clave VALUES (
        v_mes_anno, :b_run_emp_c2, v_dv, v_nombre_emp, UPPER(v_usuario), v_clave
    );
    COMMIT;
END;
/

EXEC :b_run_emp_c2 := 12642309;

DECLARE
    v_dv           empleado.dvrun_emp%TYPE;
    v_pnombre          empleado.pnombre_emp%TYPE;
    v_appaterno        empleado.appaterno_emp%TYPE;
    v_apmaterno        empleado.apmaterno_emp%TYPE;
    v_nombre_emp  VARCHAR2(100);
    v_sueldo      empleado.sueldo_base%TYPE;
    v_fecha_cont  empleado.fecha_contrato%TYPE;
    v_fecha_nac   empleado.fecha_nac%TYPE;
    v_est_civil   estado_civil.nombre_estado_civil%TYPE;
    v_comuna      comuna.nombre_comuna%TYPE;
    v_mes_anno     NUMBER(6);
    v_antiguedad   NUMBER(3);
    v_usuario      VARCHAR2(30);
    v_clave        VARCHAR2(30);
    v_letras_ape   VARCHAR2(2);
BEGIN
    v_mes_anno := TO_NUMBER(TO_CHAR(SYSDATE, 'MMYYYY'));

    SELECT e.dvrun_emp, e.pnombre_emp, e.appaterno_emp, e.apmaterno_emp, 
           e.sueldo_base, e.fecha_contrato, e.fecha_nac, ec.nombre_estado_civil, c.nombre_comuna
    INTO v_dv, v_pnombre, v_appaterno, v_apmaterno, 
         v_sueldo, v_fecha_cont, v_fecha_nac, v_est_civil, v_comuna
    FROM empleado e
    JOIN estado_civil ec ON e.id_estado_civil = ec.id_estado_civil
    JOIN comuna c ON e.id_comuna = c.id_comuna
    WHERE e.numrun_emp = :b_run_emp_c2;

    v_nombre_emp := v_pnombre || ' ' || v_appaterno || ' ' || v_apmaterno;
    v_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_cont) / 12);

    v_usuario := SUBSTR(v_pnombre, 1, 3) || TO_CHAR(LENGTH(v_pnombre)) || '*' || 
                 SUBSTR(TO_CHAR(v_sueldo), -1) || v_dv || TO_CHAR(v_antiguedad);
    IF v_antiguedad < 10 THEN
        v_usuario := v_usuario || 'X';
    END IF;

    IF v_est_civil IN ('CASADO', 'ACUERDO DE UNION CIVIL') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 2);
    ELSIF v_est_civil IN ('DIVORCIADO', 'SOLTERO') THEN
        v_letras_ape := SUBSTR(v_appaterno, 1, 1) || SUBSTR(v_appaterno, -1);
    ELSIF v_est_civil = 'VIUDO' THEN
        v_letras_ape := SUBSTR(v_appaterno, LENGTH(v_appaterno) - 2, 2);
    ELSIF v_est_civil = 'SEPARADO' THEN
        v_letras_ape := SUBSTR(v_appaterno, -2);
    END IF;

    v_clave := SUBSTR(TO_CHAR(:b_run_emp_c2), 3, 1) || 
               TO_CHAR(EXTRACT(YEAR FROM v_fecha_nac) + 2) ||
               LPAD(TO_CHAR(TO_NUMBER(SUBSTR(TO_CHAR(v_sueldo), -3)) - 1), 3, '0') ||
               LOWER(v_letras_ape) || 
               TO_CHAR(v_mes_anno) || 
               SUBSTR(v_comuna, 1, 1);
--IF UPPER sirve para que no importe como este escrito en este caso la comuna si esta en minuscula lo lea en mayuscula y asi el if logre detectarlo--    
    IF UPPER(v_comuna) = 'ÑUÑOA' THEN
        v_clave := SUBSTR(v_clave, 1, LENGTH(v_clave)-1) || 'Ñ';
    END IF;

    INSERT INTO usuario_clave VALUES (
        v_mes_anno, :b_run_emp_c2, v_dv, v_nombre_emp, UPPER(v_usuario), v_clave
    );
    COMMIT;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_credenciales IS 
        SELECT mes_anno, numrun_emp || '-' || dvrun_emp AS run_completo,
               nombre_empleado, nombre_usuario, clave_usuario
        FROM usuario_clave
        ORDER BY nombre_empleado ASC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE('                                     REPORTE DEL MÓDULO DE SEGURIDAD (CASO 2)                       ');
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PERIODO', 10) || 
        RPAD('RUN EMPLEADO', 15) || 
        RPAD('NOMBRE COMPLETO TRABAJADOR', 35) || 
        RPAD('USUARIO GENERADO', 20) || 
        'CONTRASENA ASIGNADA'
    );
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------');

    FOR r IN c_credenciales LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(r.mes_anno), 10) ||
            RPAD(r.run_completo, 15) ||
            RPAD(SUBSTR(r.nombre_empleado, 1, 32), 35) ||
            RPAD(r.nombre_usuario, 20) ||
            r.clave_usuario
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
END;
/

--Caso 3--

UPDATE camion SET valor_arriendo_dia = 14500, valor_garantia_dia = 130000 WHERE nro_patente = 'AHEW11';
UPDATE camion SET valor_arriendo_dia = 14500, valor_garantia_dia = NULL WHERE nro_patente = 'ASEZ11';
UPDATE camion SET valor_arriendo_dia = 24000, valor_garantia_dia = 200000 WHERE nro_patente = 'BC1002';
UPDATE camion SET valor_arriendo_dia = 24000, valor_garantia_dia = 140000 WHERE nro_patente = 'BT1002';
UPDATE camion SET valor_arriendo_dia = 35000, valor_garantia_dia = 170000 WHERE nro_patente = 'VR1003';
COMMIT;

VARIABLE b_patente VARCHAR2(6);
VARIABLE b_porc_rebaja NUMBER;

EXEC :b_porc_rebaja := 22.5;

EXEC :b_patente := 'AHEW11';

DECLARE
    v_anno_proceso       NUMBER(4);
    v_anno_anterior      NUMBER(4);
    v_arriendo_dia       camion.valor_arriendo_dia%TYPE;
    v_garantia_dia       camion.valor_garantia_dia%TYPE;
    v_total_arriendos    NUMBER(4);
BEGIN
    v_anno_proceso  := EXTRACT(YEAR FROM SYSDATE);
    v_anno_anterior := v_anno_proceso - 1;

    SELECT valor_arriendo_dia, valor_garantia_dia
    INTO v_arriendo_dia, v_garantia_dia
    FROM camion
    WHERE nro_patente = :b_patente;

    SELECT COUNT(*)
    INTO v_total_arriendos
    FROM arriendo_camion
    WHERE nro_patente = :b_patente
      AND EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno_anterior;

    INSERT INTO hist_arriendo_anual_camion VALUES (
        v_anno_anterior, :b_patente, v_arriendo_dia, v_garantia_dia, v_total_arriendos
    );

    IF v_total_arriendos < 5 THEN
        UPDATE camion
        SET valor_arriendo_dia = ROUND(valor_arriendo_dia * (1 - (:b_porc_rebaja / 100))),
            valor_garantia_dia = ROUND(valor_garantia_dia * (1 - (:b_porc_rebaja / 100)))
        WHERE nro_patente = :b_patente;
    END IF;

    COMMIT;
END;
/

EXEC :b_patente := 'ASEZ11';

DECLARE
    v_anno_proceso       NUMBER(4);
    v_anno_anterior      NUMBER(4);
    v_arriendo_dia       camion.valor_arriendo_dia%TYPE;
    v_garantia_dia       camion.valor_garantia_dia%TYPE;
    v_total_arriendos    NUMBER(4);
BEGIN
    v_anno_proceso  := EXTRACT(YEAR FROM SYSDATE);
    v_anno_anterior := v_anno_proceso - 1;

    SELECT valor_arriendo_dia, valor_garantia_dia
    INTO v_arriendo_dia, v_garantia_dia
    FROM camion
    WHERE nro_patente = :b_patente;

    SELECT COUNT(*)
    INTO v_total_arriendos
    FROM arriendo_camion
    WHERE nro_patente = :b_patente
      AND EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno_anterior;

    INSERT INTO hist_arriendo_anual_camion VALUES (
        v_anno_anterior, :b_patente, v_arriendo_dia, v_garantia_dia, v_total_arriendos
    );

    IF v_total_arriendos < 5 THEN
        UPDATE camion
        SET valor_arriendo_dia = ROUND(valor_arriendo_dia * (1 - (:b_porc_rebaja / 100))),
            valor_garantia_dia = ROUND(valor_garantia_dia * (1 - (:b_porc_rebaja / 100)))
        WHERE nro_patente = :b_patente;
    END IF;

    COMMIT;
END;
/

EXEC :b_patente := 'BC1002';

DECLARE
    v_anno_proceso       NUMBER(4);
    v_anno_anterior      NUMBER(4);
    v_arriendo_dia       camion.valor_arriendo_dia%TYPE;
    v_garantia_dia       camion.valor_garantia_dia%TYPE;
    v_total_arriendos    NUMBER(4);
BEGIN
    v_anno_proceso  := EXTRACT(YEAR FROM SYSDATE);
    v_anno_anterior := v_anno_proceso - 1;

    SELECT valor_arriendo_dia, valor_garantia_dia
    INTO v_arriendo_dia, v_garantia_dia
    FROM camion
    WHERE nro_patente = :b_patente;

    SELECT COUNT(*)
    INTO v_total_arriendos
    FROM arriendo_camion
    WHERE nro_patente = :b_patente
      AND EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno_anterior;

    INSERT INTO hist_arriendo_anual_camion VALUES (
        v_anno_anterior, :b_patente, v_arriendo_dia, v_garantia_dia, v_total_arriendos
    );

    IF v_total_arriendos < 5 THEN
        UPDATE camion
        SET valor_arriendo_dia = ROUND(valor_arriendo_dia * (1 - (:b_porc_rebaja / 100))),
            valor_garantia_dia = ROUND(valor_garantia_dia * (1 - (:b_porc_rebaja / 100)))
        WHERE nro_patente = :b_patente;
    END IF;

    COMMIT;
END;
/

EXEC :b_patente := 'BT1002';

DECLARE
    v_anno_proceso       NUMBER(4);
    v_anno_anterior      NUMBER(4);
    v_arriendo_dia       camion.valor_arriendo_dia%TYPE;
    v_garantia_dia       camion.valor_garantia_dia%TYPE;
    v_total_arriendos    NUMBER(4);
BEGIN
    v_anno_proceso  := EXTRACT(YEAR FROM SYSDATE);
    v_anno_anterior := v_anno_proceso - 1;

    SELECT valor_arriendo_dia, valor_garantia_dia
    INTO v_arriendo_dia, v_garantia_dia
    FROM camion
    WHERE nro_patente = :b_patente;

    SELECT COUNT(*)
    INTO v_total_arriendos
    FROM arriendo_camion
    WHERE nro_patente = :b_patente
      AND EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno_anterior;

    INSERT INTO hist_arriendo_anual_camion VALUES (
        v_anno_anterior, :b_patente, v_arriendo_dia, v_garantia_dia, v_total_arriendos
    );

    IF v_total_arriendos < 5 THEN
        UPDATE camion
        SET valor_arriendo_dia = ROUND(valor_arriendo_dia * (1 - (:b_porc_rebaja / 100))),
            valor_garantia_dia = ROUND(valor_garantia_dia * (1 - (:b_porc_rebaja / 100)))
        WHERE nro_patente = :b_patente;
    END IF;

    COMMIT;
END;
/

EXEC :b_patente := 'VR1003';

DECLARE
    v_anno_proceso       NUMBER(4);
    v_anno_anterior      NUMBER(4);
    v_arriendo_dia       camion.valor_arriendo_dia%TYPE;
    v_garantia_dia       camion.valor_garantia_dia%TYPE;
    v_total_arriendos    NUMBER(4);
BEGIN
    v_anno_proceso  := EXTRACT(YEAR FROM SYSDATE);
    v_anno_anterior := v_anno_proceso - 1;

    SELECT valor_arriendo_dia, valor_garantia_dia
    INTO v_arriendo_dia, v_garantia_dia
    FROM camion
    WHERE nro_patente = :b_patente;

    SELECT COUNT(*)
    INTO v_total_arriendos
    FROM arriendo_camion
    WHERE nro_patente = :b_patente
      AND EXTRACT(YEAR FROM fecha_ini_arriendo) = v_anno_anterior;

    INSERT INTO hist_arriendo_anual_camion VALUES (
        v_anno_anterior, :b_patente, v_arriendo_dia, v_garantia_dia, v_total_arriendos
    );

    IF v_total_arriendos < 5 THEN
        UPDATE camion
        SET valor_arriendo_dia = ROUND(valor_arriendo_dia * (1 - (:b_porc_rebaja / 100))),
            valor_garantia_dia = ROUND(valor_garantia_dia * (1 - (:b_porc_rebaja / 100)))
        WHERE nro_patente = :b_patente;
    END IF;

    COMMIT;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_historial IS 
        SELECT anno_proceso, nro_patente, valor_arriendo_dia, valor_garactia_dia, total_veces_arrendado
        FROM hist_arriendo_anual_camion
        ORDER BY nro_patente ASC;

    CURSOR c_camiones IS
        SELECT nro_patente, valor_arriendo_dia, valor_garantia_dia
        FROM camion
        WHERE nro_patente IN ('AHEW11', 'ASEZ11', 'BC1002', 'BT1002', 'VR1003')
        ORDER BY nro_patente ASC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE('                    REPORTE DE CATASTRO HISTÓRICO ANUAL (TABLA HIST_ARRIENDO_ANUAL)                ');
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('AÑO PROC', 12) || RPAD('PATENTE', 12) || RPAD('VALOR ARRIENDO', 18) || RPAD('VALOR GARANTÍA', 18) || 'TOTAL VECES');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------');
    FOR h IN c_historial LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(h.anno_proceso), 12) ||
            RPAD(h.nro_patente, 12) ||
            RPAD(TO_CHAR(h.valor_arriendo_dia), 18) ||
            RPAD(NVL(TO_CHAR(h.valor_garactia_dia), '(null)'), 18) ||
            TO_CHAR(h.total_veces_arrendado)
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE('                      NUEVAS TARIFAS ACTUALIZADAS EN MAESTRO (TABLA CAMION)                        ');
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('PATENTE', 15) || RPAD('NUEVO VALOR ARRIENDO', 25) || 'NUEVO VALOR GARANTÍA');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------');
    FOR c IN c_camiones LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(c.nro_patente, 15) ||
            RPAD(TO_CHAR(c.valor_arriendo_dia), 25) ||
            NVL(TO_CHAR(c.valor_garantia_dia), '(null)')
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
END;
/

--Caso 4--

VARIABLE b_patente_c4 VARCHAR2(6);
VARIABLE b_multa_dia NUMBER;

EXEC :b_multa_dia := 25500;

EXEC :b_patente_c4 := 'AA1001';

DECLARE
    CURSOR c_arriendos_mes IS
        SELECT fecha_ini_arriendo, dias_solicitados, fecha_devolucion
        FROM arriendo_camion
        WHERE nro_patente = :b_patente_c4
          AND fecha_devolucion IS NOT NULL
          AND TO_CHAR(fecha_devolucion, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');

    v_periodo_proc    NUMBER(6);
    v_fecha_esperada  DATE;
    v_dias_atraso     NUMBER(3);
    v_monto_multa     NUMBER(8);
BEGIN
    v_periodo_proc := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));

    FOR reg IN c_arriendos_mes LOOP
        v_fecha_esperada := reg.fecha_ini_arriendo + reg.dias_solicitados;
        
        IF reg.fecha_devolucion > v_fecha_esperada THEN
            v_dias_atraso := TRUNC(reg.fecha_devolucion - v_fecha_esperada);
        ELSE
            v_dias_atraso := 0;
        END IF;

        IF v_dias_atraso > 0 THEN
            v_monto_multa := v_dias_atraso * :b_multa_dia;
            INSERT INTO multa_arriendo VALUES (
                202002, :b_patente_c4, reg.fecha_ini_arriendo,
                reg.dias_solicitados, reg.fecha_devolucion, v_dias_atraso, v_monto_multa
            );
        END IF;
    END LOOP;
    COMMIT;
END;
/

EXEC :b_patente_c4 := 'AHEW11';

DECLARE
    CURSOR c_arriendos_mes IS
        SELECT fecha_ini_arriendo, dias_solicitados, fecha_devolucion
        FROM arriendo_camion
        WHERE nro_patente = :b_patente_c4
          AND fecha_devolucion IS NOT NULL
          AND TO_CHAR(fecha_devolucion, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');

    v_periodo_proc    NUMBER(6);
    v_fecha_esperada  DATE;
    v_dias_atraso     NUMBER(3);
    v_monto_multa     NUMBER(8);
BEGIN
    v_periodo_proc := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));

    FOR reg IN c_arriendos_mes LOOP
        v_fecha_esperada := reg.fecha_ini_arriendo + reg.dias_solicitados;
        
        IF reg.fecha_devolucion > v_fecha_esperada THEN
            v_dias_atraso := TRUNC(reg.fecha_devolucion - v_fecha_esperada);
        ELSE
            v_dias_atraso := 0;
        END IF;

        IF v_dias_atraso > 0 THEN
            v_monto_multa := v_dias_atraso * :b_multa_dia;

            INSERT INTO multa_arriendo VALUES (
                202002, :b_patente_c4, reg.fecha_ini_arriendo,
                reg.dias_solicitados, reg.fecha_devolucion, v_dias_atraso, v_monto_multa
            );
        END IF;
    END LOOP;
    COMMIT;
END;
/

EXEC :b_patente_c4 := 'ASEZ11';

DECLARE
    CURSOR c_arriendos_mes IS
        SELECT fecha_ini_arriendo, dias_solicitados, fecha_devolucion
        FROM arriendo_camion
        WHERE nro_patente = :b_patente_c4
          AND fecha_devolucion IS NOT NULL
          AND TO_CHAR(fecha_devolucion, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');

    v_periodo_proc    NUMBER(6);
    v_fecha_esperada  DATE;
    v_dias_atraso     NUMBER(3);
    v_monto_multa     NUMBER(8);
BEGIN
    v_periodo_proc := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));

    FOR reg IN c_arriendos_mes LOOP
        v_fecha_esperada := reg.fecha_ini_arriendo + reg.dias_solicitados;
        
        IF reg.fecha_devolucion > v_fecha_esperada THEN
            v_dias_atraso := TRUNC(reg.fecha_devolucion - v_fecha_esperada);
        ELSE
            v_dias_atraso := 0;
        END IF;

        IF v_dias_atraso > 0 THEN
            v_monto_multa := v_dias_atraso * :b_multa_dia;

            INSERT INTO multa_arriendo VALUES (
                202002, :b_patente_c4, reg.fecha_ini_arriendo,
                reg.dias_solicitados, reg.fecha_devolucion, v_dias_atraso, v_monto_multa
            );
        END IF;
    END LOOP;
    COMMIT;
END;
/

EXEC :b_patente_c4 := 'BT1002';

DECLARE
    CURSOR c_arriendos_mes IS
        SELECT fecha_ini_arriendo, dias_solicitados, fecha_devolucion
        FROM arriendo_camion
        WHERE nro_patente = :b_patente_c4
          AND fecha_devolucion IS NOT NULL
          AND TO_CHAR(fecha_devolucion, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');

    v_periodo_proc    NUMBER(6);
    v_fecha_esperada  DATE;
    v_dias_atraso     NUMBER(3);
    v_monto_multa     NUMBER(8);
BEGIN
    v_periodo_proc := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));

    FOR reg IN c_arriendos_mes LOOP
        v_fecha_esperada := reg.fecha_ini_arriendo + reg.dias_solicitados;
        
        IF reg.fecha_devolucion > v_fecha_esperada THEN
            v_dias_atraso := TRUNC(reg.fecha_devolucion - v_fecha_esperada);
        ELSE
            v_dias_atraso := 0;
        END IF;

        IF v_dias_atraso > 0 THEN
            v_monto_multa := v_dias_atraso * :b_multa_dia;

            INSERT INTO multa_arriendo VALUES (
                202002, :b_patente_c4, reg.fecha_ini_arriendo,
                reg.dias_solicitados, reg.fecha_devolucion, v_dias_atraso, v_monto_multa
            );
        END IF;
    END LOOP;
    COMMIT;
END;
/

EXEC :b_patente_c4 := 'VR1003';

DECLARE
    CURSOR c_arriendos_mes IS
        SELECT fecha_ini_arriendo, dias_solicitados, fecha_devolucion
        FROM arriendo_camion
        WHERE nro_patente = :b_patente_c4
          AND fecha_devolucion IS NOT NULL
          AND TO_CHAR(fecha_devolucion, 'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');

    v_periodo_proc    NUMBER(6);
    v_fecha_esperada  DATE;
    v_dias_atraso     NUMBER(3);
    v_monto_multa     NUMBER(8);
BEGIN
    v_periodo_proc := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMM'));

    FOR reg IN c_arriendos_mes LOOP
        v_fecha_esperada := reg.fecha_ini_arriendo + reg.dias_solicitados;
        
        IF reg.fecha_devolucion > v_fecha_esperada THEN
            v_dias_atraso := TRUNC(reg.fecha_devolucion - v_fecha_esperada);
        ELSE
            v_dias_atraso := 0;
        END IF;

        IF v_dias_atraso > 0 THEN
            v_monto_multa := v_dias_atraso * :b_multa_dia;

            INSERT INTO multa_arriendo VALUES (
                202002, :b_patente_c4, reg.fecha_ini_arriendo,
                reg.dias_solicitados, reg.fecha_devolucion, v_dias_atraso, v_monto_multa
            );
        END IF;
    END LOOP;
    COMMIT;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_multas IS 
        SELECT anno_mes_proceso, nro_patente, fecha_ini_arriendo, 
               dias_solicitado, fecha_devolucion, dias_atraso, valor_multa
        FROM multa_arriendo
        ORDER BY nro_patente ASC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE('                               INFORME MENSUAL DE MULTAS (CASO 4)                                   ');
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PERIODO', 10) || 
        RPAD('PATENTE', 10) || 
        RPAD('F. INICIO', 13) || 
        RPAD('D. SOLIC.', 11) || 
        RPAD('F. DEVOL.', 13) || 
        RPAD('D. ATRASO', 11) || 
        'VALOR MULTA'
    );
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------------------');

    FOR r IN c_multas LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(TO_CHAR(r.anno_mes_proceso), 10) ||
            RPAD(r.nro_patente, 10) ||
            RPAD(TO_CHAR(r.fecha_ini_arriendo, 'DD/MM/YYYY'), 13) ||
            RPAD(TO_CHAR(r.dias_solicitado), 11) ||
            RPAD(TO_CHAR(r.fecha_devolucion, 'DD/MM/YYYY'), 13) ||
            RPAD(TO_CHAR(r.dias_atraso), 11) ||
            TO_CHAR(r.valor_multa)
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('====================================================================================================');
END;
/