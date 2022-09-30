--/*************************************************************************************************************************************************
--AUTOR				:	Consultores DRE
--FECHA DE CREACION	:	22/01/2020
--LLAMADO POR			:
--DESCRIPCION			:	Eliminación de registro de documento DRE.
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--*/
--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_DEL_ARCHIVO_DRE_HISTORICO] (
           @ID_DOCUMENTOS_DRE_ARCHIVOS INT,
		   @USUARIO VARCHAR(MAX)
)AS
DECLARE @RESULT INT
BEGIN
	UPDATE [transaccional].[documentos_dre_archivos]
	SET ESTADO = 0,
	USUARIO_MODIFICACION = @USUARIO,
	FECHA_MODIFICACION = GETDATE()
	WHERE ID_DOCUMENTOS_DRE_ARCHIVOS = @ID_DOCUMENTOS_DRE_ARCHIVOS;
	SET @RESULT = 1  
END
SELECT @RESULT