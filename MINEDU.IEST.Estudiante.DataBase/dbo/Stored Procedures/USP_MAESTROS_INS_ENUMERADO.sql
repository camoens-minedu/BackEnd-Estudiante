--/************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Inserción de enumerado
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		
--/*
--	1.0			20/12/2019		MALVA          MODIFICACIÓN DE CONSULTA SE EVALÚA SI YA EXISTE CON ESTADO <> 0
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_INS_ENUMERADO]
(
    @ID_TIPO_ENUMERADO int,
    @DESCRIPCION	 nvarchar(100),
     @ID_ESTADO  int,
    @USUARIO	 nvarchar(20)
)
AS
DECLARE @RESULT INT
IF EXISTS(SELECT TOP 1 ID_ENUMERADO FROM sistema.enumerado
WHERE RTRIM(LTRIM(VALOR_ENUMERADO)) COLLATE LATIN1_GENERAL_CI_AI = RTRIM(LTRIM(UPPER(@DESCRIPCION))) COLLATE LATIN1_GENERAL_CI_AI AND ID_TIPO_ENUMERADO=@ID_TIPO_ENUMERADO
AND ESTADO<>0)
	SET @RESULT = -180
ELSE
BEGIN	   	   
	   INSERT INTO sistema.enumerado
	   (
		  ID_TIPO_ENUMERADO,
		  CODIGO_ENUMERADO,
		  VALOR_ENUMERADO,
		  ORDEN_ENUMERADO,
		  ES_EDITABLE,		  
		  ESTADO,
		  FECHA_CREACION,
		  USUARIO_CREACION

	   )
	   VALUES
	   (		  
		  @ID_TIPO_ENUMERADO, -- ID_TIPO_ENUMERADO - int
		  (SELECT MAX(CODIGO_ENUMERADO)+1 FROM sistema.enumerado WHERE ID_TIPO_ENUMERADO = @ID_TIPO_ENUMERADO),
		  UPPER(@DESCRIPCION),
		  (SELECT MAX(ORDEN_ENUMERADO)+1 FROM sistema.enumerado WHERE ID_TIPO_ENUMERADO = @ID_TIPO_ENUMERADO),
		  1, -- ES_ACTIVO - bit
		  @ID_ESTADO, -- ESTADO - smallint
		  getdate(),  -- FECHA_CREACION - datetime
		  @USUARIO  -- USUARIO_CREACION - nvarchar
	   )

	SET @RESULT = 1
END
SELECT @RESULT
GO


