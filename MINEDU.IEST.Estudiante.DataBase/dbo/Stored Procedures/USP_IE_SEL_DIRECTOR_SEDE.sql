CREATE PROCEDURE [dbo].[USP_IE_SEL_DIRECTOR_SEDE]
(
	@ID_INSTITUCION     INT,
	@ID_TIPO_DOCUMENTO	INT,
    @NUMERO_DOCUMENTO	VARCHAR(15)
)
AS
BEGIN

SELECT 

personalinstitucion.ID_PERSONAL_INSTITUCION                                                              IdPersonalInstitucion,
persona.APELLIDO_PATERNO_PERSONA +' '+ persona.APELLIDO_MATERNO_PERSONA + ' ' + persona.NOMBRE_PERSONA   Director
 
FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinstitucion
ON persona.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN maestro.personal_institucion personalinstitucion
ON pinstitucion.ID_PERSONA_INSTITUCION = personalinstitucion.ID_PERSONA_INSTITUCION
WHERE
persona.ID_TIPO_DOCUMENTO        = @ID_TIPO_DOCUMENTO AND
persona.NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO AND pinstitucion.ID_INSTITUCION = @ID_INSTITUCION

--persona.ID_TIPO_DOCUMENTO        = 26 AND
--persona.NUMERO_DOCUMENTO_PERSONA = '42122536'


END
GO


