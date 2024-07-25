--FORMATO PARA ARTICULOS SIN JERARQUIZAR
SELECT 
			AR.COD_ITEM,
			AR.DESC_ITEM,
			P.C_PROVEEDOR,
			P.X_PROVEEDOR AS PROVEEDOR,
			AR.ID_CLASE AS CLASE,
			AR.ID_SUBTI AS SUBTIPO,
			AR.ID_VARIE AS VARIEDAD,
			AR.ID_PRESE AS PRESENTACION,
			AR.ID_CATEGORIA AS CATEGORIA,
			AR.ID_FAMILIA AS FAMILIA,
			AR.ID_MARCA AS MARCA,
			AR.ID_TIPO AS TIPO,
			AR.COD_ITEM_ORIGEN,
			AR.VIDA_UTIL

FROM  SYSADM.ARTICULOS AR
INNER JOIN SYSADM.PROVEEDOR P
	     ON AR.PROVEEDOR_DEFAULT=P.C_PROVEEDOR
WHERE AR.PROVEEDOR_DEFAULT = '0138' 
AND AR.ID_FAMILIA IS NULL
--ON JA.COD_ITEM = AR.COD_ITEM;