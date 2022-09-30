/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	24/01/2021
LLAMADO POR			:
DESCRIPCION			:	Anula las notas de un estudiante para un determinado periodo académico 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 24/01/2021		LESPINOZA		Creación
--	2.0		 05/01/2022		JCHAVEZ			Se agrega sección para borrar notas de EFSRT
--  TEST:  
--			USP_MATRICULA_UPD_ANULA_NOTAS_ESTUDIANTE 306, 1235, 101,1135,3
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_ANULA_NOTAS_ESTUDIANTE]
(
	@ID_INSTITUCION							INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@ID_TIPO_DOCUMENTO						INT,
	@NUMERO_DOCUMENTO_PERSONA				VARCHAR(20),
	@ESTUDIANTE								VARCHAR(200),
	@ID_CARRERA								INT,
	@ID_SEDE_INSTITUCION					INT,
	@ID_PLAN_ESTUDIO						INT,
	@ID_TIPO_ITINERARIO						INT,
	@ID_PERIODO_ACADEMICO					INT,
	@ID_SEMESTRE_ACADEMICO					INT,
	@ID_TURNOS_POR_INSTITUCION				INT,
	@USUARIO								VARCHAR(20)
)
AS
BEGIN

	DECLARE @MSG_TRANS VARCHAR(MAX)
	DECLARE @fechaActual date
	set @fechaActual = GETDATE()

	DECLARE @TmpEvaluacionDetalle TABLE (ID_EVALUACION INT, ID_EVALUACION_DETALLE INT, NOTA DECIMAL(18,2), ID_MATRICULA_ESTUDIANTE INT)
	DECLARE @TmpEvaluacion TABLE (NRO INT, ID_EVALUACION INT)

	BEGIN TRY

		BEGIN TRAN TransactSQL
		
		INSERT INTO @TmpEvaluacionDetalle
		SELECT
			ted.ID_EVALUACION,
			ted.ID_EVALUACION_DETALLE,
			ted.NOTA,
			ted.ID_MATRICULA_ESTUDIANTE
			--tme.ID_MATRICULA_ESTUDIANTE		IdMatriculaEstudiante,
			--mp.ID_TIPO_DOCUMENTO			IdTipoDocumento,
			--enu.VALOR_ENUMERADO             TipoDocumento,
			--mp.NUMERO_DOCUMENTO_PERSONA		NumeroDocumentoPersona, 
			--UPPER(mp.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(mp.APELLIDO_MATERNO_PERSONA) + ', '+ dbo.UFN_CAPITALIZAR( mp.NOMBRE_PERSONA) Estudiante,
			--mc.ID_CARRERA					IdCarrera,
			--mc.NOMBRE_CARRERA				NombreProgramaEstudio,
			--tme.ID_SEMESTRE_ACADEMICO		IdSemestreAcademico,
			--se_semestre.VALOR_ENUMERADO		SemestreAcademico,	
			--mti.ID_TURNOS_POR_INSTITUCION	IdTurnoInstitucion,
			--se_turno.VALOR_ENUMERADO		TurnoInstitucion,	
			--tme.ID_PERIODO_ACADEMICO		IdPeriodoAcademico,
			--tpa.NOMBRE_PERIODO_ACADEMICO	NombrePeriodoAcademico,
			--tpe.ID_PLAN_ESTUDIO				IdPlanEstudios,
			--se_tipo_itin.VALOR_ENUMERADO	TipoPlanEstudios,
			--tpe.NOMBRE_PLAN_ESTUDIOS    	NombrePlanEstudios,
			--mpl.CODIGO_PERIODO_LECTIVO		CodigoPeriodoLectivo,
			--tpm.ID_TIPO_MATRICULA			IdTipoMatricula,
			--se_tipo_mat.VALOR_ENUMERADO		TipoMatricula,
			--tme.ID_PROGRAMACION_MATRICULA	IdProgramacionMatricula,
			--tme.FECHA_MATRICULA				FechaMatricula,
			--case when exists (select TOP 1 ED.ID_EVALUACION_DETALLE from transaccional.evaluacion_detalle ED where ED.ID_MATRICULA_ESTUDIANTE=tme.ID_MATRICULA_ESTUDIANTE AND ED.ES_ACTIVO=1
			--and ED.NOTA IS NOT NULL ) then cast(1 as bit)  else cast(0 as bit)  end EsEvaluado			
		FROM transaccional.evaluacion_detalle ted 
			INNER JOIN transaccional.matricula_estudiante tme on ted.ID_MATRICULA_ESTUDIANTE = tme.ID_MATRICULA_ESTUDIANTE AND tme.ES_ACTIVO=1
			INNER JOIN transaccional.programacion_matricula tpm on tpm.ID_PROGRAMACION_MATRICULA= tme.ID_PROGRAMACION_MATRICULA and tpm.ES_ACTIVO=1
			INNER JOIN transaccional.estudiante_institucion tei on tei.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION AND tei.ES_ACTIVO=1
			INNER JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION = tei.ID_PERSONA_INSTITUCION AND mpi.ESTADO=1
			INNER JOIN maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA AND mp.ESTADO=1
			INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE AND tcid.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION = tci.ID_CARRERAS_POR_INSTITUCION AND tei.ID_PLAN_ESTUDIO = tpe.ID_PLAN_ESTUDIO 
			--INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA = tci.ID_CARRERA
			--INNER JOIN sistema.enumerado se_semestre on se_semestre.ID_ENUMERADO = tme.ID_SEMESTRE_ACADEMICO
			INNER JOIN maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION = tei.ID_TURNOS_POR_INSTITUCION AND mti.ES_ACTIVO=1
			INNER JOIN maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA AND mte.ESTADO=1
			--INNER JOIN sistema.enumerado se_turno on se_turno.ID_ENUMERADO = mte.ID_TURNO
			INNER JOIN transaccional.periodo_academico tpa on tpa.ID_PERIODO_ACADEMICO= tme.ID_PERIODO_ACADEMICO AND tpa.ES_ACTIVO=1
			inner join transaccional.periodos_lectivos_por_institucion tpli on tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND tpli.ES_ACTIVO=1
			--inner join maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tpli.ID_PERIODO_LECTIVO
			--INNER JOIN sistema.enumerado se_tipo_itin on se_tipo_itin.ID_ENUMERADO= tpe.ID_TIPO_ITINERARIO
			--INNER JOIN sistema.enumerado se_tipo_mat on se_tipo_mat.ID_ENUMERADO= tpm.ID_TIPO_MATRICULA
			--INNER JOIN sistema.enumerado enu on mp.ID_TIPO_DOCUMENTO=enu.ID_ENUMERADO				
		WHERE ted.ES_ACTIVO=1
			AND (mp.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO=0)
			AND (mp.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NUMERO_DOCUMENTO_PERSONA + '%' COLLATE LATIN1_GENERAL_CI_AI
			AND (mp.APELLIDO_PATERNO_PERSONA + ' '+ mp.APELLIDO_MATERNO_PERSONA + ', ' + mp.NOMBRE_PERSONA) LIKE '%'+ @ESTUDIANTE +'%' COLLATE LATIN1_GENERAL_CI_AI
			AND (@ID_SEDE_INSTITUCION=0 OR tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION)
			AND (@ID_CARRERA=0 OR tci.ID_CARRERA=@ID_CARRERA)
			AND (@ID_TIPO_ITINERARIO= 0 OR tpe.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO)
			AND (@ID_PLAN_ESTUDIO= 0 OR tpe.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO)
			AND (@ID_PERIODO_ACADEMICO = 0 OR tme.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO)
			AND (@ID_SEMESTRE_ACADEMICO = 0 OR tme.ID_SEMESTRE_ACADEMICO=@ID_SEMESTRE_ACADEMICO)
			AND (tci.ID_INSTITUCION= @ID_INSTITUCION)
			AND (@ID_TURNOS_POR_INSTITUCION=0 OR tei.ID_TURNOS_POR_INSTITUCION = @ID_TURNOS_POR_INSTITUCION)
			AND tme.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION

		UPDATE ed SET ES_ACTIVO=0,NOTA=NULL,USUARIO_MODIFICACION=@USUARIO,FECHA_MODIFICACION=@fechaActual
		FROM transaccional.evaluacion_detalle ed
		WHERE ed.ID_EVALUACION_DETALLE IN (SELECT ID_EVALUACION_DETALLE FROM @TmpEvaluacionDetalle)
		
		INSERT INTO @TmpEvaluacion
		SELECT ROW_NUMBER() OVER(ORDER BY ID_EVALUACION ASC) NRO,ID_EVALUACION
		FROM (SELECT DISTINCT ID_EVALUACION 
			  FROM @TmpEvaluacionDetalle) e

		DECLARE @ES_ACTIVO BIT = 0
        DECLARE @ID_EVALUACION INT = 0
		DECLARE @NRO INT = 1
		DECLARE @TOTAL INT = (SELECT COUNT(ID_EVALUACION) FROM @TmpEvaluacion)
				
		WHILE (@NRO <= @TOTAL)
		BEGIN
			SET @ID_EVALUACION = (SELECT ID_EVALUACION FROM @TmpEvaluacion WHERE NRO=@NRO)
			
			IF EXISTS (SELECT ID_EVALUACION_DETALLE FROM transaccional.evaluacion_detalle WHERE ID_EVALUACION = @ID_EVALUACION AND ES_ACTIVO=1)
			BEGIN
				SET @ES_ACTIVO = 1
			END

			UPDATE e SET e.ES_ACTIVO=@ES_ACTIVO,e.CIERRE_PROGRAMACION=234,e.USUARIO_MODIFICACION=@USUARIO,e.FECHA_MODIFICACION=@fechaActual
			FROM transaccional.evaluacion e
			WHERE e.ID_EVALUACION = @ID_EVALUACION		
					
			SET @NRO = @NRO + 1
			CONTINUE;
			IF @NRO = @TOTAL
				BREAK;	
		END	 

		/** BORRAR NOTAS EFSRT ******************************************************/
		UPDATE ted SET ES_ACTIVO=0,NOTA=NULL,USUARIO_MODIFICACION=@USUARIO,FECHA_MODIFICACION=@fechaActual 
		--SELECT
		--	ted.ID_EVALUACION_EXPERIENCIA_FORMATIVA,
		--	ted.NOTA,
		--	ted.ID_MATRICULA_ESTUDIANTE			
		FROM transaccional.evaluacion_experiencia_formativa ted 
			INNER JOIN transaccional.matricula_estudiante tme on ted.ID_MATRICULA_ESTUDIANTE = tme.ID_MATRICULA_ESTUDIANTE AND tme.ES_ACTIVO=1
			--INNER JOIN transaccional.programacion_matricula tpm on tpm.ID_PROGRAMACION_MATRICULA= tme.ID_PROGRAMACION_MATRICULA and tpm.ES_ACTIVO=1
			INNER JOIN transaccional.estudiante_institucion tei on tei.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION AND tei.ES_ACTIVO=1
			INNER JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION = tei.ID_PERSONA_INSTITUCION AND mpi.ESTADO=1
			INNER JOIN maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA AND mp.ESTADO=1
			INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE AND tcid.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION = tci.ID_CARRERAS_POR_INSTITUCION AND tei.ID_PLAN_ESTUDIO = tpe.ID_PLAN_ESTUDIO 
			INNER JOIN maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION = tei.ID_TURNOS_POR_INSTITUCION AND mti.ES_ACTIVO=1
			INNER JOIN maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA AND mte.ESTADO=1
			INNER JOIN transaccional.periodo_academico tpa on tpa.ID_PERIODO_ACADEMICO= tme.ID_PERIODO_ACADEMICO AND tpa.ES_ACTIVO=1
			inner join transaccional.periodos_lectivos_por_institucion tpli on tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND tpli.ES_ACTIVO=1
		WHERE ted.ES_ACTIVO=1
			AND (mp.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO=0)
			AND (mp.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NUMERO_DOCUMENTO_PERSONA + '%' COLLATE LATIN1_GENERAL_CI_AI
			AND (mp.APELLIDO_PATERNO_PERSONA + ' '+ mp.APELLIDO_MATERNO_PERSONA + ', ' + mp.NOMBRE_PERSONA) LIKE '%'+ @ESTUDIANTE +'%' COLLATE LATIN1_GENERAL_CI_AI
			AND (@ID_SEDE_INSTITUCION=0 OR tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION)
			AND (@ID_CARRERA=0 OR tci.ID_CARRERA=@ID_CARRERA)
			AND (@ID_TIPO_ITINERARIO= 0 OR tpe.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO)
			AND (@ID_PLAN_ESTUDIO= 0 OR tpe.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO)
			AND (@ID_PERIODO_ACADEMICO = 0 OR tme.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO)
			AND (@ID_SEMESTRE_ACADEMICO = 0 OR tme.ID_SEMESTRE_ACADEMICO=@ID_SEMESTRE_ACADEMICO)
			AND (tci.ID_INSTITUCION= @ID_INSTITUCION)
			AND (@ID_TURNOS_POR_INSTITUCION=0 OR tei.ID_TURNOS_POR_INSTITUCION = @ID_TURNOS_POR_INSTITUCION)
			AND tme.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		/****************************************************************************/

		COMMIT TRANSACTION TransactSQL
			SELECT @@ROWCOUNT AS Value

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN TransactSQL
		PRINT ERROR_MESSAGE()
		SELECT				
			0 as Value
	END CATCH

END