/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista evaluadores de la institución por modalidad en el proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_GET_EVALUADORES_MODALIDAD_INSTITUTO] 
(
	@ID_PERIODOLECTIVO_INSTITUCION INT='',
	@ID_MODALIDAD INT=''
)
AS
BEGIN
	
	SELECT 
	persona.ID_PERSONA                                                                                                 IdEvaluador,
	persona.APELLIDO_PATERNO_PERSONA + ' ' + persona.APELLIDO_MATERNO_PERSONA + ' ' + persona.NOMBRE_PERSONA           Evaluador

	FROM transaccional.evaluador_admision_modalidad eadmmod INNER JOIN transaccional.modalidades_por_proceso_admision mppadm
	ON eadmmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mppadm.ID_MODALIDADES_POR_PROCESO_ADMISION INNER JOIN transaccional.proceso_admision_periodo padmp
	ON mppadm.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO INNER JOIN sistema.enumerado enu
	ON mppadm.ID_MODALIDAD = enu.ID_ENUMERADO INNER JOIN maestro.personal_institucion personalinsti
	ON eadmmod.ID_PERSONAL_INSTITUCION = personalinsti.ID_PERSONAL_INSTITUCION INNER JOIN maestro.persona_institucion pinstitucion
	ON personalinsti.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
	ON pinstitucion.ID_PERSONA = persona.ID_PERSONA
	WHERE padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION AND mppadm.ID_MODALIDAD=@ID_MODALIDAD
	AND eadmmod.ES_ACTIVO=1
	
END
GO


