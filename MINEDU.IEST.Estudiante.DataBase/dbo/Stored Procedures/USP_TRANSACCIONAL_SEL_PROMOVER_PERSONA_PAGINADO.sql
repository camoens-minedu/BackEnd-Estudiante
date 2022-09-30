/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la listade personas que serán promovidas 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
1.1			15/04/2021		JCHAVEZ			Modificación, se agregó join con transaccional.plan_estudio
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_PROMOVER_PERSONA_PAGINADO]
(
	@IdPeriodoLectivoInstitucion	INT, 
    @IdSedeInstitucion INT,
	@IdProgramaEstudio INT,
	@DNIPromovido VARCHAR(10),
	@TIPOMOTIVO INT,
	@Pagina						int		=1,
	@Registros					int		=10
)AS
BEGIN
SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(
	SELECT 
		ppi.ID_PROMOVER_PERSONA_INSTITUCION as IdPromoverEstudiante,
		ppi.ID_SEDE_INSTITUCION as IdSedeInstitucion,
		car.ID_CARRERA as IdPrograma,
		pe.ID_PLAN_ESTUDIO IdPlanEstudio,
		pe.NOMBRE_PLAN_ESTUDIOS + ' (' + enu_pe.VALOR_ENUMERADO + ') ' PlanEstudios,
		pe.ID_TIPO_ITINERARIO IdTipoPlanEstudio,
		ppi.ID_POSTULANTES_POR_MODALIDAD_RETIRADO as IdRetirado,
		ppi.ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO as IdPromovido,
		ppi.MOTIVO as IdMotivo,
		enumerado.ID_ENUMERADO as IdModalidad,
		sins.NOMBRE_SEDE as Sede,
	    car.NOMBRE_CARRERA as Programa,
		enumerado.VALOR_ENUMERADO as Modalidad,
	    persona.NUMERO_DOCUMENTO_PERSONA as DNIRETIRADO,
		UPPER(persona.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(persona.APELLIDO_MATERNO_PERSONA) + ', ' + dbo.UFN_CAPITALIZAR(persona.NOMBRE_PERSONA) AS RETIRADO,
		persona1.NUMERO_DOCUMENTO_PERSONA as DNIPROMOVIDO,
		UPPER(persona1.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(persona1.APELLIDO_MATERNO_PERSONA) + ', '+ dbo.UFN_CAPITALIZAR(persona1.NOMBRE_PERSONA) AS PROMOVIDO,
		enu.VALOR_ENUMERADO as motivo,
		ROW_NUMBER() OVER ( ORDER BY ppi.ID_SEDE_INSTITUCION) AS Row,
		Total = COUNT(1) OVER ( )
		FROM transaccional.promover_persona_institucion ppi JOIN maestro.sede_institucion sins
		ON ppi.ID_SEDE_INSTITUCION=sins.ID_SEDE_INSTITUCION JOIN transaccional.carreras_por_institucion cpi
		ON ppi.ID_CARRERAS_POR_INSTITUCION=cpi.ID_CARRERAS_POR_INSTITUCION JOIN db_auxiliar.dbo.UVW_CARRERA car
		ON cpi.ID_CARRERA=car.ID_CARRERA JOIN transaccional.periodos_lectivos_por_institucion pli
		ON ppi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=pli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION INNER JOIN transaccional.postulantes_por_modalidad ppmod
		ON ppi.ID_POSTULANTES_POR_MODALIDAD_RETIRADO = ppmod.ID_POSTULANTES_POR_MODALIDAD INNER JOIN maestro.persona_institucion pins
		ON ppmod.ID_PERSONA_INSTITUCION = pins.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
		ON pins.ID_PERSONA=persona.ID_PERSONA JOIN transaccional.periodos_lectivos_por_institucion plis
		ON ppi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plis.ID_PERIODOS_LECTIVOS_POR_INSTITUCION INNER JOIN transaccional.postulantes_por_modalidad ppmod1
		ON ppi.ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO = ppmod1.ID_POSTULANTES_POR_MODALIDAD INNER JOIN maestro.persona_institucion pinss
		ON ppmod1.ID_PERSONA_INSTITUCION=pinss.ID_PERSONA_INSTITUCION JOIN maestro.persona persona1
		ON pinss.ID_PERSONA=persona1.ID_PERSONA INNER JOIN sistema.enumerado enu
		ON ppi.MOTIVO=enu.ID_ENUMERADO INNER JOIN transaccional.modalidades_por_proceso_admision mppadm
		ON ppmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mppadm.ID_MODALIDADES_POR_PROCESO_ADMISION INNER JOIN sistema.enumerado enumerado
		ON mppadm.ID_MODALIDAD = enumerado.ID_ENUMERADO LEFT JOIN transaccional.plan_estudio pe
		ON pe.ID_PLAN_ESTUDIO = ppi.ID_PLAN_ESTUDIO LEFT JOIN sistema.enumerado enu_pe
		ON enu_pe.ID_ENUMERADO = pe.ID_TIPO_ITINERARIO
		WHERE
				
		ppi.ID_SEDE_INSTITUCION =	CASE WHEN @IdSedeInstitucion IS NULL	OR	LEN(@IdSedeInstitucion) = 0		OR @IdSedeInstitucion = ''	THEN ppi.ID_SEDE_INSTITUCION	ELSE @IdSedeInstitucion	END AND
		ppi.ID_CARRERAS_POR_INSTITUCION= CASE WHEN @IdProgramaEstudio IS NULL	OR	LEN(@IdProgramaEstudio) = 0		OR @IdProgramaEstudio = ''	THEN ppi.ID_CARRERAS_POR_INSTITUCION	ELSE @IdProgramaEstudio	END AND
		persona1.NUMERO_DOCUMENTO_PERSONA= CASE WHEN @DNIPromovido IS NULL	OR	LEN(@DNIPromovido) = 0		OR @DNIPromovido = ''	THEN persona1.NUMERO_DOCUMENTO_PERSONA	ELSE @DNIPromovido	END AND
		enu.ID_ENUMERADO= CASE WHEN @TIPOMOTIVO IS NULL	OR	LEN(@TIPOMOTIVO) = 0		OR @TIPOMOTIVO = ''	THEN enu.ID_ENUMERADO	ELSE @TIPOMOTIVO	END AND
		ppi.ES_ACTIVO=1
		and plis.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @IdPeriodoLectivoInstitucion 		
	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END
GO


