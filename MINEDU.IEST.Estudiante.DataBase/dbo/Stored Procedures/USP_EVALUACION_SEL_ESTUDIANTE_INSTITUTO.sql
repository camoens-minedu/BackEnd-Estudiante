/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2022
LLAMADO POR			:
DESCRIPCION			:	Obtiene información del estudiante para registrar evaluación extraordinaria o complementaria
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2022		JCHAVEZ			Creación

TEST:  
	USP_EVALUACION_SEL_ESTUDIANTE_INSTITUTO 607,4039,26,73182945
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_ESTUDIANTE_INSTITUTO] 
(
	@ID_INSTITUCION INT,
	@ID_PERIODOLECTIVO_INSTITUCION	INT,
	@ID_TIPO_DOCUMENTO	INT,
	@NUMERO_DOCUMENTO VARCHAR(15)
)
AS
BEGIN
	DECLARE @RESULT INT

	SELECT 
	p.APELLIDO_PATERNO_PERSONA + ' ' + p.APELLIDO_MATERNO_PERSONA + ', ' + p.NOMBRE_PERSONA   Estudiante,
	eins.ID_SEMESTRE_ACADEMICO					IdSemestreAcademico,
	enu.VALOR_ENUMERADO							Ciclo,
	c.ID_CARRERA								IdCarrera,
	c.NOMBRE_CARRERA							Programa,
	sinstitucion.ID_SEDE_INSTITUCION			IdSedeInstitucion,
	sinstitucion.NOMBRE_SEDE					Sede,
	pestudio.ID_TIPO_ITINERARIO					IdTipoPlanEstudios,
	enume.VALOR_ENUMERADO						TipoPlanEstudios,
	pestudio.ID_PLAN_ESTUDIO					IdPlanEstudios,
    pestudio.NOMBRE_PLAN_ESTUDIOS				PlanEstudios,
	eins.ID_ESTUDIANTE_INSTITUCION				IdEstudianteInstitucion,	
	ISNULL(mestu.ID_MATRICULA_ESTUDIANTE,0)		IdMatriculaEstudiante,
	nf.SEMESTRES_ACADEMICOS						SemestresAcademicos,
	enu_nf.ID_ENUMERADO							MaximoSemestre
	FROM maestro.persona p 
	INNER JOIN maestro.persona_institucion pins ON p.ID_PERSONA = pins.ID_PERSONA 
	INNER JOIN transaccional.estudiante_institucion eins ON pins.ID_PERSONA_INSTITUCION = eins.ID_PERSONA_INSTITUCION AND eins.ES_ACTIVO = 1
	LEFT JOIN transaccional.matricula_estudiante mestu	ON eins.ID_ESTUDIANTE_INSTITUCION = mestu.ID_ESTUDIANTE_INSTITUCION AND mestu.ES_ACTIVO = 1
	LEFT JOIN sistema.enumerado enu ON eins.ID_SEMESTRE_ACADEMICO = enu.ID_ENUMERADO 
	INNER JOIN transaccional.carreras_por_institucion_detalle cpidet ON eins.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpidet.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cpidet.ES_ACTIVO = 1
	INNER JOIN transaccional.carreras_por_institucion cins ON cpidet.ID_CARRERAS_POR_INSTITUCION = cins.ID_CARRERAS_POR_INSTITUCION AND cins.ES_ACTIVO = 1
	INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cins.ID_CARRERA = c.ID_CARRERA 
	INNER JOIN maestro.nivel_formacion nf ON nf.ID_NIVEL_FORMACION = c.ID_NIVEL_FORMACION
	INNER JOIN sistema.enumerado enu_nf ON nf.SEMESTRES_ACADEMICOS = enu_nf.CODIGO_ENUMERADO AND enu_nf.ID_TIPO_ENUMERADO = 38 
	INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON pins.ID_INSTITUCION = i.ID_INSTITUCION 
	INNER JOIN maestro.sede_institucion sinstitucion ON cpidet.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION AND sinstitucion.ES_ACTIVO=1
	INNER JOIN transaccional.plan_estudio pestudio ON eins.ID_PLAN_ESTUDIO = pestudio.ID_PLAN_ESTUDIO AND pestudio.ES_ACTIVO=1
	INNER JOIN sistema.enumerado enume ON pestudio.ID_TIPO_ITINERARIO = enume.ID_ENUMERADO

	WHERE p.NUMERO_DOCUMENTO_PERSONA=@NUMERO_DOCUMENTO AND p.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO 
		AND pins.ID_INSTITUCION = @ID_INSTITUCION
	ORDER BY enu.VALOR_ENUMERADO DESC
END