/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista aulas de la institución en el proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_GET_AULAS_SEDE_INSTITUTO] 
(
	@ID_INSTITUCION INT='',
	@ID_SEDE_INSTITUCION INT=''
)
AS
BEGIN
	
	SELECT 
	aula.ID_AULA                            IdAula,
	aula.NOMBRE_AULA                        NombreAula,
	aula.AFORO_AULA                         AforoAula
		
	FROM maestro.aula aula 
	JOIN maestro.sede_institucion sinsti ON aula.ID_SEDE_INSTITUCION=sinsti.ID_SEDE_INSTITUCION 
	JOIN db_auxiliar.dbo.UVW_INSTITUCION insti ON sinsti.ID_INSTITUCION=insti.ID_INSTITUCION

	WHERE insti.ID_INSTITUCION = @ID_INSTITUCION AND sinsti.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION
	AND aula.ES_ACTIVO=1 AND aula.CATEGORIA_AULA = 10
END
GO


