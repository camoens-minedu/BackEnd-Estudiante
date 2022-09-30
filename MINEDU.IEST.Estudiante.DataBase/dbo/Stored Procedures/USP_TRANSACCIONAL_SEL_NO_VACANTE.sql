/*********************************************************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Retorna la lista de postulantes que no alcanzaron vacante.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			24/01/2020		MALVA			SE AÑADIÓ PARÁMETRO @ID_PLAN_ESTUDIO, SE QUITA @IdProgramaEstudio
1.1			15/04/2021		JCHAVEZ			Modificación, se agregó orden por apellidos y nombres

TEST:		USP_TRANSACCIONAL_SEL_NO_VACANTE 1106,4221,7053,10319,24
***********************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_NO_VACANTE] 
(
	@IdInstituto INT='',
	@IdSedeInstitucion	INT ='',
	@ID_PLAN_ESTUDIO	INT, --@IdProgramaEstudio	INT	='',
	@IdPeriodoInstitucion INT='',
	@IdModalidad INT

	--DECLARE @IdInstituto INT=440
	--DECLARE @IdSedeInstitucion	INT =1965
	--DECLARE @IdProgramaEstudio	INT	=64
	--DECLARE @IdPeriodoInstitucion INT=5517
	--DECLARE @IdModalidad INT=24
)AS
BEGIN
	SELECT 
	    
	p.ID_POSTULANTES_POR_MODALIDAD                                      Value,
	UPPER(persona.APELLIDO_PATERNO_PERSONA) + ' ' +
	UPPER(persona.APELLIDO_MATERNO_PERSONA) + ', ' + 
	dbo.UFN_CAPITALIZAR(persona.NOMBRE_PERSONA)								Text,
	pinstitucion.ID_PERSONA_INSTITUCION                                     Code
		

	FROM transaccional.resultados_por_postulante r INNER JOIN transaccional.postulantes_por_modalidad p
	ON r.ID_POSTULANTES_POR_MODALIDAD = p.ID_POSTULANTES_POR_MODALIDAD AND r.ES_ACTIVO=1 and p.ES_ACTIVO=1
	INNER JOIN transaccional.postulantes_por_modalidad c ON p.ID_POSTULANTES_POR_MODALIDAD = c.ID_POSTULANTES_POR_MODALIDAD AND c.ES_ACTIVO=1 				
	INNER JOIN maestro.persona_institucion pinstitucion 
	ON c.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION 
	INNER JOIN maestro.persona persona ON pinstitucion.ID_PERSONA = persona.ID_PERSONA 
	INNER JOIN transaccional.opciones_por_postulante opostulante ON p.ID_POSTULANTES_POR_MODALIDAD = opostulante.ID_POSTULANTES_POR_MODALIDAD and opostulante.ES_ACTIVO=1
	INNER JOIN transaccional.meta_carrera_institucion_detalle mcidet ON opostulante.ID_META_CARRERA_INSTITUCION_DETALLE = mcidet.ID_META_CARRERA_INSTITUCION_DETALLE and mcidet.ES_ACTIVO=1
	INNER JOIN transaccional.meta_carrera_institucion mci ON mcidet.ID_META_CARRERA_INSTITUCION = mci.ID_META_CARRERA_INSTITUCION and mci.ES_ACTIVO=1
	INNER JOIN transaccional.carreras_por_institucion cpins ON mci.ID_CARRERAS_POR_INSTITUCION = cpins.ID_CARRERAS_POR_INSTITUCION and cpins.ES_ACTIVO=1
	--INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera ON cpins.ID_CARRERA = carrera.ID_CARRERA 
	INNER JOIN transaccional.modalidades_por_proceso_admision mppadm ON p.ID_MODALIDADES_POR_PROCESO_ADMISION = mppadm.ID_MODALIDADES_POR_PROCESO_ADMISION and mppadm.ES_ACTIVO=1
	INNER JOIN sistema.enumerado enu ON mppadm.ID_MODALIDAD = enu.ID_ENUMERADO 	

	WHERE 
		
	pinstitucion.ID_INSTITUCION = @IdInstituto
	AND enu.ID_ENUMERADO = @IdModalidad
	--AND carrera.ID_CARRERA = @IdProgramaEstudio
	and mci.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO
	AND mcidet.ID_SEDE_INSTITUCION = @IdSedeInstitucion
	AND mcidet.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @IdPeriodoInstitucion
	AND r.ESTADO=176
	ORDER BY persona.APELLIDO_PATERNO_PERSONA, persona.APELLIDO_MATERNO_PERSONA,persona.NOMBRE_PERSONA

END
GO


