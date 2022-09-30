/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro del detalle de la meta de una carrera de la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_INS_META_CARRERA_INSTITUCION_DETALLE]
(
	@ID_META_CARRERA_INSTITUCION	INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT,
	@ID_SEDE_INSTITUCION			INT,
	@META_PERIODO					INT,	
	@USUARIO						VARCHAR(20)
)
AS
BEGIN
	DECLARE @ID_PERIODO_LECTIVO INT, @ID_CARRERA_INSTITUCION INT, @ID_INSTITUCION INT,@ANIO INT
	
	SET @ID_PERIODO_LECTIVO = (SELECT ISNULL((SELECT ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion 
								WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION),0))
	SET @ANIO = (SELECT ANIO FROM maestro.periodo_lectivo WHERE ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO)
	SET @ID_INSTITUCION = (SELECT ID_INSTITUCION FROM maestro.sede_institucion WHERE ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION)	
	
	IF EXISTS(SELECT TOP 1 ID_META_CARRERA_INSTITUCION_DETALLE FROM transaccional.meta_carrera_institucion_detalle 
				WHERE ID_META_CARRERA_INSTITUCION = @ID_META_CARRERA_INSTITUCION AND ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION 
				AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO = 1)
		SELECT -180
	ELSE
	BEGIN
		INSERT INTO transaccional.meta_carrera_institucion_detalle(
			
			ID_META_CARRERA_INSTITUCION,
			ID_SEDE_INSTITUCION,
			ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
			META_SEDE,
			ES_ACTIVO,
			ESTADO,			
			USUARIO_CREACION,
			FECHA_CREACION
		)
		VALUES(
			
			@ID_META_CARRERA_INSTITUCION,
			@ID_SEDE_INSTITUCION,
			@ID_PERIODO_LECTIVO_INSTITUCION,			
			@META_PERIODO,
			1,
			1,
			@USUARIO,
			GETDATE()
		)
	
		SELECT 1
	END
END
GO


