/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de la sede del examen para el proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_INS_EXAMEN_ADMISION_SEDE]
(
	@ID_SEDE_INSTITUCION					INT,
	@FECHA_EVALUACION						DATE,
	@HORA_EVALUACION						VARCHAR(5),
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@ID_MODALIDAD							INT,
	@USUARIO								VARCHAR(20)
)AS
	DECLARE @RESULT INT,
	@ID_PROCESO_ADMISION_PERIODO INT
	SET @ID_PROCESO_ADMISION_PERIODO = (SELECT ID_PROCESO_ADMISION_PERIODO FROM transaccional.proceso_admision_periodo 
									WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND ES_ACTIVO=1)
	
	IF @ID_PROCESO_ADMISION_PERIODO IS NULL
		SET @RESULT = -204	
	ELSE IF EXISTS (SELECT TOP 1 ID_EXAMEN_ADMISION_SEDE FROM transaccional.examen_admision_sede
				WHERE ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION  AND ID_MODALIDAD = @ID_MODALIDAD AND ID_PROCESO_ADMISION_PERIODO= @ID_PROCESO_ADMISION_PERIODO
				AND ES_ACTIVO =1)
		SET @RESULT= -180
	ELSE
	BEGIN
		INSERT INTO transaccional.examen_admision_sede
		(	ID_SEDE_INSTITUCION,
			ID_PROCESO_ADMISION_PERIODO,
			ID_MODALIDAD,
			FECHA_EVALUACION,
			HORA_EVALUACION,
			ES_ACTIVO,
			ESTADO,
			USUARIO_CREACION,
			FECHA_CREACION
		)
		VALUES(	@ID_SEDE_INSTITUCION,
				@ID_PROCESO_ADMISION_PERIODO,
				@ID_MODALIDAD,
				@FECHA_EVALUACION,
				@HORA_EVALUACION,
				1,
				1,
				@USUARIO,
				GETDATE()
				)

		SET @RESULT =1
	END
	SELECT @RESULT
GO


