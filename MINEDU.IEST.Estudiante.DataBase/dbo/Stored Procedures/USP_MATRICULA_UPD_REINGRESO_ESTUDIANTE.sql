/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de matricula por reingreso de un estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_REINGRESO_ESTUDIANTE]
(	
	@ID_REINGRESO_ESTUDIANTE INT,
	@USUARIO VARCHAR(20)
)
AS
BEGIN
DECLARE @RESULT INT	
	BEGIN TRY
	BEGIN TRANSACTION T1	
UPDATE transaccional.reingreso_estudiante
SET ES_ACTIVO=1, USUARIO_MODIFICACION=@USUARIO, FECHA_MODIFICACION=GETDATE()
WHERE ID_REINGRESO_ESTUDIANTE=@ID_REINGRESO_ESTUDIANTE


COMMIT TRANSACTION T1		
		SET @RESULT = 1
	END TRY
	BEGIN CATCH	
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -1
		END
		ELSE
			ROLLBACK TRANSACTION T1	   
	END CATCH

	SELECT @RESULT


END
GO


