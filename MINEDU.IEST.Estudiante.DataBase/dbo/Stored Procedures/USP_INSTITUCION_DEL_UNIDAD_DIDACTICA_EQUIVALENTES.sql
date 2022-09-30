/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	10/01/2022
LLAMADO POR			:
DESCRIPCION			:	Elimina una unidad didáctica asociada a un módulo equivalente
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
	
TEST:  
	USP_INSTITUCION_DEL_UNIDAD_DIDACTICA 3648,106088,'70557821' 
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_DEL_UNIDAD_DIDACTICA_EQUIVALENTES]
(
	@ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA INT, 
    @USUARIO VARCHAR(8)
)
AS
BEGIN
	DECLARE @MSG_TRANS VARCHAR(MAX)

	BEGIN TRY

		BEGIN TRAN TransactSQL

		DECLARE @RESULT INT

		UPDATE transaccional.unidad_didactica_modulo_equivalencia SET
			ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA = @ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA

		COMMIT TRAN TransactSQL
		SELECT 1 AS valor

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN TransactSQL
		DECLARE @ERROR_MESSAGE VARCHAR(MAX) = ''
		SET @ERROR_MESSAGE = ERROR_MESSAGE() + ' -- '
		SELECT 'Error: ' + @ERROR_MESSAGE
		SELECT 0 AS valor
	END CATCH
END