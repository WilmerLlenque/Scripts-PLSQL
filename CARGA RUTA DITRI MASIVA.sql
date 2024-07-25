--CREAR RUTA_DESPACHO NUEVA

DECLARE
    vCANT NUMBER:=0;
    vID NUMBER;
		--vIDDET NUMBER;
    CODIGO VARCHAR(3):='';
    INICIO NUMBER := 66;
    p_DESCRIPCION VARCHAR2(50);
    
    v_parametros   XRAYADMIN.LISTPARAMETR0STRING;
    v_cursor   SYS_REFCURSOR;
    v_respuesta    NUMBER;
    v_mensaje      VARCHAR2 (32767);
    v_codigo varchar2(4);
BEGIN
-- created_at
-- updated_at
-- deleted_at


		
    SELECT MAX(IDRUTADESPACHO)+1 INTO vID FROM SYSADM.RUTA_DESPACHO;
		
    FOR CUR IN (
		SELECT * FROM NPAZ.CARGAR_RUTA_DISTRI R 
		JOIN SYSADM.TB_SEDE S ON R.SEDE=S.CODSEDE 

	)	
    LOOP
        v_codigo:= '';
        v_parametros := XRAYADMIN.LISTPARAMETR0STRING();
        v_parametros.extend(1);
        XRAYADMIN.PK_RUTAS_DESPACHO.SP_LU_RUTAS_DESPACHO (
            P_OPERACION    => 5,
            P_PARAMETROS   => v_parametros,
            X_CURSORRPTA   => v_cursor,
            X_RESPUESTA    => v_respuesta,
            X_MENSAJE      => v_mensaje
        );
         loop fetch v_cursor into v_codigo;
            exit when v_cursor%notfound;
            null;
         --dbms_output.put_line(v_codigo);
         end loop;
         close v_cursor;
    
        p_DESCRIPCION:=CUR.DESCRIPCION;
        IF LENGTH(p_DESCRIPCION)>40 THEN
            DBMS_OUTPUT.PUT_LINE(p_DESCRIPCION);
        END IF;
								
				INSERT INTO SYSADM.RUTA_DESPACHO(
										IDRUTADESPACHO, 
										CODRUTADESPACHO, 
										DESCRUTADESPACHO, 
										CODEMPRESA, 
										CODSEDE, 
										CODFUERZAV, 
										RECORRIDO, 
										ESTADO, 
										USUARIOREGISTRO, 
										FECHAREGISTRO)
								VALUES(	
												--vID, --vID_RUTAD.IDRUTADESPACHO,
												vID+vCANT,  --vID_RUTAD.IDRUTADESPACHO,
												v_codigo,
												CUR.DESCRIPCION,
												CUR.EMPRESA,
												CUR.CODSEDE,
												'GL',
												0,
												'A',
												'PAZVILNO', 
												SYSDATE
								);
        
        vCANT := vCANT +1;
    END LOOP;
    --COMMIT;
		--ROLLBACK;
    DBMS_OUTPUT.PUT_LINE ('CANTIDAD: '||vCANT);
END;