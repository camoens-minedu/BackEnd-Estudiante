--/************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Inserción de enumerado
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		[dbo].[USP_MAESTROS_UPD_ENUMERADO] 193,'BACHILLER',181,''
--/*
--	1.0			20/12/2019		MALVA          MODIFICACIÓN DE CONSULTA SE EVALÚA SI YA EXISTE CON ESTADO <> 0
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_ENUMERADO]
(
    @ID_ENUMERADO int,
    @DESCRIPCION nvarchar(50),
    @ID_ESTADO int,
    @USUARIO nvarchar(20)
    ) 

AS
DECLARE @RESULT INT
DECLARE @IDTIPOENUMERADO int =(SELECT e.ID_TIPO_ENUMERADO FROM sistema.enumerado e WHERE e.ID_ENUMERADO=@ID_ENUMERADO)


IF EXISTS(SELECT TOP 1 ID_ENUMERADO FROM sistema.enumerado e
WHERE RTRIM(LTRIM(VALOR_ENUMERADO)) COLLATE LATIN1_GENERAL_CI_AI = RTRIM(LTRIM(UPPER(@DESCRIPCION))) COLLATE LATIN1_GENERAL_CI_AI   
AND ID_TIPO_ENUMERADO=@IDTIPOENUMERADO  AND ID_ENUMERADO <> @ID_ENUMERADO AND ESTADO<>0
)
	SET @RESULT = -180
ELSE
BEGIN
    UPDATE  sistema.enumerado
    SET

	   VALOR_ENUMERADO=UPPER(@DESCRIPCION), -- nvarchar
	   ESTADO=@ID_ESTADO,
	   FECHA_MODIFICACION = getdate(), -- datetime
	   USUARIO_MODIFICACION = @USUARIO -- nvarchar
    WHERE 
	   ID_ENUMERADO=@ID_ENUMERADO
    SET @RESULT = 1
END
SELECT @RESULT
GO


