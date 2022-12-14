/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2018
LLAMADO POR			:
DESCRIPCION			:	Realizar promoción de alumnos en el periodo lectivo
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2018		JTOVAR			Creación
2.0			21/01/2022		JCHAVEZ			Optimización de proceso

TEST:
	--USP_EVALUACION_UPD_PROMOCION_POR_ALUMNO 2163, 5520, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_UPD_PROMOCION_POR_ALUMNO]
(
    @ID_INSTITUCION							INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@USUARIO								VARCHAR(20)
)AS
BEGIN
	SET NOCOUNT ON;

	BEGIN --VARIABLES ANTIGUAS 
		DECLARE @NotaMinima INT
		DECLARE @CRITERIO INT
		DECLARE @ID_SEMESTRE_ACADEMICO INT
		DECLARE @PERIODO_LECTIVO_ANTERIOR INT
	END

	BEGIN --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
		IF (OBJECT_ID('tempdb.dbo.#temp001','U')) IS NOT NULL DROP TABLE #temp001
		IF (OBJECT_ID('tempdb.dbo.#temp001_2','U')) IS NOT NULL DROP TABLE #temp001_2
		IF (OBJECT_ID('tempdb.dbo.#temp002','U')) IS NOT NULL DROP TABLE #temp002
		IF (OBJECT_ID('tempdb.dbo.#temp003','U')) IS NOT NULL DROP TABLE #temp003
		----
	END

	BEGIN --> OBTENEMOS LA NOTA MINIMA POR INSTITUCION 	
		SET @NotaMinima = (Select ISNULL(VALOR_PARAMETRO,0)  from maestro.parametros_institucion where ID_INSTITUCION =@ID_INSTITUCION AND ESTADO=1)	
	END	

	BEGIN --> OBTENER ESTUDIANTES POR PERIODO DE CLASES A CERRAR 
		SELECT '#temp001: Estudiantes por Periodo de Clases' AS Tabla,
			A.ID_PROGRAMACION_CLASE,
			--SD2.ID_INSTITUCION,
			--SD2.NOMBRE_INSTITUCION						AS NombreInstituto,
			I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
			--PL2.ID_PERIODO_LECTIVO,
			--PL2.CODIGO_PERIODO_LECTIVO,
			E.ID_TIPO_ITINERARIO,
			--PES.VALOR_ENUMERADO,
			E.ID_PLAN_ESTUDIO,		
			C.ID_UNIDAD_DIDACTICA						AS IdUnidadDidactica,
			UD1.NOMBRE_UNIDAD_DIDACTICA					AS UnidadDidactica,
			CASE WHEN UD1.ID_TIPO_UNIDAD_DIDACTICA IS NULL THEN 7 ELSE UD1.ID_TIPO_UNIDAD_DIDACTICA END ID_TIPO_UNIDAD_DIDACTICA,
			CASE WHEN UD2.NOMBRE_TIPO_UNIDAD IS NULL THEN 'Curso' ELSE UD2.NOMBRE_TIPO_UNIDAD END  NOMBRE_TIPO_UNIDAD,
			I.ID_ESTUDIANTE_INSTITUCION,
			--AL2.NUMERO_DOCUMENTO_PERSONA				AS IdEstudiante,
			--AL2.APELLIDO_PATERNO_PERSONA + ' '+ AL2.APELLIDO_MATERNO_PERSONA+ ' ' + AL2.NOMBRE_PERSONA AS NombreAlumno,	
			convert(varchar(2), CAST(N2.NOTA AS INT))	AS Nota,
			EI.ID_SEMESTRE_ACADEMICO,
			F.ID_CARRERA,
			--UPPER(G.NOMBRE_CARRERA)						as carrera,
			--SD1.ID_SEDE_INSTITUCION,
			--PA1.ID_PERIODO_ACADEMICO					AS IdPeriodoClases,
			--PA1.NOMBRE_PERIODO_ACADEMICO				AS Periodo_clases,
			--SA1.VALOR_ENUMERADO							AS Ciclo,		
			CASE
				WHEN convert(varchar(2), CAST(N2.NOTA AS INT)) >= @NotaMinima then 'APROBADO'
				WHEN convert(varchar(2), CAST(N2.NOTA AS INT)) < @NotaMinima then 'DESAPROBADO'	
			END  AS ESTADO		
		INTO #temp001
		FROM 
			transaccional.programacion_clase  A
			INNER JOIN transaccional.unidades_didacticas_por_programacion_clase	B	ON A.ID_PROGRAMACION_CLASE= B.ID_PROGRAMACION_CLASE AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1	
			INNER JOIN transaccional.unidades_didacticas_por_enfoque C				ON B.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = C.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND C.ES_ACTIVO=1	
			INNER JOIN transaccional.enfoques_por_plan_estudio D					ON C.ID_ENFOQUES_POR_PLAN_ESTUDIO=D.ID_ENFOQUES_POR_PLAN_ESTUDIO AND D.ES_ACTIVO=1	
			INNER JOIN transaccional.plan_estudio E									ON D.ID_PLAN_ESTUDIO = E.ID_PLAN_ESTUDIO AND D.ES_ACTIVO=1	
			INNER JOIN transaccional.carreras_por_institucion F						ON E.ID_CARRERAS_POR_INSTITUCION =F.ID_CARRERAS_POR_INSTITUCION AND F.ES_ACTIVO=1
			--INNER JOIN db_auxiliar.dbo.UVW_CARRERA G								ON F.ID_CARRERA=G.ID_CARRERA --AND G.ESTADO=1	--reemplazoPorVista
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante H	ON A.ID_PROGRAMACION_CLASE = H.ID_PROGRAMACION_CLASE AND H.ES_ACTIVO=1			
			INNER JOIN transaccional.matricula_estudiante I							ON H.ID_MATRICULA_ESTUDIANTE = I.ID_MATRICULA_ESTUDIANTE AND I.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion_detalle J				ON F.ID_CARRERAS_POR_INSTITUCION = J.ID_CARRERAS_POR_INSTITUCION AND A.ID_SEDE_INSTITUCION =J.ID_SEDE_INSTITUCION AND J.ES_ACTIVO=1	
			--SEDES
			--INNER JOIN maestro.sede_institucion	SD1									ON J.ID_SEDE_INSTITUCION=SD1.ID_SEDE_INSTITUCION
			--INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION SD2							ON SD1.ID_INSTITUCION=SD2.ID_INSTITUCION		
			--SEMESTRE academico		
			--INNER JOIN sistema.enumerado SA1										ON I.ID_SEMESTRE_ACADEMICO =SA1.ID_ENUMERADO AND SA1.ESTADO=1
			--PERIODO LECTIVO
			--INNER JOIN transaccional.periodos_lectivos_por_institucion PL1			ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PL1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND PL1.ES_ACTIVO=1
			--INNER JOIN maestro.periodo_lectivo PL2									ON PL1.ID_PERIODO_LECTIVO=PL2.ID_PERIODO_LECTIVO AND PL2.ESTADO=1
			--PERIODO ACADEMICO / CLASES
			--INNER JOIN transaccional.periodo_academico PA1							ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PA1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and A.ID_PERIODO_ACADEMICO=PA1.ID_PERIODO_ACADEMICO AND PA1.ES_ACTIVO=1
			--UNIDAD DIDACTICA	
			INNER JOIN transaccional.unidad_didactica UD1							ON C.ID_UNIDAD_DIDACTICA=UD1.ID_UNIDAD_DIDACTICA AND UD1.ES_ACTIVO=1
			LEFT JOIN maestro.tipo_unidad_didactica UD2								ON UD1.ID_TIPO_UNIDAD_DIDACTICA= UD2.ID_TIPO_UNIDAD_DIDACTICA
			--ALUMNO
			INNER JOIN transaccional.estudiante_institucion EI						ON I.ID_ESTUDIANTE_INSTITUCION=EI.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1
			--INNER JOIN maestro.persona_institucion AL1								ON EI.ID_PERSONA_INSTITUCION=AL1.ID_PERSONA_INSTITUCION AND AL1.ESTADO=1
			--INNER JOIN maestro.persona AL2											ON AL1.ID_PERSONA=AL2.ID_PERSONA AND AL2.ESTADO=1		
			--NOTA
			INNER JOIN transaccional.evaluacion N1									ON H.ID_PROGRAMACION_CLASE=N1.ID_PROGRAMACION_CLASE AND N1.ID_CARRERA = F.ID_CARRERA AND N1.ID_UNIDAD_DIDACTICA = UD1.ID_UNIDAD_DIDACTICA AND N1.ES_ACTIVO=1
			LEFT JOIN transaccional.evaluacion_detalle N2							ON N1.ID_EVALUACION=N2.ID_EVALUACION AND H.ID_MATRICULA_ESTUDIANTE=N2.ID_MATRICULA_ESTUDIANTE AND N2.ES_ACTIVO=1
			--PLAN DE ESTUDIOS
			--INNER JOIN sistema.enumerado PES										ON E.ID_TIPO_ITINERARIO = PES.ID_ENUMERADO
			--INNER JOIN transaccional.promocion_institucion_estudiante K				ON F.ID_INSTITUCION= K.ID_INSTITUCION AND E.ID_TIPO_ITINERARIO=K.TIPO_VERSION AND K.ES_ACTIVO=1 AND K.ESTADO=1
		WHERE
			F.ID_INSTITUCION							= @ID_INSTITUCION 
			AND I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
	END

	BEGIN --> OBTENER ESTUDIANTES DEL PERIODO DE CLASES ANTERIOR  
		SET @PERIODO_LECTIVO_ANTERIOR = (SELECT DISTINCT ISNULL(a.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,0) ID_PERIODOS_LECTIVOS_ANTERIOR 
										FROM transaccional.periodos_lectivos_por_institucion l 
											LEFT JOIN transaccional.periodos_lectivos_por_institucion a 
											ON l.ID_INSTITUCION = a.ID_INSTITUCION AND l.ES_ACTIVO=1 AND a.ES_ACTIVO=1 AND l.ID_PERIODO_LECTIVO = a.ID_PERIODO_LECTIVO + 1  
											INNER JOIN transaccional.promocion_institucion_estudiante p	
											ON l.ID_INSTITUCION = p.ID_INSTITUCION 
										WHERE l.ID_INSTITUCION = @ID_INSTITUCION 
											AND p.ES_ACTIVO=1 AND p.ESTADO=1
											AND l.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
											AND p.TIPO_PROMOCION = 207 --PROMOCIÓN ANUAL
											AND SUBSTRING(l.NOMBRE_PERIODO_LECTIVO_INSTITUCION, 6, 1) > 1 --PARA DETERMINAR SI ES EL SEGUNDO PERIODO DEL AÑO
										)

		IF @PERIODO_LECTIVO_ANTERIOR > 0
		BEGIN
			SELECT '#temp001: Estudiantes por Periodo de Clases' AS Tabla,
				A.ID_PROGRAMACION_CLASE,
				--SD2.ID_INSTITUCION,
				--SD2.NOMBRE_INSTITUCION						AS NombreInstituto,
				I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
				--PL2.ID_PERIODO_LECTIVO,
				--PL2.CODIGO_PERIODO_LECTIVO,
				E.ID_TIPO_ITINERARIO,
				--PES.VALOR_ENUMERADO,
				E.ID_PLAN_ESTUDIO,		
				C.ID_UNIDAD_DIDACTICA						AS IdUnidadDidactica,
				UD1.NOMBRE_UNIDAD_DIDACTICA					AS UnidadDidactica,
				CASE WHEN UD1.ID_TIPO_UNIDAD_DIDACTICA IS NULL THEN 7 ELSE UD1.ID_TIPO_UNIDAD_DIDACTICA END ID_TIPO_UNIDAD_DIDACTICA,
				CASE WHEN UD2.NOMBRE_TIPO_UNIDAD IS NULL THEN 'Curso' ELSE UD2.NOMBRE_TIPO_UNIDAD END  NOMBRE_TIPO_UNIDAD,
				I.ID_ESTUDIANTE_INSTITUCION,
				--AL2.NUMERO_DOCUMENTO_PERSONA				AS IdEstudiante,
				--AL2.APELLIDO_PATERNO_PERSONA + ' '+ AL2.APELLIDO_MATERNO_PERSONA+ ' ' + AL2.NOMBRE_PERSONA AS NombreAlumno,	
				convert(varchar(2), CAST(N2.NOTA AS INT))	AS Nota,
				EI.ID_SEMESTRE_ACADEMICO,
				F.ID_CARRERA,
				--UPPER(G.NOMBRE_CARRERA)						as carrera,
				--SD1.ID_SEDE_INSTITUCION,
				--PA1.ID_PERIODO_ACADEMICO					AS IdPeriodoClases,
				--PA1.NOMBRE_PERIODO_ACADEMICO				AS Periodo_clases,
				--SA1.VALOR_ENUMERADO							AS Ciclo,		
				CASE
					WHEN convert(varchar(2), CAST(N2.NOTA AS INT)) >= @NotaMinima then 'APROBADO'
					WHEN convert(varchar(2), CAST(N2.NOTA AS INT)) < @NotaMinima then 'DESAPROBADO'	
				END  AS ESTADO		
			INTO #temp001_2
			FROM 
				transaccional.programacion_clase  A
				INNER JOIN transaccional.unidades_didacticas_por_programacion_clase	B	ON A.ID_PROGRAMACION_CLASE= B.ID_PROGRAMACION_CLASE AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1	
				INNER JOIN transaccional.unidades_didacticas_por_enfoque C				ON B.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = C.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND C.ES_ACTIVO=1	
				INNER JOIN transaccional.enfoques_por_plan_estudio D					ON C.ID_ENFOQUES_POR_PLAN_ESTUDIO=D.ID_ENFOQUES_POR_PLAN_ESTUDIO AND D.ES_ACTIVO=1	
				INNER JOIN transaccional.plan_estudio E									ON D.ID_PLAN_ESTUDIO = E.ID_PLAN_ESTUDIO AND D.ES_ACTIVO=1	
				INNER JOIN transaccional.carreras_por_institucion F						ON E.ID_CARRERAS_POR_INSTITUCION =F.ID_CARRERAS_POR_INSTITUCION AND F.ES_ACTIVO=1
				--INNER JOIN db_auxiliar.dbo.UVW_CARRERA G								ON F.ID_CARRERA=G.ID_CARRERA --AND G.ESTADO=1	--reemplazoPorVista
				INNER JOIN transaccional.programacion_clase_por_matricula_estudiante H	ON A.ID_PROGRAMACION_CLASE = H.ID_PROGRAMACION_CLASE AND H.ES_ACTIVO=1			
				INNER JOIN transaccional.matricula_estudiante I							ON H.ID_MATRICULA_ESTUDIANTE = I.ID_MATRICULA_ESTUDIANTE AND I.ES_ACTIVO=1
				INNER JOIN transaccional.carreras_por_institucion_detalle J				ON F.ID_CARRERAS_POR_INSTITUCION = J.ID_CARRERAS_POR_INSTITUCION AND A.ID_SEDE_INSTITUCION =J.ID_SEDE_INSTITUCION AND J.ES_ACTIVO=1	
				--SEDES
				--INNER JOIN maestro.sede_institucion	SD1									ON J.ID_SEDE_INSTITUCION=SD1.ID_SEDE_INSTITUCION
				--INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION SD2							ON SD1.ID_INSTITUCION=SD2.ID_INSTITUCION		
				--SEMESTRE academico		
				INNER JOIN sistema.enumerado SA1										ON I.ID_SEMESTRE_ACADEMICO =SA1.ID_ENUMERADO AND SA1.ESTADO=1
				--PERIODO LECTIVO
				--INNER JOIN transaccional.periodos_lectivos_por_institucion PL1			ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PL1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND PL1.ES_ACTIVO=1
				--INNER JOIN maestro.periodo_lectivo PL2									ON PL1.ID_PERIODO_LECTIVO=PL2.ID_PERIODO_LECTIVO AND PL2.ESTADO=1
				--PERIODO ACADEMICO / CLASES
				--INNER JOIN transaccional.periodo_academico PA1							ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PA1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and A.ID_PERIODO_ACADEMICO=PA1.ID_PERIODO_ACADEMICO AND PA1.ES_ACTIVO=1
				--UNIDAD DIDACTICA	
				INNER JOIN transaccional.unidad_didactica UD1							ON C.ID_UNIDAD_DIDACTICA=UD1.ID_UNIDAD_DIDACTICA AND UD1.ES_ACTIVO=1
				LEFT JOIN maestro.tipo_unidad_didactica UD2								ON UD1.ID_TIPO_UNIDAD_DIDACTICA= UD2.ID_TIPO_UNIDAD_DIDACTICA
				--ALUMNO
				INNER JOIN transaccional.estudiante_institucion EI						ON I.ID_ESTUDIANTE_INSTITUCION=EI.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1
				--INNER JOIN maestro.persona_institucion AL1								ON EI.ID_PERSONA_INSTITUCION=AL1.ID_PERSONA_INSTITUCION AND AL1.ESTADO=1
				--INNER JOIN maestro.persona AL2											ON AL1.ID_PERSONA=AL2.ID_PERSONA AND AL2.ESTADO=1		
				--NOTA
				INNER JOIN transaccional.evaluacion N1									ON H.ID_PROGRAMACION_CLASE=N1.ID_PROGRAMACION_CLASE AND N1.ID_CARRERA = F.ID_CARRERA AND N1.ID_UNIDAD_DIDACTICA = UD1.ID_UNIDAD_DIDACTICA AND N1.ES_ACTIVO=1
				LEFT JOIN transaccional.evaluacion_detalle N2							ON N1.ID_EVALUACION=N2.ID_EVALUACION AND H.ID_MATRICULA_ESTUDIANTE=N2.ID_MATRICULA_ESTUDIANTE AND N2.ES_ACTIVO=1
				--PLAN DE ESTUDIOS
				--INNER JOIN sistema.enumerado PES										ON E.ID_TIPO_ITINERARIO = PES.ID_ENUMERADO
				--INNER JOIN transaccional.promocion_institucion_estudiante K				ON F.ID_INSTITUCION= K.ID_INSTITUCION AND E.ID_TIPO_ITINERARIO=K.TIPO_VERSION AND K.ES_ACTIVO=1 AND K.ESTADO=1
			WHERE
				F.ID_INSTITUCION							= @ID_INSTITUCION 
				AND I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	= @PERIODO_LECTIVO_ANTERIOR
			
				--SE RECUPERAN LAS UNIDADES DIDACTICAS DE LOS ALUMNOS MATRICULADOS EN EL PERIODO ANTERIOR PARA IEST CON REGLAS DE PROMOCION ANUAL
				INSERT INTO #temp001  
				 SELECT t2.* FROM #temp001_2 t2 
				 WHERE CONCAT(t2.ID_ESTUDIANTE_INSTITUCION,'-',t2.ID_PLAN_ESTUDIO) in (SELECT DISTINCT CONCAT(t1.ID_ESTUDIANTE_INSTITUCION,'-',t1.ID_PLAN_ESTUDIO) FROM #temp001 t1)
		END
	END

	BEGIN --> OBTENER TABLA TEMPORAL002 

		;WITH total00 as ( --OBTENER TABLA TEMP002 
				select  ID_ESTUDIANTE_INSTITUCION,
				count(*) as cantTotal00		
				from #temp001		
				group by ID_ESTUDIANTE_INSTITUCION
			), total as (
				select ID_ESTUDIANTE_INSTITUCION, 
				ID_TIPO_UNIDAD_DIDACTICA,NOMBRE_TIPO_UNIDAD,ID_TIPO_ITINERARIO, --**
				count(*) as cantSubTotal		
				from #temp001
				group by ID_ESTUDIANTE_INSTITUCION,ID_TIPO_UNIDAD_DIDACTICA,NOMBRE_TIPO_UNIDAD,ID_TIPO_ITINERARIO --**
			), aprobados as (
				select  ID_ESTUDIANTE_INSTITUCION,ID_TIPO_UNIDAD_DIDACTICA,count(*) as CantAprobados
				from #temp001  
				where ESTADO ='APROBADO'		
				group by ID_ESTUDIANTE_INSTITUCION,ID_TIPO_UNIDAD_DIDACTICA,NOMBRE_TIPO_UNIDAD
			), desaprobados as (
				select  ID_ESTUDIANTE_INSTITUCION,ID_TIPO_UNIDAD_DIDACTICA,count(*) as CantDesaprobados 
				from #temp001  
				where ESTADO ='DESAPROBADO'		
				group by ID_ESTUDIANTE_INSTITUCION,ID_TIPO_UNIDAD_DIDACTICA,NOMBRE_TIPO_UNIDAD
			)
			 SELECT '#temp002: Estudiantes con notas ya procesadas para realizar validaciones' AS Tabla,
			 a.ID_ESTUDIANTE_INSTITUCION,		a.ID_TIPO_ITINERARIO,		
			 case when a.ID_TIPO_UNIDAD_DIDACTICA IS NULL THEN 7 ELSE a.ID_TIPO_UNIDAD_DIDACTICA END ID_TIPO_UNIDAD_DIDACTICA, 
			 case when a.NOMBRE_TIPO_UNIDAD IS NULL THEN 'Curso' ELSE a.NOMBRE_TIPO_UNIDAD END NOMBRE_TIPO_UNIDAD, 	 														
			 b.cantTotal00, a.cantSubTotal, isnull(c.CantAprobados,0) as CantAprobados, isnull(d.CantDesaprobados,0) as CantDesaprobados,
			 --round((100*isnull(c.CantAprobados,0))/Cast(isnull(b.cantTotal00,1) as decimal(10,2)),2) as porcentaje --> no del total
			 round((100*isnull(c.CantAprobados,0))/Cast(isnull(a.cantSubTotal,1) as decimal(10,2)),2) as porcentaje
			 INTO #temp002
			 FROM total a
			 LEFT JOIN total00 b on a.ID_ESTUDIANTE_INSTITUCION=b.ID_ESTUDIANTE_INSTITUCION
			 LEFT JOIN  aprobados c on a.ID_ESTUDIANTE_INSTITUCION= c.ID_ESTUDIANTE_INSTITUCION and a.ID_TIPO_UNIDAD_DIDACTICA= c.ID_TIPO_UNIDAD_DIDACTICA
			 LEFT JOIN desaprobados d on a.ID_ESTUDIANTE_INSTITUCION=d.ID_ESTUDIANTE_INSTITUCION and a.ID_TIPO_UNIDAD_DIDACTICA=d.ID_TIPO_UNIDAD_DIDACTICA

			 --SELECT * FROM #temp002-- <-para revisión
	END

	BEGIN --> OBTENER CRITERIOS DEL LISTADO DE PROMOCION POR INSTITUCION 
		PRINT ''
		------
		IF (OBJECT_ID('tempdb.dbo.#tmpCriterios','U')) IS NOT NULL DROP TABLE #tmpCriterios
		------

		SELECT 
			piest.ID_PROMOCION_INSTITUCION_ESTUDIANTE									ID_PROMOCION_INSTITUCION_ESTUDIANTE,
			piest.ID_INSTITUCION														ID_INSTITUCION,		
			enu.ID_ENUMERADO															ID_TIPO_PROMOCION,
			enu.VALOR_ENUMERADO															TIPO_PROMOCION,
			enumerado.ID_ENUMERADO														ID_TIPO_PLAN_ESTUDIOS,
			enumerado.VALOR_ENUMERADO													TIPO_PLAN_ESTUDIOS,
			tud.ID_TIPO_UNIDAD_DIDACTICA												ID_TIPO_UNIDAD_DIDACTICA,
			tud.NOMBRE_TIPO_UNIDAD														TIPO_UNIDAD_DIDACTICA,
			enumera.ID_ENUMERADO														ID_CRITERIO,
			enumera.VALOR_ENUMERADO														CRITERIO,
			piest.VALOR																	VALOR,
			piest.ES_ACTIVO																ES_ACTIVO,
			ROW_NUMBER() OVER ( ORDER BY piest.ID_PROMOCION_INSTITUCION_ESTUDIANTE)		Row,
			Total = COUNT(1) OVER ( )
		INTO #tmpCriterios
		FROM transaccional.promocion_institucion_estudiante piest 
			INNER JOIN sistema.enumerado enu						ON piest.TIPO_PROMOCION = enu.ID_ENUMERADO 
			INNER JOIN sistema.enumerado enumerado					ON piest.TIPO_VERSION = enumerado.ID_ENUMERADO 
			LEFT JOIN maestro.tipo_unidad_didactica tud			ON piest.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA 
			INNER JOIN sistema.enumerado enumera					ON piest.CRITERIO = enumera.ID_ENUMERADO
		WHERE 
			piest.ID_INSTITUCION =	@ID_INSTITUCION	
			AND piest.ES_ACTIVO = 1 
			AND piest.ESTADO=1 --rfc-13
	END

	BEGIN --> TABLA DE ESTUDIANTES APROBADOS 
		 CREATE TABLE #temp003( ID_ESTUDIANTE_INSTITUCION INT )
	END

	BEGIN --> WHILE POR CADA CRITERIO DE PROMOCION

		BEGIN --> DECLARACION DE VARIABLES PARA EL WHILE 
			DECLARE @CANTIDAD_REGISTROS INT;
			DECLARE @CONTADOR_ROW INT = 1;
			DECLARE @ID_TIPO_ITINERARIO INT;
			DECLARE @VALOR INT;
			DECLARE @ID_TIPO_UNIDAD_DIDACTICA INT;
			--
			DECLARE @TIPO_PLAN_ESTUDIOS VARCHAR(100);
			DECLARE @TEXTO_CRITERIO VARCHAR(100);

			SET @CANTIDAD_REGISTROS = (SELECT COUNT(*) FROM #tmpCriterios c)
		END

		BEGIN --> WHILE 

			WHILE @CONTADOR_ROW <= @CANTIDAD_REGISTROS
			BEGIN
	
				BEGIN --> OBTENER CRITERIO, ID_TIPO_ITINERARIO, @VALOR 
					SET @CRITERIO = (SELECT c.ID_CRITERIO FROM #tmpCriterios c WHERE c.Row = @CONTADOR_ROW)		
					SET @ID_TIPO_ITINERARIO = (SELECT c.ID_TIPO_PLAN_ESTUDIOS FROM #tmpCriterios c WHERE c.Row = @CONTADOR_ROW)
					SET @VALOR = (SELECT c.VALOR FROM #tmpCriterios c WHERE c.Row = @CONTADOR_ROW)
					SET @ID_TIPO_UNIDAD_DIDACTICA = (SELECT c.ID_TIPO_UNIDAD_DIDACTICA FROM #tmpCriterios c WHERE c.Row = @CONTADOR_ROW)
				END

				BEGIN --> CRITERIO 65: PORCENTAJE 
					IF @CRITERIO = 65
					BEGIN PRINT ''
						--CRITERIO: PORCENTAJE
						INSERT INTO #temp003 (ID_ESTUDIANTE_INSTITUCION)
						SELECT a.ID_ESTUDIANTE_INSTITUCION
						FROM #temp002 a				
						WHERE 
						a.porcentaje >= @VALOR
						AND a.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO
						AND a.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA
					END
				END

				BEGIN --> CRITERIO 66: NUMERO 
					IF @CRITERIO = 66
					BEGIN PRINT ''
						--CRITERIO: NUMERO
						INSERT INTO #temp003 (ID_ESTUDIANTE_INSTITUCION)
						SELECT a.ID_ESTUDIANTE_INSTITUCION			
						FROM #temp002 a			
						WHERE 
						a.CantAprobados >= @VALOR
						AND a.ID_TIPO_ITINERARIO = @ID_TIPO_ITINERARIO
						AND a.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA
					END
				END

				BEGIN --> ACTUALIZAR SEMESTRE A ESTUDIANTES QUE APROBARON 
					UPDATE ei
					SET
						ei.ID_SEMESTRE_ACADEMICO	= ( SELECT enum.ID_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = e.ID_TIPO_ENUMERADO AND enum.ORDEN_ENUMERADO = e.ORDEN_ENUMERADO + 1),
						ei.USUARIO_MODIFICACION		= @USUARIO,
						ei.FECHA_MODIFICACION		= GETDATE()
					FROM #temp003 a
					INNER JOIN transaccional.estudiante_institucion ei ON a.ID_ESTUDIANTE_INSTITUCION=ei.ID_ESTUDIANTE_INSTITUCION
					INNER JOIN maestro.persona_institucion pi ON ei.ID_PERSONA_INSTITUCION = pi.ID_PERSONA_INSTITUCION
					INNER JOIN maestro.persona p ON pi.ID_PERSONA = p.ID_PERSONA
					INNER JOIN sistema.enumerado e ON ei.ID_SEMESTRE_ACADEMICO = e.ID_ENUMERADO		
					--
					inner join transaccional.carreras_por_institucion_detalle cid on cid.ID_CARRERAS_POR_INSTITUCION_DETALLE = ei.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cid.ES_ACTIVO =1
					inner join transaccional.carreras_por_institucion ci on ci.ID_CARRERAS_POR_INSTITUCION = cid.ID_CARRERAS_POR_INSTITUCION  AND ci.ES_ACTIVO=1
					INNER JOIN db_auxiliar.dbo.UVW_CARRERA MC ON MC.ID_CARRERA= ci.ID_CARRERA 
					INNER JOIN maestro.nivel_formacion MNF ON MNF.CODIGO_TIPO = MC.TIPO_NIVEL_FORMACION 
					where ei.ID_SEMESTRE_ACADEMICO = (select me.ID_SEMESTRE_ACADEMICO from transaccional.matricula_estudiante me 
														where me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
														and me.ID_ESTUDIANTE_INSTITUCION= ei.ID_ESTUDIANTE_INSTITUCION and me.ES_ACTIVO=1)
						and ei.ID_SEMESTRE_ACADEMICO < ( case when MNF.SEMESTRES_ACADEMICOS = 8 then 138 
															when MNF.SEMESTRES_ACADEMICOS = 6 then 116
															when MNF.SEMESTRES_ACADEMICOS = 4 then 114 
															when MNF.SEMESTRES_ACADEMICOS = 2  then 112 end )		

				END

				BEGIN --> ELIMINAR REGISTROS DE LA TABLA TEMP003 CUANDO YA SE ACTUALIZO ESTUDIANTE 
				PRINT ''
				DELETE FROM #temp003
				END
	
				SET @CONTADOR_ROW = @CONTADOR_ROW + 1; --Incrementador
			END
		END
	END
END
GO


