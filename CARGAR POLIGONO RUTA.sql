--SE DEBE VERIFICAR QUE LAS COORDENADAS NO SEAN DUPLICADAS , SI ES ASI SE DEBE LIMPIAR EL EXCEL 1ER DE LA DUPLICIDAD.

-------------------------------------------------------------------------------

---LIMPIAR RUTAS CON PUNTOS DE COORDENADAS NULL

--DELETE FROM NPAZ.CARGAR_RUTA_POLIGONO NRP WHERE NRP.PUNTO_X_Y IS NULL;

--------------------------------------------------------------------------------

--CARGAR DE MANERA MASIVA LOS CORTES DE RUTAS
DECLARE
n number:=0;
v_rowsaffected NUMBER:=0;

ex_exception exception;

BEGIN 
DBMS_OUTPUT.ENABLE (buffer_size => NULL);

FOR c IN (
				
				Select  DISTINCT
				NPR.RUTA, NPR.PUNTO_X_Y, NPR.SECUENCIA
        from NPAZ.CARGAR_RUTA_POLIGONO NPR
        INNER JOIN SYSADM.TB_RUTA RUT ON NPR.RUTA = RUT.CODRUTA 
				ORDER BY NPR.RUTA, NPR.SECUENCIA
       
    )
    LOOP
				v_rowsaffected:= v_rowsaffected+1;
								
        INSERT INTO SYSADM.POLIGONO_RUTA  ( CODRUTA, PUNTO_XY, SECUENCIA )
               VALUES ( c.RUTA, c.PUNTO_X_Y, c.SECUENCIA );
  n:=n+1;
	
END LOOP;
DBMS_OUTPUT.PUT_LINE(n);
DBMS_OUTPUT.PUT_LINE('rows affected: ' || v_rowsaffected  );

exception 		
when others then
	--rollback;
	DBMS_OUTPUT.PUT_LINE('error:'||sqlerrm || ' - '||dbms_utility.format_error_backtrace);

--COMMIT;
--ROLLBACK;
END;

-------------------------------------------------------------------------


