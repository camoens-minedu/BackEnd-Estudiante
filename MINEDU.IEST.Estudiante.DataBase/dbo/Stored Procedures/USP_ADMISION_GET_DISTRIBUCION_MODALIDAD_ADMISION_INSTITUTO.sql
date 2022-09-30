/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la cantidad distribuída por modalidad en el proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_GET_DISTRIBUCION_MODALIDAD_ADMISION_INSTITUTO] 
(
	@ID_PERIODOLECTIVO_INSTITUCION INT,
	@ID_SEDE_INSTITUCION INT,
	@ID_MODALIDAD INT,
	@ID_EVALUADOR INT,
	@ID_AULA INT
)
AS
BEGIN

SELECT 
COUNT( * ) as CantidadDistribuida
FROM transaccional.distribucion_evaluacion_admision_detalle deadd INNER JOIN transaccional.distribucion_examen_admision deadm
ON deadd.ID_DISTRIBUCION_EXAMEN_ADMISION = deadm.ID_DISTRIBUCION_EXAMEN_ADMISION INNER JOIN transaccional.postulantes_por_modalidad ppmod
ON deadd.ID_POSTULANTES_POR_MODALIDAD = ppmod.ID_POSTULANTES_POR_MODALIDAD INNER JOIN transaccional.evaluador_admision_modalidad eadmod
ON deadm.ID_EVALUADOR_ADMISION_MODALIDAD = eadmod.ID_EVALUADOR_ADMISION_MODALIDAD INNER JOIN transaccional.examen_admision_sede eadmse
ON deadm.ID_EXAMEN_ADMISION_SEDE = eadmse.ID_EXAMEN_ADMISION_SEDE INNER JOIN transaccional.postulantes_por_modalidad pospmod
ON deadd.ID_POSTULANTES_POR_MODALIDAD = pospmod.ID_POSTULANTES_POR_MODALIDAD AND pospmod.ID_EXAMEN_ADMISION_SEDE = eadmse.ID_EXAMEN_ADMISION_SEDE INNER JOIN transaccional.modalidades_por_proceso_admision modppadm
ON pospmod.ID_MODALIDADES_POR_PROCESO_ADMISION = modppadm.ID_MODALIDADES_POR_PROCESO_ADMISION INNER JOIN maestro.personal_institucion personal
ON eadmod.ID_PERSONAL_INSTITUCION = personal.ID_PERSONAL_INSTITUCION INNER JOIN maestro.persona_institucion pinstitucion
ON personal.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona per
ON pinstitucion.ID_PERSONA = per.ID_PERSONA INNER JOIN maestro.persona_institucion perinstitucion
ON pospmod.ID_PERSONA_INSTITUCION = perinstitucion.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
ON pinstitucion.ID_PERSONA = persona.ID_PERSONA INNER JOIN maestro.sede_institucion sinstitucion
ON eadmse.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION INNER JOIN transaccional.proceso_admision_periodo padmp
ON eadmse.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO INNER JOIN transaccional.periodos_lectivos_por_institucion plepinst
ON padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plepinst.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
WHERE sinstitucion.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION 
AND per.ID_PERSONA=@ID_EVALUADOR AND deadm.ID_AULA=@ID_AULA AND modppadm.ID_MODALIDAD=@ID_MODALIDAD
	
END
GO


