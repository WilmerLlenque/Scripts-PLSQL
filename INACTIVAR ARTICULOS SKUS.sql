---ANALIZAR ARTICULOS

SELECT 
		CL.COD_ITEM,
		LC.STATUS_ITEM
FROM NPAZ.ACT_ART_PESOS_GLORIA CL
INNER JOIN SYSADM.ARTICULOS LC
ON CL.COD_ITEM = LC.COD_ITEM

-----------------------------------------------

---INACTIVAR SKUS 

DECLARE
    CANT NUMBER :=0;
BEGIN
    FOR CUR IN (SELECT DISTINCT * FROM NPAZ.ACT_ART_PESOS_GLORIA)
    LOOP
        
	UPDATE SYSADM.ARTICULOS LC SET STATUS_ITEM='I'
        WHERE LC.COD_ITEM=CUR.COD_ITEM;
        CANT := CANT +1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CANT);
		--COMMIT;
END
;