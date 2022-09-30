﻿CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_INSTITUCION]
(
	@ID_INSTITUCION		INT,
	@PAGINA_WEB			VARCHAR(200),
	@CORREO_ELECTRONICO	VARCHAR(200),
	@TELEFONO			VARCHAR(9),
	@CELULAR			VARCHAR(9),
	@TIENE_ADMISION		BIT,
	@USUARIO			INT
	--@TIENE_ADMISION	INT,
	--@USUARIO			VARCHAR(20)
	
)
AS
BEGIN

DECLARE @RESULT INT 
EXEC db_auxiliar.dbo.USP_UPD_INSTITUCION_EXT @ID_INSTITUCION, @PAGINA_WEB, @CORREO_ELECTRONICO, @TELEFONO, @CELULAR, @TIENE_ADMISION, @USUARIO
SET @RESULT=1
SELECT @RESULT

END


--****************************************************************************************************BK 03-05-2019

/*

ALTER PROCEDURE [dbo].[USP_MAESTROS_UPD_INSTITUCION]
(
	@ID_INSTITUCION		INT,
	@PAGINA_WEB			VARCHAR(50),
	@CORREO_ELECTRONICO	VARCHAR(100),
	@TELEFONO			VARCHAR(30),
	@CELULAR			VARCHAR(30),
	@TIENE_ADMISION		INT,
	@USUARIO			VARCHAR(20)
)
AS
BEGIN
	UPDATE maestro.institucion
	SET PAGINA_WEB = LOWER(@PAGINA_WEB),
	CORREO_ELECTRONICO = LOWER(@CORREO_ELECTRONICO),
	TELEFONO = @TELEFONO,
	CELULAR = @CELULAR,
	ADMISION = @TIENE_ADMISION,
	USUARIO_MODIFICACION = @USUARIO,
	FECHA_MODIFICACION = GETDATE()
	WHERE ID_INSTITUCION = @ID_INSTITUCION

	SELECT @@ROWCOUNT
END

*/
GO

