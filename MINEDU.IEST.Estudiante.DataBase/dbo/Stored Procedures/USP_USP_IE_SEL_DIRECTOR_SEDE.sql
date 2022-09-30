/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro de datos personales de una persona
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_USP_IE_SEL_DIRECTOR_SEDE]
(
	@ID_TIPO_DOCUMENTO	INT,
    @NUMERO_DOCUMENTO	VARCHAR(15)
)
AS
BEGIN

SELECT 

persona.ID_PERSONA                       IdPersona,
persona.APELLIDO_PATERNO_PERSONA +' '+ persona.APELLIDO_MATERNO_PERSONA + ' ' + persona.NOMBRE_PERSONA   Director
 
FROM maestro.persona persona 
WHERE
persona.ID_TIPO_DOCUMENTO        = @ID_TIPO_DOCUMENTO AND
persona.NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO

END
GO


