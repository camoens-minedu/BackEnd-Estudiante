﻿CREATE PROCEDURE [dbo].[USP_ADMISION_INS_TIPO_MODALIDAD_IE]
(
	@ID_TIPO_MODALIDAD	INT,
	@ID_INSTITUCION		INT,
	@USUARIO			VARCHAR(20)
)
AS
DECLARE @RESULT INT
IF EXISTS(select top 1 ID_TIPOS_MODALIDAD_POR_INSTITUCION from maestro.tipos_modalidad_por_institucion 
where ID_INSTITUCION=@ID_INSTITUCION AND ID_TIPO_MODALIDAD=@ID_TIPO_MODALIDAD and ES_ACTIVO=1
)
 SET @RESULT = -180  
 ELSE
BEGIN
	INSERT INTO maestro.tipos_modalidad_por_institucion(ID_TIPO_MODALIDAD,ID_INSTITUCION,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
	VALUES (@ID_TIPO_MODALIDAD,@ID_INSTITUCION,1,1,@USUARIO,GETDATE())
	SET @RESULT =  1
END
SELECT @RESULT
GO

