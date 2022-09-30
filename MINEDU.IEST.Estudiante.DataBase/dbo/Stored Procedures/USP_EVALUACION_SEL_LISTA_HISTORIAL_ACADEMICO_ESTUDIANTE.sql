/*********************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Listado de historial académico
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE	Creación
2.0			07/02/2022		JCHAVEZ			Optimización de script
3.0			17/05/2022		JCHAVEZ			Se agregó else en caso que no se obtengan datos con los filtros de búsqueda seleccionados

TEST:
	USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE 221,26,'73046240',27,1255,442,403
	USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE 221,26,'73046240',27,1255,442,3842
	USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE 221,26,'75571952',27,1311,1258,403
***********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE] (
	@ID_INSTITUCION					INT,
	@ID_TIPO_DOCUMENTO				INT,
	@ID_NUMERO_DOCUMENTO			VARCHAR(16),
	@ID_SEDE_INSTITUCION			INT,
	@ID_CARRERA						INT,
	@ID_PLAN_ESTUDIO			    INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT
)
AS
BEGIN 
	DECLARE @ID_SEMESTRE_ACTUAL INT, @SEMESTRE_ACTUAL VARCHAR(5);

	BEGIN --> Eliminar Temporales 
		IF (OBJECT_ID('tempdb.dbo.#tmpPersonaReporteAcademico','U')) IS NOT NULL DROP TABLE #tmpPersonaReporteAcademico
		IF (OBJECT_ID('tempdb.dbo.#TmpDetalleNotaMatricula','U')) IS NOT NULL DROP TABLE #TmpDetalleNotaMatricula
	END

	DECLARE @RUTA_FOTO VARCHAR(500) = (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS() + 'ESTUDIANTES_FOTOS\')
	
	DECLARE @CODIGO_PERIODO_LECTIVO VARCHAR(20) = (	SELECT pl.CODIGO_PERIODO_LECTIVO
													FROM transaccional.periodos_lectivos_por_institucion plxi
													INNER JOIN maestro.periodo_lectivo pl ON pl.ID_PERIODO_LECTIVO = plxi.ID_PERIODO_LECTIVO
													WHERE plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION)
	
	SELECT p.ID_PERSONA,ID_TIPO_DOCUMENTO,tipo_doc.VALOR_ENUMERADO TIPO_DOCUMENTO_PERSONA,NUMERO_DOCUMENTO_PERSONA,
	APELLIDO_PATERNO_PERSONA,APELLIDO_MATERNO_PERSONA,NOMBRE_PERSONA,SEXO_PERSONA,enumera.VALOR_ENUMERADO SEXO,
	UPPER(p.APELLIDO_PATERNO_PERSONA) + ' '+ UPPER(p.APELLIDO_MATERNO_PERSONA)+ ', ' + dbo.UFN_CAPITALIZAR(p.NOMBRE_PERSONA) AS NOMBRE_ESTUDIANTE,
	einstitucion.ID_ESTUDIANTE_INSTITUCION,@RUTA_FOTO + einstitucion.ARCHIVO_FOTO FOTO
	INTO #tmpPersonaReporteAcademico
	FROM maestro.persona p
	INNER JOIN maestro.persona_institucion pinstitucion ON p.ID_PERSONA = pinstitucion.ID_PERSONA AND pinstitucion.ESTADO=1
			INNER JOIN transaccional.estudiante_institucion einstitucion ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION AND einstitucion.ES_ACTIVO = 1
			INNER JOIN transaccional.carreras_por_institucion_detalle cpi ON einstitucion.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpi.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cpi.ES_ACTIVO = 1
			INNER JOIN transaccional.carreras_por_institucion ci ON cpi.ID_CARRERAS_POR_INSTITUCION = ci.ID_CARRERAS_POR_INSTITUCION AND ci.ES_ACTIVO = 1
			INNER JOIN sistema.enumerado enumera ON p.SEXO_PERSONA = enumera.ID_ENUMERADO 
			INNER JOIN sistema.enumerado tipo_doc ON tipo_doc.ID_ENUMERADO= p.ID_TIPO_DOCUMENTO
	WHERE ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO 
			AND NUMERO_DOCUMENTO_PERSONA = @ID_NUMERO_DOCUMENTO 
			AND pinstitucion.ID_INSTITUCION = @ID_INSTITUCION 
			AND cpi.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION 
			AND ci.ID_CARRERA = @ID_CARRERA 
			AND einstitucion.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
			AND p.ESTADO=1

	SELECT @ID_SEMESTRE_ACTUAL = MAX(ISNULL(me.ID_SEMESTRE_ACADEMICO,estinst.ID_SEMESTRE_ACADEMICO))--, @SEMESTRE_ACTUAL = e.VALOR_ENUMERADO
	FROM #tmpPersonaReporteAcademico pr 
		INNER JOIN maestro.persona_institucion perinst ON pr.ID_PERSONA = perinst.ID_PERSONA AND perinst.ESTADO=1
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON perinst.ID_INSTITUCION = i.ID_INSTITUCION 
		INNER JOIN transaccional.estudiante_institucion estinst ON perinst.ID_PERSONA_INSTITUCION = estinst.ID_PERSONA_INSTITUCION AND estinst.ES_ACTIVO = 1
		INNER JOIN transaccional.carreras_por_institucion_detalle cpid ON cpid.ID_CARRERAS_POR_INSTITUCION_DETALLE = estinst.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cpid.ES_ACTIVO = 1
		INNER JOIN transaccional.carreras_por_institucion cpi ON cpi.ID_CARRERAS_POR_INSTITUCION = cpid.ID_CARRERAS_POR_INSTITUCION AND cpi.ES_ACTIVO=1
		INNER JOIN sistema.enumerado e ON e.ID_ENUMERADO = estinst.ID_SEMESTRE_ACADEMICO
		LEFT JOIN transaccional.matricula_estudiante me ON me.ID_ESTUDIANTE_INSTITUCION = estinst.ID_ESTUDIANTE_INSTITUCION AND me.ES_ACTIVO = 1 AND me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION <= @ID_PERIODO_LECTIVO_INSTITUCION
	WHERE perinst.ID_INSTITUCION = @ID_INSTITUCION AND cpid.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION AND cpi.ID_CARRERA = @ID_CARRERA AND estinst.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
	
	SET @SEMESTRE_ACTUAL = (SELECT VALOR_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO = @ID_SEMESTRE_ACTUAL)
	
	IF EXISTS (SELECT TOP 1 ID_PERSONA FROM #tmpPersonaReporteAcademico)
	BEGIN --> Validar Existencia de Datos
		SELECT	
			--i.ID_INSTITUCION,
			--i.NOMBRE_INSTITUCION,
			--SI.ID_SEDE_INSTITUCION,
			--SI.NOMBRE_SEDE,
			--c.ID_CARRERA,
			--c.NOMBRE_CARRERA,
			--udidactica.ID_SEMESTRE_ACADEMICO,
			--E_CICLO.VALOR_ENUMERADO as SEMESTRE_ACADEMICO,
			--PC.ID_PERIODO_ACADEMICO,
			--PA.NOMBRE_PERIODO_ACADEMICO,
			--udidactica.NOMBRE_UNIDAD_DIDACTICA,
			--PES.ID_ENUMERADO as IdPlanEstudios,
			--PES.VALOR_ENUMERADO as PlanEstudios,
			p.ID_PERSONA,
			p.TIPO_DOCUMENTO_PERSONA,
			p.NUMERO_DOCUMENTO_PERSONA,
			NOMBRE_ESTUDIANTE,
			--PL.CODIGO_PERIODO_LECTIVO,
			--i.TIPO_GESTION_NOMBRE,
			--enumera.VALOR_ENUMERADO,
			--enu.VALOR_ENUMERADO as CICLO, 
			p.ID_ESTUDIANTE_INSTITUCION,
			--mestudiante.ID_MATRICULA_ESTUDIANTE,
			udoenfoque.ID_UNIDAD_DIDACTICA,
			MAX(ed.NOTA) NOTA
			--udidactica.HORAS,
			--udidactica.CREDITOS,
			INTO #TmpDetalleNotaMatricula
		FROM #tmpPersonaReporteAcademico p 
			--INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON ci.ID_CARRERA = c.ID_CARRERA
			--INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON pinstitucion.ID_INSTITUCION = i.ID_INSTITUCION
			--INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION= cpi.ID_SEDE_INSTITUCION AND SI.ES_ACTIVO=1
			INNER JOIN transaccional.matricula_estudiante mestudiante ON p.ID_ESTUDIANTE_INSTITUCION = mestudiante.ID_ESTUDIANTE_INSTITUCION AND mestudiante.ES_ACTIVO = 1
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCXME ON mestudiante.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE AND PCXME.ES_ACTIVO=1
			--INNER JOIN transaccional.programacion_clase PC ON PC.ID_PROGRAMACION_CLASE= PCXME.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1
			INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udppclase ON PCXME.ID_PROGRAMACION_CLASE = udppclase.ID_PROGRAMACION_CLASE 
			INNER JOIN transaccional.unidades_didacticas_por_enfoque udoenfoque ON udppclase.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = udoenfoque.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE 
			INNER JOIN transaccional.evaluacion_detalle ed on ed.ID_MATRICULA_ESTUDIANTE = mestudiante.ID_MATRICULA_ESTUDIANTE AND ed.ES_ACTIVO=1
			INNER JOIN transaccional.evaluacion e ON e.ID_EVALUACION = ed.ID_EVALUACION AND e.ID_PROGRAMACION_CLASE = PCXME.ID_PROGRAMACION_CLASE AND e.ID_UNIDAD_DIDACTICA = udoenfoque.ID_UNIDAD_DIDACTICA AND e.ES_ACTIVO=1
			--INNER JOIN transaccional.unidad_didactica udidactica ON udoenfoque.ID_UNIDAD_DIDACTICA = udidactica.ID_UNIDAD_DIDACTICA 
			--INNER JOIN transaccional.modulo M ON M.ID_MODULO= udidactica.ID_MODULO AND M.ES_ACTIVO=1
			--INNER JOIN transaccional.plan_estudio PE ON PE.ID_PLAN_ESTUDIO= M.ID_PLAN_ESTUDIO AND PE.ES_ACTIVO=1
			--INNER JOIN transaccional.periodo_academico PA ON PA.ID_PERIODO_ACADEMICO= PC.ID_PERIODO_ACADEMICO AND PA.ES_ACTIVO=1
			--INNER JOIN transaccional.periodos_lectivos_por_institucion PLXI ON PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= mestudiante.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  AND PLXI.ES_ACTIVO=1
			--INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO= PLXI.ID_PERIODO_LECTIVO AND PLXI.ES_ACTIVO = 1
			--INNER JOIN sistema.enumerado enu ON einstitucion.ID_SEMESTRE_ACADEMICO = enu.ID_ENUMERADO 
			--INNER JOIN sistema.enumerado PES ON PE.ID_TIPO_ITINERARIO = PES.ID_ENUMERADO 
			--INNER JOIN sistema.enumerado E_CICLO ON E_CICLO.ID_ENUMERADO= udidactica.ID_SEMESTRE_ACADEMICO
		WHERE mestudiante.ID_PERIODOS_LECTIVOS_POR_INSTITUCION <= @ID_PERIODO_LECTIVO_INSTITUCION
			
		GROUP BY p.ID_PERSONA,p.TIPO_DOCUMENTO_PERSONA,p.NUMERO_DOCUMENTO_PERSONA,p.NOMBRE_ESTUDIANTE,
		p.ID_ESTUDIANTE_INSTITUCION,udoenfoque.ID_UNIDAD_DIDACTICA
	
		--Obtenemos todas las unidades didácticas del plan de estudio
		SELECT Total = count(1) OVER (),
			@CODIGO_PERIODO_LECTIVO CODIGO_PERIODO_LECTIVO,
			@SEMESTRE_ACTUAL SEMESTRE_ACTUAL,
			i.ID_INSTITUCION,
			i.CODIGO_MODULAR,
			i.NOMBRE_INSTITUCION,
			si.ID_SEDE_INSTITUCION,
			si.NOMBRE_SEDE,
			c.ID_CARRERA,
			c.NOMBRE_CARRERA,
			pe.ID_PLAN_ESTUDIO,
			pe.NOMBRE_PLAN_ESTUDIOS,
			pe.ID_TIPO_ITINERARIO,
			e_pe.VALOR_ENUMERADO NOMBRE_TIPO_ITINERARIO,
			NUMERO_DOCUMENTO_PERSONA = (SELECT TOP 1 NUMERO_DOCUMENTO_PERSONA from #tmpPersonaReporteAcademico),
			TIPO_DOCUMENTO_PERSONA = (SELECT TOP 1 TIPO_DOCUMENTO_PERSONA from #tmpPersonaReporteAcademico),
			ESTUDIANTE = (SELECT TOP 1 NOMBRE_ESTUDIANTE from #tmpPersonaReporteAcademico),
			FOTO = (SELECT TOP 1 FOTO from #tmpPersonaReporteAcademico),
			e_ciclo.VALOR_ENUMERADO SEMESTRE_ACADEMICO_UD,
			ud.ID_UNIDAD_DIDACTICA,
			UPPER(ud.NOMBRE_UNIDAD_DIDACTICA) NOMBRE_UNIDAD_DIDACTICA,
			HORAS,
			CREDITOS,
			DETALLE.NOTA
			FROM transaccional.carreras_por_institucion ci
				INNER JOIN transaccional.carreras_por_institucion_detalle cpi ON cpi.ID_CARRERAS_POR_INSTITUCION = ci.ID_CARRERAS_POR_INSTITUCION AND cpi.ES_ACTIVO=1 AND ci.ES_ACTIVO=1
				INNER JOIN maestro.sede_institucion si ON si.ID_SEDE_INSTITUCION = cpi.ID_SEDE_INSTITUCION AND si.ES_ACTIVO=1
				INNER JOIN transaccional.plan_estudio pe ON pe.ID_CARRERAS_POR_INSTITUCION=ci.ID_CARRERAS_POR_INSTITUCION AND pe.ES_ACTIVO=1
				--INNER JOIN transaccional.enfoques_por_plan_estudio eppe ON eppe.ID_PLAN_ESTUDIO=pe.ID_PLAN_ESTUDIO
				--INNER JOIN transaccional.unidades_didacticas_por_enfoque udpe ON udpe.ID_ENFOQUES_POR_PLAN_ESTUDIO=eppe.ID_ENFOQUES_POR_PLAN_ESTUDIO
				INNER JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
				INNER JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO=m.ID_MODULO AND ud.ES_ACTIVO=1
				INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON i.ID_INSTITUCION=ci.ID_INSTITUCION
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON c.ID_CARRERA=ci.ID_CARRERA
				INNER JOIN sistema.enumerado e_ciclo ON e_ciclo.ID_ENUMERADO= ud.ID_SEMESTRE_ACADEMICO
				INNER JOIN sistema.enumerado e_pe ON e_pe.ID_ENUMERADO=pe.ID_TIPO_ITINERARIO
			LEFT JOIN #TmpDetalleNotaMatricula DETALLE ON ud.ID_UNIDAD_DIDACTICA=DETALLE.ID_UNIDAD_DIDACTICA
		WHERE i.ID_INSTITUCION = @ID_INSTITUCION AND c.ID_CARRERA = @ID_CARRERA AND cpi.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
		ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.NOMBRE_UNIDAD_DIDACTICA

		DROP TABLE #TmpDetalleNotaMatricula
	END
    ELSE BEGIN
		SELECT 0 Total
	END
	DROP TABLE #tmpPersonaReporteAcademico
END