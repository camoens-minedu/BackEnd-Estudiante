/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	24/01/2021
LLAMADO POR			:
DESCRIPCION			:	Anula las notas de un estudiante para un determinado periodo académico 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 24/01/2021		LESPINOZA
--  TEST:  
--			USP_MATRICULA_UPD_REVIERTE_PROMOCION_ESTUDIANTE 306, 1235, 101,1135,3
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_REVIERTE_PROMOCION_ESTUDIANTE]
(
	@ID_INSTITUCION					INT,
	@ID_TIPO_DOCUMENTO				INT,
	@NUMERO_DOCUMENTO_PERSONA		VARCHAR(16),
	@ESTUDIANTE						VARCHAR(150),
	@ID_SEDE_INSTITUCION			INT,	
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT,
	@ID_TURNOS_POR_INSTITUCION		INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT,
	@ID_PLAN_ESTUDIO				INT,  
	@ID_ESTUDIANTE_INSTITUCION		INT = 0,
	@USUARIO						VARCHAR(20)
)
AS
BEGIN

	DECLARE @MSG_TRANS VARCHAR(MAX)
	DECLARE @fechaActual date
	set @fechaActual = GETDATE()

	BEGIN TRY

		BEGIN TRAN TransactSQL
		
			Select
					tci.ID_INSTITUCION IdInstitucion,
					tehi.ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
					tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  IdPeriodoLectivoInstitucion,
					tehi.ID_SEMESTRE_ACADEMICO	IdSemestreAcademico,
					se_semestre.VALOR_ENUMERADO	SemestreAcademico,
					MAX(tme.ID_MATRICULA_ESTUDIANTE) IdMatriculaEstudiante,
					Estado = 1	
				INTO #tmp_Estudiantes
				from transaccional.estudiante_institucion (nolock) tehi
					inner join transaccional.matricula_estudiante (nolock) tme on tehi.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION AND tehi.ES_ACTIVO=1
					inner join maestro.persona_institucion (nolock) mpi on tehi.ID_PERSONA_INSTITUCION = mpi.ID_PERSONA_INSTITUCION AND tehi.ES_ACTIVO=1
					inner join maestro.persona (nolock) mp on mpi.ID_PERSONA = mp.ID_PERSONA
					inner join sistema.enumerado (nolock) se_tipo_doc on mp.ID_TIPO_DOCUMENTO = se_tipo_doc.ID_ENUMERADO
					inner join transaccional.carreras_por_institucion_detalle (nolock) tcid ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE= tehi.ID_CARRERAS_POR_INSTITUCION_DETALLE
					AND tcid.ES_ACTIVO=1
					inner join [maestro].[sede_institucion] (nolock) msi ON msi.ID_SEDE_INSTITUCION = tcid.ID_SEDE_INSTITUCION
					and msi.ES_ACTIVO=1
					inner join transaccional.carreras_por_institucion (nolock) tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1		
					inner join db_auxiliar.dbo.UVW_CARRERA (nolock) mc on mc.ID_CARRERA= tci.ID_CARRERA
					inner join [maestro].[turnos_por_institucion] (nolock) mti on mti.ID_TURNOS_POR_INSTITUCION = tehi.ID_TURNOS_POR_INSTITUCION AND mti.ES_ACTIVO=1
					inner join [maestro].[turno_equivalencia] (nolock) mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA
					inner join sistema.enumerado (nolock) se_turno on mte.ID_TURNO = se_turno.ID_ENUMERADO
					inner join transaccional.periodos_lectivos_por_institucion (nolock) plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  and plxi.ES_ACTIVO=1
					inner join maestro.periodo_lectivo (nolock) pl on pl.ID_PERIODO_LECTIVO= plxi.ID_PERIODO_LECTIVO 
					LEFT JOIN transaccional.plan_estudio (nolock) pe ON pe.ID_PLAN_ESTUDIO = tehi.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
					LEFT JOIN [maestro].[institucion_basica] (nolock) mib on tehi.ID_INSTITUCION_BASICA = mib.ID_INSTITUCION_BASICA		--POR LA CARGA MASIVA, esto ya no es obligatorio
					LEFT JOIN db_auxiliar.dbo.UVW_PAIS (nolock) PBAS ON CONVERT(INT,SUBSTRING(PBAS.CODIGO,1,5)) = mib.ID_PAIS --POR LA CARGA MASIVA, esto ya no es obligatorio
					INNER JOIN sistema.enumerado (nolock) se_semestre on se_semestre.ID_ENUMERADO = tehi.ID_SEMESTRE_ACADEMICO		
					--INNER JOIN sistema.enumerado (nolock) se_itin on se_itin.ID_ENUMERADO= tci.ID_TIPO_ITINERARIO  
					--LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_RENIEC (nolock) UBI ON UBI.CODIGO_UBIGEO = mpi.UBIGEO_PERSONA
					--LEFT JOIN db_auxiliar.dbo.UVW_PAIS (nolock) PAIS ON CONVERT(INT,SUBSTRING(PAIS.CODIGO,1,5)) = mpi.PAIS_PERSONA --POR LA CARGA MASIVA, esto ya no es obligatorio
					--left JOIN sistema.enumerado (nolock) se_parentesco on tehi.ID_TIPO_PARENTESCO = se_parentesco.ID_ENUMERADO		
					where 
					(mp.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO = 0)  		
					AND (mp.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NUMERO_DOCUMENTO_PERSONA + '%' COLLATE LATIN1_GENERAL_CI_AI
					AND (mp.APELLIDO_PATERNO_PERSONA + ' '+ mp.APELLIDO_MATERNO_PERSONA + ', ' + mp.NOMBRE_PERSONA) LIKE '%'+ @ESTUDIANTE +'%' COLLATE LATIN1_GENERAL_CI_AI
					AND (msi.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)  				
					AND (tci.ID_CARRERA=@ID_CARRERA OR @ID_CARRERA=0 )
					AND (tci.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO=0)
					AND (mti.ID_TURNOS_POR_INSTITUCION = @ID_TURNOS_POR_INSTITUCION OR @ID_TURNOS_POR_INSTITUCION = 0)  	
					AND msi.ID_INSTITUCION = @ID_INSTITUCION	
					and (tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION OR @ID_PERIODO_LECTIVO_INSTITUCION= 0 or (@NUMERO_DOCUMENTO_PERSONA<>'' or @ESTUDIANTE<>''))
					AND (pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO = 0)
					AND (tehi.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION OR @ID_ESTUDIANTE_INSTITUCION = 0)
				group by tci.ID_INSTITUCION,
					tehi.ID_ESTUDIANTE_INSTITUCION,
					tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
					tehi.ID_SEMESTRE_ACADEMICO,
					se_semestre.VALOR_ENUMERADO

				Create Table #tmp_unidades_seleccionada
							(
							   ID_UNIDAD_SELECCIONADA  INT IDENTITY(1,1)
							   ,ID_ESTUDIANTE_INSTITUCION INT
							   ,ID_ESTADO_UNIDAD_DIDACTICA INT
							   ,ID_SEMESTRE_ACADEMICO INT
							   ,ID_SEMESTRE_ACADEMICO_UD INT
							   ,ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT
							   ,ESTADO INT
							   ,SELECCIONADO INT
							)
							Create Clustered index IX_TMP_UNIDAD_SEL on #tmp_unidades_seleccionada(ID_UNIDAD_SELECCIONADA)


							SELECT DISTINCT
								tme.ID_ESTUDIANTE_INSTITUCION				IdEstudianteInstitucion,								
								tme.ID_MATRICULA_ESTUDIANTE					IdMatriculaEstudiante,
								tpcme.ID_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE IdProgramacionClaseMatEstudiante,
								tud.ID_UNIDAD_DIDACTICA						IdUnidadDidactica, 
								tme.ID_SEMESTRE_ACADEMICO					IdSemestreAcademico,
								tud.NOMBRE_UNIDAD_DIDACTICA					NombreUnidadDidactica,
								tpcme.ID_ESTADO_UNIDAD_DIDACTICA			IdEstadoUnidadDidactica,
								tud.ID_SEMESTRE_ACADEMICO					IdSemestreAcademicoUD,
								Estado = 1								
							INTO
								#tmp_matricula_unidad_didactica
							FROM transaccional.matricula_estudiante (nolock) tme
							INNER JOIN #tmp_Estudiantes te on tme.ID_MATRICULA_ESTUDIANTE = te.IdMatriculaEstudiante
							INNER JOIN transaccional.programacion_clase_por_matricula_estudiante (nolock) tpcme on tme.ID_MATRICULA_ESTUDIANTE= tpcme.ID_MATRICULA_ESTUDIANTE
							AND tme.ES_ACTIVO=1 AND tpcme.ES_ACTIVO=1
							INNER JOIN transaccional.programacion_clase (nolock) tpc on tpc.ID_PROGRAMACION_CLASE= tpcme.ID_PROGRAMACION_CLASE 
							AND tpc.ES_ACTIVO=1
							INNER JOIN transaccional.unidades_didacticas_por_programacion_clase (nolock) tudpc on tudpc.ID_PROGRAMACION_CLASE= tpcme.ID_PROGRAMACION_CLASE AND tudpc.ES_ACTIVO = 1
							INNER JOIN transaccional.unidades_didacticas_por_enfoque (nolock) tude on tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
							INNER JOIN transaccional.unidad_didactica (nolock) tud on tud.ID_UNIDAD_DIDACTICA= tude.ID_UNIDAD_DIDACTICA
							INNER JOIN sistema.enumerado (nolock) se_semestre on se_semestre.ID_ENUMERADO= tud.ID_SEMESTRE_ACADEMICO
							INNER JOIN sistema.enumerado (nolock) se_seccion on se_seccion.ID_ENUMERADO= tpc.ID_SECCION	
		

		Create Clustered index IX_TMP_Estudiante_Ins on #tmp_Estudiantes(IdEstudianteInstitucion)
		Create Clustered index IX_TMP_Prog_Clas_Mat_Est on #tmp_matricula_unidad_didactica(IdProgramacionClaseMatEstudiante)

		-----Actualiza el IdSemestreAcademico Nuevo en el temporal
		--111: I 112: II 113: III 114:IV 115: V 116:VI
		
		UPDATE #tmp_Estudiantes
		SET IdSemestreAcademico = (CASE WHEN IdSemestreAcademico = 111 THEN 111
										WHEN IdSemestreAcademico = 112 THEN 111
										WHEN IdSemestreAcademico = 113 THEN 112
										WHEN IdSemestreAcademico = 114 THEN 113
										WHEN IdSemestreAcademico = 115 THEN 114
										WHEN IdSemestreAcademico = 116 THEN 115
										--WHEN IdSemestreAcademico = 116 THEN 115
										--WHEN IdSemestreAcademico = 137 THEN 116
										--WHEN IdSemestreAcademico = 138 THEN 137
									END),
			SemestreAcademico = (CASE WHEN IdSemestreAcademico = 111 THEN 'I'
										WHEN IdSemestreAcademico = 112 THEN 'I'
										WHEN IdSemestreAcademico = 113 THEN 'II'
										WHEN IdSemestreAcademico = 114 THEN 'III'
										WHEN IdSemestreAcademico = 115 THEN 'IV'
										WHEN IdSemestreAcademico = 116 THEN 'V'
										--WHEN IdSemestreAcademico = 116 THEN 'V'
										--WHEN IdSemestreAcademico = 137 THEN 'VI'
										--WHEN IdSemestreAcademico = 138 THEN 'VII'
									END)


		--- Actualiza el Estado de la Unidad didactica en el temporal
		DECLARE @TotEstudiantes INT, @ContEst INT, @IdSemestreNuevo INT, @IdSemestreAcademicoMat INT, @Semestre NVARCHAR(3), @IdEstudianteInstitucion INT,
				@UniSel INT, @TotUniSel INT,@IdEstadoUnidadDidactica INT, @IdProgramacionClaseMatEstudiante INT, @IdMatriculaEstudiante INT,
				@IdSemestreAcademioUD INT
				
				SET @TotEstudiantes = (Select count(*) from #tmp_Estudiantes)
				SET @ContEst = 1 
				
				---usuarios
				WHILE (@ContEst <= @TotEstudiantes)
				BEGIN

					Select TOP 1 @IdSemestreNuevo = IdSemestreAcademico, @IdEstudianteInstitucion = IdEstudianteInstitucion, @IdMatriculaEstudiante = IdMatriculaEstudiante 
					from #tmp_Estudiantes Where Estado = 1

					Insert into #tmp_unidades_seleccionada
					Select IdEstudianteInstitucion,IdEstadoUnidadDidactica,IdSemestreAcademico,IdSemestreAcademicoUD,IdProgramacionClaseMatEstudiante,1,0 
					From #tmp_matricula_unidad_didactica 
					Where IdEstudianteInstitucion = @IdEstudianteInstitucion
					and IdMatriculaEstudiante = @IdMatriculaEstudiante

						Set @UniSel = 1
						Set @TotUniSel = (select count(*) from #tmp_unidades_seleccionada)

						WHILE (@UniSel <= @TotUniSel)
						BEGIN

							Select @IdSemestreAcademicoMat = ID_SEMESTRE_ACADEMICO, @IdSemestreAcademioUD = ID_SEMESTRE_ACADEMICO_UD, @IdEstadoUnidadDidactica = ID_ESTADO_UNIDAD_DIDACTICA, @IdProgramacionClaseMatEstudiante = ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
							From #tmp_unidades_seleccionada 
							Where ID_UNIDAD_SELECCIONADA = @UniSel 

							---Verifica si el estado es correcto
							if(@IdSemestreNuevo > @IdSemestreAcademioUD)
							Begin								
								--171: subsanacion 173:adelando 170: regular
									Update #tmp_matricula_unidad_didactica
									set IdEstadoUnidadDidactica = 171	--subsanacion
									where  IdProgramacionClaseMatEstudiante = @IdProgramacionClaseMatEstudiante
							End

							if(@IdSemestreNuevo = @IdSemestreAcademioUD)
							Begin								
								--171: subsanacion 173:adelando 170: regular
									Update #tmp_matricula_unidad_didactica
									set IdEstadoUnidadDidactica = 170	--regular
									where  IdProgramacionClaseMatEstudiante = @IdProgramacionClaseMatEstudiante
							End

							if(@IdSemestreNuevo < @IdSemestreAcademioUD)
							Begin								
								--171: subsanacion 173:adelando 170: regular
									Update #tmp_matricula_unidad_didactica
									set IdEstadoUnidadDidactica = 173	--adelanto
									where  IdProgramacionClaseMatEstudiante = @IdProgramacionClaseMatEstudiante
							End
									
							SET @UniSel = @UniSel + 1
												
							CONTINUE;
							IF @UniSel = @TotUniSel
								BREAK;

						END		--- WHILE (@UniSel <= @TotUniSel)
														
						Update #tmp_Estudiantes
						Set Estado = 0
						Where IdEstudianteInstitucion = @IdEstudianteInstitucion

						truncate table #tmp_unidades_seleccionada								

										
					SET @ContEst = @ContEst + 1
					CONTINUE;
					IF @ContEst = @TotEstudiantes
						BREAK;
						
				END		--- WHILE (@ContEst <=@TotEstudiantes)
			


			---ACTUALIZAR EL NUEVO SEMESTRE EN ESTUDIANTES
			
			UPDATE transaccional.estudiante_institucion
			SET ID_SEMESTRE_ACADEMICO = tsel.IdSemestreAcademico,
				USUARIO_MODIFICACION = @USUARIO, 
				FECHA_MODIFICACION = @fechaActual
			FROM transaccional.estudiante_institucion t1,#tmp_Estudiantes tsel
			WHERE 
				t1.ID_ESTUDIANTE_INSTITUCION = tsel.IdEstudianteInstitucion
				and t1.ES_ACTIVO = 1

			---ACTUALIZAR EL NUEVO SEMESTRE EN LA MATRÍCULA
			
			UPDATE transaccional.matricula_estudiante
			SET ID_SEMESTRE_ACADEMICO = tsel.IdSemestreAcademico,
				USUARIO_MODIFICACION = @USUARIO, 
				FECHA_MODIFICACION = @fechaActual
			FROM transaccional.matricula_estudiante t1,#tmp_Estudiantes tsel
			WHERE 
				t1.ID_MATRICULA_ESTUDIANTE = tsel.IdMatriculaEstudiante
				and t1.ES_ACTIVO = 1	

			---ACTUALIZAR EL ESTADO DE LAS UNIDADES DIDÁCTICAS MATRICULADAS SEGÚN EL NUEVO SEMESTRE
			
			UPDATE transaccional.programacion_clase_por_matricula_estudiante
			SET ID_ESTADO_UNIDAD_DIDACTICA = tsel.IdEstadoUnidadDidactica,
				USUARIO_MODIFICACION = @USUARIO, 
				FECHA_MODIFICACION = @fechaActual
			FROM transaccional.programacion_clase_por_matricula_estudiante t1,#tmp_matricula_unidad_didactica tsel
			WHERE 
				t1.ID_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE = tsel.IdProgramacionClaseMatEstudiante
				and t1.ES_ACTIVO = 1		
			
			COMMIT TRANSACTION TransactSQL

			drop table #tmp_Estudiantes
			drop table #tmp_matricula_unidad_didactica
			drop table #tmp_unidades_seleccionada

			SELECT 1 AS Value

		END TRY

		BEGIN CATCH
			ROLLBACK TRAN TransactSQL
			PRINT ERROR_MESSAGE()
			SELECT 				
				0 AS Value
		END CATCH

END