/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	09/09/2018
LLAMADO POR			:
DESCRIPCION			:	Obtener información de los permisos del usuario
REVISIONES			:

-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			09/09/2018		JTOVAR			Creación
1.1			22/01/2021		JCHAVEZ			Filtrar solo activos en parametro @ID_PERIODO_LECTIVO_ACTUAL
1.2			17/05/2022		JCHAVEZ			Buscar solo periodos lectivos aperturados (7) activos

TEST:			
	[dbo].[USP_MAESTROS_SEL_PERMISO_PERSONAL_INSTITUCION] 10,10,10,10
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERMISO_PERSONAL_INSTITUCION]
(
	@ID_INSTITUCION						INT,
	@ID_ROL								INT,
	@ID_TIPO_DOCUMENTO					INT,
	@NUMERO_DOCUMENTO					VARCHAR(15)	
)
AS
BEGIN
	DECLARE @fechaActual date, 
	@ID_PERIODO_LECTIVO_ACTUAL INT
	SET @fechaActual = GETDATE()

	SET @ID_PERIODO_LECTIVO_ACTUAL = (	SELECT TOP 1 ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
										FROM transaccional.periodos_lectivos_por_institucion 
										WHERE @fechaActual BETWEEN FECHA_INICIO_INSTITUCION AND FECHA_FIN_INSTITUCION
										--AND ID_INSTITUCION=@ID_INSTITUCION AND ESTADO in (6,7) AND ES_ACTIVO = 1
										AND ID_INSTITUCION=@ID_INSTITUCION AND ESTADO in (7) AND ES_ACTIVO = 1
										ORDER BY ID_PERIODOS_LECTIVOS_POR_INSTITUCION) --estado creado, aperturado


	 SELECT 
			PINS.ID_PERSONAL_INSTITUCION				IdPersonalInstitucion,
			PINS.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	IdPeriodoLectivoInstitucion,
			PINS.ID_ROL									IdRol
	 FROM	maestro.personal_institucion PINS
			INNER JOIN maestro.persona_institucion PEI ON PINS.ID_PERSONA_INSTITUCION= PEI.ID_PERSONA_INSTITUCION AND PINS.ES_ACTIVO=1
			INNER JOIN maestro.persona PE ON PE.ID_PERSONA= PEI.ID_PERSONA 
	 WHERE	PINS.ID_ROL =@ID_ROL 
			AND PE.ID_TIPO_DOCUMENTO= @ID_TIPO_DOCUMENTO AND PE.NUMERO_DOCUMENTO_PERSONA=@NUMERO_DOCUMENTO
			AND PINS.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_ACTUAL 
			AND PINS.ESTADO=1
END
GO



GO



GO


