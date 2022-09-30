/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro de una sede la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_GET_SEDES_MODALIDAD_INSTITUTO] 
(
	@ID_SEDE_INSTITUCION INT=''
)
AS
BEGIN
	
	SELECT 
	sinstitucion.ID_SEDE_INSTITUCION            IdSedeInstitucion,
	sinstitucion.NOMBRE_SEDE                    NombreSede,
	sinstitucion.CODIGO_SEDE                    CodigoSede
	
	FROM maestro.sede_institucion sinstitucion 
	WHERE sinstitucion.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION
	
END
GO


