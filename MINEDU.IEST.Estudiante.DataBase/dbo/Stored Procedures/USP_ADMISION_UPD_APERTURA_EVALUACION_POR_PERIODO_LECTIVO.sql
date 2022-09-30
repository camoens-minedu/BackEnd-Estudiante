/**********************************************************************************************************
AUTOR				:	FERNANDO RAMOS C.
CREACION			:	16/04/2019
LLAMADO POR			:
DESCRIPCION			:	APERTURA PERIODO LECTIVO QUE SE ENCUENTRA YA CERRADO
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			13/09/2021		FRAMOS			CREACIÓN
1.1			04/11/2021		JCHAVEZ			MODIFICACIÓN PARA REGRESAR SEMESTRE SOLO A ESTUDIANTES DE CILO II EN ADELANTE
1.2			02/03/2022		JCHAVEZ			OPTIMIZACIÓN

TEST:			
	EXEC USP_ADMISION_UPD_APERTURA_EVALUACION_POR_PERIODO_LECTIVO 443,1209,24,'20078244'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_APERTURA_EVALUACION_POR_PERIODO_LECTIVO](
	@ID_INSTITUCION INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,
	@ID_PERIODO_ACADEMICO INT,
	@USUARIO VARCHAR(20)
	)
AS
BEGIN

	BEGIN --> DECLARACION DE VARIABLES 
	PRINT ''
		DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION_SIGUIENTE INT;
		DECLARE @NotaMinima INT;
		DECLARE @ExistenEstudiantesMatriculados INT = 0;
		DECLARE @CODIGO_PERIODO_LECTIVO_ACTUAL VARCHAR(40);
		DECLARE @RESULT INT;
	END

	BEGIN --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
		PRINT ''
		IF (OBJECT_ID('tempdb.dbo.#tmpAlumnosPorInstitucionYPeriodoLectivo','U')) IS NOT NULL DROP TABLE #tmpAlumnosPorInstitucionYPeriodoLectivo
		IF (OBJECT_ID('tempdb.dbo.#temp001','U')) IS NOT NULL DROP TABLE #temp001
		IF (OBJECT_ID('tempdb.dbo.#temp002','U')) IS NOT NULL DROP TABLE #temp002
		IF (OBJECT_ID('tempdb.dbo.#temp003','U')) IS NOT NULL DROP TABLE #temp003
		IF (OBJECT_ID('tempdb.dbo.#tmpCriterios','U')) IS NOT NULL DROP TABLE #tmpCriterios
		----
	END

	BEGIN --> OBTENEMOS LA NOTA MINIMA POR INSTITUCION 	
		SET @NotaMinima = (Select ISNULL(VALOR_PARAMETRO,0)  from maestro.parametros_institucion where ID_INSTITUCION =@ID_INSTITUCION AND ESTADO=1)	
	END	

	BEGIN --> OBTENER NUMERO DE DOCUMENTOS DE TODOS LOS ALUMNOS INVOLUCRADOS --> OBTENER ESTUDIANTES POR PERIODO DE CLASES A CERRAR 
	PRINT ''
		SELECT 	
			DISTINCT
			--'#tmpAlumnosPorInstitucionYPeriodoLectivo: Estudiantes por Periodo de Clases' AS Tabla, --borrar		
			I.ID_ESTUDIANTE_INSTITUCION		
		INTO #tmpAlumnosPorInstitucionYPeriodoLectivo 
		FROM 
			transaccional.programacion_clase  A
			INNER JOIN transaccional.unidades_didacticas_por_programacion_clase	B	ON A.ID_PROGRAMACION_CLASE= B.ID_PROGRAMACION_CLASE AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1	
			--INNER JOIN transaccional.unidades_didacticas_por_enfoque C				ON B.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = C.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND C.ES_ACTIVO=1	
			--INNER JOIN transaccional.enfoques_por_plan_estudio D					ON C.ID_ENFOQUES_POR_PLAN_ESTUDIO=D.ID_ENFOQUES_POR_PLAN_ESTUDIO AND D.ES_ACTIVO=1	
			--INNER JOIN transaccional.plan_estudio E								ON D.ID_PLAN_ESTUDIO = E.ID_PLAN_ESTUDIO AND D.ES_ACTIVO=1	
			--INNER JOIN transaccional.carreras_por_institucion F						ON E.ID_CARRERAS_POR_INSTITUCION =F.ID_CARRERAS_POR_INSTITUCION AND F.ES_ACTIVO=1
			--INNER JOIN db_auxiliar.dbo.UVW_CARRERA  G											ON F.ID_CARRERA=G.ID_CARRERA --AND G.ESTADO=1	
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante H	ON A.ID_PROGRAMACION_CLASE = H.ID_PROGRAMACION_CLASE AND H.ES_ACTIVO=1			
			INNER JOIN transaccional.matricula_estudiante I							ON H.ID_MATRICULA_ESTUDIANTE = I.ID_MATRICULA_ESTUDIANTE AND I.ES_ACTIVO=1
			--INNER JOIN transaccional.carreras_por_institucion_detalle J				ON F.ID_CARRERAS_POR_INSTITUCION = J.ID_CARRERAS_POR_INSTITUCION AND A.ID_SEDE_INSTITUCION =J.ID_SEDE_INSTITUCION AND J.ES_ACTIVO=1	
			--SEDES
			--INNER JOIN maestro.sede_institucion	SD1									ON J.ID_SEDE_INSTITUCION=SD1.ID_SEDE_INSTITUCION
			--INNER JOIN maestro.institucion SD2										ON SD1.ID_INSTITUCION=SD2.ID_INSTITUCION		
			--SEMESTRE academico		
			--INNER JOIN sistema.enumerado SA1										ON I.ID_SEMESTRE_ACADEMICO =SA1.ID_ENUMERADO AND SA1.ESTADO=1
			--PERIODO LECTIVO
			INNER JOIN transaccional.periodos_lectivos_por_institucion PL1			ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PL1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND PL1.ES_ACTIVO=1
			--INNER JOIN maestro.periodo_lectivo PL2									ON PL1.ID_PERIODO_LECTIVO=PL2.ID_PERIODO_LECTIVO AND PL2.ESTADO=1
			--PERIODO ACADEMICO / CLASES
			--INNER JOIN transaccional.periodo_academico PA1							ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PA1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and A.ID_PERIODO_ACADEMICO=PA1.ID_PERIODO_ACADEMICO AND PA1.ES_ACTIVO=1
			--UNIDAD DIDACTICA	
			--INNER JOIN transaccional.unidad_didactica UD1							ON C.ID_UNIDAD_DIDACTICA=UD1.ID_UNIDAD_DIDACTICA AND UD1.ES_ACTIVO=1
			--INNER JOIN maestro.tipo_unidad_didactica UD2							ON UD1.ID_TIPO_UNIDAD_DIDACTICA= UD2.ID_TIPO_UNIDAD_DIDACTICA
			--ALUMNO
			--INNER JOIN transaccional.estudiante_institucion EI						ON I.ID_ESTUDIANTE_INSTITUCION=EI.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1
			--INNER JOIN maestro.persona_institucion AL1								ON EI.ID_PERSONA_INSTITUCION=AL1.ID_PERSONA_INSTITUCION AND AL1.ESTADO=1
			--INNER JOIN maestro.persona AL2											ON AL1.ID_PERSONA=AL2.ID_PERSONA AND AL2.ESTADO=1		
			--NOTA
			--INNER JOIN transaccional.evaluacion N1									ON H.ID_PROGRAMACION_CLASE=N1.ID_PROGRAMACION_CLASE AND N1.ES_ACTIVO=1
			--LEFT JOIN transaccional.evaluacion_detalle N2							ON N1.ID_EVALUACION=N2.ID_EVALUACION AND H.ID_MATRICULA_ESTUDIANTE=N2.ID_MATRICULA_ESTUDIANTE AND N2.ES_ACTIVO=1
			--PLAN DE ESTUDIOS
			--INNER JOIN sistema.enumerado PES										ON E.ID_TIPO_ITINERARIO = PES.ID_ENUMERADO
			--INNER JOIN transaccional.promocion_institucion_estudiante K				ON F.ID_INSTITUCION= K.ID_INSTITUCION AND E.ID_TIPO_ITINERARIO=K.TIPO_VERSION AND K.ES_ACTIVO=1
		WHERE
			PL1.ID_INSTITUCION							= @ID_INSTITUCION 
			AND I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION		

	END

	BEGIN --> OBTENER EL SIGUIENTE PERIODO ACADEMICO 
	PRINT ''
		SET @CODIGO_PERIODO_LECTIVO_ACTUAL = (	
													SELECT --TOP 1					
															PL.CODIGO_PERIODO_LECTIVO													
													FROM	transaccional.periodos_lectivos_por_institucion PLI
															INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO = PLI.ID_PERIODO_LECTIVO				
													WHERE 	1 = 1		
															AND PLI.ID_INSTITUCION = @ID_INSTITUCION
															AND PLI.ES_ACTIVO = 1
															AND PLI.ESTADO IN (7,8)
															AND PLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
											)

		SET @ID_PERIODOS_LECTIVOS_POR_INSTITUCION_SIGUIENTE = (
																SELECT TOP 1					
																		--PL.CODIGO_PERIODO_LECTIVO,
																		PLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
																FROM	transaccional.periodos_lectivos_por_institucion PLI
																		INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO = PLI.ID_PERIODO_LECTIVO				
																WHERE 	1 = 1		
																		AND PLI.ID_INSTITUCION = @ID_INSTITUCION
																		AND PLI.ES_ACTIVO = 1
																		AND PLI.ESTADO IN (7,8)
																		AND PL.CODIGO_PERIODO_LECTIVO > @CODIGO_PERIODO_LECTIVO_ACTUAL			
																		ORDER BY PL.CODIGO_PERIODO_LECTIVO ASC
																	)

	END

	BEGIN --> BUSCAR SI LOS ESTUDIANTES YA ESTAN MATRICULADOS 
	PRINT ''

		SELECT
			@ExistenEstudiantesMatriculados = COUNT(tme.ID_MATRICULA_ESTUDIANTE)	

			FROM #tmpAlumnosPorInstitucionYPeriodoLectivo t
					INNER JOIN transaccional.matricula_estudiante tme ON t.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION
					--INNER JOIN transaccional.programacion_matricula tpm on tpm.ID_PROGRAMACION_MATRICULA= tme.ID_PROGRAMACION_MATRICULA and tpm.ES_ACTIVO=1
					--INNER JOIN transaccional.estudiante_institucion tei on tei.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION AND tei.ES_ACTIVO=1
					--INNER JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION = tei.ID_PERSONA_INSTITUCION
					--INNER JOIN maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA
					--INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE 
					--INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION
					--INNER JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION = tci.ID_CARRERAS_POR_INSTITUCION
					--INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA = tci.ID_CARRERA
					--INNER JOIN sistema.enumerado se_semestre on se_semestre.ID_ENUMERADO = tme.ID_SEMESTRE_ACADEMICO
					--INNER JOIN maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION = tei.ID_TURNOS_POR_INSTITUCION
					--INNER JOIN maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA 
					--INNER JOIN sistema.enumerado se_turno on se_turno.ID_ENUMERADO = mte.ID_TURNO
					--INNER JOIN transaccional.periodo_academico tpa on tpa.ID_PERIODO_ACADEMICO= tme.ID_PERIODO_ACADEMICO
					inner join transaccional.periodos_lectivos_por_institucion tpli on tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tme.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
					--inner join maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tpli.ID_PERIODO_LECTIVO
					--INNER JOIN sistema.enumerado se_tipo_itin on se_tipo_itin.ID_ENUMERADO= tpe.ID_TIPO_ITINERARIO
					--INNER JOIN sistema.enumerado se_tipo_mat on se_tipo_mat.ID_ENUMERADO= tpm.ID_TIPO_MATRICULA
					--INNER JOIN #tmpAlumnosPorInstitucionYPeriodoLectivo t ON t.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION --***
			WHERE (tpli.ID_INSTITUCION= @ID_INSTITUCION)		
			AND tme.ES_ACTIVO =1 AND tpli.ES_ACTIVO=1
			AND tme.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION_SIGUIENTE
	END

	BEGIN --> IF: EXISTEN ESTUDIANTES MATRICULADOS / CASO CONTRARIO REABRIR 

		IF @ExistenEstudiantesMatriculados > 0 
			BEGIN --> 'No se puede reabrir el periodo porque existen alumnos matriculados en el siguiente periodo lectivo.' 
				SET @RESULT =  -1 
			END
		ELSE	
			BEGIN --> SI NO HAY MATRICULADOS RESTAURAR UN CICLO ANTERIOR A LOS ESTUDIANTES 

				BEGIN --> REALIZAR EL PROCESO DE CIERRE IDENTIFICANDO LOS ALUMNOS PARA RESTARLE UN CICLO 
				PRINT ''

				--///**************************************************************************************

					BEGIN --VARIABLES ANTIGUAS 
						DECLARE @CRITERIO INT
						DECLARE @ID_SEMESTRE_ACADEMICO INT
					END

					BEGIN --> OBTENER ESTUDIANTES POR PERIODO DE CLASES A CERRAR 
						SELECT 
							A.ID_PROGRAMACION_CLASE,
							PL1.ID_INSTITUCION,
							--SD2.NOMBRE_INSTITUCION						AS NombreInstituto,
							I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
							--PL2.ID_PERIODO_LECTIVO,
							--PL2.CODIGO_PERIODO_LECTIVO,
							E.ID_TIPO_ITINERARIO,
							--PES.VALOR_ENUMERADO,
							E.ID_PLAN_ESTUDIO,		
							C.ID_UNIDAD_DIDACTICA						AS IdUnidadDidactica,
							UD1.NOMBRE_UNIDAD_DIDACTICA					AS UnidadDidactica,
							UD1.ID_TIPO_UNIDAD_DIDACTICA,
							UD2.NOMBRE_TIPO_UNIDAD,
							I.ID_ESTUDIANTE_INSTITUCION,
							--AL2.NUMERO_DOCUMENTO_PERSONA				AS IdEstudiante,
							--AL2.APELLIDO_PATERNO_PERSONA + ' '+ AL2.APELLIDO_MATERNO_PERSONA+ ' ' + AL2.NOMBRE_PERSONA AS NombreAlumno,	
							convert(varchar(2), CAST(N2.NOTA AS INT))	AS Nota,
							EI.ID_SEMESTRE_ACADEMICO,
							--G.ID_CARRERA,
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
							INNER JOIN transaccional.plan_estudio E								ON D.ID_PLAN_ESTUDIO = E.ID_PLAN_ESTUDIO AND D.ES_ACTIVO=1	
							--INNER JOIN transaccional.carreras_por_institucion F						ON E.ID_CARRERAS_POR_INSTITUCION =F.ID_CARRERAS_POR_INSTITUCION AND F.ES_ACTIVO=1
							--INNER JOIN db_auxiliar.dbo.UVW_CARRERA G								ON F.ID_CARRERA=G.ID_CARRERA --AND G.ESTADO=1	
							INNER JOIN transaccional.programacion_clase_por_matricula_estudiante H	ON A.ID_PROGRAMACION_CLASE = H.ID_PROGRAMACION_CLASE AND H.ES_ACTIVO=1			
							INNER JOIN transaccional.matricula_estudiante I							ON H.ID_MATRICULA_ESTUDIANTE = I.ID_MATRICULA_ESTUDIANTE AND I.ES_ACTIVO=1
							--INNER JOIN transaccional.carreras_por_institucion_detalle J				ON F.ID_CARRERAS_POR_INSTITUCION = J.ID_CARRERAS_POR_INSTITUCION AND A.ID_SEDE_INSTITUCION =J.ID_SEDE_INSTITUCION AND J.ES_ACTIVO=1	
							--SEDES
							--INNER JOIN maestro.sede_institucion	SD1									ON J.ID_SEDE_INSTITUCION=SD1.ID_SEDE_INSTITUCION
							--INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION SD2							ON SD1.ID_INSTITUCION=SD2.ID_INSTITUCION		
							--SEMESTRE academico		
							--INNER JOIN sistema.enumerado SA1										ON I.ID_SEMESTRE_ACADEMICO =SA1.ID_ENUMERADO AND SA1.ESTADO=1
							--PERIODO LECTIVO
							INNER JOIN transaccional.periodos_lectivos_por_institucion PL1			ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PL1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND PL1.ES_ACTIVO=1
							--INNER JOIN maestro.periodo_lectivo PL2									ON PL1.ID_PERIODO_LECTIVO=PL2.ID_PERIODO_LECTIVO AND PL2.ESTADO=1
							--PERIODO ACADEMICO / CLASES
							--INNER JOIN transaccional.periodo_academico PA1							ON I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=PA1.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and A.ID_PERIODO_ACADEMICO=PA1.ID_PERIODO_ACADEMICO AND PA1.ES_ACTIVO=1
							--UNIDAD DIDACTICA	
							INNER JOIN transaccional.unidad_didactica UD1							ON C.ID_UNIDAD_DIDACTICA=UD1.ID_UNIDAD_DIDACTICA AND UD1.ES_ACTIVO=1
							INNER JOIN maestro.tipo_unidad_didactica UD2							ON UD1.ID_TIPO_UNIDAD_DIDACTICA= UD2.ID_TIPO_UNIDAD_DIDACTICA
							--ALUMNO
							INNER JOIN transaccional.estudiante_institucion EI						ON I.ID_ESTUDIANTE_INSTITUCION=EI.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1
							--INNER JOIN maestro.persona_institucion AL1								ON EI.ID_PERSONA_INSTITUCION=AL1.ID_PERSONA_INSTITUCION AND AL1.ESTADO=1
							--INNER JOIN maestro.persona AL2											ON AL1.ID_PERSONA=AL2.ID_PERSONA AND AL2.ESTADO=1		
							--NOTA
							INNER JOIN transaccional.evaluacion N1									ON H.ID_PROGRAMACION_CLASE=N1.ID_PROGRAMACION_CLASE AND N1.ES_ACTIVO=1
							LEFT JOIN transaccional.evaluacion_detalle N2							ON N1.ID_EVALUACION=N2.ID_EVALUACION AND H.ID_MATRICULA_ESTUDIANTE=N2.ID_MATRICULA_ESTUDIANTE AND N2.ES_ACTIVO=1
							--PLAN DE ESTUDIOS
							--INNER JOIN sistema.enumerado PES										ON E.ID_TIPO_ITINERARIO = PES.ID_ENUMERADO
							INNER JOIN transaccional.promocion_institucion_estudiante K				ON PL1.ID_INSTITUCION= K.ID_INSTITUCION AND E.ID_TIPO_ITINERARIO=K.TIPO_VERSION AND K.ES_ACTIVO=1 AND K.ESTADO=1
						WHERE
							PL1.ID_INSTITUCION							= @ID_INSTITUCION 
							AND I.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION

					END

					BEGIN --> OBTENER TABLA TEMPORAL002 

					;WITH total00 as ( --OBTENER TABLA TEMP002 
							select  ID_ESTUDIANTE_INSTITUCION,
							count(*) as cantTotal00		
							from #temp001		
							group by ID_ESTUDIANTE_INSTITUCION
						), total as (
							select ID_ESTUDIANTE_INSTITUCION, 
							ID_TIPO_UNIDAD_DIDACTICA,NOMBRE_TIPO_UNIDAD,													ID_TIPO_ITINERARIO, --**
							count(*) as cantSubTotal		
							from #temp001
							group by ID_ESTUDIANTE_INSTITUCION,ID_TIPO_UNIDAD_DIDACTICA,NOMBRE_TIPO_UNIDAD					,ID_TIPO_ITINERARIO --**
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
						 select --'#temp002: Estudiantes con notas ya procesadas para realizar validaciones' AS Tabla,
						 a.ID_ESTUDIANTE_INSTITUCION,		a.ID_TIPO_ITINERARIO,		a.ID_TIPO_UNIDAD_DIDACTICA,		a.NOMBRE_TIPO_UNIDAD,																
						 b.cantTotal00, a.cantSubTotal, isnull(c.CantAprobados,0) as CantAprobados, isnull(d.CantDesaprobados,0) as CantDesaprobados,
						 round((100*isnull(c.CantAprobados,0))/Cast(isnull(b.cantTotal00,1) as decimal(10,2)),2) as porcentaje
						 into #temp002
						 from total a
						 left join total00 b on a.ID_ESTUDIANTE_INSTITUCION=b.ID_ESTUDIANTE_INSTITUCION
						 left join aprobados c on a.ID_ESTUDIANTE_INSTITUCION= c.ID_ESTUDIANTE_INSTITUCION and a.ID_TIPO_UNIDAD_DIDACTICA= c.ID_TIPO_UNIDAD_DIDACTICA
						 LEFT JOIN desaprobados d on a.ID_ESTUDIANTE_INSTITUCION=d.ID_ESTUDIANTE_INSTITUCION and a.ID_TIPO_UNIDAD_DIDACTICA=d.ID_TIPO_UNIDAD_DIDACTICA

					END

					BEGIN --> OBTENER CRITERIOS DEL LISTADO DE PROMOCION POR INSTITUCION 
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
						INNER JOIN maestro.tipo_unidad_didactica tud			ON piest.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA 
						INNER JOIN sistema.enumerado enumera					ON piest.CRITERIO = enumera.ID_ENUMERADO
					WHERE 
						piest.ID_INSTITUCION =	@ID_INSTITUCION	
						AND piest.ES_ACTIVO = 1 AND piest.ESTADO = 1
					END

					BEGIN --> TABLA DE ESTUDIANTES APROBADOS 
						 CREATE TABLE #temp003(
						 ID_ESTUDIANTE_INSTITUCION INT
						 )
					END

					BEGIN --> WHILE POR CADA CRITERIO DE PROMOCION 
						--SELECT '************************************************************************************************' AS '************************************************************************************************'
					BEGIN --> DECLARACION DE VARIABLES PARA EL WHILE 
					DECLARE @CANTIDAD_REGISTROS INT;
					DECLARE @CONTADOR_ROW INT = 1;
					DECLARE @ID_TIPO_ITINERARIO INT;
					DECLARE @VALOR INT;
					DECLARE @ID_TIPO_UNIDAD_DIDACTICA INT;
					--
					DECLARE @TIPO_PLAN_ESTUDIOS VARCHAR(100);
					DECLARE @TEXTO_CRITERIO VARCHAR(100);
					END

					BEGIN --> OBTENER CANTIDAD DE PROMOCIONES O CRITERIOS DE EVALUACION 
					SET @CANTIDAD_REGISTROS = (SELECT COUNT(*) FROM #tmpCriterios c)
					END

					BEGIN --> WHILE 

					WHILE @CONTADOR_ROW <= @CANTIDAD_REGISTROS
					BEGIN

						BEGIN --> ELIMINAR REGISTROS DE LA TABLA TEMP003 CUANDO YA SE ACTUALIZO ESTUDIANTE 
						PRINT ''
						DELETE FROM #temp003
						END
	
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
						PRINT ''	

							UPDATE ei
							SET
								ei.ID_SEMESTRE_ACADEMICO	= ( SELECT enum.ID_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = e.ID_TIPO_ENUMERADO AND enum.ORDEN_ENUMERADO = e.ORDEN_ENUMERADO - 1),
								ei.USUARIO_MODIFICACION		= @USUARIO,
								ei.FECHA_MODIFICACION		= GETDATE()
							FROM #temp003 a
							INNER JOIN transaccional.estudiante_institucion ei ON a.ID_ESTUDIANTE_INSTITUCION=ei.ID_ESTUDIANTE_INSTITUCION
							INNER JOIN maestro.persona_institucion pi ON ei.ID_PERSONA_INSTITUCION = pi.ID_PERSONA_INSTITUCION
							INNER JOIN maestro.persona p ON pi.ID_PERSONA = p.ID_PERSONA
							INNER JOIN sistema.enumerado e ON ei.ID_SEMESTRE_ACADEMICO = e.ID_ENUMERADO
							WHERE ei.ID_SEMESTRE_ACADEMICO > 111 --versión 1.1 
						END
		
						BEGIN --> CONTADOR AUTOINCREMENTAL PARA BUCLE 
							PRINT ''
							SET @CONTADOR_ROW = @CONTADOR_ROW + 1;
						END
	
						BEGIN --DESCOMENTAR PARA PRUEBAS 
							PRINT ''
							--SELECT 'Estudiantes a actualizar'AS'TABLA',*, @ID_TIPO_ITINERARIO AS '@ID_TIPO_ITINERARIO', @CRITERIO  AS '@CRITERIO', @VALOR AS '@VALOR' FROM #temp003
							-------------------------
							--SELECT 'UPDATE: Estudiantes por ID_TIPO_ITINERARIO = ' + CAST(@ID_TIPO_ITINERARIO AS VARCHAR(10)) AS 'TABLA',
							--	ei.ID_SEMESTRE_ACADEMICO,
							--	ei.USUARIO_MODIFICACION,
							--	ei.FECHA_MODIFICACION,
							--	'-->' AS '-->',
							--	@ID_TIPO_ITINERARIO AS '@ID_TIPO_ITINERARIO', @CRITERIO  AS '@CRITERIO', @VALOR AS '@VALOR',
							--	e.VALOR_ENUMERADO AS SEMESTRE_ACADEMICO,
							--	ei.ID_ESTUDIANTE_INSTITUCION,
							--	p.NUMERO_DOCUMENTO_PERSONA							
							--FROM #temp003 a
							--INNER JOIN transaccional.estudiante_institucion ei ON a.ID_ESTUDIANTE_INSTITUCION=ei.ID_ESTUDIANTE_INSTITUCION
							--INNER JOIN maestro.persona_institucion pi ON ei.ID_PERSONA_INSTITUCION = pi.ID_PERSONA_INSTITUCION
							--INNER JOIN maestro.persona p ON pi.ID_PERSONA = p.ID_PERSONA
							--INNER JOIN sistema.enumerado e ON ei.ID_SEMESTRE_ACADEMICO = e.ID_ENUMERADO
						END
	
					END

					END
						--SELECT '************************************************************************************************' AS '************************************************************************************************'
					END
				END

				BEGIN --> CAMBIAR DE ESTADO Y REABRIR LOS PERIODOS DE CLASE 
				
					UPDATE transaccional.programacion_clase 
						SET ESTADO=1,					
						USUARIO_MODIFICACION= @USUARIO,
						FECHA_MODIFICACION=GETDATE()
					FROM transaccional.periodo_academico A
					INNER JOIN transaccional.programacion_clase B	ON A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO  AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1
					INNER JOIN transaccional.evaluacion C			ON B.ID_PROGRAMACION_CLASE=C.ID_PROGRAMACION_CLASE AND C.ES_ACTIVO=1
					WHERE
					A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
					AND A.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO					
				
					UPDATE C 
						SET 
						C.CIERRE_PROGRAMACION = 234,
						C.USUARIO_MODIFICACION= @USUARIO,
						C.FECHA_MODIFICACION=GETDATE()
					FROM transaccional.periodo_academico A
					INNER JOIN transaccional.programacion_clase B	ON A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO  AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1
					INNER JOIN transaccional.evaluacion C			ON B.ID_PROGRAMACION_CLASE=C.ID_PROGRAMACION_CLASE AND C.ES_ACTIVO=1
					WHERE
					A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
					AND A.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO

				END

				--actualizar ID_SEMESTRE_ACADEMICO en caso de corrección
	
				UPDATE EI
				SET EI.ID_SEMESTRE_ACADEMICO = ME.ID_SEMESTRE_ACADEMICO ,
					EI.USUARIO_MODIFICACION = @USUARIO,
					FECHA_MODIFICACION= GETDATE()	
				from transaccional.estudiante_institucion EI 
				INNER JOIN transaccional.matricula_estudiante ME ON EI.ID_ESTUDIANTE_INSTITUCION= ME.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1 AND ME.ES_ACTIVO=1
				where ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
			


				SET @RESULT = 1 --> 'Exitoso'
				EXEC USP_EVALUACION_UPD_PERIODOS_CLASES_CERRADOS @ID_PERIODO_ACADEMICO,@USUARIO -- ACTUALIZAR TABLA transaccional.cierre_periodo_clases
			END

	END

	BEGIN --> IMPRIMIR RESULTADO 
	PRINT ''
	SELECT @RESULT AS '@RESULT';
	END

	BEGIN --> DESCOMENTAR PARA PRUEBAS 
		PRINT ''

		--SELECT '' AS 'RESULTADO PRUEBAS HACIA ABAJO ******************************************************************************************' 
		-------------------------
		--SELECT * FROM #tmpAlumnosPorInstitucionYPeriodoLectivo
		--SELECT @NotaMinima AS '@NotaMinima'
		--SELECT @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AS '@ID_PERIODOS_LECTIVOS_POR_INSTITUCION'
		--SELECT @CODIGO_PERIODO_LECTIVO_ACTUAL AS '@CODIGO_PERIODO_LECTIVO_ACTUAL'
		--SELECT @ID_PERIODOS_LECTIVOS_POR_INSTITUCION_SIGUIENTE AS '@ID_PERIODOS_LECTIVOS_POR_INSTITUCION_SIGUIENTE'
		-------------------------
		--SELECT PL.CODIGO_PERIODO_LECTIVO AS 'CODIGO_PERIODO_LECTIVO_SIGUIENTE' 
		--FROM transaccional.periodos_lectivos_por_institucion PLI INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO = PLI.ID_PERIODO_LECTIVO 
		--WHERE PLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION_SIGUIENTE
		--------
		--SELECT @ExistenEstudiantesMatriculados AS '@ExistenEstudiantesMatriculados'
		--------------------------
		--------------------------
		--SELECT '#tmpCriterios' AS 'TABLA',* FROM #tmpCriterios
		-------------------------
		--SELECT '#temp001: Estudiantes por Periodo de Clases' AS 'TABLA', * FROM #temp001 
		--SELECT '#temp002: Estudiantes con notas ya procesadas para realizar validaciones' AS 'TABLA', * FROM #temp002 
		--SELECT 'UPDATE: Periodo de clases cambia al ESTADO = 1 y CIERRE_PROGRAMACION = 234' AS 'TABLA', 
		--	B.ESTADO, ISNULL(C.CIERRE_PROGRAMACION,0) AS CIERRE_PROGRAMACION, B.USUARIO_MODIFICACION, B.FECHA_MODIFICACION,
		--	'-->' AS '-->',
		--	B.ID_PROGRAMACION_CLASE
		--FROM transaccional.periodo_academico A
		--INNER JOIN transaccional.programacion_clase B	ON A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO  AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1
		--INNER JOIN transaccional.evaluacion C			ON B.ID_PROGRAMACION_CLASE=C.ID_PROGRAMACION_CLASE AND C.ES_ACTIVO=1
		--WHERE
		--A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
		--AND A.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO
		-------------------------
		--SELECT GETDATE() AS 'Ultima corrida'
	END

END
GO


