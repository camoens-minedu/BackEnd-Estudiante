/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	05/02/2019
LLAMADO POR			:
DESCRIPCION			:	Lista de las unidades didácticas por plan de estudio
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/02/2019		JTOVAR			Creación
1.2			04/11/2021		JCHAVEZ			Actualización del match entre sede y carrera
1.3			24/01/2022		JCHAVEZ			Actualización en WHERE para agregar ID_PERIODOS_LECTIVOS_POR_INSTITUCION

TEST:  
	USP_MATRICULA_SEL_ESTUDIANTE_INSTITUTO 607,4039,26,73182945
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ESTUDIANTE_INSTITUTO] 
(
	@ID_INSTITUCION INT,
	@ID_PERIODOLECTIVO_INSTITUCION	INT,
	@ID_TIPO_DOCUMENTO	INT,
	@NUMERO_DOCUMENTO VARCHAR(15)

	--DECLARE @ID_INSTITUCION INT=607
	--DECLARE @ID_PERIODOLECTIVO_INSTITUCION	INT=4039
	--DECLARE @ID_TIPO_DOCUMENTO	INT=26
	--DECLARE @NUMERO_DOCUMENTO VARCHAR(15)='73182945'
)
AS
BEGIN
	DECLARE @RESULT INT

	SELECT 
	TOP 1
	p.APELLIDO_PATERNO_PERSONA + ' ' 
	+ p.APELLIDO_MATERNO_PERSONA + ', ' 
	+ p.NOMBRE_PERSONA   Estudiante,
	enu.VALOR_ENUMERADO                                Ciclo,
	c.ID_CARRERA								   IdCarrera,
	c.NOMBRE_CARRERA                             Programa,
	sinstitucion.ID_SEDE_INSTITUCION						   IdSedeInstitucion,
	sinstitucion.NOMBRE_SEDE                                Sede,
	pestudio.ID_TIPO_ITINERARIO							   IdTipoPlanEstudios,
	enume.VALOR_ENUMERADO							   TipoPlanEstudios,
	pestudio.ID_PLAN_ESTUDIO								   IdPlanEstudios,
    pestudio.NOMBRE_PLAN_ESTUDIOS							   PlanEstudios,
	eins.ID_ESTUDIANTE_INSTITUCION				   IdEstudianteInstitucion	
	
	FROM maestro.persona p INNER JOIN maestro.persona_institucion pins	
	ON p.ID_PERSONA = pins.ID_PERSONA INNER JOIN transaccional.estudiante_institucion eins
	ON pins.ID_PERSONA_INSTITUCION = eins.ID_PERSONA_INSTITUCION INNER JOIN transaccional.matricula_estudiante mestu
	ON eins.ID_ESTUDIANTE_INSTITUCION = mestu.ID_ESTUDIANTE_INSTITUCION INNER JOIN sistema.enumerado enu
	ON mestu.ID_SEMESTRE_ACADEMICO = enu.ID_ENUMERADO INNER JOIN transaccional.carreras_por_institucion_detalle cpidet
	ON eins.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpidet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cins
	ON cpidet.ID_CARRERAS_POR_INSTITUCION = cins.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA c
	ON cins.ID_CARRERA = c.ID_CARRERA INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i
	ON pins.ID_INSTITUCION = i.ID_INSTITUCION INNER JOIN maestro.sede_institucion sinstitucion
	ON cpidet.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
	ON eins.ID_PLAN_ESTUDIO = pestudio.ID_PLAN_ESTUDIO INNER JOIN sistema.enumerado enume
	ON pestudio.ID_TIPO_ITINERARIO = enume.ID_ENUMERADO

	WHERE p.NUMERO_DOCUMENTO_PERSONA=@NUMERO_DOCUMENTO AND p.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO 
	AND mestu.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION --versión 1.3
	AND mestu.ES_ACTIVO = 1 AND eins.ES_ACTIVO = 1 AND cpidet.ES_ACTIVO = 1 and cins.ES_ACTIVO = 1 AND pestudio.ES_ACTIVO=1
	ORDER BY enu.VALOR_ENUMERADO DESC
END
GO


