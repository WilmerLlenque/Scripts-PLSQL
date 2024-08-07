---------------- CONSULTAS JERARQUIAS DE ARTICULOS -----------------------------

--CONSULTAR LOS ARTICULOS A JERARUIZAR

SELECT 
			JA.COD_ITEM,
			AR.DESC_ITEM,
			AR.ID_CLASE,
			AR.ID_SUBTI,
			AR.ID_VARIE,
			AR.ID_PRESE,
			AR.ID_CATEGORIA,
			AR.ID_FAMILIA,
			AR.ID_MARCA,
			AR.ID_TIPO,
			AR.COD_ITEM_ORIGEN,
			AR.VIDA_UTIL

FROM NPAZ.JERARQUIZAR_ARTICULOS JA
INNER JOIN SYSADM.ARTICULOS AR
ON JA.COD_ITEM = AR.COD_ITEM;

---------------------------------------------------------------------
--CONSULTAR ARTICULOS YA JERAQUIZADOS RECIEN CARGADOS

SELECT 
			JA.COD_ITEM,
			AR.DESC_ITEM,
			--ID_FAMILIA, 
			FA.DESCR AS FAMILIA,
			--ID_CLASE,
			CA.DESCR AS CLASE,
			--ID_MARCA, 
			MA.DESCR AS MARCA,
			--ID_VARIE,
			VA.DESCR AS VARIEDAD,
			--ID_TIPO,
			TA.DESCR AS TIPO,
			--ID_SUBTI, 
			SA.DESCR AS SUBTIPO,
			--ID_CATEGORIA, 
			CAT.DESCR AS CATEGORIA,
			PA.DESCR AS PRESENTACION,
			AR.COD_ITEM_ORIGEN,
			AR.VIDA_UTIL

FROM NPAZ.JERARQUIZAR_ARTICULOS JA
INNER JOIN SYSADM.ARTICULOS AR
ON JA.COD_ITEM = AR.COD_ITEM

JOIN SYSADM.SGC_PRESENTACION_ARTICULO PA ON AR.ID_PRESE=PA.ID
			JOIN SYSADM.SGC_FAMILIA_ARTICULO FA ON AR.ID_FAMILIA=FA.ID
			JOIN SYSADM.SGC_CLASE_ARTICULO CA ON AR.ID_CLASE=CA.ID
			JOIN SYSADM.SGC_MARCA_ARTICULO MA ON AR.ID_MARCA=MA.ID
			JOIN SYSADM.SGC_VARIEDAD_ARTICULO VA ON AR.ID_VARIE=VA.ID
			JOIN SYSADM.SGC_TIPO_ARTICULO TA ON AR.ID_TIPO=TA.ID
			JOIN SYSADM.SGC_SUBTIPO_ARTICULO SA ON AR.ID_SUBTI=SA.ID
			JOIN SYSADM.SGC_CATEGORIA_ARTICULO CAT ON AR.ID_CATEGORIA=CAT.ID;

-------------------------------------------------------------
--CONSULTAR TODOS LOD ARTICULOS JERARUIZADOS SEGÚN EL PROVEEDOR

SELECT 
			ART.COD_ITEM, 
			ART.DESC_ITEM ARTICULO, 
			ART.DESC_VTA_DIGITAL_COMPLETA DESCRIPCION_AMIGABLE,			
			--ID_PRESE,
			PA.DESCR AS PRESENTACION,
			--ID_FAMILIA, 
			FA.DESCR AS FAMILIA,
			--ID_CLASE,
			CA.DESCR AS CLASE,
			--ID_MARCA, 
			MA.DESCR AS MARCA,
			--ID_VARIE,
			VA.DESCR AS VARIEDAD,
			--ID_TIPO,
			TA.DESCR AS TIPO,
			--ID_SUBTI, 
			SA.DESCR AS SUBTIPO,
			--ID_CATEGORIA, 
			CAT.DESCR AS CATEGORIA,
			ART.STATUS_ITEM ESTADO,
			ART.VIDA_UTIL, 
			--ART.TIPO_COMBO, 
			ART.COD_ITEM_ORIGEN,
			--ART.FLAG_VTA_DIGITAL MI_DESPENSA, 
			ART.UM_COMPRA,
			ART.UM_VENTA, 
			ART.UM_CONTROL_STOCK
			--ART.FOTO, ID_FAMILIA_COMERCIAL, ID_CLASE_COMERCIAL
FROM SYSADM.ARTICULOS ART
			JOIN SYSADM.SGC_PRESENTACION_ARTICULO PA ON ART.ID_PRESE=PA.ID
			JOIN SYSADM.SGC_FAMILIA_ARTICULO FA ON ART.ID_FAMILIA=FA.ID
			JOIN SYSADM.SGC_CLASE_ARTICULO CA ON ART.ID_CLASE=CA.ID
			JOIN SYSADM.SGC_MARCA_ARTICULO MA ON ART.ID_MARCA=MA.ID
			JOIN SYSADM.SGC_VARIEDAD_ARTICULO VA ON ART.ID_VARIE=VA.ID
			JOIN SYSADM.SGC_TIPO_ARTICULO TA ON ART.ID_TIPO=TA.ID
			JOIN SYSADM.SGC_SUBTIPO_ARTICULO SA ON ART.ID_SUBTI=SA.ID
			JOIN SYSADM.SGC_CATEGORIA_ARTICULO CAT ON ART.ID_CATEGORIA=CAT.ID
			
WHERE 1=1

			AND	ART.STATUS_ITEM IN 'A'
			AND ART.PROVEEDOR_DEFAULT = '0150';
		
