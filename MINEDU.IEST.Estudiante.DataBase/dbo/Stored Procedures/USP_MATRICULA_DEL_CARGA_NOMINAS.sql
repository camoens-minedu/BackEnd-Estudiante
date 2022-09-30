/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	15/03/2021
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de carga de nomina
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:  

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_DEL_CARGA_NOMINAS]
(
	@ID_INSTITUCION				        INT, 
	@ID_CARGA_MASIVA_NOMINA				INT,
	@USUARIO					        VARCHAR(20)
)
AS
BEGIN
	DECLARE @RESULT INT = 0

	IF NOT EXISTS (SELECT ID_CARGA_MASIVA_NOMINA FROM transaccional.carga_masiva_nominas WHERE ID_INSTITUCION = @ID_INSTITUCION AND ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA AND ES_ACTIVO = 1)
	BEGIN
		SET @RESULT = -300
	END
	ELSE IF EXISTS (SELECT ID_CARGA_MASIVA_NOMINA FROM transaccional.carga_masiva_actas WHERE ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA AND ES_ACTIVO = 1)
	BEGIN
		SET @RESULT = -384
    END
	ELSE
	BEGIN
		BEGIN TRY

		BEGIN TRAN TransactSQL
			UPDATE transaccional.carga_masiva_nominas
			SET 
				[ES_ACTIVO]	= 0 
				,[FECHA_MODIFICACION] = GETDATE()   
				,[USUARIO_MODIFICACION] = @USUARIO
			WHERE 
				ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA	
			   
			UPDATE [transaccional].carga_masiva_nominas_detalle
			SET 
				[ES_ACTIVO]	= 0 
				,[FECHA_MODIFICACION] = GETDATE()   
				,[USUARIO_MODIFICACION] = @USUARIO
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