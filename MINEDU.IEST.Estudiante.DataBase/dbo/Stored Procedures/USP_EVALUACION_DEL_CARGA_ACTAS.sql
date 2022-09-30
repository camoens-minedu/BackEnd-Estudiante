/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	15/03/2021
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de carga masiva de actas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:  

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_DEL_CARGA_ACTAS]
(
	@ID_INSTITUCION INT, 
	@ID_CARGA_MASIVA_ACTA INT,
	@USUARIO VARCHAR(20)
)
AS
BEGIN
	DECLARE @RESULT INT = 0
	DECLARE @ID_CARGA_MASIVA_NOMINA INT = (SELECT ID_CARGA_MASIVA_NOMINA FROM transaccional.carga_masiva_actas WHERE ID_CARGA_MASIVA_ACTA = @ID_CARGA_MASIVA_ACTA)

	IF NOT EXISTS (SELECT ID_CARGA_MASIVA_NOMINA FROM transaccional.carga_masiva_nominas WHERE ID_INSTITUCION = @ID_INSTITUCION AND ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA AND ES_ACTIVO = 1)
	BEGIN
		SET @RESULT = -300
	END
	ELSE IF NOT EXISTS (SELECT ID_CARGA_MASIVA_NOMINA FROM transaccional.carga_masiva_actas WHERE ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA AND ID_CARGA_MASIVA_ACTA = @ID_CARGA_MASIVA_ACTA AND ES_ACTIVO = 1)
	BEGIN
		SET @RESULT = -300
    END
	ELSE
	BEGIN
		BEGIN TRY

		BEGIN TRAN TransactSQL
			UPDATE transaccional.carga_masiva_actas
				SET ES_ACTIVO = 0 
					,FECHA_MODIFICACION = GETDATE()   
					,USUARIO_MODIFICACION = @USUARIO
				WHERE 
					ID_CARGA_MASIVA_ACTA	= @ID_CARGA_MASIVA_ACTA
			   
			UPDATE transaccional.carga_masiva_nominas_detalle
				SET NOTA = NULL 
					,FECHA_MODIFICACION = GETDATE()   
					,USUARIO_MODIFICACION = @USUARIO
				WHERE 
					ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA
		
			SET @RESULT = 1

			COMMIT TRAN TransactSQL

		END TRY

		BEGIN CATCH
			ROLLBACK TRAN TransactSQL
			SET @RESULT = 0
		END CATCH
	 END

	 SELECT @RESULT
END