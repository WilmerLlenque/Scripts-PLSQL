DECLARE
n number:=0;
v_id_local_new number:=0;
v_rowsaffected NUMBER:=0;

BEGIN 
DBMS_OUTPUT.ENABLE (buffer_size => NULL);
-- SELECT DISTINCT COD_CLIENTE FROM wzamora.CLIENTE_LOCAL WHERE CODIGO_RUTA_ANTIGUA=CODIGO_RUTA_NUEVA
    FOR c IN (
        
				Select DISTINCT cr.CODIGO_RUTA_NUEVA,CR.CODIGO_LOCAL,cr.id,
        LC.*
        from NPAZ.CLIENTE_LOCAL cr
        INNER JOIN SYSADM.LOCALES_CLIENTE LC ON (cr.CODIGO_RUTA_antigua=LC.RUTA_DESPACHO 
        AND CR.COD_CLIENTE=LC.COD_CLIENTE
        and cr.codigo_local=lc.cod_local) 
				
        --where lc.division='BE'
    --INNER JOIN SYSADM.TB_RUTA R ON (CR.CODIGO_RUTA_NUEVA=R.CODRUTA)
    -- SELECT * FROM SYSADM.LOCALES_CLIENTE
		
		/* CUANDO LAS RUTAS ANTIGUAS TIENEN UN ESPACIO AL FINAL
		Select DISTINCT cr.CODIGO_RUTA_NUEVA,CR.CODIGO_LOCAL,cr.id,
        LC.*
        from NPAZ.CLIENTE_LOCAL cr
        INNER JOIN SYSADM.LOCALES_CLIENTE LC ON 
				(
				--cr.CODIGO_RUTA_antigua=LC.RUTA_DESPACHO 
        --AND 
				CR.COD_CLIENTE=LC.COD_CLIENTE
        and cr.codigo_local=lc.cod_local) 
		*/
    )
    LOOP
        SELECT MAX(COD_LOCAL)+1 INTO v_id_local_new 
        FROM SYSADM.LOCALES_CLIENTE 
        WHERE COD_CLIENTE=c.COD_CLIENTE;
        -- select * from SYSADM.LOCALES_CLIENTE
				
				UPDATE NPAZ.CLIENTE_LOCAL SET 
				local_nuevo=v_id_local_new
        WHERE id=c.id;
				
				/*
				UPDATE SYSADM.LOCALES_CLIENTE SET 
				--ESTAD='I',
				delete_at= sysdate
        WHERE COD_CLIENTE=c.COD_CLIENTE 
        --AND RUTA_DESPACHO=c.RUTA_DESPACHO
        AND cod_local=c.CODIGO_LOCAL
				and DIVISION='AB'
				and ESTAD<>'I';
				*/
				
				--v_rowsaffected  := SQL%rowcount;
				v_rowsaffected:= v_rowsaffected+1;
        --
        INSERT INTO SYSADM.LOCALES_CLIENTE 
                    (
                    COD_CIA,
                    COD_CLIENTE,
                    COD_LOCAL,
                    DESC_LOCAL,
                    DIRECCION,
                    ROWVERSION,
                    UBIGEO,
                    REF_DESPACHO,
                    RUTA_DESPACHO,
                    COD_USUARIO,
                    B_EXONERA_IGV,
                    ESTAD,
                    FECGEOLOCALIZACION,
                    USUAR_GEOLO,
                    NEW_COORDENADAS,
                    FECHA_NEWGEO,
                    COD_LISTA,
                    DIVISION,
                    GIRO_NEGOCIO,
                    TIPO_CLIENTE,
                    COD_VIA,
                    DESC_VIA,
                    FRECUENCIA_VISITA
                    )
                    VALUES
                    (
                    '00',
                    c.COD_CLIENTE,
                    v_id_local_new,
                    c.DESC_LOCAL,
                    c.DIRECCION,
                    0,
                    c.UBIGEO,
                    c.REF_DESPACHO,
                    c.CODIGO_RUTA_NUEVA,
                    'PAZVILNO',
                    c.B_EXONERA_IGV,
                    'A',
                    sysdate,
                    'PAZVILNO',
                    c.NEW_COORDENADAS,
                    c.FECHA_NEWGEO,
                    c.COD_LISTA ,
                    --c.DIVISION,
                    'AB',
                    'AB',
                    c.TIPO_CLIENTE,
                    c.COD_VIA,
                    c.DESC_VIA,
                    c.FRECUENCIA_VISITA);
  n:=n+1;
	DBMS_OUTPUT.PUT_LINE(c.COD_CLIENTE);
	
END LOOP;
DBMS_OUTPUT.PUT_LINE(n);
DBMS_OUTPUT.PUT_LINE('rows affected: ' || v_rowsaffected  );

--COMMIT;
--rollback;
END;
