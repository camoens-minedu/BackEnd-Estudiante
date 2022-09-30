
--USP_MATRICULA_SEL_MATRICULA_ESTUDIANTE_PAGINADO 443,895,0,'','',0,0,100,0,0,773
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_MATRICULA_SIMPLE]
  
	(@ID_INSTITUCION					INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,
	@ID_SEDE_INSTITUCION			INT,
	@ID_CARRERA						INT
	/*@ID_PLAN_ESTUDIO				INT,
	@ID_PERIODO_ACADEMICO			INT,
	@ID_SEMESTRE_ACADEMICO			INT,
	@ID_TURNOS_POR_INSTITUCION		INT */
	 ) as  
	  begin
	  
 /*
 DECLARE	@IdMatriculaEstudiante int, @IdTipoDocumento int, @NumeroDocumentoPersona varchar(16),
			@Estudiante varchar(200),@IdCarrera  int,@NombreProgramaEstudio varchar(150),
			@IdSemestreAcademico int, @SemestreAcademico varchar(5),@IdTurnoInstitucion int,
			@TurnoInstitucion varchar(20),@IdPeriodoAcademico int, @UnidadesDidacticas varchar(400),
			@NombrePeriodoAcademico varchar(50),@IdPlanEstudios INT, @NombrePlanEstudios varchar(150), 
			@CodigoPeriodoLectivo varchar(16), @IdTipoMatricula INT, @TipoMatricula VARCHAR(20), @IdProgramacionMatricula INT
			*/

	SELECT 			
				tme.ID_MATRICULA_ESTUDIANTE		IdMatriculaEstudiante,
				mp.ID_TIPO_DOCUMENTO			IdTipoDocumento,
				mp.NUMERO_DOCUMENTO_PERSONA		NumeroDocumentoPersona, 
				mp.APELLIDO_PATERNO_PERSONA + ' ' + mp.APELLIDO_MATERNO_PERSONA + ', '+ mp.NOMBRE_PERSONA Estudiante,
				mc.ID_CARRERA					IdCarrera,
				mc.NOMBRE_CARRERA				NombreProgramaEstudio,
				tme.ID_SEMESTRE_ACADEMICO		IdSemestreAcademico,
				se_semestre.VALOR_ENUMERADO		SemestreAcademico,	
				mti.ID_TURNOS_POR_INSTITUCION	IdTurnoInstitucion,
				se_turno.VALOR_ENUMERADO		TurnoInstitucion,	
				tme.ID_PERIODO_ACADEMICO		IdPeriodoAcademico,
				tpa.NOMBRE_PERIODO_ACADEMICO	NombrePeriodoAcademico,
				tpe.ID_PLAN_ESTUDIO				IdPlanEstudios,
				se_tipo_itin.VALOR_ENUMERADO	NombrePlanEstudios,
				mpl.CODIGO_PERIODO_LECTIVO		CodigoPeriodoLectivo,
				tpm.ID_TIPO_MATRICULA			IdTipoMatricula,
				se_tipo_mat.VALOR_ENUMERADO		TipoMatricula,
				tme.ID_PROGRAMACION_MATRICULA	IdProgramacionMatricula
		FROM transaccional.matricula_estudiante tme
				INNER JOIN transaccional.programacion_matricula tpm on tpm.ID_PROGRAMACION_MATRICULA= tme.ID_PROGRAMACION_MATRICULA and tpm.ES_ACTIVO=1
				INNER JOIN transaccional.estudiante_institucion tei on tei.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION AND tei.ES_ACTIVO=1
				INNER JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION = tei.ID_PERSONA_INSTITUCION
				INNER JOIN maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA
				INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE 
				INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION
				INNER JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION = tci.ID_CARRERAS_POR_INSTITUCION
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA = tci.ID_CARRERA
				INNER JOIN sistema.enumerado se_semestre on se_semestre.ID_ENUMERADO = tme.ID_SEMESTRE_ACADEMICO
				INNER JOIN maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION = tei.ID_TURNOS_POR_INSTITUCION
				INNER JOIN maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA 
				INNER JOIN sistema.enumerado se_turno on se_turno.ID_ENUMERADO = mte.ID_TURNO
				INNER JOIN transaccional.periodo_academico tpa on tpa.ID_PERIODO_ACADEMICO= tme.ID_PERIODO_ACADEMICO
				inner join transaccional.periodos_lectivos_por_institucion tpli on tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
				inner join maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tpli.ID_PERIODO_LECTIVO
				INNER JOIN sistema.enumerado se_tipo_itin on se_tipo_itin.ID_ENUMERADO= tpe.ID_TIPO_ITINERARIO
				INNER JOIN sistema.enumerado se_tipo_mat on se_tipo_mat.ID_ENUMERADO= tpm.ID_TIPO_MATRICULA
		WHERE 
		
		tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION
		AND tci.ID_INSTITUCION= @ID_INSTITUCION
		AND tci.ID_CARRERA=@ID_CARRERA
		AND tme.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		/*AND tpe.ID_TIPO_ITINERARIO=@ID_PLAN_ESTUDIO
		AND tme.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO
		AND tme.ID_SEMESTRE_ACADEMICO=@ID_SEMESTRE_ACADEMICO
		
		AND tei.ID_TURNOS_POR_INSTITUCION = @ID_TURNOS_POR_INSTITUCION
		AND tme.ES_ACTIVO =1 AND tpe.ES_ACTIVO=1
		
		*/
		order by 4 ASC

END
GO


