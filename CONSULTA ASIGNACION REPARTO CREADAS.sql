SELECT DISTINCT
			PR.EMPRESA,
			PR.SEDE,
			PR.IDPROGRAMACION,
			PR.VEHICULO,
			PR.RUTA,
			PR.FECHAPROGRAMACION,
			PR.ESTADO,
			PR.CODFUERZAV,
			PR.USUARIOREGISTRO,
			PR.FECHAREGISTRO

FROM 
SYSADM.PROGRAMACION_REPARTO PR 
INNER JOIN 
		(SELECT DISTINCT
									RD.CODEMPRESA,
									RD.CODSEDE,
									VR.PLACA,
									RD.CODRUTADESPACHO,
									NCPR.FECHA 

						FROM NPAZ.CARGAR_PROGRA_REPARTO NCPR
						JOIN SYSADM.RUTA_DESPACHO RD ON NCPR.RUTA = RD.CODRUTADESPACHO
						JOIN SYSADM.VEHICULO_REPARTO VR ON NCPR.VEHICULO = VR.PLACA) CR
						
						ON CR.CODRUTADESPACHO=PR.RUTA
						AND CR.CODEMPRESA = PR.EMPRESA
						AND CR.CODSEDE = PR.SEDE
						AND CR.PLACA = PR.VEHICULO
						
--NPAZ.CARGAR_PROGRA_REPARTO NCPR ON PR.VEHICULO = NCPR.VEHICULO

WHERE 
			PR.USUARIOREGISTRO = 'PAZVILNO'
		AND TO_DATE(PR.FECHAREGISTRO, 'dd-mm-yy')=TO_DATE('21-08-2021', 'dd-mm-yy');