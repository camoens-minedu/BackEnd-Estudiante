/*******************************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la situación del estudiante en la institución. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO		DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		MALVA		CREACIÓN
1.1			14/01/2020		MALVA		MODIFICACIÓN DE CONSULTA, SE EVALÚA LA NUEVA COLUMNA ID_PLAN_ESTUDIO DE estudiante_institucion.
										SE OBTIENEN LOS VALORES CORRECTOS DE TipoPlanEstudios y PlanEstudios.
1.2			13/05/2020		MALVA		SE OBTIENEN VALORES IdSedeInstitucion, IdCarrera
1.3			09/06/2020		MALVA		SE CONSULTA ESTADO de estudiante_institucion
2.0			07/01/2022		JCHAVEZ		OBTENCIÓN DE SOLO UN UNICO ESTUDIANTE POR INSTITUCION Y CARRERA (DISTINCT)

TEST:	
	USP_MATRICULA_SEL_ESTUDIANTE_SITUACION 262, 26, '73504078'
**********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ESTUDIANTE_SITUACION]
(  
 @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,
 @ID_TIPO_DOCUMENTO INT,
 @NUMERO_DOCUMENTO_PERSONA VARCHAR(16),
 @ID_ESTUDIANTE_INSTITUCION INT =0
)  
AS  
BEGIN  
	SET NOCOUNT ON;  
	DECLARE @ID_INSTITUCION INT, @vVACIO AS NVARCHAR(10) = '',
	@ESTADO_EN_TRASLADO INT = 333, @ESTADO_TRASLADADO INT = 334, @ESTADO_EN_CONVALIDACION INT =200
	SET @ID_INSTITUCION = (SELECT ID_INSTITUCION FROM transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION and ES_ACTIVO=1)
	SELECT 
			
			DISTINCT
			tei.ID_ESTUDIANTE_INSTITUCION																	IdEstudianteInstitucion, 
			mp.ID_TIPO_DOCUMENTO																			IdTipoDocumento,
			mp.NUMERO_DOCUMENTO_PERSONA																		NumeroDocumento,
			CASE WHEN mp.APELLIDO_PATERNO_PERSONA = @vVACIO THEN '.' ELSE mp.APELLIDO_PATERNO_PERSONA END   ApPaterno,
			CASE WHEN mp.APELLIDO_MATERNO_PERSONA = @vVACIO THEN '.' ELSE mp.APELLIDO_MATERNO_PERSONA END   ApMaterno,
			--mp.APELLIDO_PATERNO_PERSONA																		ApPaterno,
			--mp.APELLIDO_MATERNO_PERSONA																		ApMaterno,
			mp.NOMBRE_PERSONA																				Nombres,
			msi.ID_SEDE_INSTITUCION																			IdSedeInstitucion,
			msi.NOMBRE_SEDE																					SedeInstitucion,
			(UPPER(mp.APELLIDO_PATERNO_PERSONA)  + ' ' + UPPER(mp.APELLIDO_MATERNO_PERSONA) + ', ' + mp.NOMBRE_PERSONA)	Estudiante,			
			tci.ID_CARRERA																					IdCarrera,	
			tci.ID_CARRERAS_POR_INSTITUCION																	IdCarreraInstitucion,
			mc.NOMBRE_CARRERA																				ProgramaEstudios,
			CASE WHEN tple.ID_PLAN_ESTUDIO IS NULL 
						THEN 0 
						ELSE tple.ID_PLAN_ESTUDIO END														IdPlanEstudios,
			tci.ID_TIPO_ITINERARIO																			IdTipoItinerario,
			se_tipo_itin.VALOR_ENUMERADO																	TipoPlanEstudios,
			CASE WHEN tple.ID_PLAN_ESTUDIO IS NULL 
						THEN '' 
						ELSE tple.NOMBRE_PLAN_ESTUDIOS END													PlanEstudios,
			se_turno.VALOR_ENUMERADO																		TurnoInstitucion,  			
			CASE	WHEN se_estado_ei.ID_ENUMERADO= @ESTADO_EN_TRASLADO OR se_estado_ei.ID_ENUMERADO=  @ESTADO_TRASLADADO
						 THEN se_estado_ei.VALOR_ENUMERADO		
					WHEN LICENCIAS_PENDIENTES.ID_TIPO_LICENCIA  is NOT NULL  AND LICENCIAS_PENDIENTES.ID_REINGRESO_ESTUDIANTE IS NULL 
						THEN 'LICENCIA ' + LICENCIAS_PENDIENTES.VALOR_ENUMERADO 
					WHEN RESERVAS_PENDIENTES.ID_MOTIVO_RESERVA is NOT NULL  AND RESERVAS_PENDIENTES.ID_REINGRESO_ESTUDIANTE IS NULL
						THEN 'RESERVA MATRICULA ' + RESERVAS_PENDIENTES.VALOR_ENUMERADO
					WHEN conv.ID_CONVALIDACION is NOT NULL AND conv.ESTADO =@ESTADO_EN_CONVALIDACION 
						THEN 'EN CONVALIDACION'
				ELSE 'REGULAR' END																	Condicion,						
			CASE WHEN se_estado_ei.ID_ENUMERADO= @ESTADO_EN_TRASLADO OR se_estado_ei.ID_ENUMERADO=  @ESTADO_TRASLADADO THEN 0						
					WHEN LICENCIAS_PENDIENTES.ID_TIPO_LICENCIA is NOT NULL AND LICENCIAS_PENDIENTES.ID_REINGRESO_ESTUDIANTE IS NULL THEN 0
					WHEN RESERVAS_PENDIENTES.ID_MOTIVO_RESERVA IS NOT NULL AND RESERVAS_PENDIENTES.ID_REINGRESO_ESTUDIANTE IS NULL THEN 0
					WHEN tple.ID_PLAN_ESTUDIO IS NULL				THEN 0
					WHEN conv.ID_CONVALIDACION is NOT NULL AND conv.ESTADO =@ESTADO_EN_CONVALIDACION	THEN 0
					ELSE 1 END																			EsMatriculaPermitida ,
			tei.ID_SEMESTRE_ACADEMICO																		IdSemestreAcademico,
			se_semestre.VALOR_ENUMERADO																		Semestre,
			CASE WHEN MATRICULA_REALIZADA.ID_MATRICULA_ESTUDIANTE IS NOT NULL 
						THEN 1 
						ELSE 0 END																			Matriculado,
			ISNULL (TLE.ID_LIBERACION_ESTUDIANTE, 0)														IdLiberacionEstudiante,
			ISNULL (TTE.ID_TRASLADO_ESTUDIANTE, 0)															IdTrasladoEstudiante,
			tci.ID_TIPO_ITINERARIO																			IdTipoItinerario,
			ISNULL(MATRICULA_REALIZADA.ID_MATRICULA_ESTUDIANTE,0 )											IdMatriculaEstudiante
	FROM 
			transaccional.estudiante_institucion tei 
			INNER JOIN maestro.persona_institucion mpi						on tei.ID_PERSONA_INSTITUCION = mpi.ID_PERSONA_INSTITUCION 
																			AND tei.ES_ACTIVO=1 
			INNER JOIN maestro.persona mp									on mp.ID_PERSONA= mpi.ID_PERSONA			
			INNER JOIN transaccional.carreras_por_institucion_detalle tcid	on tei.ID_CARRERAS_POR_INSTITUCION_DETALLE= tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE 
																			AND tcid.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion tci			on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc						on mc.ID_CARRERA = tci.ID_CARRERA			
			INNER JOIN [maestro].[turnos_por_institucion] mti				on mti.ID_TURNOS_POR_INSTITUCION = tei.ID_TURNOS_POR_INSTITUCION
			INNER JOIN maestro.turno_equivalencia mte						on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA
			INNER JOIN maestro.sede_institucion	msi							on msi.ID_SEDE_INSTITUCION= tcid.ID_SEDE_INSTITUCION							
			INNER JOIN sistema.enumerado se_turno							on se_turno.ID_ENUMERADO= mte.ID_TURNO
			INNER JOIN sistema.enumerado se_semestre						on se_semestre.ID_ENUMERADO= tei.ID_SEMESTRE_ACADEMICO
			INNER JOIN sistema.enumerado se_tipo_itin						on se_tipo_itin.ID_ENUMERADO= tci.ID_TIPO_ITINERARIO
			INNER JOIN sistema.enumerado se_estado_ei						on se_estado_ei.ID_ENUMERADO = tei.ESTADO
			LEFT JOIN transaccional.plan_estudio tple						on tple.ID_PLAN_ESTUDIO= tei.ID_PLAN_ESTUDIO AND tple.ES_ACTIVO=1
			LEFT JOIN (SELECT SUBCONSULTA.ID_ESTUDIANTE_INSTITUCION, MAX (SUBCONSULTA.ID_PERIODOS_LECTIVOS_POR_INSTITUCION) ID_ULT_PERIODO_LECTIVO_INSTITUCION FROM 
						(
							SELECT ID_ESTUDIANTE_INSTITUCION, ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM 
							transaccional.reserva_matricula	WHERE ES_ACTIVO=1
							UNION
							SELECT ID_ESTUDIANTE_INSTITUCION, ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM 
							transaccional.licencia_estudiante WHERE ES_ACTIVO=1
						) SUBCONSULTA
						GROUP BY SUBCONSULTA.ID_ESTUDIANTE_INSTITUCION) SUBCONSULTA_ULT_PERIODO_RESERVA_LICENCIA ON SUBCONSULTA_ULT_PERIODO_RESERVA_LICENCIA.ID_ESTUDIANTE_INSTITUCION= tei.ID_ESTUDIANTE_INSTITUCION
						
			LEFT JOIN (	
						SELECT  tle.ID_LICENCIA_ESTUDIANTE,ID_ESTUDIANTE_INSTITUCION, ID_TIPO_LICENCIA, VALOR_ENUMERADO, tle.ID_PERIODOS_LECTIVOS_POR_INSTITUCION, tre.ID_REINGRESO_ESTUDIANTE
						FROM 
							transaccional.licencia_estudiante tle
							LEFT JOIN transaccional.reingreso_estudiante tre on tle.ID_LICENCIA_ESTUDIANTE = tre.ID_LICENCIA_ESTUDIANTE AND tre.ES_ACTIVO=1							 
							INNER JOIN sistema.enumerado se_tipo_lic on se_tipo_lic.ID_ENUMERADO= tle.ID_TIPO_LICENCIA						
							WHERE tle.ES_ACTIVO =1							
						)
						LICENCIAS_PENDIENTES on LICENCIAS_PENDIENTES.ID_ESTUDIANTE_INSTITUCION = tei.ID_ESTUDIANTE_INSTITUCION 
						AND LICENCIAS_PENDIENTES.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= SUBCONSULTA_ULT_PERIODO_RESERVA_LICENCIA.ID_ULT_PERIODO_LECTIVO_INSTITUCION
			LEFT JOIN (
						SELECT TME.ID_MATRICULA_ESTUDIANTE, TME.ID_ESTUDIANTE_INSTITUCION
						FROM
								transaccional.matricula_estudiante TME
						WHERE	TME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND TME.ES_ACTIVO=1

			) MATRICULA_REALIZADA ON MATRICULA_REALIZADA.ID_ESTUDIANTE_INSTITUCION =tei.ID_ESTUDIANTE_INSTITUCION
			LEFT JOIN
					(
						SELECT trm.ID_RESERVA_MATRICULA,  ID_ESTUDIANTE_INSTITUCION, ID_MOTIVO_RESERVA, VALOR_ENUMERADO, trm.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
						tre.ID_REINGRESO_ESTUDIANTE
						FROM transaccional.reserva_matricula trm
						LEFT JOIN transaccional.reingreso_estudiante tre on trm.ID_RESERVA_MATRICULA = tre.ID_RESERVA_MATRICULA AND tre.ES_ACTIVO=1							 
						INNER JOIN sistema.enumerado se_mot_reserva on se_mot_reserva.ID_ENUMERADO= trm.ID_MOTIVO_RESERVA
						
						WHERE trm.ES_ACTIVO=1
					)RESERVAS_PENDIENTES on RESERVAS_PENDIENTES.ID_ESTUDIANTE_INSTITUCION= tei.ID_ESTUDIANTE_INSTITUCION
					AND RESERVAS_PENDIENTES.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= SUBCONSULTA_ULT_PERIODO_RESERVA_LICENCIA.ID_ULT_PERIODO_LECTIVO_INSTITUCION
			LEFT JOIN transaccional.liberacion_estudiante TLE ON TLE.ID_ESTUDIANTE_INSTITUCION= tei.ID_ESTUDIANTE_INSTITUCION AND TLE.ES_ACTIVO=1
			LEFT JOIN transaccional.traslado_estudiante TTE ON TTE.ID_ESTUDIANTE_INSTITUCION= tei.ID_ESTUDIANTE_INSTITUCION AND TTE.ES_ACTIVO=1
			LEFT JOIN transaccional.convalidacion conv on conv.ID_ESTUDIANTE_INSTITUCION = tei.ID_ESTUDIANTE_INSTITUCION and conv.ES_ACTIVO=1 AND conv.ESTADO =@ESTADO_EN_CONVALIDACION 
	WHERE 
			(mp.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO and UPPER(mp.NUMERO_DOCUMENTO_PERSONA)=UPPER(@NUMERO_DOCUMENTO_PERSONA) OR tei.ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION ) 
			AND mpi.ID_INSTITUCION=@ID_INSTITUCION 
			AND tei.ESTADO <> @ESTADO_TRASLADADO

--	GROUP BY tei.ID_ESTUDIANTE_INSTITUCION,mp.ID_TIPO_DOCUMENTO,mp.NUMERO_DOCUMENTO_PERSONA,mp.APELLIDO_PATERNO_PERSONA ,mp.APELLIDO_MATERNO_PERSONA,mp.NOMBRE_PERSONA,msi.ID_SEDE_INSTITUCION,msi.NOMBRE_SEDE,mp.APELLIDO_PATERNO_PERSONA
--			,tci.ID_CARRERA,tci.ID_CARRERAS_POR_INSTITUCION,mc.NOMBRE_CARRERA,tple.ID_PLAN_ESTUDIO,tci.ID_TIPO_ITINERARIO,se_tipo_itin.VALOR_ENUMERADO,																	
--tple.ID_PLAN_ESTUDIO,	tple.NOMBRE_PLAN_ESTUDIOS,		
--			se_turno.VALOR_ENUMERADO,																				
--			se_estado_ei.ID_ENUMERADO,
						 
--LICENCIAS_PENDIENTES.ID_TIPO_LICENCIA,  																	
--se_estado_ei.ID_ENUMERADO,					
--LICENCIAS_PENDIENTES.ID_TIPO_LICENCIA,
--RESERVAS_PENDIENTES.ID_MOTIVO_RESERVA,
--tple.ID_PLAN_ESTUDIO, 
--conv.ID_CONVALIDACION, 
--tei.ID_SEMESTRE_ACADEMICO,	
--			se_semestre.VALOR_ENUMERADO,	
--MATRICULA_REALIZADA.ID_MATRICULA_ESTUDIANTE,
--TLE.ID_LIBERACION_ESTUDIANTE,
--TTE.ID_TRASLADO_ESTUDIANTE,
--			tci.ID_TIPO_ITINERARIO,		
--MATRICULA_REALIZADA.ID_MATRICULA_ESTUDIANTE,se_estado_ei.VALOR_ENUMERADO,LICENCIAS_PENDIENTES.ID_TIPO_LICENCIA,LICENCIAS_PENDIENTES.ID_REINGRESO_ESTUDIANTE,	
--RESERVAS_PENDIENTES.ID_MOTIVO_RESERVA, RESERVAS_PENDIENTES.ID_REINGRESO_ESTUDIANTE 
--						,RESERVAS_PENDIENTES.VALOR_ENUMERADO,
--conv.ID_CONVALIDACION, conv.ESTADO,LICENCIAS_PENDIENTES.VALOR_ENUMERADO  
--ORDER BY tci.ID_CARRERAS_POR_INSTITUCION

END
GO


