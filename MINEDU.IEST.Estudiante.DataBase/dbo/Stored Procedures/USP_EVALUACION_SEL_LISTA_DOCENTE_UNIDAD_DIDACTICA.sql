/**********************************************************************************************************
AUTOR				:	Jose Alvaro Del Castillo  Aquino
FECHA DE CREACION	:	21/09/2020
LLAMADO POR			:
DESCRIPCION			:	Listado de docentes con unidades didaticas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			21/09/2020		JDELCASTILLO	Creación
1.1			25/01/2021		JCHAVEZ			Se agregó valor a @ID_CARRERA Y @ID_UNIDAD_DIDACTICA
2.0			06/08/2021		JCHAVEZ			Se agregó variable table @matricula_estudiante para optimizar la consulta 
2.1			10/08/2021		JCHAVEZ			Se agregó campo NotasCompletas
2.2			28/02/2022		JCHAVEZ			Se mejoró campo NotasCompletas
2.3			27/04/2022		JCHAVEZ			Se mejoró inner de la tabla plan_estudio para considerar el campo ID_PLAN_ESTUDIO
											de la tabla estudiante_institucion y mostrar solo clases con estudiantes matriculados

TEST:
		EXEC USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA 383,3938,0,0,0,0,0,0,0,0,0,0,0,0,0,1,10
************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA](
--declare
	@ID_INSTITUCION							INT=1145, 
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT=607, 
	@ID_SEDE_INSTITUCION					INT=0, 	 
	@ID_PERSONAL_INSTITUCION                INT=0,
	@ID_CARRERA								INT=0, 
	@ID_UNIDAD_DIDACTICA					INT=0, 
	@ID_PERIODO_ACADEMICO					INT=0,
	@ID_TURNOS_POR_INSTITUCION				INT=0, 
	@ID_SECCION								INT=0, 
	@ID_SEMESTRE_ACADEMICO					INT=0,
	@CIERRE_PROGRAMACION					INT=0,
	@TIPO_CONSULTA							CHAR(1)='2', 
	@ID_PROGRAMACION_CLASE					INT =0,	
	@ID_TIPO_ITINERARIO						INT =0, 
	@ID_PLAN_ESTUDIO						INT =0,
	@Pagina									INT	=1, 
	@Registros								INT	=10
	)
	AS 
BEGIN
 
 DECLARE @matricula_estudiante TABLE (ID_MATRICULA_ESTUDIANTE ID, ID_PERIODOS_LECTIVOS_POR_INSTITUCION ID, ID_ESTUDIANTE_INSTITUCION ID)

 INSERT INTO @matricula_estudiante
 SELECT ID_MATRICULA_ESTUDIANTE, ID_PERIODOS_LECTIVOS_POR_INSTITUCION,ID_ESTUDIANTE_INSTITUCION
 FROM transaccional.matricula_estudiante
 WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND ES_ACTIVO=1

 SELECT  
	 STUFF(
			(
			select ',',NOMBRE_CARRERA	
			from  db_auxiliar.dbo.UVW_CARRERA
			where ID_CARRERA=TE.IdCarrera
			FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
			, 1, 1, '') as ProgramaEstudio,
	STUFF(
			(
			select ',',X.VALOR_ENUMERADO	
			from  sistema.enumerado X
			where X.ID_ENUMERADO=TE.ID_SEMESTRE_ACADEMICO
			FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
			, 1, 1, '') as SemestreAcademico,
    STUFF(
			(
			select ',',x.NOMBRE_UNIDAD_DIDACTICA 
			from  transaccional.unidad_didactica x
			where x.ID_UNIDAD_DIDACTICA=TE.ID_UNIDAD_DIDACTICA
			FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
			, 1, 1, '') as UnidadDidactica,
	 (CASE WHEN (NroMatriculados > NroEvaluados OR NroMatriculados = 0 OR NroEvaluados = 0) THEN 'NO' ELSE 'SI' END) as NotasCompletas,
     TE.*				 
 FROM( 
	SELECT 	
	      T1.* 
	FROM(
			SELECT TT.*,
				   COUNT(*) OVER () as Total,
				   Row_number() over (order by 
						 TT.Docente,
						STUFF(
								(
							    select ',',e.VALOR_ENUMERADO	
								from  sistema.enumerado e
								where e.ID_ENUMERADO=TT.ID_SEMESTRE_ACADEMICO
								FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
								, 1, 1, ''), 
						STUFF(
								(
								select ',',x.NOMBRE_UNIDAD_DIDACTICA 
								from  transaccional.unidad_didactica x
								where x.ID_UNIDAD_DIDACTICA=TT.ID_UNIDAD_DIDACTICA
								FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
								, 1, 1, '') ASC  
						) as Row,
						NroMatriculados = (SELECT COUNT(PCME.ID_MATRICULA_ESTUDIANTE) 
											FROM @matricula_estudiante ME
											INNER JOIN transaccional.estudiante_institucion EI ON ME.ID_ESTUDIANTE_INSTITUCION = EI.ID_ESTUDIANTE_INSTITUCION
											INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCME ON PCME.ID_MATRICULA_ESTUDIANTE = ME.ID_MATRICULA_ESTUDIANTE AND PCME.ES_ACTIVO = 1
											INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC ON UDXPC.ID_PROGRAMACION_CLASE = PCME.ID_PROGRAMACION_CLASE AND UDXPC.ES_ACTIVO = 1
											INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO = 1
											WHERE PCME.ES_ACTIVO=1 AND PCME.ID_PROGRAMACION_CLASE=TT.IdProgramacionClase AND UDXE.ID_UNIDAD_DIDACTICA=TT.IdUnidadDidactica AND EI.ID_PLAN_ESTUDIO=TT.IdPlanEstudios),
						NroEvaluados = (SELECT COUNT(TED.ID_MATRICULA_ESTUDIANTE) 
										FROM @matricula_estudiante ME
										INNER JOIN transaccional.evaluacion_detalle TED ON TED.ID_MATRICULA_ESTUDIANTE = ME.ID_MATRICULA_ESTUDIANTE
										INNER JOIN transaccional.evaluacion TE ON TE.ID_EVALUACION = TED.ID_EVALUACION AND TE.ES_ACTIVO = 1
										WHERE TED.ES_ACTIVO=1 AND TED.ID_EVALUACION=TT.IdEvaluacion AND TED.NOTA IS NOT NULL AND TE.ID_CARRERA=TT.IdCarrera AND TE.ID_UNIDAD_DIDACTICA=TT.IdUnidadDidactica)
			FROM(
					SELECT 	 	
							DISTINCT
							SI.ID_SEDE_INSTITUCION  IdSedeInstitucion,
							SI.NOMBRE_SEDE					Sede,
							PC.ID_TURNOS_POR_INSTITUCION	IdTurnoInstitucion,
							E_TURNO.VALOR_ENUMERADO			Turno,
							PC.ID_SECCION					IdSeccion,
							E_SECCION.VALOR_ENUMERADO		Seccion,
							PL.ID_PERIODO_LECTIVO,
							PL.CODIGO_PERIODO_LECTIVO		Periodo_lectivo,
							ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
							PC.ID_PERIODO_ACADEMICO			IdPeriodoClases,
							PA.NOMBRE_PERIODO_ACADEMICO		Periodo_clases,
							isnull(E.CIERRE_PROGRAMACION,234)			AS IdEstadoCierre,
							E.ID_EVALUACION							AS IdEvaluacion,
							PINS.ID_PERSONAL_INSTITUCION	IdPersonalInstitucion,
							(CASE WHEN P_D.APELLIDO_PATERNO_PERSONA <> '' THEN  UPPER(P_D.APELLIDO_PATERNO_PERSONA)	+' ' ELSE '' END)  + UPPER(P_D.APELLIDO_MATERNO_PERSONA)	+', '+ dbo.UFN_CAPITALIZAR( P_D.NOMBRE_PERSONA) AS Docente,
							PC.ID_PROGRAMACION_CLASE AS IdProgramacionClase,
							EC1.VALOR_ENUMERADO	AS NombreEstadoCierre,		
							P_D.ID_TIPO_DOCUMENTO AS IdTipoDocDocente,
							P_D.NUMERO_DOCUMENTO_PERSONA	AS NumeroDocDocente,
							UD.ID_SEMESTRE_ACADEMICO,
							CXI.ID_CARRERA IdCarrera,
							UDXE.ID_UNIDAD_DIDACTICA,
							UDXE.ID_UNIDAD_DIDACTICA IdUnidadDidactica,
							PE.ID_PLAN_ESTUDIO IdPlanEstudios,
							PE.NOMBRE_PLAN_ESTUDIOS PlanEstudios
					FROM  
						@matricula_estudiante ME 
						INNER JOIN transaccional.estudiante_institucion EI  WITH (NOLOCK)  ON EI.ID_ESTUDIANTE_INSTITUCION= ME.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1		
						INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCXME ON ME.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE AND PCXME.ES_ACTIVO=1 --AND ME.ES_ACTIVO=1
						INNER JOIN transaccional.programacion_clase PC WITH (NOLOCK)  ON PC.ID_PROGRAMACION_CLASE= PCXME.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1
						INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION= PC.ID_SEDE_INSTITUCION AND SI.ES_ACTIVO=1
						INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC WITH (NOLOCK) ON UDXPC.ID_PROGRAMACION_CLASE= PC.ID_PROGRAMACION_CLASE AND UDXPC.ES_ACTIVO=1
						INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE WITH (NOLOCK) ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO=1
						INNER JOIN transaccional.unidad_didactica UD WITH (NOLOCK) ON UD.ID_UNIDAD_DIDACTICA= UDXE.ID_UNIDAD_DIDACTICA AND UD.ES_ACTIVO=1
						INNER JOIN transaccional.modulo M WITH (NOLOCK) ON M.ID_MODULO= UD.ID_MODULO AND M.ES_ACTIVO=1
						--INNER JOIN transaccional.plan_estudio PE WITH (NOLOCK) ON PE.ID_PLAN_ESTUDIO= M.ID_PLAN_ESTUDIO AND PE.ES_ACTIVO=1
						INNER JOIN transaccional.plan_estudio PE WITH (NOLOCK) ON EI.ID_PLAN_ESTUDIO=PE.ID_PLAN_ESTUDIO AND PE.ID_PLAN_ESTUDIO= M.ID_PLAN_ESTUDIO AND PE.ES_ACTIVO=1 --versión 2.3
						INNER JOIN transaccional.carreras_por_institucion CXI WITH (NOLOCK) ON CXI.ID_CARRERAS_POR_INSTITUCION= PE.ID_CARRERAS_POR_INSTITUCION AND CXI.ES_ACTIVO=1
						INNER JOIN maestro.turnos_por_institucion TXI ON TXI.ID_TURNOS_POR_INSTITUCION= PC.ID_TURNOS_POR_INSTITUCION AND TXI.ES_ACTIVO=1
						INNER JOIN maestro.turno_equivalencia TE ON TE.ID_TURNO_EQUIVALENCIA= TXI.ID_TURNO_EQUIVALENCIA 
						INNER JOIN sistema.enumerado E_TURNO ON E_TURNO.ID_ENUMERADO= TE.ID_TURNO
						INNER JOIN sistema.enumerado E_SECCION ON E_SECCION.ID_ENUMERADO= PC.ID_SECCION
						INNER JOIN transaccional.periodo_academico PA ON PA.ID_PERIODO_ACADEMICO= PC.ID_PERIODO_ACADEMICO AND PA.ES_ACTIVO=1
						INNER JOIN maestro.persona_institucion PEI WITH (NOLOCK) ON PEI.ID_PERSONA_INSTITUCION= EI.ID_PERSONA_INSTITUCION 
						INNER JOIN maestro.personal_institucion PINS WITH (NOLOCK) ON PINS.ID_PERSONAL_INSTITUCION= PC.ID_PERSONAL_INSTITUCION AND PINS.ES_ACTIVO=1
						INNER JOIN maestro.persona_institucion  PEI_D WITH (NOLOCK) ON PEI_D.ID_PERSONA_INSTITUCION=PINS.ID_PERSONA_INSTITUCION
						INNER JOIN maestro.persona P_D  WITH (NOLOCK) ON P_D.ID_PERSONA= PEI_D.ID_PERSONA
						INNER JOIN transaccional.periodos_lectivos_por_institucion PLXI ON PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  AND PLXI.ES_ACTIVO=1
						INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO= PLXI.ID_PERIODO_LECTIVO 	 
						LEFT  JOIN transaccional.evaluacion E WITH (NOLOCK) ON E.ID_PROGRAMACION_CLASE= PC.ID_PROGRAMACION_CLASE AND E.ID_CARRERA=CXI.ID_CARRERA AND E.ID_UNIDAD_DIDACTICA=UD.ID_UNIDAD_DIDACTICA AND E.ES_ACTIVO=1	 
						LEFT  JOIN sistema.enumerado EC1	ON E.CIERRE_PROGRAMACION=EC1.ID_ENUMERADO AND EC1.ESTADO=1
					WHERE		
						ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND 		
						(PC.ID_SEDE_INSTITUCION					= @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0) AND
						(PINS.ID_PERSONAL_INSTITUCION			= @ID_PERSONAL_INSTITUCION OR @ID_PERSONAL_INSTITUCION = '0') AND 		
						(UD.ID_UNIDAD_DIDACTICA					= @ID_UNIDAD_DIDACTICA OR @ID_UNIDAD_DIDACTICA=0) AND 
						(PC.ID_PERIODO_ACADEMICO				= @ID_PERIODO_ACADEMICO OR @ID_PERIODO_ACADEMICO=0)	AND
						(PC.ID_TURNOS_POR_INSTITUCION			= @ID_TURNOS_POR_INSTITUCION OR @ID_TURNOS_POR_INSTITUCION=0) AND
						(PC.ID_SECCION							= @ID_SECCION OR @ID_SECCION=0) AND
						(E.CIERRE_PROGRAMACION					= @CIERRE_PROGRAMACION OR @CIERRE_PROGRAMACION=0) AND
						(PC.ID_PROGRAMACION_CLASE				= @ID_PROGRAMACION_CLASE OR @ID_PROGRAMACION_CLASE=0) AND
						(PE.ID_TIPO_ITINERARIO					= @ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO=0) AND
						(PE.ID_PLAN_ESTUDIO						= @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO=0) AND
						(UD.ID_SEMESTRE_ACADEMICO               = @ID_SEMESTRE_ACADEMICO OR @ID_SEMESTRE_ACADEMICO =0) AND 
						(CXI.ID_CARRERA                         = @ID_CARRERA OR @ID_CARRERA =0)
				)TT	      
			)T1 
		    WHERE T1.Row BETWEEN   (@Pagina-1) * @Registros + 1 	 AND   	(@Pagina * @Registros) 
		)TE
END
GO


