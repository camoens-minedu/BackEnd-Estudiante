/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	16/02/2022
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro de una nota de evaluacion extraordinaria.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_DEL_EVALUACION_EXTRAORDINARIA_DET]
(
	@ID_INSTITUCION							INT,
	@ID_EVALUACION_EXTRAORDINARIA	        INT,       
	@ID_EVALUACION_EXTRAORDINARIA_DETALLE	INT, 
	@ID_UNIDAD_DIDACTICA                    INT,
    @USUARIO						        nvarchar(20)
)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_PERIODOS_LECTIVOS_INSTITUCION INT, @ID_INSTITUCION_CONSULTA INT

	SET @ID_PERIODOS_LECTIVOS_INSTITUCION = (SELECT ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM transaccional.evaluacion_extraordinaria WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO = 1)
	SET @ID_INSTITUCION_CONSULTA = (SELECT ID_INSTITUCION FROM transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_INSTITUCION AND ES_ACTIVO=1)

	--IF EXISTS (SELECT TOP 1 ID_EVALUACION_EXTRAORDINARIA_DETALLE FROM transaccional.evaluacion_extraordinaria_detalle WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO = 1)
	--	SET @RESULT = -162
	IF EXISTS(SELECT TOP 1 pc.ID_PROGRAMACION_CLASE
			FROM transaccional.periodo_academico pa
			INNER JOIN transaccional.programacion_clase pc ON pc.ID_PERIODO_ACADEMICO = pa.ID_PERIODO_ACADEMICO AND pc.ES_ACTIVO = 1
			WHERE pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_INSTITUCION AND pa.ES_ACTIVO = 1 AND pc.ESTADO = 0)
	BEGIN
		SET @RESULT = -329 -- PERIODO SE ENCUENTRA CERRADO
    END
	ELSE IF (@ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA)
	BEGIN
		SET @RESULT = -362
	END
	ELSE
	BEGIN
		UPDATE transaccional.evaluacion_extraordinaria_detalle
		SET 
			[ES_ACTIVO]	= 0 
			,[FECHA_MODIFICACION]	  = GETDATE()   
			,[USUARIO_MODIFICACION]	  = @USUARIO
		WHERE 
			[ID_EVALUACION_EXTRAORDINARIA] = @ID_EVALUACION_EXTRAORDINARIA AND
			[ID_EVALUACION_EXTRAORDINARIA_DETALLE] = @ID_EVALUACION_EXTRAORDINARIA_DETALLE AND
			[ID_UNIDAD_DIDACTICA] = @ID_UNIDAD_DIDACTICA
			   
		SET @RESULT = 1
	END

	SELECT @RESULT
END