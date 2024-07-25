
/*SELECT COMPANIA_VENTA,sede,hora,count(hora) cant_pedidos
from
(
	SELECT ph.COMPANIA_VENTA,ph.Nro_pedido,ph.MONTO_DESP_BONIF,ph.CODSEDE,ph.COD_VENDEDOR,ph.FECHA_HORAREG,TO_CHAR(ph.FECHA_HORAREG,'HH24') as hora,
	(SELECT s.descsede from TB_SEDE s where s.CODSEDE=ph.CODSEDE)  sede
	FROM SPEDIDO_HEADER ph
	where ph.FECHA_PEDIDO='20-10-2021' 
	and ph.codsede='003'
	order by 5,6
) GROUP BY COMPANIA_VENTA,sede,hora ORDER BY 2;
*/

SELECT DIVISION, COMPANIA_VENTA,sede,hora,count(hora) cant_pedidos
from
(
	SELECT ph.COMPANIA_VENTA,ph.Nro_pedido,ph.MONTO_DESP_BONIF,ph.CODSEDE,ph.COD_VENDEDOR,ph.FECHA_HORAREG,TO_CHAR(ph.FECHA_HORAREG,'HH24') as hora,
	(SELECT s.descsede from SYSADM.TB_SEDE s where s.CODSEDE=ph.CODSEDE)  sede,
	(SELECT m.cod_division from SYSADM.TB_MESA m where m.CODLOCALIDAD=ph.CODMESA) division
	FROM SYSADM.SPEDIDO_HEADER ph
	--INNER JOIN 
	where 
	--ph.FECHA_PEDIDO='20-10-2021' 
	
	--to_char(ph.FECHA_PEDIDO,'yyyy-mm-dd')=TO_char(sysdate,'yyyy-mm-dd')
	ph.FECHA_PEDIDO = TO_DATE(sysdate, 'dd-mm-yy')
	
	--and ph.codsede='003'
	order by 5,6
) GROUP BY DIVISION, COMPANIA_VENTA,sede,hora ORDER BY 1,2,3,4