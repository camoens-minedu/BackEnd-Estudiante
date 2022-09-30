/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	26/01/2022
LLAMADO POR			:
DESCRIPCION			:	Elimina modulo equivalencia
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
	
TEST:  
	
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_DEL_MODULOS_EQUIVALENTES]
(
	@ID_PLAN_ESTUDIO INT,
	@ID_MODULO INT, 
    @USUARIO VARCHAR(8)

)
AS
BEGIN
	DECLARE @MSG_TRANS VARCHAR(MAX)

	BEGIN TRY

	BEGIN TRAN TransactSQL

	DECLARE @RESULT INT = 0
		
	--SET @ID_MODULO = (SELECT ID_MODULO FROM transaccional.unidad_didactica_modulo_equivalencia WHERE ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA = @ID_UNIDAD_DIDACTICA)

	IF EXISTS (SELECT TOP 1 mequi.ID_MODULO_EQUIVALENCIA FROM transaccional.modulo_equivalencia mequi INNER JOIN transaccional.modulo_unidad_competencia muc
	           ON mequi.ID_MODULO_EQUIVALENCIA = muc.ID_MODULO_EQUIVALENCIA WHERE mequi.ID_MODULO_EQUIVALENCIA = @ID_MODULO AND mequi.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO AND 
			   mequi.ES_ACTIVO = 1 AND muc. ES_ACTIVO = 1)
	BEGIN
		SET @RESULT = -396
	END
	ELSE IF EXISTS (SELECT TOP 1 mequi.ID_MODULO_EQUIVALENCIA FROM transaccional.modulo_equivalencia mequi INNER JOIN transaccional.unidad_didactica_modulo_equivalencia muc
				   ON mequi.ID_MODULO_EQUIVALENCIA = muc.ID_MODULO_EQUIVALENCIA WHERE mequi.ID_MODULO_EQUIVALENCIA = @ID_MODULO AND mequi.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO AND 
				   mequi.ES_ACTIVO = 1 AND muc. ES_ACTIVO = 1)
	BEGIN
		SET @RESULT = -396
	END
	ELSE BEGIN
		UPDATE transaccional.modulo_equivalencia SET
			ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE ID_MODULO_EQUIVALENCIA = @ID_MODULO
		
		SET @RESULT = 1
	END

	COMMIT TRAN TransactSQL
	SELECT @RESULT AS valor

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN TransactSQL
		DECLARE @ERROR_MESSAGE VARCHAR(MAX) = ''
		SET @ERROR_MESSAGE = ERROR_MESSAGE() + ' -- '
		SELECT 'Error: ' + @ERROR_MESSAGE
		SELECT 0 AS valor
	END CATCH
END