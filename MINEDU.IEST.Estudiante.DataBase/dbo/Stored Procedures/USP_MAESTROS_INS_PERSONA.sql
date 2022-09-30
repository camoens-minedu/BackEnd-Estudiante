/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta el registro de persona
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*

*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_INS_PERSONA]
(
	@TIPO_DOCUMENTO_PERSONA		INT,
	@NUMERO_DOCUMENTO_PERSONA	VARCHAR(16),
	@NOMBRE_PERSONA				VARCHAR(50),
	@APELLIDO_PATERNO_PERSONA	VARCHAR(40),
	@APELLIDO_MATERNO_PERSONA	VARCHAR(40),
	@FECHA_NACIMIENTO_PERSONA	DATETIME,
	@SEXO_PERSONA				INT,
	@ESTADO_CIVIL_PERSONA		INT,
	@PAIS_NACIMIENTO			INT,
	@UBIGEO_NACIMIENTO			VARCHAR(6),
	@USUARIO					VARCHAR(20)
)
AS
BEGIN
	IF NOT EXISTS(SELECT TOP 1 ID_PERSONA FROM maestro.persona WHERE ID_TIPO_DOCUMENTO = @TIPO_DOCUMENTO_PERSONA AND NUMERO_DOCUMENTO_PERSONA = UPPER(@NUMERO_DOCUMENTO_PERSONA))
	BEGIN
		INSERT INTO maestro.persona 
		(			
			ID_TIPO_DOCUMENTO,
			NUMERO_DOCUMENTO_PERSONA,
			NOMBRE_PERSONA,
			APELLIDO_PATERNO_PERSONA,
			APELLIDO_MATERNO_PERSONA,
			FECHA_NACIMIENTO_PERSONA,
			SEXO_PERSONA,
			--ESTADO_CIVIL_PERSONA,		
			PAIS_NACIMIENTO,
			UBIGEO_NACIMIENTO,
			ESTADO,
			FECHA_CREACION,
			USUARIO_CREACION				
		)
		VALUES
		(			
			@TIPO_DOCUMENTO_PERSONA,
			UPPER(@NUMERO_DOCUMENTO_PERSONA),
			UPPER(@NOMBRE_PERSONA),
			UPPER(@APELLIDO_PATERNO_PERSONA),
			UPPER(@APELLIDO_MATERNO_PERSONA),
			@FECHA_NACIMIENTO_PERSONA,
			@SEXO_PERSONA,
			--@ESTADO_CIVIL_PERSONA,
			@PAIS_NACIMIENTO,
			@UBIGEO_NACIMIENTO,
			1,
			GETDATE(),
			@USUARIO			
		)		
		SELECT CONVERT(INT,@@IDENTITY)
	END
	ELSE
		SELECT -1
END
GO


