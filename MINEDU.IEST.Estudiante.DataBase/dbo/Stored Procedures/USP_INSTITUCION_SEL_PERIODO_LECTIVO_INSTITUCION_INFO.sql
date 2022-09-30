--/*************************************************************************************************************************************************
--AUTOR				:	Mayra Alva
--FECHA DE CREACION	:	22/01/2020
--LLAMADO POR			:
--DESCRIPCION			:	Consultar información de periodo lectivo institución.
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--*/
--  TEST:		USP_INSTITUCION_SEL_PERIODO_LECTIVO_INSTITUCION_INFO 10319
--**************************************************************************************************************************************************/
CREATE  PROCEDURE [dbo].[USP_INSTITUCION_SEL_PERIODO_LECTIVO_INSTITUCION_INFO](		
	@ID_PERIODO_LECTIVO_INSTITUCION INT
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE
	@ANIO INT, 
	@ID_PERIODO_LECTIVO_INSTITUCION_UNO INT,	
	@ES_PERIODO_LECTIVO_INSTITUCION_UNO BIT =0,
	@ESTADO_APERTURADO INT =7,
	@ES_PERIODO_INICIAL BIT = 0, 
	@ID_INSTITUCION INT 

	SELECT @ANIO = mpl.ANIO, @ID_INSTITUCION= tplxi.ID_INSTITUCION  FROM transaccional.periodos_lectivos_por_institucion tplxi
				INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
				WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
				AND tplxi.ES_ACTIVO=1
		
	SET @ID_PERIODO_LECTIVO_INSTITUCION_UNO = (	SELECT top 1 
												tplxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
												FROM transaccional.periodos_lectivos_por_institucion tplxi 
												INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
												WHERE ID_INSTITUCION=@ID_INSTITUCION 
												AND ES_ACTIVO=1 AND mpl.ANIO=@ANIO
												AND tplxi.ESTADO =@ESTADO_APERTURADO
												ORDER BY 1 ASC )
	IF 		@ID_PERIODO_LECTIVO_INSTITUCION_UNO	= @ID_PERIODO_LECTIVO_INSTITUCION		
			SET @ES_PERIODO_INICIAL = 1
	ELSE	
			SET @ES_PERIODO_INICIAL = 0

	SELECT 
		pli.NOMBRE_PERIODO_LECTIVO_INSTITUCION		NombrePeriodoLectivoInstitucion, 
		pli.FECHA_INICIO_INSTITUCION				FechaInicioInstitucion, 
		pli.FECHA_FIN_INSTITUCION					FechaFinInstitucion, 
		@ES_PERIODO_INICIAL							EsPeriodoInicial 
	FROM transaccional.periodos_lectivos_por_institucion pli WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION

END