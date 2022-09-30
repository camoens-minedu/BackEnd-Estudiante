﻿
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_RETIRO_ESTUDIANTE]
(    
	@ID_RETIRO_ESTUDIANTE INT,	
	@ID_MOTIVO INT,
	@USUARIO VARCHAR(20)
)
AS
DECLARE @RESULT INT
BEGIN
	UPDATE transaccional.retiro_estudiante
	SET ID_MOTIVO= @ID_MOTIVO,
		USUARIO_MODIFICACION= @USUARIO,
		FECHA_MODIFICACION= GETDATE()
	WHERE ID_RETIRO_ESTUDIANTE= @ID_RETIRO_ESTUDIANTE
	SET @RESULT=1
END
SELECT @RESULT
GO


