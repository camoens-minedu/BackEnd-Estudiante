CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_EVALUACION_EXTRAORDINARIA_PAGINADO]	
(
    @ID_INSTITUCION					INT,
	@ID_PERIODOLECTIVO_INSTITUCION	INT,
	@ID_TIPO_DOCUMENTO				INT,
	@NRO_DOCUMENTO					VARCHAR(15),
	@ID_SEDE_INSTITUCION			INT,
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT,
	@ID_PLAN_ESTUDIO				INT,
	@Pagina							INT		=1,
	@Registros						INT		=10
)AS
BEGIN
SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT, @Cantidad INT;

	--SET @Cantidad = (SELECT count(*)
	--FROM maestro.persona per INNER JOIN maestro.persona_institucion pins 
	--ON per.ID_PERSONA = pins.ID_PERSONA INNER JOIN transaccional.estudiante_institucion estuin
	--ON pins.ID_PERSONA_INSTITUCION = estuin.ID_PERSONA_INSTITUCION INNER JOIN transaccional.evaluacion_extraordinaria extra
	--ON estuin.ID_ESTUDIANTE_INSTITUCION = extra.ID_ESTUDIANTE_INSTITUCION INNER JOIN transaccional.evaluacion_extraordinaria_detalle extradet
	--ON extra.ID_EVALUACION_EXTRAORDINARIA = extradet.ID_EVALUACION_EXTRAORDINARIA
	--WHERE 
	--per.ID_TIPO_DOCUMENTO =	CASE WHEN @ID_TIPO_DOCUMENTO IS NULL	OR	LEN(@ID_TIPO_DOCUMENTO) = 0	OR @ID_TIPO_DOCUMENTO=0	OR @ID_TIPO_DOCUMENTO = ''	THEN per.ID_TIPO_DOCUMENTO	ELSE @ID_TIPO_DOCUMENTO	END AND
	--per.NUMERO_DOCUMENTO_PERSONA= CASE WHEN @NRO_DOCUMENTO IS NULL	OR	LEN(@NRO_DOCUMENTO) = 0	OR @NRO_DOCUMENTO=0	OR @NRO_DOCUMENTO = ''	THEN per.NUMERO_DOCUMENTO_PERSONA	ELSE @NRO_DOCUMENTO	END AND
	--pins.ID_INSTITUCION = @ID_INSTITUCION AND estuin.ES_ACTIVO=1 AND extra.ES_ACTIVO=1 and extradet.ES_ACTIVO=1
	--)
	DECLARE @ESTADO_PERIODO INT = (	SELECT COUNT(1)
									FROM transaccional.periodo_academico pa
									INNER JOIN transaccional.programacion_clase pc ON pc.ID_PERIODO_ACADEMICO = pa.ID_PERIODO_ACADEMICO AND pc.ES_ACTIVO = 1
									WHERE pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION AND pa.ES_ACTIVO = 1 AND pc.ESTADO = 1)
	
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(
	
        SELECT
			eextra.ID_EVALUACION_EXTRAORDINARIA											IdEvaluacionExtraordinaria,
			einsti.ID_ESTUDIANTE_INSTITUCION											IdEstudianteInstitucion,		
			enu.ID_ENUMERADO															IdTipoDocumento,  
	    	enu.VALOR_ENUMERADO															TipoDocumento, 
	    	per.NUMERO_DOCUMENTO_PERSONA												NroDocumento,
			per.APELLIDO_PATERNO_PERSONA + ' ' 
		    + per.APELLIDO_MATERNO_PERSONA + ', ' 
		    + dbo.UFN_CAPITALIZAR(per.NOMBRE_PERSONA)									Estudiante,
			sinsti.ID_SEDE_INSTITUCION													IdSedeInstitucion,
			sinsti.NOMBRE_SEDE															Sede,
			cinsti.ID_CARRERA															IdCarrera,
	    	carrera.NOMBRE_CARRERA														Programa,
	    	enume.VALOR_ENUMERADO														Ciclo,
			eextra.ARCHIVO_RD															ArchivoRD,
			enumeradoo.ID_ENUMERADO														IdTipoEvaluacion,
			enumeradoo.VALOR_ENUMERADO													TipoEvaluacion,
	    	pe.ID_PLAN_ESTUDIO															IdPlanEstudios,
	    	pe.NOMBRE_PLAN_ESTUDIOS		+ ' (' + ti.VALOR_ENUMERADO + ')'				PlanEstudios,
	    	cinsti.ID_TIPO_ITINERARIO													IdTipoPlanEstudios,
	    	ti.VALOR_ENUMERADO															TipoPlanEstudios,
			(CASE WHEN @ESTADO_PERIODO > 0 THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END)	EsPeriodoCerrado,
			(SELECT COUNT(1) FROM transaccional.evaluacion_extraordinaria_detalle
			WHERE ID_EVALUACION_EXTRAORDINARIA = eextra.ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO = 1) NotasRegistradas,
			ROW_NUMBER() OVER ( ORDER BY eextra.ID_EVALUACION_EXTRAORDINARIA) AS Row,
	        Total = COUNT(1) OVER ( )
		FROM maestro.persona per JOIN maestro.persona_institucion pinsti
		ON per.ID_PERSONA=pinsti.ID_PERSONA JOIN transaccional.estudiante_institucion einsti 
		ON pinsti.ID_PERSONA_INSTITUCION=einsti.ID_PERSONA_INSTITUCION and einsti.ES_ACTIVO=1 JOIN transaccional.evaluacion_extraordinaria eextra
		ON einsti.ID_ESTUDIANTE_INSTITUCION = eextra.ID_ESTUDIANTE_INSTITUCION and eextra.ES_ACTIVO=1 JOIN transaccional.carreras_por_institucion_detalle cinstidet 
		ON einsti.ID_CARRERAS_POR_INSTITUCION_DETALLE=cinstidet.ID_CARRERAS_POR_INSTITUCION_DETALLE and cinstidet.ES_ACTIVO=1 JOIN transaccional.carreras_por_institucion cinsti
		ON cinstidet.ID_CARRERAS_POR_INSTITUCION=cinsti.ID_CARRERAS_POR_INSTITUCION JOIN maestro.sede_institucion sinsti
		ON cinstidet.ID_SEDE_INSTITUCION=sinsti.ID_SEDE_INSTITUCION and sinsti.ES_ACTIVO=1 JOIN db_auxiliar.dbo.UVW_CARRERA carrera
		ON cinsti.ID_CARRERA=carrera.ID_CARRERA and cinsti.ES_ACTIVO=1 JOIN sistema.enumerado enu  
		ON per.ID_TIPO_DOCUMENTO=enu.ID_ENUMERADO JOIN sistema.enumerado enume
		ON einsti.ID_SEMESTRE_ACADEMICO=enume.ID_ENUMERADO INNER JOIN transaccional.plan_estudio pe 
		ON pe.ID_PLAN_ESTUDIO = einsti.ID_PLAN_ESTUDIO and pe.ES_ACTIVO=1 INNER JOIN sistema.enumerado ti 
		ON ti.ID_ENUMERADO = pe.ID_TIPO_ITINERARIO  INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i 
		ON pinsti.ID_INSTITUCION = i.ID_INSTITUCION INNER JOIN transaccional.periodos_lectivos_por_institucion plectivo
		ON eextra.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION INNER JOIN sistema.enumerado enumeradoo
		ON eextra.ID_TIPO_EVALUACION = enumeradoo.ID_ENUMERADO
		WHERE
		per.ID_TIPO_DOCUMENTO =	CASE WHEN @ID_TIPO_DOCUMENTO IS NULL	OR	LEN(@ID_TIPO_DOCUMENTO) = 0	OR @ID_TIPO_DOCUMENTO=0	OR @ID_TIPO_DOCUMENTO = ''	THEN per.ID_TIPO_DOCUMENTO	ELSE @ID_TIPO_DOCUMENTO	END AND
		per.NUMERO_DOCUMENTO_PERSONA= CASE WHEN @NRO_DOCUMENTO IS NULL	OR	LEN(@NRO_DOCUMENTO) = 0	OR @NRO_DOCUMENTO=0	OR @NRO_DOCUMENTO = ''	THEN per.NUMERO_DOCUMENTO_PERSONA	ELSE @NRO_DOCUMENTO	END
		AND (@ID_SEDE_INSTITUCION = 0 OR cinstidet.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION )
		AND (@ID_CARRERA = 0 OR carrera.ID_CARRERA = @ID_CARRERA )
		AND (@ID_TIPO_ITINERARIO = 0 OR pe.ID_TIPO_ITINERARIO = @ID_TIPO_ITINERARIO)
		AND (@ID_PLAN_ESTUDIO =0 OR pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO)
		AND pinsti.ID_INSTITUCION = @ID_INSTITUCION AND plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION
	)
	SELECT  *
    FROM tempPaginado T WHERE ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END