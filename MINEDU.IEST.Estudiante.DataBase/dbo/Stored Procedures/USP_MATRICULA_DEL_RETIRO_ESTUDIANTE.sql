/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro del retiro de un estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_DEL_RETIRO_ESTUDIANTE]
(    
	@ID_RETIRO_ESTUDIANTE INT,		
	@USUARIO VARCHAR(20)
)
AS
DECLARE @RESULT INT
BEGIN
	BEGIN TRANSACTION T1
	BEGIN TRY
			DECLARE @ID_ESTUDIANTE_INSTITUCION INT

			SET @ID_ESTUDIANTE_INSTITUCION = (SELECT ID_ESTUDIANTE_INSTITUCION FROM transaccional.retiro_estudiante WHERE ID_RETIRO_ESTUDIANTE= @ID_RETIRO_ESTUDIANTE)
			UPDATE transaccional.retiro_estudiante
			SET ES_ACTIVO=0,
			USUARIO_MODIFICACION= @USUARIO,
			FECHA_MODIFICACION = GETDATE()
			WHERE ID_RETIRO_ESTUDIANTE= @ID_RETIRO_ESTUDIANTE


			UPDATE transaccional.estudiante_institucion
			SET ES_ACTIVO=1,
			USUARIO_MODIFICACION= @USUARIO,
			FECHA_MODIFICACION = GETDATE()
			WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION 

			COMMIT TRANSACTION T1
			SET @RESULT = 1
	END TRY
	BEGIN CATCH	
		IF @@ERROR = 50000
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -223
		END
		ELSE	
			IF @@ERROR<>0
			BEGIN
			   
			   ROLLBACK TRANSACTION T1	   			   
			   SET @RESULT = -1
			
			END
	END CATCH
END
SELECT @RESULT
GO


