/************************************************************************************************************************************
AUTOR				:	JUAN JOSE TOVAR YAÑEZ
FECHA DE CREACION	:	18/05/2022
LLAMADO POR			:
DESCRIPCION			:	Listado de matrículas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			18/09/2018		MRUIZ			CREACIÓN


TEST:		USP_MATRICULA_SEL_MATRICULA_ESTUDIANTE_PAGINADO1 290, 3921,0,'','',0,0,0,0,0,0,0
			USP_MATRICULA_SEL_MATRICULA_ESTUDIANTE_PAGINADO1 2164,1666,0,'','',0,0,0,0,0,0,0
*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_MATRICULA_ESTUDIANTE_PAGINADO1]
(  
	@ID_INSTITUCION					INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,
	@ID_TIPO_DOCUMENTO				INT,
	@NUMERO_DOCUMENTO_PERSONA		VARCHAR(16),
	@ESTUDIANTE						VARCHAR(150),
	@ID_SEDE_INSTITUCION			INT,
	@ID_CARRERA						INT,
	@ID_PLAN_ESTUDIO				INT,
	@ID_TIPO_ITINERARIO				INT,
	@ID_PERIODO_ACADEMICO			INT,
	@ID_SEMESTRE_ACADEMICO			INT,
	@ID_TURNOS_POR_INSTITUCION		INT, 
	@Pagina							int = 1,
	@Registros						int = 10  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @desde INT , @hasta INT;  
    SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;

	DECLARE @TmpPeriodoLectivoMatricula TABLE (IdPeriodosLectivosInstitucion int, IdPeriodoAcademico int, PeriodoAcademico varchar(10), ESTADO_pc int, estado varchar(10), Row int, Total int)
	INSERT INTO @TmpPeriodoLectivoMatricula
	EXEC USP_EVALUACION_SEL_CIERRE_PERIODO_LECTIVO_PAGINADO @ID_PERIODOS_LECTIVOS_POR_INSTITUCION,1,100
	
	SELECT T.*,
	STUFF(
						(
						select		 
									', ',convert(varchar(20),tude.ID_UNIDAD_DIDACTICA) + '|' +convert(varchar(20),tpcme.ID_PROGRAMACION_CLASE)
						FROM 
									transaccional.programacion_clase_por_matricula_estudiante tpcme									
									INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc 
											ON tudpc.ID_PROGRAMACION_CLASE = tpcme.ID_PROGRAMACION_CLASE
									INNER JOIN transaccional.unidades_didacticas_por_enfoque tude 
											ON tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE

						WHERE		 tudpc.ES_ACTIVO=1 and tpcme.ES_ACTIVO=1
									and tpcme.ID_MATRICULA_ESTUDIANTE= T.IdMatriculaEstudiante
						FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
						, 1, 1, '') as UnidadesDidacticas
	FROM(
		SELECT 			
					ROW_NUMBER() OVER ( ORDER BY UPPER(mp.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(mp.APELLIDO_MATERNO_PERSONA) + ', '+ dbo.UFN_CAPITALIZAR( mp.NOMBRE_PERSONA)) AS Row,
 					Total = COUNT(1) OVER ( ), 
					tei.ID_ESTUDIANTE_INSTITUCION	IdEstudianteInstitucion,
					tme.ID_MATRICULA_ESTUDIANTE		IdMatriculaEstudiante,
					mp.ID_TIPO_DOCUMENTO			IdTipoDocumento,
					enu.VALOR_ENUMERADO             TipoDocumento,
					mp.NUMERO_DOCUMENTO_PERSONA		NumeroDocumentoPersona, 
					UPPER(mp.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(mp.APELLIDO_MATERNO_PERSONA) + ', '+ dbo.UFN_CAPITALIZAR( mp.NOMBRE_PERSONA) Estudiante,
					mc.ID_CARRERA					IdCarrera,
					mc.NOMBRE_CARRERA				NombreProgramaEstudio,
					tme.ID_SEMESTRE_ACADEMICO		IdSemestreAcademico,
					se_semestre.VALOR_ENUMERADO		SemestreAcademico,	
					mti.ID_TURNOS_POR_INSTITUCION	IdTurnoInstitucion,
					se_turno.VALOR_ENUMERADO		TurnoInstitucion,	
					tme.ID_PERIODO_ACADEMICO		IdPeriodoAcademico,
					tpa.NOMBRE_PERIODO_ACADEMICO	NombrePeriodoAcademico,
					tpe.ID_PLAN_ESTUDIO				IdPlanEstudios,
					se_tipo_itin.VALOR_ENUMERADO	TipoPlanEstudios,
					tpe.ID_TIPO_ITINERARIO			IdTipoPlanEstudios,
					tpe.NOMBRE_PLAN_ESTUDIOS + ' (' + se_tipo_itin.VALOR_ENUMERADO + ')'    	NombrePlanEstudios,
					mpl.CODIGO_PERIODO_LECTIVO		CodigoPeriodoLectivo,
					tpm.ID_TIPO_MATRICULA			IdTipoMatricula,
					se_tipo_mat.VALOR_ENUMERADO		TipoMatricula,
					tme.ID_PROGRAMACION_MATRICULA	IdProgramacionMatricula,
					tme.FECHA_MATRICULA				FechaMatricula,
					case when exists (select TOP 1 ED.ID_EVALUACION_DETALLE from transaccional.evaluacion_detalle ED where ED.ID_MATRICULA_ESTUDIANTE=tme.ID_MATRICULA_ESTUDIANTE AND ED.ES_ACTIVO=1
					and ED.NOTA IS NOT NULL ) then cast(1 as bit)  else cast(0 as bit)  end EsEvaluado,
					(CAST((SELECT TOP 1 (CASE ESTADO_pc WHEN 0 THEN 1 WHEN 1 THEN 0 END) FROM @TmpPeriodoLectivoMatricula) AS bit)) EsCerrado
			FROM transaccional.matricula_estudiante tme
					INNER JOIN transaccional.programacion_matricula tpm on tpm.ID_PROGRAMACION_MATRICULA= tme.ID_PROGRAMACION_MATRICULA and tpm.ES_ACTIVO=1
					INNER JOIN transaccional.estudiante_institucion tei on tei.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION AND tei.ES_ACTIVO=1
					INNER JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION = tei.ID_PERSONA_INSTITUCION
					INNER JOIN maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA
					INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE 
					INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION
					INNER JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION = tci.ID_CARRERAS_POR_INSTITUCION AND tei.ID_PLAN_ESTUDIO = tpe.ID_PLAN_ESTUDIO 
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
					INNER JOIN sistema.enumerado enu on mp.ID_TIPO_DOCUMENTO=enu.ID_ENUMERADO				
			WHERE 
			(mp.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO=0)
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
			AND tme.ES_ACTIVO =1 AND tpe.ES_ACTIVO=1
			AND tme.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		)T    
		WHERE ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END