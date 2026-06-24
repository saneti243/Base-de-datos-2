-- CASO 1--
DECLARE

    TYPE t_multas IS VARRAY(10) OF NUMBER;
    v_multas t_multas := t_multas(1200, 1300, 1700, 1900, 1100, 2000, 2300);
    CURSOR c_morosos IS
        SELECT
            p.pac_run,
            p.dv_run,
            p.pnombre || ' ' || p.snombre || ' ' || p.apaterno || ' ' || p.amaterno AS pac_nombre,
            a.ate_id,
            pa.fecha_venc_pago,
            pa.fecha_pago,
            (pa.fecha_pago - pa.fecha_venc_pago) AS dias_morosidad,
            e.nombre AS especialidad,
            e.esp_id,
            p.fecha_nacimiento
        FROM PAGO_ATENCION pa
        JOIN ATENCION a       ON pa.ate_id = a.ate_id
        JOIN PACIENTE p       ON a.pac_run = p.pac_run
        JOIN ESPECIALIDAD e   ON a.esp_id  = e.esp_id
        WHERE EXTRACT(YEAR FROM pa.fecha_venc_pago) = EXTRACT(YEAR FROM SYSDATE) - 1
          AND pa.fecha_pago > pa.fecha_venc_pago   
        ORDER BY pa.fecha_venc_pago ASC, p.apaterno ASC;

    r_moroso c_morosos%ROWTYPE;

    v_edad          NUMBER;          
    v_monto_multa   NUMBER;          
    v_porc_descto   NUMBER := 0;    
    v_multa_dia     NUMBER;          

BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE PAGO_MOROSO';
    DBMS_OUTPUT.PUT_LINE('Tabla PAGO_MOROSO truncada correctamente.');

    OPEN c_morosos;
    LOOP
        FETCH c_morosos INTO r_moroso;
        EXIT WHEN c_morosos%NOTFOUND;

        v_edad := TRUNC(MONTHS_BETWEEN(SYSDATE, r_moroso.fecha_nacimiento) / 12);

        IF r_moroso.esp_id IN (100, 300) THEN
            v_multa_dia := v_multas(1);
        ELSIF r_moroso.esp_id = 200 THEN
            v_multa_dia := v_multas(2);
        ELSIF r_moroso.esp_id IN (400, 900) THEN
            v_multa_dia := v_multas(3);
        ELSIF r_moroso.esp_id IN (500, 600) THEN
            v_multa_dia := v_multas(4);
        ELSIF r_moroso.esp_id = 700 THEN
            v_multa_dia := v_multas(5);
        ELSIF r_moroso.esp_id = 1100 THEN
            v_multa_dia := v_multas(6);
        ELSIF r_moroso.esp_id IN (1400, 1800) THEN
            v_multa_dia := v_multas(7);
        ELSE
            v_multa_dia := 1000; 
        END IF;

        v_monto_multa := r_moroso.dias_morosidad * v_multa_dia;

        v_porc_descto := 0;
        IF v_edad >= 65 THEN
            BEGIN
                SELECT porcentaje_descto
                INTO v_porc_descto
                FROM PORC_DESCTO_3RA_EDAD
                WHERE v_edad BETWEEN anno_ini AND anno_ter;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_porc_descto := 0; 
            END;

            v_monto_multa := v_monto_multa - (v_monto_multa * v_porc_descto / 100);
        END IF;

        INSERT INTO PAGO_MOROSO (
            pac_run, pac_dv_run, pac_nombre, ate_id,
            fecha_venc_pago, fecha_pago, dias_morosidad,
            especialidad_atencion, monto_multa
        ) VALUES (
            r_moroso.pac_run,
            r_moroso.dv_run,
            r_moroso.pac_nombre,
            r_moroso.ate_id,
            r_moroso.fecha_venc_pago,
            r_moroso.fecha_pago,
            r_moroso.dias_morosidad,
            r_moroso.especialidad,
            v_monto_multa
        );

    END LOOP;
    CLOSE c_morosos;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso CASO 1 completado. Registros insertados: ' || SQL%ROWCOUNT);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en CASO 1: ' || SQLERRM);
END;
/

-- CASO 2--
--El drop table esta por que la guia pedia borrar la tabla--

DROP TABLE MEDICO_SERVICIO_COMUNIDAD;
CREATE TABLE MEDICO_SERVICIO_COMUNIDAD (
    id_med_scomun     NUMBER(2) GENERATED ALWAYS AS IDENTITY
                      MINVALUE 1 MAXVALUE 9999999999999999999999999999
                      INCREMENT BY 1 START WITH 1
                      CONSTRAINT PK_MED_SERV_COMUNIDAD PRIMARY KEY,
    unidad            VARCHAR2(50) NOT NULL,
    run_medico        VARCHAR2(15) NOT NULL,
    nombre_medico     VARCHAR2(50) NOT NULL,
    correo_institucional VARCHAR2(25) NOT NULL,
    total_aten_medicas NUMBER(2) NOT NULL,
    destinacion       VARCHAR2(50) NOT NULL
);

DECLARE
    v_max_atenciones    NUMBER;
    v_total_atenciones  NUMBER;
    v_correo            VARCHAR2(25);
    v_destinacion       VARCHAR2(50);

    TYPE t_medico IS RECORD (
        med_run    MEDICO.med_run%TYPE,
        dv_run     MEDICO.dv_run%TYPE,
        nombre     VARCHAR2(60),
        uni_nombre UNIDAD.nombre%TYPE
    );
    r_medico t_medico;

    CURSOR c_medicos IS
        SELECT
            m.med_run,
            m.dv_run,
            m.pnombre || ' ' || m.snombre || ' ' || m.apaterno || ' ' || m.amaterno AS nombre,
            u.nombre AS uni_nombre
        FROM MEDICO m
        JOIN UNIDAD u ON m.uni_id = u.uni_id
        ORDER BY u.nombre ASC, m.apaterno ASC;

BEGIN

    SELECT MAX(total_aten)
    INTO v_max_atenciones
    FROM (
        SELECT COUNT(*) AS total_aten
        FROM ATENCION
        WHERE EXTRACT(YEAR FROM fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) - 1
        GROUP BY med_run
    );

    DBMS_OUTPUT.PUT_LINE('Máximo de atenciones año anterior: ' || v_max_atenciones);

    OPEN c_medicos;
    LOOP
        FETCH c_medicos INTO r_medico;
        EXIT WHEN c_medicos%NOTFOUND;
        SELECT COUNT(*)
        INTO v_total_atenciones
        FROM ATENCION
        WHERE med_run = r_medico.med_run
          AND EXTRACT(YEAR FROM fecha_atencion) = EXTRACT(YEAR FROM SYSDATE) - 1;

        IF v_total_atenciones < v_max_atenciones THEN

            DECLARE
                v_apaterno VARCHAR2(20);
                v_uni_dos  VARCHAR2(2);
                v_letras   VARCHAR2(2);
                v_run_tres VARCHAR2(3);
            BEGIN

                SELECT apaterno INTO v_apaterno FROM MEDICO WHERE med_run = r_medico.med_run;

                v_uni_dos := LOWER(SUBSTR(r_medico.uni_nombre, 1, 2));

                v_letras := LOWER(
                    SUBSTR(v_apaterno, LENGTH(v_apaterno) - 1, 1) ||
                    SUBSTR(v_apaterno, LENGTH(v_apaterno) - 2, 1)
                );

                v_run_tres := SUBSTR(TO_CHAR(r_medico.med_run), -3);

                v_correo := v_uni_dos || v_letras || v_run_tres || '@ketekura.cl';
            END;

            IF r_medico.uni_nombre IN ('ATENCIÓN ADULTO', 'ATENCIÓN AMBULATORIA') THEN
                v_destinacion := 'Servicio de Atención Primaria de Urgencia (SAPU)';
            ELSIF r_medico.uni_nombre = 'ATENCIÓN URGENCIA' THEN
                IF v_total_atenciones BETWEEN 0 AND 3 THEN
                    v_destinacion := 'Servicio de Atención Primaria de Urgencia (SAPU)';
                ELSE
                    v_destinacion := 'Hospitales del área de la Salud Pública';
                END IF;
            ELSIF r_medico.uni_nombre IN ('CARDIOLOGÍA', 'ONCOLÓGICA') THEN
                v_destinacion := 'Hospitales del área de la Salud Pública';
            ELSIF r_medico.uni_nombre IN ('CIRUGÍA', 'CIRUGÍA PLÁSTICA') THEN
                IF v_total_atenciones BETWEEN 0 AND 3 THEN
                    v_destinacion := 'Servicio de Atención Primaria de Urgencia (SAPU)';
                ELSE
                    v_destinacion := 'Hospitales del área de la Salud Pública';
                END IF;
            ELSIF r_medico.uni_nombre = 'PACIENTE CRÍTICO' THEN
                v_destinacion := 'Hospitales del área de la Salud Pública';
            ELSIF r_medico.uni_nombre = 'PSIQUIATRÍA Y SALUD MENTAL' THEN
                v_destinacion := 'Centros de Salud Familiar (CESFAM)';
            ELSIF r_medico.uni_nombre = 'TRAUMATOLOGÍA ADULTO' THEN
                IF v_total_atenciones BETWEEN 0 AND 3 THEN
                    v_destinacion := 'Servicio de Atención Primaria de Urgencia (SAPU)';
                ELSE
                    v_destinacion := 'Hospitales del área de la Salud Pública';
                END IF;
            ELSE
                v_destinacion := 'Servicio de Atención Primaria de Urgencia (SAPU)';
            END IF;

            INSERT INTO MEDICO_SERVICIO_COMUNIDAD (
                unidad, run_medico, nombre_medico,
                correo_institucional, total_aten_medicas, destinacion
            ) VALUES (
                r_medico.uni_nombre,
                TO_CHAR(r_medico.med_run) || '-' || r_medico.dv_run,
                r_medico.nombre,
                v_correo,
                v_total_atenciones,
                v_destinacion
            );

        END IF;

    END LOOP;
    CLOSE c_medicos;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso CASO 2 completado.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en CASO 2: ' || SQLERRM);
END;
/



-- CASO 3.1 --

DECLARE
    c_porc_descuento   CONSTANT NUMBER := 23;
    v_nombre_tabla     VARCHAR2(30);
    v_total_procesados NUMBER := 0;
    v_total_actualizados NUMBER := 0;
    v_monto_original_total NUMBER := 0;
    v_monto_nuevo_total NUMBER := 0;

    TYPE t_pago IS RECORD (
        ate_id           PAGO_ATENCION.ate_id%TYPE,
        fecha_venc_pago  PAGO_ATENCION.fecha_venc_pago%TYPE,
        fecha_pago       PAGO_ATENCION.fecha_pago%TYPE,
        monto_atencion   PAGO_ATENCION.monto_atencion%TYPE,
        monto_a_cancelar PAGO_ATENCION.monto_a_cancelar%TYPE,
        obs_pago         PAGO_ATENCION.obs_pago%TYPE
    );
    r_pago t_pago;

    CURSOR c_pagos IS
        SELECT ate_id, fecha_venc_pago, fecha_pago,
               monto_atencion, monto_a_cancelar, obs_pago
        FROM PAGO_ATENCION
        WHERE EXTRACT(YEAR FROM fecha_venc_pago) = EXTRACT(YEAR FROM SYSDATE) - 1
        ORDER BY ate_id;

    v_nuevo_monto   NUMBER;
    v_observacion   VARCHAR2(100);

BEGIN
    v_nombre_tabla := 'pago_atencion_' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE));

    EXECUTE IMMEDIATE 'CREATE TABLE ' || v_nombre_tabla || ' AS SELECT * FROM pago_atencion';
    DBMS_OUTPUT.PUT_LINE('Tabla ' || v_nombre_tabla || ' creada como copia de pago_atencion.');

    OPEN c_pagos;
    LOOP
        FETCH c_pagos INTO r_pago;
        EXIT WHEN c_pagos%NOTFOUND;

        v_total_procesados := v_total_procesados + 1;

        v_monto_original_total := v_monto_original_total + r_pago.monto_atencion;

        v_nuevo_monto := ROUND(r_pago.monto_atencion * (1 - c_porc_descuento / 100));

        v_monto_nuevo_total := v_monto_nuevo_total + v_nuevo_monto;

        v_observacion := 'Descuento ' || c_porc_descuento || '% aplicado año ' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1);

        EXECUTE IMMEDIATE
            'UPDATE ' || v_nombre_tabla ||
            ' SET monto_a_cancelar = :1, obs_pago = :2 WHERE ate_id = :3'
            USING v_nuevo_monto, v_observacion, r_pago.ate_id;

        v_total_actualizados := v_total_actualizados + 1;

    END LOOP;
    CLOSE c_pagos;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('=== ESTADÍSTICAS DEL PROCESO CASO 3.1 ===');
    DBMS_OUTPUT.PUT_LINE('Tabla procesada        : ' || v_nombre_tabla);
    DBMS_OUTPUT.PUT_LINE('Año procesado          : ' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1));
    DBMS_OUTPUT.PUT_LINE('Total registros proceso: ' || v_total_procesados);
    DBMS_OUTPUT.PUT_LINE('Total actualizados     : ' || v_total_actualizados);
    DBMS_OUTPUT.PUT_LINE('Monto total original   : $' || TO_CHAR(v_monto_original_total, '999,999,999'));
    DBMS_OUTPUT.PUT_LINE('Monto total con desc.  : $' || TO_CHAR(v_monto_nuevo_total, '999,999,999'));
    DBMS_OUTPUT.PUT_LINE('Descuento aplicado     : ' || c_porc_descuento || '%');
    DBMS_OUTPUT.PUT_LINE('Proceso completado exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en CASO 3.1: ' || SQLERRM);
END;
/

-- CASO 3.2 --
DECLARE

    v_descto_ab        NUMBER := 10;  
    v_descto_cd        NUMBER := 20;  

    v_nombre_tabla     VARCHAR2(30);

    v_total_procesados NUMBER := 0;
    v_total_actualizados NUMBER := 0;
    v_monto_orig_total NUMBER := 0;
    v_monto_nuevo_total NUMBER := 0;

    TYPE t_pago_fase2 IS RECORD (
        ate_id           PAGO_ATENCION.ate_id%TYPE,
        monto_atencion   PAGO_ATENCION.monto_atencion%TYPE,
        tipo_sal_id      TIPO_SALUD.tipo_sal_id%TYPE,
        sal_descripcion  SALUD.descripcion%TYPE
    );
    r_pago_fase2 t_pago_fase2;

    CURSOR c_fase2 IS
        SELECT
            pa.ate_id,
            pa.monto_atencion,
            ts.tipo_sal_id,
            s.descripcion AS sal_descripcion
        FROM PAGO_ATENCION pa
        JOIN ATENCION a        ON pa.ate_id   = a.ate_id
        JOIN PACIENTE p        ON a.pac_run   = p.pac_run
        JOIN SALUD s           ON p.sal_id    = s.sal_id
        JOIN TIPO_SALUD ts     ON s.tipo_sal_id = ts.tipo_sal_id
        WHERE EXTRACT(YEAR FROM pa.fecha_venc_pago) = EXTRACT(YEAR FROM SYSDATE) - 1
          AND a.esp_id IN (100, 600, 200, 500, 1100)
          AND ts.tipo_sal_id = 'F'  
        ORDER BY pa.ate_id;

    v_porc_descto   NUMBER;
    v_nuevo_monto   NUMBER;
    v_obs           VARCHAR2(100);

BEGIN

    v_nombre_tabla := 'pago_atencion_fase2';
    EXECUTE IMMEDIATE 'CREATE TABLE ' || v_nombre_tabla || ' AS SELECT * FROM pago_atencion';
    DBMS_OUTPUT.PUT_LINE('Tabla ' || v_nombre_tabla || ' creada como copia de pago_atencion.');

    OPEN c_fase2;
    LOOP
        FETCH c_fase2 INTO r_pago_fase2;
        EXIT WHEN c_fase2%NOTFOUND;

        v_total_procesados := v_total_procesados + 1;
        v_monto_orig_total := v_monto_orig_total + r_pago_fase2.monto_atencion;

        IF r_pago_fase2.sal_descripcion IN ('Tramo A', 'Tramo B') THEN
            v_porc_descto := v_descto_ab;   
        ELSIF r_pago_fase2.sal_descripcion IN ('Tramo C', 'Tramo D') THEN
            v_porc_descto := v_descto_cd;   
        ELSE
            v_porc_descto := 0;
        END IF;

        v_nuevo_monto := ROUND(r_pago_fase2.monto_atencion * (1 - v_porc_descto / 100));
        v_monto_nuevo_total := v_monto_nuevo_total + v_nuevo_monto;

        v_obs := 'Desc. ' || v_porc_descto || '% Fonasa ' ||
                 r_pago_fase2.sal_descripcion || ' año ' ||
                 TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1);


        EXECUTE IMMEDIATE
            'UPDATE ' || v_nombre_tabla ||
            ' SET monto_a_cancelar = :1, obs_pago = :2 WHERE ate_id = :3'
            USING v_nuevo_monto, v_obs, r_pago_fase2.ate_id;

        v_total_actualizados := v_total_actualizados + 1;

    END LOOP;
    CLOSE c_fase2;

    COMMIT;

    -- Estadística de salida del proceso
    DBMS_OUTPUT.PUT_LINE('=== ESTADÍSTICAS DEL PROCESO CASO 3.2 ===');
    DBMS_OUTPUT.PUT_LINE('Tabla procesada           : ' || v_nombre_tabla);
    DBMS_OUTPUT.PUT_LINE('Año venc. pago procesado  : ' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1));
    DBMS_OUTPUT.PUT_LINE('Total registros procesados: ' || v_total_procesados);
    DBMS_OUTPUT.PUT_LINE('Total actualizados        : ' || v_total_actualizados);
    DBMS_OUTPUT.PUT_LINE('Monto total original      : $' || TO_CHAR(v_monto_orig_total, '999,999,999'));
    DBMS_OUTPUT.PUT_LINE('Monto total con desc.     : $' || TO_CHAR(v_monto_nuevo_total, '999,999,999'));
    DBMS_OUTPUT.PUT_LINE('Descuento Fonasa A/B      : ' || v_descto_ab || '%');
    DBMS_OUTPUT.PUT_LINE('Descuento Fonasa C/D      : ' || v_descto_cd || '%');
    DBMS_OUTPUT.PUT_LINE('Proceso completado exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en CASO 3.2: ' || SQLERRM);
END;
/

-- CASO 4 --

DECLARE
   
    TYPE t_porcentajes IS VARRAY(3) OF NUMBER;

    v_pct         t_porcentajes := t_porcentajes(20, 12, 500000000);
    
    CURSOR c_medicos IS
        SELECT
            m.med_run,
            m.dv_run,
            m.pnombre || ' ' || m.snombre || ' ' ||
            m.apaterno || ' ' || m.amaterno AS nombre_completo,
            c.nombre AS cargo,
            m.sueldo_base,
            m.fecha_contrato
        FROM MEDICO m
        JOIN CARGO c ON m.car_id = c.car_id
        ORDER BY m.med_run ASC;
 
    r_med c_medicos%ROWTYPE;
 
    v_anno_tributario      NUMBER;    
    v_anno_proceso         NUMBER;   
    v_meses_trabajados     NUMBER;   
    v_total_atenciones     NUMBER;    
    v_medicos_sup_5        NUMBER;    
    v_bono_ganancias       NUMBER;    
    v_porc_asig_atmed      NUMBER;    
    v_asig_atmed           NUMBER;    
    v_colacion             NUMBER;   
    v_movilizacion         NUMBER;    
    v_sueldo_bruto_mensual NUMBER;   
    v_renta_impon_mensual  NUMBER;    
    v_sueldo_base_anual    NUMBER;    
    v_sueldo_bruto_anual   NUMBER;    
    v_renta_impon_anual    NUMBER;    
    v_bonif_especial       NUMBER;    
 

    v_numrun_enc           NUMBER;    
    v_dv_enc               VARCHAR2(5); 
    v_sueldo_enc           NUMBER;   
    v_run_str              VARCHAR2(12);
    v_sueldo_str           VARCHAR2(12);
 
BEGIN

    v_anno_tributario := EXTRACT(YEAR FROM SYSDATE);       
    v_anno_proceso    := EXTRACT(YEAR FROM SYSDATE) - 1;   
 
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INFO_MEDICO_SII';
    DBMS_OUTPUT.PUT_LINE('Tabla INFO_MEDICO_SII truncada.');

    SELECT COUNT(*)
    INTO v_medicos_sup_5
    FROM (
        SELECT med_run, COUNT(*) AS total
        FROM ATENCION
        WHERE EXTRACT(YEAR FROM fecha_atencion) = v_anno_proceso
        GROUP BY med_run
        HAVING COUNT(*) > 5
    );
 
    DBMS_OUTPUT.PUT_LINE('Médicos con más de 5 atenciones en ' || v_anno_proceso
                         || ': ' || v_medicos_sup_5);
 

    OPEN c_medicos;
    LOOP
        FETCH c_medicos INTO r_med;
        EXIT WHEN c_medicos%NOTFOUND;
        
        IF EXTRACT(YEAR FROM r_med.fecha_contrato) <= v_anno_proceso THEN
            v_meses_trabajados := 12;
        ELSIF EXTRACT(YEAR FROM r_med.fecha_contrato) = v_anno_proceso THEN
            v_meses_trabajados := 13 - EXTRACT(MONTH FROM r_med.fecha_contrato);
        ELSE
            v_meses_trabajados := 0;
        END IF;
 
        IF v_meses_trabajados = 0 THEN
            CONTINUE;
        END IF;
 
        SELECT COUNT(*)
        INTO v_total_atenciones
        FROM ATENCION
        WHERE med_run = r_med.med_run
          AND EXTRACT(YEAR FROM fecha_atencion) = v_anno_proceso;
 
        IF v_total_atenciones > 5 AND v_medicos_sup_5 > 0 THEN
            v_bono_ganancias := ROUND((v_pct(3) * 0.03) / v_medicos_sup_5);
        ELSE
            v_bono_ganancias := 0;
        END IF;
 
        IF v_total_atenciones > 0 THEN
            BEGIN
                SELECT porc_asig
                INTO v_porc_asig_atmed
                FROM TRAMO_ASIG_ATMED
                WHERE v_total_atenciones BETWEEN tramo_inf_atm AND tramo_sup_atm;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_porc_asig_atmed := 0; 
            END;
        ELSE
            v_porc_asig_atmed := 0;
        END IF;
 
        v_asig_atmed := ROUND(r_med.sueldo_base * v_porc_asig_atmed / 100);
 
        v_colacion      := ROUND(r_med.sueldo_base * v_pct(1) / 100);
        v_movilizacion  := ROUND(r_med.sueldo_base * v_pct(2) / 100); 
 
        v_sueldo_bruto_mensual := r_med.sueldo_base + v_asig_atmed + v_colacion + v_movilizacion;
 
        v_renta_impon_mensual := r_med.sueldo_base + v_asig_atmed;
 
        v_sueldo_base_anual  := r_med.sueldo_base    * v_meses_trabajados;
        v_sueldo_bruto_anual := v_sueldo_bruto_mensual * v_meses_trabajados
                                + v_bono_ganancias;  
        v_renta_impon_anual  := v_renta_impon_mensual * v_meses_trabajados
                                + v_bono_ganancias;  
 
        v_bonif_especial := v_bono_ganancias + (v_asig_atmed * v_meses_trabajados);
 
        v_run_str   := TO_CHAR(r_med.med_run);
        v_numrun_enc := TO_NUMBER(
            SUBSTR(v_run_str, -3) ||                     
            SUBSTR(v_run_str, 1, LENGTH(v_run_str) - 3)  
        );
    
        v_dv_enc := SUBSTR(v_run_str, 1, 3);
 
        v_sueldo_str := TO_CHAR(r_med.sueldo_base);
        v_sueldo_enc := TO_NUMBER(SUBSTR(v_sueldo_str, -3)); -- Últimos 3 dígitos
 
        INSERT INTO INFO_MEDICO_SII (
            anno_tributario,
            numrun,
            dv_run,
            nombre_completo,
            cargo,
            meses_trabajados,
            sueldo_base_mensual,
            sueldo_base_anual,
            bonif_especial,
            sueldo_bruto_anual,
            renta_imponible_anual
        ) VALUES (
            v_anno_tributario,    
            v_numrun_enc,         
            v_dv_enc,             
            r_med.nombre_completo,
            r_med.cargo,
            v_meses_trabajados,
            v_sueldo_enc,         
            v_sueldo_base_anual,
            v_bonif_especial,
            v_sueldo_bruto_anual,
            v_renta_impon_anual
        );
 
    END LOOP;
    CLOSE c_medicos;
 
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso CASO 4 completado.');
    DBMS_OUTPUT.PUT_LINE('Año tributario: ' || v_anno_tributario);
    DBMS_OUTPUT.PUT_LINE('Año procesado : ' || v_anno_proceso);
    DBMS_OUTPUT.PUT_LINE('Médicos con bono por ganancias: ' || v_medicos_sup_5);
 
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en CASO 4: ' || SQLERRM);
END;
/