CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_PROGRAMAS_ESTUDIO_DET_EDITAR_LISTA]
(	
	@ID_INSTITUCION INT, 
	@ID_TIPO_RESOLUCION INT, 
	@ID_RESOLUCION	INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT
)
AS
DECLARE @ID_TIPO_META_ANUAL INT =21, 
@ID_TIPO_META_AMPL INT =22,
@ANIO INT

SET @ANIO = (SELECT PL.ANIO FROM transaccional.periodos_lectivos_por_institucion PLI
					INNER JOIN maestro.periodo_lectivo PL ON PLI.ID_PERIODO_LECTIVO = PL.ID_PERIODO_LECTIVO AND PLI.ES_ACTIVO=1 
					AND PLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
IF @ID_TIPO_RESOLUCION = @ID_TIPO_META_ANUAL OR @ID_TIPO_RESOLUCION = @ID_TIPO_META_AMPL 
BEGIN 
SELECT 
	--CI.ID_CARRERAS_POR_INSTITUCION	Value
	CONVERT (VARCHAR(15),CI.ID_CARRERAS_POR_INSTITUCION) Code, 
	UPPER(C.NOMBRE_CARRERA) + ' - ' + E.VALOR_ENUMERADO Text,
	(SELECT TOP 1 ID_CARRERAS_POR_INSTITUCION_DETALLE
		 FROM transaccional.carreras_por_institucion_detalle CID WHERE CID.ID_CARRERAS_POR_INSTITUCION= CI.ID_CARRERAS_POR_INSTITUCION AND CID.ES_ACTIVO=1
	 ) 	Value
	   FROM db_auxiliar.dbo.UVW_CARRERA C
	INNER JOIN transaccional.carreras_por_institucion CI ON C.ID_CARRERA= CI.ID_CARRERA
	INNER JOIN sistema.enumerado E ON E.ID_ENUMERADO= CI.ID_TIPO_ITINERARIO 
	AND CI.ES_ACTIVO=1 AND CI.ID_INSTITUCION=@ID_INSTITUCION
	LEFT JOIN (
		SELECT			
			RXCI.ID_CARRERAS_POR_INSTITUCION,
			RXCI.ID_RESOLUCION
		FROM transaccional.resoluciones_por_carreras_por_institucion RXCI
		INNER JOIN maestro.resolucion R ON R.ID_RESOLUCION= RXCI.ID_RESOLUCION AND RXCI.ES_ACTIVO =1
		AND R.ID_TIPO_RESOLUCION=@ID_TIPO_RESOLUCION AND R.ES_ACTIVO=1
		INNER JOIN transaccional.resoluciones_por_periodo_lectivo_institucion RXPLI ON RXPLI.ID_RESOLUCION = RXCI.ID_RESOLUCION
		INNER JOIN transaccional.periodos_lectivos_por_institucion PLI ON PLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= RXPLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND  RXPLI.ES_ACTIVO=1 AND PLI.ES_ACTIVO=1
		INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO = PLI.ID_PERIODO_LECTIVO 
		--AND RXPLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		AND PL.ANIO= @ANIO
	)	SUB_CONSULTA_RESOLUCIONES ON SUB_CONSULTA_RESOLUCIONES.ID_CARRERAS_POR_INSTITUCION= CI.ID_CARRERAS_POR_INSTITUCION
WHERE SUB_CONSULTA_RESOLUCIONES.ID_RESOLUCION IS NULL OR SUB_CONSULTA_RESOLUCIONES.ID_RESOLUCION = @ID_RESOLUCION
ORDER BY C.NOMBRE_CARRERA, E.VALOR_ENUMERADO ASC 
END
ELSE
BEGIN
SELECT 
	--CI.ID_CARRERAS_POR_INSTITUCION	Value
	CONVERT (VARCHAR(15),CI.ID_CARRERAS_POR_INSTITUCION) Code, 
	UPPER(C.NOMBRE_CARRERA) + ' - ' + E.VALOR_ENUMERADO  + ' - '+ SI.NOMBRE_SEDE Text,
	CID.ID_CARRERAS_POR_INSTITUCION_DETALLE Value
	   FROM db_auxiliar.dbo.UVW_CARRERA C
	INNER JOIN transaccional.carreras_por_institucion CI ON C.ID_CARRERA= CI.ID_CARRERA
	INNER JOIN transaccional.carreras_por_institucion_detalle CID ON CID.ID_CARRERAS_POR_INSTITUCION = CI.ID_CARRERAS_POR_INSTITUCION AND CID.ES_ACTIVO=1
	INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION= CID.ID_SEDE_INSTITUCION AND SI.ES_ACTIVO=1
	INNER JOIN sistema.enumerado E ON E.ID_ENUMERADO= CI.ID_TIPO_ITINERARIO 
	AND CI.ES_ACTIVO=1 AND CI.ID_INSTITUCION=@ID_INSTITUCION
	LEFT JOIN (
		SELECT			
			RXCI.ID_CARRERAS_POR_INSTITUCION,
			RXCI.ID_RESOLUCION
		FROM transaccional.resoluciones_por_carreras_por_institucion RXCI
		INNER JOIN maestro.resolucion R ON R.ID_RESOLUCION= RXCI.ID_RESOLUCION AND RXCI.ES_ACTIVO =1
		AND R.ID_TIPO_RESOLUCION=@ID_TIPO_RESOLUCION AND R.ES_ACTIVO=1
		INNER JOIN transaccional.resoluciones_por_periodo_lectivo_institucion RXPLI ON RXPLI.ID_RESOLUCION = RXCI.ID_RESOLUCION
		AND RXPLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		AND RXPLI.ES_ACTIVO=1
	)	SUB_CONSULTA_RESOLUCIONES ON SUB_CONSULTA_RESOLUCIONES.ID_CARRERAS_POR_INSTITUCION= CI.ID_CARRERAS_POR_INSTITUCION
WHERE SUB_CONSULTA_RESOLUCIONES.ID_RESOLUCION IS NULL OR SUB_CONSULTA_RESOLUCIONES.ID_RESOLUCION = @ID_RESOLUCION
ORDER BY C.NOMBRE_CARRERA, E.VALOR_ENUMERADO ASC 

END
GO


