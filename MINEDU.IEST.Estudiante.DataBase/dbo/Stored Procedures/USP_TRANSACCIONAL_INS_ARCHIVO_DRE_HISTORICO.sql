--/*************************************************************************************************************************************************
--AUTOR				:	Consultores DRE
--FECHA DE CREACION	:	22/01/2020
--LLAMADO POR			:
--DESCRIPCION			:	Registro de documento DRE.
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--*/
--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_INS_ARCHIVO_DRE_HISTORICO] (
           @ID_DOCUMENTOS_DRE INT,
		   @NOMBRE_ARCHIVO VARCHAR(MAX),
           @RUTA_ARCHIVO VARCHAR(MAX),
           @NOMBRE_DOCUMENTO VARCHAR(MAX),
		   @USUARIO VARCHAR(MAX)
)AS
DECLARE @RESULT INT
DECLARE @DOCUMENTOS_DRE_ARCHIVOS_R_TABLE TABLE (  
    ID_DOCUMENTOS_DRE_ARCHIVOS INT NOT NULL)
DECLARE @ID_DOCUMENTOS_DRE_ARCHIVOS_R INT
BEGIN
		INSERT INTO [transaccional].[documentos_dre_archivos]
			([ID_DOCUMENTOS_DRE]
			,[NOMBRE_DOCUMENTO]
			,[NOMBRE_ARCHIVO]
			,[RUTA_ARCHIVO]
			,[USUARIO_CREACION]
			,[FECHA_CREACION])
		OUTPUT INSERTED.ID_DOCUMENTOS_DRE_ARCHIVOS INTO @DOCUMENTOS_DRE_ARCHIVOS_R_TABLE
		VALUES
			(@ID_DOCUMENTOS_DRE
			, @NOMBRE_DOCUMENTO
			, @NOMBRE_ARCHIVO
			, @RUTA_ARCHIVO
			, @USUARIO
			, GETDATE())

			
		SET @ID_DOCUMENTOS_DRE_ARCHIVOS_R = (SELECT TOP 1 ID_DOCUMENTOS_DRE_ARCHIVOS FROM @DOCUMENTOS_DRE_ARCHIVOS_R_TABLE);
		SET @RESULT = @ID_DOCUMENTOS_DRE_ARCHIVOS_R
END
SELECT @RESULT