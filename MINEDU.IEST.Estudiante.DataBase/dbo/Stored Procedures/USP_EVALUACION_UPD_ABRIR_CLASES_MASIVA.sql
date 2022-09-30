/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	15/03/2021
LLAMADO POR			:
DESCRIPCION			:	Abre las clases masivamente de un instituto en un periodo lectivo 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:  
	EXEC USP_EVALUACION_UPD_ABRIR_CLASES_MASIVA 290,3921,0,0,0,0,0,0,0,0,0,0,'70557821'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_UPD_ABRIR_CLASES_MASIVA](
--declare
	@ID_INSTITUCION							INT=290, 
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT=3921, 
	@ID_SEDE_INSTITUCION					INT=0, 	 
	@ID_CARRERA								INT=0, 
	@ID_UNIDAD_DIDACTICA					INT=0, 
	@ID_PERIODO_ACADEMICO					INT=0,
	@ID_TURNOS_POR_INSTITUCION				INT=0, 
	@ID_SECCION								INT=0, 
	@ID_SEMESTRE_ACADEMICO					INT=0,
	@ID_PROGRAMACION_CLASE					INT =0,	
	@ID_TIPO_ITINERARIO						INT =0, 
	@ID_PLAN_ESTUDIO						INT =0,
	@USUARIO								VARCHAR(20)='00000000'
	)
AS 
BEGIN   
	DECLARE @RESULT INT = 0

	BEGIN TRY
		BEGIN TRAN AbrirClasesMasivo

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
			TE.*		
		INTO 
		#TmpClasesPorAbrir
		FROM ( 
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
				) as Row			
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
				PE.ID_PLAN_ESTUDIO IdPlanEstudios,
				PE.NOMBRE_PLAN_ESTUDIOS PlanEstudios	
			FROM  
				transaccional.matricula_estudiante ME 
				INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCXME ON ME.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE AND PCXME.ES_ACTIVO=1 AND ME.ES_ACTIVO=1
				INNER JOIN transaccional.programacion_clase PC WITH (NOLOCK)  ON PC.ID_PROGRAMACION_CLASE= PCXME.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1
				INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION= PC.ID_SEDE_INSTITUCION AND SI.ES_ACTIVO=1
				INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC WITH (NOLOCK) ON UDXPC.ID_PROGRAMACION_CLASE= PC.ID_PROGRAMACION_CLASE AND UDXPC.ES_ACTIVO=1
				INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE WITH (NOLOCK) ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO=1
				INNER JOIN transaccional.unidad_didactica UD WITH (NOLOCK) ON UD.ID_UNIDAD_DIDACTICA= UDXE.ID_UNIDAD_DIDACTICA AND UD.ES_ACTIVO=1
				INNER JOIN transaccional.modulo M WITH (NOLOCK) ON M.ID_MODULO= UD.ID_MODULO AND M.ES_ACTIVO=1
				INNER JOIN transaccional.plan_estudio PE WITH (NOLOCK) ON PE.ID_PLAN_ESTUDIO= M.ID_PLAN_ESTUDIO AND PE.ES_ACTIVO=1
				INNER JOIN transaccional.carreras_por_institucion CXI WITH (NOLOCK) ON CXI.ID_CARRERAS_POR_INSTITUCION= PE.ID_CARRERAS_POR_INSTITUCION AND CXI.ES_ACTIVO=1
				INNER JOIN maestro.turnos_por_institucion TXI ON TXI.ID_TURNOS_POR_INSTITUCION= PC.ID_TURNOS_POR_INSTITUCION AND TXI.ES_ACTIVO=1
				INNER JOIN maestro.turno_equivalencia TE ON TE.ID_TURNO_EQUIVALENCIA= TXI.ID_TURNO_EQUIVALENCIA 
				INNER JOIN sistema.enumerado E_TURNO ON E_TURNO.ID_ENUMERADO= TE.ID_TURNO
				INNER JOIN sistema.enumerado E_SECCION ON E_SECCION.ID_ENUMERADO= PC.ID_SECCION
				INNER JOIN transaccional.periodo_academico PA ON PA.ID_PERIODO_ACADEMICO= PC.ID_PERIODO_ACADEMICO AND PA.ES_ACTIVO=1
				INNER JOIN transaccional.estudiante_institucion EI  WITH (NOLOCK)  ON EI.ID_ESTUDIANTE_INSTITUCION= ME.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1		
				INNER JOIN maestro.persona_institucion PEI WITH (NOLOCK) ON PEI.ID_PERSONA_INSTITUCION= EI.ID_PERSONA_INSTITUCION 
				INNER JOIN maestro.personal_institucion PINS WITH (NOLOCK) ON PINS.ID_PERSONAL_INSTITUCION= PC.ID_PERSONAL_INSTITUCION AND PINS.ES_ACTIVO=1
				INNER JOIN maestro.persona_institucion  PEI_D WITH (NOLOCK) ON PEI_D.ID_PERSONA_INSTITUCION=PINS.ID_PERSONA_INSTITUCION
				INNER JOIN maestro.persona P_D  WITH (NOLOCK) ON P_D.ID_PERSONA= PEI_D.ID_PERSONA
				INNER JOIN transaccional.periodos_lectivos_por_institucion PLXI ON PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  AND PLXI.ES_ACTIVO=1
				INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO= PLXI.ID_PERIODO_LECTIVO 	 
				LEFT  JOIN transaccional.evaluacion E WITH (NOLOCK) ON E.ID_PROGRAMACION_CLASE= PC.ID_PROGRAMACION_CLASE AND E.ES_ACTIVO=1	 
				LEFT  JOIN sistema.enumerado EC1 ON E.CIERRE_PROGRAMACION=EC1.ID_ENUMERADO AND EC1.ESTADO=1
			WHERE		
				ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND 		
				(PC.ID_SEDE_INSTITUCION					= @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0) AND
				--(PINS.ID_PERSONAL_INSTITUCION			= @ID_PERSONAL_INSTITUCION OR @ID_PERSONAL_INSTITUCION = '0') AND 		
				(UD.ID_UNIDAD_DIDACTICA					= @ID_UNIDAD_DIDACTICA OR @ID_UNIDAD_DIDACTICA=0) AND 
				(PC.ID_PERIODO_ACADEMICO				= @ID_PERIODO_ACADEMICO OR @ID_PERIODO_ACADEMICO=0)	AND
				(PC.ID_TURNOS_POR_INSTITUCION			= @ID_TURNOS_POR_INSTITUCION OR @ID_TURNOS_POR_INSTITUCION=0) AND
				(PC.ID_SECCION							= @ID_SECCION OR @ID_SECCION=0) AND
				--(E.CIERRE_PROGRAMACION					= @CIERRE_PROGRAMACION OR @CIERRE_PROGRAMACION=0) AND
				(PC.ID_PROGRAMACION_CLASE				= @ID_PROGRAMACION_CLASE OR @ID_PROGRAMACION_CLASE=0) AND
				(PE.ID_TIPO_ITINERARIO					= @ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO=0) AND
				(PE.ID_PLAN_ESTUDIO						= @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO=0) AND
				(UD.ID_SEMESTRE_ACADEMICO               = @ID_SEMESTRE_ACADEMICO OR @ID_SEMESTRE_ACADEMICO =0) AND 
				(CXI.ID_CARRERA                         = @ID_CARRERA OR @ID_CARRERA =0)
			)TT
		)TE

		-----ABRE LAS UD
		UPDATE	e
		SET		
			e.CIERRE_PROGRAMACION=234,	
			e.USUARIO_MODIFICACION=@USUARIO,
			e.FECHA_MODIFICACION=GETDATE()
		--SELECT e.*
		FROM transaccional.evaluacion e
		INNER JOIN #TmpClasesPorAbrir tmp ON tmp.IdProgramacionClase = e.ID_PROGRAMACION_CLASE
		
		SET @RESULT = @@ROWCOUNT

		--SELECT*FROM #TmpClasesPorAbrir
		DROP TABLE #TmpClasesPorAbrir

		SELECT @RESULT

		COMMIT TRAN AbrirClasesMasivo
	END	TRY
	BEGIN CATCH
		SELECT @RESULT
		ROLLBACK TRAN AbrirClasesMasivo
	END CATCH
END