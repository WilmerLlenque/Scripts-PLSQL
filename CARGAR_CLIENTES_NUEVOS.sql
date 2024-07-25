DECLARE
    vEXISTE NUMBER :=0; -- SI EL CLIENTE EXISTE A NIVEL GENERAL
    vCANT NUMBER:=0; -- CANTIDAD DE CLIENTES
    vNUEVOS NUMBER:=0; -- CANTIDAD DE CLIENTES NUEVOS
    vEDITAR NUMBER:=0; -- CANTIDAD DE CLIENTES QUE SE AGREGARON UN LOCAL, EMPRESA O ALMACÉN
    vCALMACEN NUMBER :=0; -- EXISTE ALMACÉN NUEVO
    vALMACEN VARCHAR2(2):=''; --CÓDIGO DE ALMACÉN NUEVO
    vCEMPRESA NUMBER:= 0; --EXISTE EMPRESA NUEVA
    vMAX NUMBER:=0; -- MAXIMO LOCAL 
		--v_rowsaffected NUMBER:=0;
		ex_exception exception;
BEGIN
--DBMS_OUTPUT.ENABLE (buffer_size => NULL);

    FOR CUR IN (SELECT DISTINCT CB.*
                FROM NPAZ.CLIENTES_AB_PIURA CB 
                ORDER BY DOCUMENTO
                )
    LOOP
        SELECT COUNT(*) INTO vEXISTE FROM SYSADM.CLIENTE WHERE CLIENTE.COD_CLIENTE=CUR.COD_CLIENTE;
        IF vEXISTE=0 THEN
            INSERT INTO SYSADM.CLIENTE(
                COD_CIA, COD_CLIENTE, RUC, TELEFONO, FAX, DESC_CLIENTE,
                DIRECCION_CLIENTE, CIUDAD,
                STATUS_CLIENTE, MONEDA_DEFAULT, VENDEDOR_DEFAULT, 
								CP_DEFAULT,--condicion de pago
                ZONA_VENTAS, 
								TIPO_CLIENTE, 
								LIMITE_CREDITO,
                FECHA_CREACION, 
                DCTO_VOLUMEN_FLAG, 
								BACKORDER_FLAG,
                RIESGO, 
								CANAL, --sysadm.tb_canal
								GIRO_NEGOCIO,
                LIB_ELECTORAL, 
								FLAG_RET_PED,
								FLAG_NO_RET_CRED,
                NOM_COMERCIAL, 
								FLAG_PRO_ALQ, 
                N_EXTRANJERO,
                SEXO, 
								USUAR_REGIS, 
								TIPO_PERSO
               
            )
            VALUES(
             '00', CUR.COD_CLIENTE, CASE CUR.TIPO_DOC WHEN 'RUC' THEN CUR.DOCUMENTO ELSE '' END, CUR.CELULAR, CUR.TELEFONO, CUR.NOMBRE_CLIENTE,
             CUR.DIRECCION, CUR.UBIGEO,
             'A', 'S/.', '998', 
						 '21', --contado
             '000000', 
						 --'01', --BODEGA
						 CUR.NOMBRE_RUTA, --CUANDO EL TIPO DE CLIENTE SEAN DIFERENTES DE BODEGA, O ESTEN MEZCLADOS
						 100,
             SYSDATE,
             '0', 
						 '0',
             '04', --Normal
						 CUR.CANAL, 
						 --'01', --ABARROTES
						 CUR.EXISTE,    ---CUANDO EL GIRO DEL NEGOCIO SEA IFERENTE DE ABARROTES  
             CASE CUR.TIPO_DOC WHEN 'DNI' THEN CUR.DOCUMENTO ELSE '' END, '1', '0',
             CUR.NOMBRE_COMERCIAL, 
						 '0', --propio
            '0', --0:Nacional
             'F', 
						 'PAZVILNO', 
						 CASE CUR.TIPO_DOC WHEN 'RUC' THEN 'J' ELSE 'N' END
            );

            INSERT INTO SYSADM.CLIENTE_LISTAS(COD_CIA, COD_CLIENTE, COMPANIA_VENTA, TIPO_LISTA, COD_LISTA, USUARIO)
            VALUES ('00', CUR.COD_CLIENTE, CUR.EMPRESA, '01', CUR.COD_LISTA, 'PAZVILNO');

            /*INSERT INTO SYSADM.CLIENTE_LISTAS( COD_CIA, COD_CLIENTE, COMPANIA_VENTA, TIPO_LISTA, USUARIO )
            VALUES('00', CUR.COD_CLIENTE, CUR.EMPRESA, '02', 'PAZVILNO' ) ;*/

						--
            INSERT INTO SYSADM.CXC_CLIENTE_STD(
             COD_CIA, COD_CLIENTE, CIA_VENTA, LIMITE_CREDITO,
             CREDITO_DISPONIBLE, CREDITO_UTILIZADO, QTY_CHECK_DEVUEL,
             NRO_DOC_PENDIENTES, CANT_VENCIDOS, CANT_LETRA_PROTEST,
             QTY_CHQDEV_ACUM, CANT_LETPROT_ACUM, DIASDEMORA_CANCEL,
             MONTO_LAST_COMP, MONTO_ACUMULADO
            )
            VALUES(
             '00', CUR.COD_CLIENTE, CUR.EMPRESA, 100,
             100, 0, 0,
             0, 0, 0,
             0, 0, 0,
             0, 0
            );
            
            INSERT INTO SYSADM.CLIENTE_VENDEDOR(COD_CIA, COD_CLIENTE, CIA_VENTA, COD_VENDEDOR)
            VALUES('00', CUR.COD_CLIENTE, CUR.EMPRESA, '998')
            ;
            
            INSERT INTO SYSADM.LOCALES_CLIENTE(
             COD_CIA, COD_CLIENTE, COD_LOCAL, DESC_LOCAL, DIRECCION, UBIGEO,
             RUTA_DESPACHO, REF_DESPACHO, OBSERVACIONES, COD_USUARIO,
             B_EXONERA_IGV, ESTAD, FECGEOLOCALIZACION, USUAR_GEOLO,
             COD_LISTA, DIVISION, NEW_COORDENADAS
            )
            VALUES('00', CUR.COD_CLIENTE, '1', CUR.NOMBRE_CLIENTE, CUR.DIRECCION, CUR.UBIGEO,
              CUR.RUTA, CUR.COORDENADAS, NULL, 'PAZVILNO',
              (SELECT NVL(FLAG3, '0') FROM SYSADM.TABLAS 
                 WHERE CATEGORIA = '035' AND LLAVE = CUR.UBIGEO), 'A', SYSDATE, 'PAZVILNO',
              CUR.COD_LISTA,'AB', CUR.COORDENADAS
            );       
            
            SELECT CODALMACEN INTO vALMACEN 
						FROM SYSADM.TB_ALMACEN 
						WHERE CODEMPRESA = CUR.EMPRESA AND CODIG_SEDE=CUR.SEDE AND ROWNUM < 2; 
						
            INSERT INTO SYSADM.CLIENTE_ALMACEN(COD_CIA,COD_CLIENTE,CIA_VENTA,COD_ALMACEN) 
            VALUES('00',CUR.COD_CLIENTE,CUR.EMPRESA,vALMACEN);        
            
            vNUEVOS := vNUEVOS +1;
        ELSIF vEXISTE>0 THEN
        --ELSE
            SELECT COUNT(*) INTO vCEMPRESA 
						FROM SYSADM.CXC_CLIENTE_STD 
						WHERE CIA_VENTA=CUR.EMPRESA and COD_CLIENTE= cur.COD_CLIENTE;
            IF vCEMPRESA=0 THEN
                INSERT INTO SYSADM.CXC_CLIENTE_STD(
                 COD_CIA, COD_CLIENTE, CIA_VENTA, LIMITE_CREDITO,
                 CREDITO_DISPONIBLE, CREDITO_UTILIZADO, QTY_CHECK_DEVUEL,
                 NRO_DOC_PENDIENTES, CANT_VENCIDOS, CANT_LETRA_PROTEST,
                 QTY_CHQDEV_ACUM, CANT_LETPROT_ACUM, DIASDEMORA_CANCEL,
                 MONTO_LAST_COMP, MONTO_ACUMULADO
                )
                VALUES(
                 '00', CUR.COD_CLIENTE, CUR.EMPRESA, 100,
                 100, 0, 0,
                 0, 0, 0,
                 0, 0, 0,
                 0, 0
                );
            END IF;
            
            SELECT COUNT(*) INTO vCALMACEN FROM SYSADM.CLIENTE_ALMACEN
            WHERE COD_CIA = '00' AND COD_CLIENTE = CUR.COD_CLIENTE AND CIA_VENTA = CUR.EMPRESA;  
            IF vCALMACEN=0 THEN
                SELECT CODALMACEN INTO vALMACEN FROM SYSADM.TB_ALMACEN WHERE CODEMPRESA = CUR.EMPRESA AND CODIG_SEDE=CUR.SEDE AND ROWNUM < 2;  
                INSERT INTO SYSADM.CLIENTE_ALMACEN(COD_CIA,COD_CLIENTE,CIA_VENTA,COD_ALMACEN) 
                VALUES('00',CUR.COD_CLIENTE,CUR.EMPRESA,vALMACEN);
            END IF;
            
            SELECT MAX(COD_LOCAL)+1 INTO vMAX FROM SYSADM.LOCALES_CLIENTE WHERE COD_CLIENTE=CUR.COD_CLIENTE;
            INSERT INTO SYSADM.LOCALES_CLIENTE(
             COD_CIA, COD_CLIENTE, COD_LOCAL, DESC_LOCAL, DIRECCION, UBIGEO,
             RUTA_DESPACHO, REF_DESPACHO, OBSERVACIONES, COD_USUARIO,
             B_EXONERA_IGV, ESTAD, FECGEOLOCALIZACION, USUAR_GEOLO,
             COD_LISTA, DIVISION, NEW_COORDENADAS
            )
            VALUES('00', CUR.COD_CLIENTE, vMAX, CUR.NOMBRE_CLIENTE, CUR.DIRECCION, CUR.UBIGEO,
              CUR.RUTA, CUR.COORDENADAS, NULL, 'PAZVILNO',
              (SELECT NVL(FLAG3, '0') FROM SYSADM.TABLAS 
                 WHERE CATEGORIA = '035' AND LLAVE = CUR.UBIGEO), 'A', SYSDATE, 'PAZVILNO',
              CUR.COD_LISTA,'AB', CUR.COORDENADAS
            ); 
            vEDITAR := vEDITAR + 1;
        END IF;
        vCANT := vCANT +1;
				--v_rowsaffected:= v_rowsaffected+1;
    END LOOP;
		
		---DBMS_OUTPUT.PUT_LINE('rows affected: ' || v_rowsaffected  );
    DBMS_OUTPUT.PUT_LINE('TOTAL CLIENTES: '||vCANT);
    DBMS_OUTPUT.PUT_LINE('CLIENTES NUEVOS: '||vNUEVOS);
    DBMS_OUTPUT.PUT_LINE('CLIENTES EDITADOS: '||vEDITAR);
exception 		
when others then
	--rollback;
	DBMS_OUTPUT.PUT_LINE('error:'||sqlerrm || ' - '||dbms_utility.format_error_backtrace);
END
;
--commit;
--rollback;