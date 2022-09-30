/**********************************************************************************************************
AUTOR				:	Henry Orellano
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el listado de evaluaciones según tipo de consulta (1 -> alumnos, 2 ->docentes).
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			16/01/2020		MALVA			SE AÑADEN FILTROS @ID_TIPO_ITINERARIO Y @ID_PLAN_ESTUDIO
--											SE OBTIENEN COLUMNA PlanEstudios.
1.1			05/03/2020		MALVA           MODIFICACIÓN POR OPTIMIZACIÓN DE CONSULTA
1.2			08/06/2020		MALVA			FILTRO CORRECTO DE @CIERRE_PROGRAMACION, OPTIMIZAR CONSULTA.
1.3			25/01/2021		JCHAVEZ			Se agregó valor a @ID_CARRERA Y @ID_UNIDAD_DIDACTICA
2.0			06/08/2021		JCHAVEZ			Se agregó variable table @matricula_estudiante y @matricula_programacion_clase para optimizar la consulta 
*/
--  TEST:			
/*
USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA_ALUMNOS 1106, 10319, 0, '', 0, 0, 2255, 0,0,0,0,2,0,0,0
USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA_ALUMNOS 889, 308, 0, '', 0, 0, 0, 0,0,0,234,2,0,0,0
USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA_ALUMNOS 599,157,0,0,1311,0,0,0,0,112,0,2,0,0,0,1,10
***********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA_ALUMNOS](
	@ID_INSTITUCION							INT, 
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT, 
	@ID_SEDE_INSTITUCION					INT, 	 
	@ID_PERSONAL_INSTITUCION                INT,
	@ID_CARRERA								INT, 
	@ID_UNIDAD_DIDACTICA					INT, 
	@ID_PERIODO_ACADEMICO					INT,
	@ID_TURNOS_POR_INSTITUCION				INT, 
	@ID_SECCION								INT, 
	@ID_SEMESTRE_ACADEMICO					INT,
	@CIERRE_PROGRAMACION					INT,
	@TIPO_CONSULTA							CHAR(1), 
	@ID_PROGRAMACION_CLASE					INT =0,
	@ID_TIPO_ITINERARIO						INT,
	@ID_PLAN_ESTUDIO						INT, 	
	@Pagina									INT	=1, 
	@Registros								INT	=10


	--DECLARE @ID_INSTITUCION							INT=6
	--DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT= 1667
	--DECLARE @ID_SEDE_INSTITUCION					INT =0	 
	--DECLARE @ID_PERSONAL_INSTITUCION                INT=0
	--DECLARE @ID_CARRERA								INT =0
	--DECLARE @ID_UNIDAD_DIDACTICA					INT =0
	--DECLARE @ID_PERIODO_ACADEMICO					INT=0
	--DECLARE @ID_TURNOS_POR_INSTITUCION				INT =0
	--DECLARE @ID_SECCION								INT =0
	--DECLARE @ID_SEMESTRE_ACADEMICO					INT=0
	--DECLARE @CIERRE_PROGRAMACION					INT=0
	--DECLARE @TIPO_CONSULTA							CHAR(1)='2' 	
	--DECLARE @Pagina									INT	=1 
	--DECLARE @Registros								INT	=10 
)
AS  
BEGIN  
	SET NOCOUNT ON;
	PRINT @CIERRE_PROGRAMACION
	DECLARE @desde INT , @hasta INT;
	DECLARE @NombreInstituto varchar (150)
	DECLARE @ESTADO_ABIERTO INT = 234
	DECLARE @ESTADO_CERRADO INT = 235

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
		--Valida antes de crear tabla temporal
	IF (OBJECT_ID('tempdb.dbo.#TempTabla','U')) IS NOT NULL
	DROP TABLE #TempTabla
	
	--Valida antes de crear tabla temporal
	IF (OBJECT_ID('tempdb.dbo.#TempTabla2','U')) IS NOT NULL
	DROP TABLE #TempTabla2
	select @NombreInstituto = NOMBRE_INSTITUCION from db_auxiliar.dbo.UVW_INSTITUCION where ID_INSTITUCION = @ID_INSTITUCION

	DECLARE @matricula_estudiante TABLE (ID_MATRICULA_ESTUDIANTE ID, ID_PERIODOS_LECTIVOS_POR_INSTITUCION ID, ID_ESTUDIANTE_INSTITUCION ID)
	DECLARE @matricula_programacion_clase TABLE (ID_PERIODOS_LECTIVOS_POR_INSTITUCION ID, ID_MATRICULA_ESTUDIANTE ID, ID_ESTUDIANTE_INSTITUCION ID,
												 ID_PROGRAMACION_CLASE ID, ID_TURNOS_POR_INSTITUCION ID, ID_SECCION ID, ID_PERIODO_ACADEMICO ID,
												 ID_SEDE_INSTITUCION ID, ID_PERSONAL_INSTITUCION ID)

	INSERT INTO @matricula_estudiante
	SELECT ID_MATRICULA_ESTUDIANTE, ID_PERIODOS_LECTIVOS_POR_INSTITUCION,ID_ESTUDIANTE_INSTITUCION
	FROM transaccional.matricula_estudiante
	WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND ES_ACTIVO=1

	INSERT INTO @matricula_programacion_clase
	SELECT	ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION, ME.ID_MATRICULA_ESTUDIANTE,ME.ID_ESTUDIANTE_INSTITUCION,
			PC.ID_PROGRAMACION_CLASE, ID_TURNOS_POR_INSTITUCION, ID_SECCION, ID_PERIODO_ACADEMICO,
			PC.ID_SEDE_INSTITUCION, PC.ID_PERSONAL_INSTITUCION
	FROM @matricula_estudiante ME
	INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCXME ON ME.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE AND PCXME.ES_ACTIVO=1
	INNER JOIN transaccional.programacion_clase PC ON PC.ID_PROGRAMACION_CLASE= PCXME.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1

	IF (@TIPO_CONSULTA IS NULL ) SET @TIPO_CONSULTA = 1 --> NO QUITAR, por reporte
	
	SELECT  SI.ID_SEDE_INSTITUCION  IdSedeInstitucion,
	SI.NOMBRE_SEDE					Sede,
	C.ID_CARRERA					IdCarrera,
	C.NOMBRE_CARRERA				ProgramaEstudio,
	UD.ID_SEMESTRE_ACADEMICO,
	E_CICLO.VALOR_ENUMERADO			SemestreAcademico,
	MPC.ID_TURNOS_POR_INSTITUCION	IdTurnoInstitucion,
	E_TURNO.VALOR_ENUMERADO			Turno,
	MPC.ID_SECCION					IdSeccion,
	E_SECCION.VALOR_ENUMERADO		Seccion,
	MPC.ID_PERIODO_ACADEMICO			IdPeriodoClases,
	PA.NOMBRE_PERIODO_ACADEMICO		Periodo_clases,
	UD.ID_UNIDAD_DIDACTICA			IdUnidadDidactica,
	UD.NOMBRE_UNIDAD_DIDACTICA		UnidadDidactica,
	MPC.ID_MATRICULA_ESTUDIANTE		IdMatriculaEstudiante,
	P.ID_PERSONA,
	P.NUMERO_DOCUMENTO_PERSONA		IdEstudiante,
	tipo_doc.VALOR_ENUMERADO		TipoDocumento,
	UPPER(P.APELLIDO_PATERNO_PERSONA) + ' '+ UPPER(P.APELLIDO_MATERNO_PERSONA)+ ', ' + dbo.UFN_CAPITALIZAR( P.NOMBRE_PERSONA) AS NombreAlumno,
	PINS.ID_ROL,
	P_D.NUMERO_DOCUMENTO_PERSONA	IdDocente,
	PINS.ID_PERSONAL_INSTITUCION	IdPersonalInstitucion,
	(CASE WHEN P_D.APELLIDO_PATERNO_PERSONA <> '' THEN  UPPER(P_D.APELLIDO_PATERNO_PERSONA)	+' ' ELSE '' END)  + UPPER(P_D.APELLIDO_MATERNO_PERSONA)	+', '+ dbo.UFN_CAPITALIZAR( P_D.NOMBRE_PERSONA) AS Docente,
	E.ID_EVALUACION							AS IdEvaluacion,
	convert(varchar(2), CAST(E_D.NOTA AS INT))	AS Nota,
	MPC.ID_PROGRAMACION_CLASE						AS IdProgramacionClase,
	isnull(E.CIERRE_PROGRAMACION,234)			AS IdEstadoCierre,
	isnull(EC1.VALOR_ENUMERADO, 'ABIERTO')			AS NombreEstadoCierre,		
	PL.ID_PERIODO_LECTIVO,
	PL.CODIGO_PERIODO_LECTIVO						Periodo_lectivo,
	MPC.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
	@NombreInstituto								NombreInstituto,
	CASE WHEN LICENCIAS_PENDIENTES.ID_TIPO_LICENCIA is NOT NULL AND LICENCIAS_PENDIENTES.ID_REINGRESO_ESTUDIANTE IS NULL THEN cast(0 as BIT)
	ELSE cast( 1 as BIT)	END										EsEvaluacionPermitida,
	P_D.ID_TIPO_DOCUMENTO  AS IdTipoDocDocente,
	P_D.NUMERO_DOCUMENTO_PERSONA	AS NumeroDocDocente,										
	PE.NOMBRE_PLAN_ESTUDIOS	 + ' (' + ti.VALOR_ENUMERADO + ')'		PlanEstudios
	INTO #TempTabla
	FROM 
	--transaccional.matricula_estudiante ME 
	--INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCXME ON ME.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE AND PCXME.ES_ACTIVO=1 --AND ME.ES_ACTIVO=1
	--INNER JOIN transaccional.programacion_clase PC WITH (NOLOCK) ON PC.ID_PROGRAMACION_CLASE= PCXME.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1
	@matricula_programacion_clase MPC
	INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION= MPC.ID_SEDE_INSTITUCION AND SI.ES_ACTIVO=1
	INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC WITH (NOLOCK) ON UDXPC.ID_PROGRAMACION_CLASE= MPC.ID_PROGRAMACION_CLASE AND UDXPC.ES_ACTIVO=1
	INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE WITH (NOLOCK) ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO=1
	INNER JOIN transaccional.unidad_didactica UD WITH (NOLOCK) ON UD.ID_UNIDAD_DIDACTICA= UDXE.ID_UNIDAD_DIDACTICA AND UD.ES_ACTIVO=1
	INNER JOIN transaccional.estudiante_institucion EI WITH (NOLOCK) ON EI.ID_ESTUDIANTE_INSTITUCION= MPC.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1
	INNER JOIN transaccional.modulo M WITH (NOLOCK) ON M.ID_MODULO= UD.ID_MODULO AND M.ES_ACTIVO=1
	INNER JOIN transaccional.plan_estudio PE WITH (NOLOCK) ON PE.ID_PLAN_ESTUDIO= EI.ID_PLAN_ESTUDIO AND M.ID_PLAN_ESTUDIO=PE.ID_PLAN_ESTUDIO AND PE.ES_ACTIVO=1
	INNER JOIN transaccional.carreras_por_institucion CXI WITH (NOLOCK) ON CXI.ID_CARRERAS_POR_INSTITUCION= PE.ID_CARRERAS_POR_INSTITUCION AND CXI.ES_ACTIVO=1
	INNER JOIN db_auxiliar.dbo.UVW_CARRERA C ON C.ID_CARRERA = CXI.ID_CARRERA --AND C.ESTADO=1  --reemplazoPorVista
	INNER JOIN sistema.enumerado E_CICLO ON E_CICLO.ID_ENUMERADO= UD.ID_SEMESTRE_ACADEMICO
	INNER JOIN maestro.turnos_por_institucion TXI ON TXI.ID_TURNOS_POR_INSTITUCION= MPC.ID_TURNOS_POR_INSTITUCION AND TXI.ES_ACTIVO=1
	INNER JOIN maestro.turno_equivalencia TE ON TE.ID_TURNO_EQUIVALENCIA= TXI.ID_TURNO_EQUIVALENCIA 
	INNER JOIN sistema.enumerado E_TURNO ON E_TURNO.ID_ENUMERADO= TE.ID_TURNO
	INNER JOIN sistema.enumerado E_SECCION ON E_SECCION.ID_ENUMERADO= MPC.ID_SECCION
	INNER JOIN transaccional.periodo_academico PA ON PA.ID_PERIODO_ACADEMICO= MPC.ID_PERIODO_ACADEMICO AND PA.ES_ACTIVO=1
	--INNER JOIN transaccional.carreras_por_institucion_detalle CXID WITH (NOLOCK) ON CXID.ID_CARRERAS_POR_INSTITUCION_DETALLE= EI.ID_CARRERAS_POR_INSTITUCION_DETALLE AND CXID.ES_ACTIVO=1
	--AND CXID.ID_CARRERAS_POR_INSTITUCION= CXI.ID_CARRERAS_POR_INSTITUCION
	INNER JOIN maestro.persona_institucion PEI WITH (NOLOCK) ON PEI.ID_PERSONA_INSTITUCION= EI.ID_PERSONA_INSTITUCION 
	INNER JOIN maestro.persona P WITH (NOLOCK) ON P.ID_PERSONA=PEI.ID_PERSONA
	INNER JOIN maestro.personal_institucion PINS WITH (NOLOCK) ON PINS.ID_PERSONAL_INSTITUCION= MPC.ID_PERSONAL_INSTITUCION AND PINS.ES_ACTIVO=1
	INNER JOIN maestro.persona_institucion PEI_D WITH (NOLOCK) ON PEI_D.ID_PERSONA_INSTITUCION=PINS.ID_PERSONA_INSTITUCION
	INNER JOIN maestro.persona P_D WITH (NOLOCK) ON P_D.ID_PERSONA= PEI_D.ID_PERSONA
	INNER JOIN transaccional.periodos_lectivos_por_institucion PLXI ON PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= MPC.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  AND PLXI.ES_ACTIVO=1
	INNER JOIN  maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO= PLXI.ID_PERIODO_LECTIVO 
	INNER JOIN sistema.enumerado tipo_doc ON tipo_doc.ID_ENUMERADO= P.ID_TIPO_DOCUMENTO
	INNER JOIN sistema.enumerado ti ON ti.ID_ENUMERADO = PE.ID_TIPO_ITINERARIO 
	LEFT JOIN transaccional.evaluacion E WITH (NOLOCK) ON E.ID_PROGRAMACION_CLASE= MPC.ID_PROGRAMACION_CLASE AND E.ID_CARRERA=CXI.ID_CARRERA AND E.ID_UNIDAD_DIDACTICA=UD.ID_UNIDAD_DIDACTICA AND E.ES_ACTIVO=1
		--AND (E.CIERRE_PROGRAMACION					= @CIERRE_PROGRAMACION OR @CIERRE_PROGRAMACION=0 OR @CIERRE_PROGRAMACION= 234)
	LEFT JOIN transaccional.evaluacion_detalle E_D WITH (NOLOCK) ON E_D.ID_EVALUACION= E.ID_EVALUACION AND E_D.ES_ACTIVO=1
	AND E_D.ID_MATRICULA_ESTUDIANTE= MPC.ID_MATRICULA_ESTUDIANTE
	LEFT JOIN sistema.enumerado EC1 ON E.CIERRE_PROGRAMACION=EC1.ID_ENUMERADO --AND EC1.ESTADO=1
	LEFT JOIN (SELECT SUBCONSULTA.ID_ESTUDIANTE_INSTITUCION, MAX (SUBCONSULTA.ID_PERIODOS_LECTIVOS_POR_INSTITUCION) ID_ULT_PERIODO_LECTIVO_INSTITUCION 
				FROM 
				(
					SELECT ID_ESTUDIANTE_INSTITUCION, ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM 
					transaccional.reserva_matricula	WHERE ES_ACTIVO=1
					UNION
					SELECT ID_ESTUDIANTE_INSTITUCION, ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM 
					transaccional.licencia_estudiante WHERE ES_ACTIVO=1
				) SUBCONSULTA
				GROUP BY SUBCONSULTA.ID_ESTUDIANTE_INSTITUCION) SUBCONSULTA_ULT_PERIODO_RESERVA_LICENCIA ON SUBCONSULTA_ULT_PERIODO_RESERVA_LICENCIA.ID_ESTUDIANTE_INSTITUCION= EI.ID_ESTUDIANTE_INSTITUCION
	LEFT JOIN (	
				SELECT  tle.ID_LICENCIA_ESTUDIANTE,ID_ESTUDIANTE_INSTITUCION, ID_TIPO_LICENCIA, VALOR_ENUMERADO, tle.ID_PERIODOS_LECTIVOS_POR_INSTITUCION, tre.ID_REINGRESO_ESTUDIANTE
				FROM 
					transaccional.licencia_estudiante tle
					LEFT JOIN transaccional.reingreso_estudiante tre on tle.ID_LICENCIA_ESTUDIANTE = tre.ID_LICENCIA_ESTUDIANTE AND tre.ES_ACTIVO=1							 
					INNER JOIN sistema.enumerado se_tipo_lic on se_tipo_lic.ID_ENUMERADO= tle.ID_TIPO_LICENCIA						
					WHERE tle.ES_ACTIVO =1							
				)
				LICENCIAS_PENDIENTES on LICENCIAS_PENDIENTES.ID_ESTUDIANTE_INSTITUCION = EI.ID_ESTUDIANTE_INSTITUCION 
				AND LICENCIAS_PENDIENTES.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= SUBCONSULTA_ULT_PERIODO_RESERVA_LICENCIA.ID_ULT_PERIODO_LECTIVO_INSTITUCION
		
	WHERE
		--F.ID_INSTITUCION						= @ID_INSTITUCION AND 
		MPC.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND 
		--A.ID_SEDE_INSTITUCION					= @ID_SEDE_INSTITUCION AND 
		(MPC.ID_SEDE_INSTITUCION					= @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0) AND
		(PINS.ID_PERSONAL_INSTITUCION			= @ID_PERSONAL_INSTITUCION OR @ID_PERSONAL_INSTITUCION = '0') AND 
		(C.ID_CARRERA							= @ID_CARRERA OR @ID_CARRERA=0) AND--inconvenientes
		(UD.ID_UNIDAD_DIDACTICA					= @ID_UNIDAD_DIDACTICA OR @ID_UNIDAD_DIDACTICA=0) AND 
		(MPC.ID_PERIODO_ACADEMICO				= @ID_PERIODO_ACADEMICO OR @ID_PERIODO_ACADEMICO=0)	AND
		(MPC.ID_TURNOS_POR_INSTITUCION			= @ID_TURNOS_POR_INSTITUCION OR @ID_TURNOS_POR_INSTITUCION=0) AND
		(MPC.ID_SECCION							= @ID_SECCION OR @ID_SECCION=0) AND	
		--(UD.ID_SEMESTRE_ACADEMICO				= @ID_SEMESTRE_ACADEMICO or @ID_SEMESTRE_ACADEMICO =0) 	AND --inconvenientes
		(MPC.ID_PROGRAMACION_CLASE				=@ID_PROGRAMACION_CLASE OR @ID_PROGRAMACION_CLASE=0) AND
		(PE.ID_TIPO_ITINERARIO					=@ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO =0) AND 
		(PE.ID_PLAN_ESTUDIO						=@ID_PLAN_ESTUDIO	OR @ID_PLAN_ESTUDIO =0)
		/*and ((E.ID_EVALUACION IS NOT NULL AND E.CIERRE_PROGRAMACION = @CIERRE_PROGRAMACION AND @CIERRE_PROGRAMACION =@ESTADO_CERRADO) 
			OR ((E.ID_EVALUACION IS NOT NULL AND E.CIERRE_PROGRAMACION = @CIERRE_PROGRAMACION  OR E.ID_EVALUACION IS NULL)AND @CIERRE_PROGRAMACION =@ESTADO_ABIERTO)
			OR @CIERRE_PROGRAMACION=0 
			)*/
		AND (ISNULL(E.CIERRE_PROGRAMACION,@ESTADO_ABIERTO) = @CIERRE_PROGRAMACION OR @CIERRE_PROGRAMACION=0)
			
-- CREAR OPCIONES PARA MOSTRAR LOS  COMBOS ----------------------------------------


------SE CREA LA TABLA TEMPORAL #TempTabla:  DEPENDIENDO DEL PARAMETRO @ES_DETALLE 
--DECLARE @TIPO_CONSULTA CHAR(1)
--SET @TIPO_CONSULTA = @ES_DETALLE

-- 1. VISTA DETALLE
	IF @TIPO_CONSULTA='1'					
	BEGIN
	;WITH tempPaginadoDetalle AS (
		SELECT  *,    
			--ROW_NUMBER() OVER(ORDER BY Docente ASC) AS Row,
			ROW_NUMBER() OVER(ORDER BY NombreAlumno ASC) AS Row,
			Total = count(1) OVER ()			
		FROM    #TempTabla   	
		)
	SELECT * FROM tempPaginadoDetalle	T
	WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 						
	END
-- 2. VISTA CABECERA		
	IF @TIPO_CONSULTA='2'
	BEGIN		
		select DISTINCT IdProgramacionClase INTO #TempIDS from #TempTabla 

		create table #TempTabla2
		(
			IdProgramacionClase	int,  		 
			ProgramaEstudio	varchar(max),				 
			PlanEstudios		varchar(max),
			UnidadDidactica	varchar(max), 
			SemestreAcademico	varchar (100)
		)
		DECLARE @ID INT = 0
		DECLARE @totales INT = 0
		DECLARE @temp_programas varchar(max) =''
		DECLARE @temp_unidades varchar(max) =''
		DECLARE @temp_semestres varchar(max) =''
		DECLARE @temp_planes varchar(max) =''
		DECLARE @idProgramacionClase int =0

		SET @totales = (select count (1) from #TempIDS)
		WHILE (@ID<@totales)
		BEGIN
			set @idProgramacionClase = (select top 1 IdProgramacionClase from #TempIDS )

			set @temp_programas =null
			set @temp_unidades =null
			set @temp_semestres = null
			set @temp_planes =null

			SELECT @temp_programas = COALESCE(@temp_programas + ', ', '') + rtrim(ltrim(A.ProgramaEstudio)) 
			FROM (SELECT DISTINCT ProgramaEstudio from #TempTabla
			where IdProgramacionClase = @idProgramacionClase) A
			--print '@idProgramacionClase: ' + convert (varchar(20), @idProgramacionClase) + ' - @temp_programas: ' + convert (varchar(max), @temp_programas)

			SELECT @temp_planes = COALESCE(@temp_planes + ', ', '') + rtrim(ltrim(A.PlanEstudios))
			FROM (SELECT DISTINCT PlanEstudios from #TempTabla
			where IdProgramacionClase = @idProgramacionClase) A					
					
			SELECT @temp_unidades = COALESCE(@temp_unidades + ', ', '') + rtrim(ltrim(A.UnidadDidactica)) 
			FROM (SELECT DISTINCT UnidadDidactica from #TempTabla
			where IdProgramacionClase = @idProgramacionClase) A
					
			SELECT @temp_semestres = COALESCE(@temp_semestres + ', ', '') + rtrim(ltrim(A.SemestreAcademico)) 
			FROM (SELECT DISTINCT SemestreAcademico from #TempTabla
			where IdProgramacionClase = @idProgramacionClase) A

			--update 	#TempTabla2
			--set ProgramaEstudio = @temp_programas,
			--	PlanEstudios = @temp_planes,
			--	UnidadDidactica = @temp_unidades,
			--	SemestreAcademico = @temp_semestres
			--where IdProgramacionClase =@idProgramacionClase

			insert into #TempTabla2
			(IdProgramacionClase, ProgramaEstudio, PlanEstudios,  UnidadDidactica, SemestreAcademico)
			values (@idProgramacionClase, @temp_programas,@temp_planes,@temp_unidades, @temp_semestres  )
					
			delete from #TempIDS where IdProgramacionClase = @idProgramacionClase
			SET @ID = @ID + 1

		END
				
		DROP TABLE #TempIDS 
		; WITH tempPaginadoCabecera0 AS (
		SELECT 
			DISTINCT
			t1.IdSedeInstitucion,
			t1.Sede,
			--t1.IdCarrera,					
			t2.ProgramaEstudio,
			t2.PlanEstudios,
			--ID_SEMESTRE_ACADEMICO, 
			t2.SemestreAcademico,
			t1.IdTurnoInstitucion,Turno,
			t1.IdSeccion,
			t1.Seccion,
			t1.ID_PERIODO_LECTIVO,
			t1.Periodo_lectivo,		
			t1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
			t1.IdPeriodoClases,
			t1.Periodo_clases,
			t1.IdEstadoCierre,  --
			t1.IdEvaluacion,  --
			--IdUnidadDidactica,
			t2.UnidadDidactica,
					
			t1.IdPersonalInstitucion,
			t1.Docente,
					
			t2.IdProgramacionClase,
					
			t1.NombreEstadoCierre,
			t1.IdTipoDocDocente,
			t1.NumeroDocDocente
		FROM   #TempTabla t1
		INNER JOIN #TempTabla2 t2 on t1.IdProgramacionClase = t2.IdProgramacionClase
		WHERE t2.IdProgramacionClase  in (select IdProgramacionClase from #TempTabla where (ID_SEMESTRE_ACADEMICO = @ID_SEMESTRE_ACADEMICO or @ID_SEMESTRE_ACADEMICO =0)
		and (t1.IdCarrera = @ID_CARRERA or @ID_CARRERA =0)) 
			
		)
		, tempPaginadoCabecera1 as (
		SELECT *,
			ROW_NUMBER() OVER(ORDER BY Docente, SemestreAcademico, UnidadDidactica  ASC) AS Row,
			Total = count(1) OVER ()
			FROM tempPaginadoCabecera0
		)  
		SELECT * FROM tempPaginadoCabecera1 T
		WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 		

	END

-- 3. VISTA POR SEDE		
	IF @TIPO_CONSULTA='3'
	BEGIN
		SELECT DISTINCT  IdSedeInstitucion,Sede	 FROM #TempTabla
	END

-- 4. POR PROGRAMA DE ESTUDIO (CARRERA)
	IF @TIPO_CONSULTA='4'
	BEGIN
		SELECT DISTINCT IdCarrera,ProgramaEstudio	 FROM #TempTabla
	END

--5. LISTA DE UNIDADES DIDACTICAS
	IF @TIPO_CONSULTA='5'
	BEGIN
		SELECT DISTINCT IdUnidadDidactica,UnidadDidactica  FROM #TempTabla
	END
--6. VISTA PARA OBTENER DATA Y ACTUALIZAR CIERRE POR UNIDAD DIDACTICA
	IF @TIPO_CONSULTA='6'					
		BEGIN
		SELECT  IdEvaluacion, IdProgramacionClase
		FROM	#TempTabla					
	END

	DROP TABLE #TempTabla
END
GO


