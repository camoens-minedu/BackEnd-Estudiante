 /**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/11/2019
LLAMADO POR			:
DESCRIPCION			:	Retorna las resoluciones no válidas, es decir, las que encuentran creadas en un 
						periodo lectivo diferente al que corresponde por tipo de resolución. Las resoluciones 
						de tipo meta anual deben ser creadas en el primer semestre del año, en cambio, las 
						de tipo ampliación de meta deben ser creadas en el segundo semestre del año. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:			
/*
	USP_ADMISION_SEL_RESOLUCIONES_NO_VALIDAS 1033, 5560
*/
**********************************************************************************************************/
	CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_RESOLUCIONES_NO_VALIDAS]
	(  
		@ID_INSTITUCION INT	, 
		@ID_PERIODO_LECTIVO_INSTITUCION INT 
	)  
	AS  
	BEGIN  
		SET NOCOUNT ON;  
		DECLARE @ANIO INT , @ID_PERIODO_LECTIVO_INSTITUCION_UNO INT, @ID_TIPO_RESOLUCION INT 
		SET @ANIO = (SELECT mpl.ANIO FROM transaccional.periodos_lectivos_por_institucion tplxi
					INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
					WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
					AND tplxi.ES_ACTIVO=1)

		SET @ID_PERIODO_LECTIVO_INSTITUCION_UNO = (	SELECT top 1 
														tplxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
														FROM transaccional.periodos_lectivos_por_institucion tplxi 
														INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
														WHERE ID_INSTITUCION=@ID_INSTITUCION
														AND ES_ACTIVO=1 AND mpl.ANIO=@ANIO
														AND tplxi.ESTADO =7 --PERIODO LECTIVO INSTITUCIÓN APERTURADO
														ORDER BY 1 ASC )
												
			IF @ID_PERIODO_LECTIVO_INSTITUCION_UNO =  @ID_PERIODO_LECTIVO_INSTITUCION
				SET @ID_TIPO_RESOLUCION = 21 --Para el primer periodo corresponden resoluciones de meta anual
			ELSE 
				SET @ID_TIPO_RESOLUCION = 22 --Para el segundo periodo corresponden resoluciones de meta de ampliación

			SELECT TRXPLI.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION IdResolucionInstitucion, 
		    MPL.CODIGO_PERIODO_LECTIVO CodigoPeriodoLectivo
			FROM transaccional.resoluciones_por_periodo_lectivo_institucion TRXPLI 
			INNER JOIN transaccional.periodos_lectivos_por_institucion TPLXI ON TPLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= TRXPLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
						AND TPLXI.ES_ACTIVO=1 AND TRXPLI.ES_ACTIVO=1	
			INNER JOIN maestro.resolucion MR ON MR.ID_RESOLUCION = TRXPLI.ID_RESOLUCION AND MR.ESTADO=1 AND MR.ES_ACTIVO=1
			INNER JOIN maestro.periodo_lectivo MPL ON MPL.ID_PERIODO_LECTIVO = TPLXI.ID_PERIODO_LECTIVO AND MPL.ESTADO=1
			WHERE ANIO = @ANIO and TPLXI.ID_INSTITUCION=@ID_INSTITUCION 
				  AND MR.ID_TIPO_RESOLUCION=@ID_TIPO_RESOLUCION 
				  AND TPLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION<> @ID_PERIODO_LECTIVO_INSTITUCION--9307--5560	
	END
GO


