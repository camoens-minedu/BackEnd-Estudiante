/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los datos del registro de un traslado de un estudiante 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.1			05/07/2019		MAlva			Modificación de store. Se consideran las columnas ES_ACTIVO de la
											tabla estudiante_institucion.
1.2			18/06/2020		MALVA			Obtener valores únicos
**********************************************************************************************************/
--USP_TRASLADO_SEL_INSTITUTO_ESTUDIANTE 26, '42123212'
CREATE PROCEDURE [dbo].[USP_TRASLADO_SEL_INSTITUTO_ESTUDIANTE]
(
	@ID_TIPO_DOCUMENTO	INT,
	@NRO_DOCUMENTO VARCHAR(12)
)
AS
BEGIN

        SELECT 
		DISTINCT
		institucion.ID_INSTITUCION                        IdInstituto,
		institucion.NOMBRE_INSTITUCION                    NombreInstituto
		FROM maestro.persona_institucion pinstitucion INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION institucion
		ON pinstitucion.ID_INSTITUCION = institucion.ID_INSTITUCION  INNER JOIN transaccional.estudiante_institucion einstitucion
		ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION AND einstitucion.ES_ACTIVO=1 INNER JOIN maestro.persona persona
		ON pinstitucion.ID_PERSONA = persona.ID_PERSONA
		WHERE --pinstitucion.ID_PERSONA=11 
		persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO and persona.NUMERO_DOCUMENTO_PERSONA = @NRO_DOCUMENTO

END

--***********************************************************************************************
--58. USP_CONVALIDACION_SEL_ESTUDIANTE_PAGINADO.sql
GO


