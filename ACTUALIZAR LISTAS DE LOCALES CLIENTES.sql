-------------------------------------------------------------------------------------------------------------------
DECLARE
    CANT NUMBER :=0;
		v_rowsaffected NUMBER:=0;
		
BEGIN

DBMS_OUTPUT.ENABLE (buffer_size => NULL);

    FOR CUR IN (SELECT * FROM NPAZ.ACT_LISTAS_CLIENTES)
		
    LOOP
        UPDATE SYSADM.LOCALES_CLIENTE LC SET LC.COD_LISTA=CUR.COD_LISTA
																			 
        WHERE LC.COD_CLIENTE = CUR.COD_CLIENTE
					AND LC.COD_LOCAL = CUR.COD_LOCAL;
					
				
        CANT := CANT +1;
				
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CANT);
		DBMS_OUTPUT.PUT_LINE('rows affected: ' || v_rowsaffected  );
		--COMMIT;
		--
		--ROLLBACK;
END
;

-----------------------------------------------------------------------------
---Consultar las listas

SELECT 
			AL.COD_CLIENTE,
			AL.COD_LOCAL,
			AL.COD_LISTA AS LISTA_NUEVA,
			LC.COD_LOCAL AS LOCAL_REF,
			LC.COD_LISTA AS LISTA_ANTIGUA
FROM NPAZ.ACT_LISTAS_CLIENTES AL
INNER JOIN SYSADM.LOCALES_CLIENTE LC
ON AL.COD_CLIENTE = LC.COD_CLIENTE
AND AL.COD_LOCAL = LC.COD_LOCAL;

------------------------------------------------------------
---CARGA_MASIVA_LOCALES_CLIENTES BEBIDAS_ CHICLAYO

DECLARE
    CANT NUMBER :=0;
BEGIN
    FOR CUR IN (SELECT * FROM NPAZ.CLIENTE_LOCAL)
    LOOP
        UPDATE SYSADM.LOCALES_CLIENTE LC SET LC.COD_LISTA=CUR.LOCAL_NUEVO
																			 
        WHERE LC.COD_CLIENTE = CUR.COD_CLIENTE
					AND LC.COD_LOCAL = CUR.CODIGO_LOCAL
					AND LC.DIVISION = 'BE';
				
        CANT := CANT +1;
				
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CANT);
		--COMMIT;
END
;



