/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta el registro de un retiro de un estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_RETIRO_ESTUDIANTE]
(    
	@ID_ESTUDIANTE_INSTITUCION INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,
	@ID_MOTIVO INT,
	@USUARIO VARCHAR(20)
)
AS
DECLARE @RESULT INT
BEGIN
	BEGIN TRANSACTION T1
	BEGIN TRY
	
			INSERT INTO transaccional.retiro_estudiante
			( ID_ESTUDIANTE_INSTITUCION, ID_PERIODOS_LECTIVOS_POR_INSTITUCION, ID_MOTIVO, ES_ACTIVO, ESTADO,USUARIO_CREACION,  FECHA_CREACION)
			VALUES 
			( @ID_ESTUDIANTE_INSTITUCION, @ID_PERIODOS_LECTIVOS_POR_INSTITUCION, @ID_MOTIVO, 1, 1, @USUARIO, GETDATE() )

			UPDATE transaccional.estudiante_institucion
			SET ES_ACTIVO=0 WHERE ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION		


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


