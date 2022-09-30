/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtener unidades didácticas para la matrícula de un estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
2.0			05/03/2021		JCHAVEZ			Modificación, se agregó validación de ud predecesoras que no se
											registraron en periodos lectivos anteriores al uso del sistema
3.0			23/03/2021		JCHAVEZ			Modificación, se agregó la validación de unidades didacticas de experiencias formativas
											para no mostrarlo en la matricula regular
4.0			21/04/2022		JCHAVEZ			Modificación, para considerar UD anteriores al semestre en estudiantes 
											trasladados y con convalidación

TEST:	USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO 2164,3774,3713,113,122281,223474,0
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO]
(  
	@ID_INSTITUCION INT, 
	@ID_PERIODO_ACADEMICO INT, 
	@ID_PLAN_ESTUDIO INT,
	@ID_SEMESTRE_ACADEMICO_ACTUAL INT,
	@ID_ESTUDIANTE_INSTITUCION INT,
	@ID_MATRICULA_ESTUDIANTE INT,
	@_ES_UNIDAD_DIDACTICA_EF BIT,
	@Pagina						int = 1,
	@Registros					int = 100  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE	 @IdUnidadDidactica int, @IdTipoUnidadDidactica int, @NombreTipoUnidadDidactica varchar(50),
				@IdModulo int, @NombreModulo	varchar(150), @IdSemestreAcademico	int,
				@CodigoUnidadDidactica varchar(16), @NombreUnidadDidactica	varchar(150), @Horas decimal,
				@Creditos decimal(5,1), @SemestreAcademico varchar(5),@Estado	varchar (20),
				@IdSemestreAcademicoI INT, @TienePredecesoras INT,
				@SEMESTRE_ACADEMICO_SIG VARCHAR(5),@SEMESTRE_ACADEMICO VARCHAR(5), @ID_SEMESTRE_ACADEMICO_SIG INT,@ID_SEMESTRE_ACADEMICO_INI INT,
				@NotaMinimaAprobatoria DECIMAL, @NOMBRE_PARAMETRO VARCHAR(30), @IdUnidadDidacticaPredecesora INT, 
				@UnidadDesaprobada INT, @DESCRIPCION_TIPO_ENUMERADO VARCHAR(10), @NroClasesProgramadas INT,
				@IdEstado INT,@EsDeProcesoAdmision BIT, @IdTipoEnumeradoEstadoUD INT,
				@ID_ESTADO_CONVALIDADO INT,
				@ID_ESTADO_CONVALIDACION INT,
				@ID_ESTADO_NO_CONVALIDADO INT,
				@ID_TIPO_HISTORICO INT,
				@ID_TIPO_ESTUDIANTE INT,
				@CANTIDAD_EVALUACIONES INT,
				--@HayConvalidaciones bit,
				@UDInsertada bit,	
				@NRO_SEMESTRES	INT, @IdTipoItinerario INT, @ItinerarioAsignatura INT =99,
				@ID_SEMESTRE_ACADEMICO_PENDIENTE_INI INT, --@ExcepcionEstudianteHistorico bit,
				 @ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI INT,
				 @ID_TIPO_UD_EXPERIENCIA_FORMATIVA INT,
				 @PERMITE_EDITAR_EF BIT

				SET @NOMBRE_PARAMETRO='NOTA_MINIMA_APROBATORIA'
				SET @DESCRIPCION_TIPO_ENUMERADO='SEMESTRE'
				SET @ID_SEMESTRE_ACADEMICO_INI=0
				SET @IdTipoEnumeradoEstadoUD = (SELECT ID_TIPO_ENUMERADO FROM sistema.tipo_enumerado WHERE DESCRIPCION_TIPO_ENUMERADO='ESTADO_UNIDAD_DIDACTICA')
				SET @ID_ESTADO_CONVALIDADO = 201
				SET @ID_ESTADO_NO_CONVALIDADO =202
				SET @ID_TIPO_HISTORICO =190
				SET @ID_TIPO_UD_EXPERIENCIA_FORMATIVA = 3
				SET @PERMITE_EDITAR_EF = 1

				SET @IdTipoItinerario  = (SELECT ID_TIPO_ITINERARIO FROM transaccional.plan_estudio WHERE ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO)
	create table #UnidadesDidacticas
	(
		 IdUnidadDidactica int,
		 IdTipoUnidadDidactica int,
		 NombreTipoUnidadDidactica varchar(50),
		 IdModulo int,
		 NombreModulo	varchar(MAX),
		 IdSemestreAcademico	int,
		 CodigoUnidadDidactica varchar(16),
		 NombreUnidadDidactica	varchar(150),
		 Horas decimal,
		 Creditos decimal(5,1), 
		 SemestreAcademico varchar(5),
		 Estado	varchar (20),
		 NroClasesProgramadas INT,
		 IdEstado INT, --ID interno, para prioridades
		 --EsAsignada bit 		 
		 IdMatriculaEstudiante INT,
		 Nota DECIMAL(18,2),
		 IdCierreEvaluacion INT null,
		 IdEvaluacionExperienciaFormativa INT null
	)
	SELECT 
		@EsDeProcesoAdmision=
		(CASE WHEN tpm.ID_POSTULANTES_POR_MODALIDAD IS NULL THEN 0 ELSE 1 END)
		 FROM transaccional.estudiante_institucion  tei		
		left JOIN transaccional.postulantes_por_modalidad  tpm on tpm.ID_PERSONA_INSTITUCION =tei.ID_PERSONA_INSTITUCION
		where tei.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION

		
	SET @ID_TIPO_ESTUDIANTE = (SELECT ID_TIPO_ESTUDIANTE FROM transaccional.estudiante_institucion WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION)

	SET @CANTIDAD_EVALUACIONES = (SELECT COUNT(1) FROM transaccional.evaluacion_detalle ED
								INNER JOIN transaccional.matricula_estudiante ME ON ED.ID_MATRICULA_ESTUDIANTE = ME.ID_MATRICULA_ESTUDIANTE AND ED.ES_ACTIVO=1 AND ME.ES_ACTIVO=1
								AND ED.ES_ACTIVO=1
								WHERE ME.ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION
							 )
	--if exists(SELECT top 1 ID_CONVALIDACION FROM transaccional.convalidacion where ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION and ES_ACTIVO=1)
	--SET @HayConvalidaciones =  CAST(1 AS BIT)
	--else
	--SET @HayConvalidaciones =  CAST(0 AS BIT)


	SELECT @SEMESTRE_ACADEMICO = VALOR_ENUMERADO FROM sistema.enumerado where ID_ENUMERADO=@ID_SEMESTRE_ACADEMICO_ACTUAL 

	SET @SEMESTRE_ACADEMICO_SIG  =	CASE WHEN @SEMESTRE_ACADEMICO ='I' THEN  'II' 
									WHEN @SEMESTRE_ACADEMICO ='II' THEN 'III'
									WHEN @SEMESTRE_ACADEMICO ='III'  THEN 'IV'
									WHEN @SEMESTRE_ACADEMICO ='IV'  THEN 'V'
									WHEN @SEMESTRE_ACADEMICO ='V'  THEN 'VI'
									WHEN @SEMESTRE_ACADEMICO ='VI'  THEN 'VII'
									ELSE 'VII'
									END	

	--if (@EsDeProcesoAdmision=0) SET @ID_SEMESTRE_ACADEMICO_INI= @ID_SEMESTRE_ACADEMICO_ACTUAL -->no depende de admisión
	
	
	select @NotaMinimaAprobatoria= VALOR_PARAMETRO from maestro.parametros_institucion where ID_INSTITUCION=@ID_INSTITUCION and NOMBRE_PARAMETRO=@NOMBRE_PARAMETRO
	--set @ExcepcionEstudianteHistorico = 0
	--IF (@ID_TIPO_ESTUDIANTE = @ID_TIPO_HISTORICO )  
	--BEGIN
	--set @ExcepcionEstudianteHistorico = 1
	--SI tiene una matrícula asociada
	IF EXISTS(SELECT TOP 1 ID_MATRICULA_ESTUDIANTE FROM transaccional.matricula_estudiante WHERE ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION AND ES_ACTIVO=1
				and ID_PERIODO_ACADEMICO <> @ID_PERIODO_ACADEMICO )
	BEGIN
		--Se toma el ciclo de la primera matrícula
		SET @ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI= (select MIN (ID_SEMESTRE_ACADEMICO) from transaccional.matricula_estudiante where ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION 
		AND ES_ACTIVO=1 )								
	END 
	ELSE
	BEGIN
		--Se toma el ciclo que se ha configurado en Registro de estudiante
		SET @ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI=  (SELECT ID_SEMESTRE_ACADEMICO FROM transaccional.estudiante_institucion WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION AND ES_ACTIVO=1)				
	END
	--END

	/** PARA MOSTRAR UD ANTERIORES PENDIENTES AL SEMESTRE TRASLADO O CONVALIDADO -- Versión 4.0 **/
	IF EXISTS(SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION FROM transaccional.convalidacion WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION AND ES_ACTIVO=1)
	BEGIN
		SET @ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI = 111
	END
	IF EXISTS(SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION FROM transaccional.traslado_estudiante WHERE ID_ESTUDIANTE_INSTITUCION_NUEVO=@ID_ESTUDIANTE_INSTITUCION AND ES_ACTIVO=1)
	BEGIN
		SET @ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI = 111
	END
	/**********************************************************************************/

	print 'eval:'  + convert(varchar,@ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI)
	--Se evalúa si existen unidades didácticas desaprobadas y no cursadas anteriores al ciclo actual

	SELECT ud.ID_UNIDAD_DIDACTICA, ud.NOMBRE_UNIDAD_DIDACTICA, ud.ID_SEMESTRE_ACADEMICO,
		CASE WHEN  SUBCONSULTA_EVALUACION_UNIDADES.ID_UNIDAD_DIDACTICA IS NULL and SUBCONSULTA_EVALUACION_UNIDADES.NOTA IS NULL AND SUBCONSULTA_CONVALIDACION.ID_CONVALIDACION_DETALLE is null THEN 'NO CURSADO'
		WHEN SUBCONSULTA_EVALUACION_UNIDADES.NOTA < @NotaMinimaAprobatoria THEN 'DESAPROBADO' ELSE 'CURSADO/CONVALIDADO' END ESTATUS
	INTO #TempUDSVerificar
	FROM transaccional.modulo m
	INNER JOIN transaccional.unidad_didactica ud on m.ID_MODULO= ud.ID_MODULO and m.ES_ACTIVO=1 and ud.ES_ACTIVO=1
	LEFT JOIN (	SELECT udxe.ID_UNIDAD_DIDACTICA, ed.NOTA 
				FROM transaccional.evaluacion e
					INNER JOIN transaccional.evaluacion_detalle ed  on e.ID_EVALUACION = ed.ID_EVALUACION and e.ES_ACTIVO=1 AND ed.ES_ACTIVO=1 
					INNER JOIN transaccional.programacion_clase pc on pc.ID_PROGRAMACION_CLASE= e.ID_PROGRAMACION_CLASE and pc.ES_ACTIVO=1
					INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udxpc on udxpc.ID_PROGRAMACION_CLASE= pc.ID_PROGRAMACION_CLASE and udxpc.ES_ACTIVO=1
					INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe on udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= udxpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE and udxe.ES_ACTIVO=1
					INNER JOIN transaccional.matricula_estudiante me on me.ID_MATRICULA_ESTUDIANTE = ed.ID_MATRICULA_ESTUDIANTE and me.ES_ACTIVO=1
				AND me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
				UNION ALL
                SELECT udxe.ID_UNIDAD_DIDACTICA, eef.NOTA
				FROM transaccional.evaluacion_experiencia_formativa eef
					INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe on udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= eef.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE and udxe.ES_ACTIVO=1
					INNER JOIN transaccional.matricula_estudiante me ON me.ID_MATRICULA_ESTUDIANTE = eef.ID_MATRICULA_ESTUDIANTE AND me.ES_ACTIVO=1
				AND eef.ES_ACTIVO=1 AND me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
			   ) SUBCONSULTA_EVALUACION_UNIDADES ON SUBCONSULTA_EVALUACION_UNIDADES.ID_UNIDAD_DIDACTICA= ud.ID_UNIDAD_DIDACTICA
	LEFT JOIN ( SELECT cd.ID_CONVALIDACION_DETALLE, cd.ID_UNIDAD_DIDACTICA 
				FROM transaccional.convalidacion c 
					INNER JOIN transaccional.convalidacion_detalle cd on cd.ID_CONVALIDACION= cd.ID_CONVALIDACION and c.ES_ACTIVO =1 and  cd.ES_ACTIVO=1 and cd.ESTADO=201 and 
				c.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION
			  ) SUBCONSULTA_CONVALIDACION ON SUBCONSULTA_CONVALIDACION.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA
	WHERE m.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO and ud.ID_SEMESTRE_ACADEMICO<@ID_SEMESTRE_ACADEMICO_ACTUAL
	AND ((@_ES_UNIDAD_DIDACTICA_EF = 0 AND ud.ID_TIPO_UNIDAD_DIDACTICA <> @ID_TIPO_UD_EXPERIENCIA_FORMATIVA) OR
		 (@_ES_UNIDAD_DIDACTICA_EF = 1 AND ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UD_EXPERIENCIA_FORMATIVA))

	SET @ID_SEMESTRE_ACADEMICO_PENDIENTE_INI = (select top 1 ID_SEMESTRE_ACADEMICO  from #TempUDSVerificar WHERE ESTATUS ='DESAPROBADO' ORDER BY 1 ASC)

	DROP TABLE #TempUDSVerificar
	
	PRINT @ID_SEMESTRE_ACADEMICO_PENDIENTE_INI

	IF @ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI IS NOT NULL
		SET @ID_SEMESTRE_ACADEMICO_INI= @ID_SEMESTRE_ACADEMICO_PENDIENTE_HIST_INI
	ELSE IF @ID_SEMESTRE_ACADEMICO_PENDIENTE_INI IS NOT NULL
		SET @ID_SEMESTRE_ACADEMICO_INI= @ID_SEMESTRE_ACADEMICO_PENDIENTE_INI		
	ELSE
		SET @ID_SEMESTRE_ACADEMICO_INI= @ID_SEMESTRE_ACADEMICO_ACTUAL
	
	PRINT 'FINAL:'  + CONVERT(varchar, @ID_SEMESTRE_ACADEMICO_INI)
									
	SELECT @ID_SEMESTRE_ACADEMICO_SIG = ID_ENUMERADO FROM sistema.enumerado where VALOR_ENUMERADO=@SEMESTRE_ACADEMICO_SIG  
	
	SET @NRO_SEMESTRES =(
						SELECT MNF.SEMESTRES_ACADEMICOS FROM transaccional.plan_estudio TPE
							INNER JOIN transaccional.carreras_por_institucion TCI ON TCI.ID_CARRERAS_POR_INSTITUCION=TPE.ID_CARRERAS_POR_INSTITUCION AND TPE.ES_ACTIVO=1 AND TCI.ES_ACTIVO=1
							INNER JOIN db_auxiliar.dbo.UVW_CARRERA MC ON MC.ID_CARRERA= TCI.ID_CARRERA 
							INNER JOIN maestro.nivel_formacion MNF ON MNF.CODIGO_TIPO = MC.TIPO_NIVEL_FORMACION --MNF.ID_NIVEL_FORMACION= MC.ID_NIVEL_FORMACION 	--reemplazoPorVista
						WHERE TPE.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO
						)

	SELECT @IdSemestreAcademicoI= ID_ENUMERADO FROM sistema.enumerado WHERE VALOR_ENUMERADO ='I'
	
	PRINT 'DATOS-> @ID_PLAN_ESTUDIO:' + CONVERT(VARCHAR(10),@ID_PLAN_ESTUDIO) + ' @DESCRIPCION_TIPO_ENUMERADO:' + CONVERT(VARCHAR(30),@DESCRIPCION_TIPO_ENUMERADO) +
	' @ID_PERIODO_ACADEMICO:'+ CONVERT(VARCHAR(10),@ID_PERIODO_ACADEMICO) + 
	' @ID_SEMESTRE_ACADEMICO_INI:' +CONVERT(VARCHAR(10),@ID_SEMESTRE_ACADEMICO_INI)  + ' @ID_SEMESTRE_ACADEMICO_SIG:' + CONVERT(VARCHAR(10),@ID_SEMESTRE_ACADEMICO_SIG)+
	' @NRO_SEMESTRES:' + CONVERT(VARCHAR(10),@NRO_SEMESTRES) + ' @IdTipoItinerario:' + CONVERT(varchar(10), @IdTipoItinerario)

	--Listar unidades didácticas del ciclo actual y del siguiente
	DECLARE unidades_didacticas_cursor CURSOR FOR   

	SELECT DISTINCT
		tud.ID_UNIDAD_DIDACTICA IdUnidadDidactica,
		ISNULL(tud.ID_TIPO_UNIDAD_DIDACTICA,0) IdTipoUnidadDidactica, 
		ISNULL(mtud.NOMBRE_TIPO_UNIDAD,'Curso') NombreTipoUnidadDidactica,
		tm.ID_MODULO IdModulo,
		tm.NOMBRE_MODULO NombreModulo,
		tud.ID_SEMESTRE_ACADEMICO IdSemestreAcademico, 
		tud.CODIGO_UNIDAD_DIDACTICA CodigoUnidadDidactica,
		tud.NOMBRE_UNIDAD_DIDACTICA NombreUnidadDidactica, 
		tud.HORAS Horas,
		tud.CREDITOS Creditos,
		se_ciclo.VALOR_ENUMERADO SemestreAcademico,	    
		--0 EsAsignada
		CASE WHEN tudd.ID_UNIDAD_DIDACTICA IS NULL THEN 0 ELSE 1 END TienePredecesoras,
		COUNT (A.IdProgramacionClase) NroClasesProgramadas
	FROM transaccional.plan_estudio tpe
		INNER JOIN transaccional.modulo  tm on tpe.ID_PLAN_ESTUDIO = tm.ID_PLAN_ESTUDIO and tpe.ES_ACTIVO=1 and tm.ES_ACTIVO=1
		INNER JOIN transaccional.unidad_didactica tud on tud.ID_MODULO = tm.ID_MODULO and  tud.ES_ACTIVO=1 
		LEFT JOIN maestro.tipo_unidad_didactica mtud on tud.ID_TIPO_UNIDAD_DIDACTICA = mtud.ID_TIPO_UNIDAD_DIDACTICA	--En asignaturas no se guarda un tipo, ese valor es nulo
		INNER JOIN sistema.enumerado se_ciclo on se_ciclo.ID_ENUMERADO = tud.ID_SEMESTRE_ACADEMICO	
		LEFT JOIN transaccional.unidad_didactica_detalle tudd on tudd.ID_UNIDAD_DIDACTICA = tud.ID_UNIDAD_DIDACTICA
		INNER JOIN transaccional.unidades_didacticas_por_enfoque tude on tude.ID_UNIDAD_DIDACTICA= tud.ID_UNIDAD_DIDACTICA		
		LEFT JOIN (	SELECT tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE IdUnidadesDidacticasEnfoque, tpc.ID_PROGRAMACION_CLASE IdProgramacionClase,  tpc.ID_PERIODO_ACADEMICO IdPeriodoAcademico 
					FROM transaccional.unidades_didacticas_por_programacion_clase tudpc
						INNER JOIN transaccional.programacion_clase tpc on tpc.ID_PROGRAMACION_CLASE = tudpc.ID_PROGRAMACION_CLASE	
					WHERE tpc.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO AND tudpc.ES_ACTIVO=1					
				   ) A on A.IdUnidadesDidacticasEnfoque = tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
	WHERE tm.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO 
		AND tud.ID_SEMESTRE_ACADEMICO in (
											SELECT ID_ENUMERADO 
											FROM sistema.enumerado se_semestre 
											WHERE se_semestre.ID_TIPO_ENUMERADO= (select ID_TIPO_ENUMERADO FROM sistema.tipo_enumerado where DESCRIPCION_TIPO_ENUMERADO=@DESCRIPCION_TIPO_ENUMERADO)					
												AND (se_semestre.ID_ENUMERADO>=@ID_SEMESTRE_ACADEMICO_INI OR @ID_SEMESTRE_ACADEMICO_INI=0) 
												AND se_semestre.ID_ENUMERADO IN (SELECT TOP (@NRO_SEMESTRES) *  FROM dbo.UFN_SPLIT('111|112|113|114|115|116|137|138','|'))	 
											)
		AND tud.ID_SEMESTRE_ACADEMICO <= (CASE WHEN @IdTipoItinerario = @ItinerarioAsignatura THEN @ID_SEMESTRE_ACADEMICO_ACTUAL ELSE tud.ID_SEMESTRE_ACADEMICO END)
		AND ((@_ES_UNIDAD_DIDACTICA_EF = 0 AND tud.ID_TIPO_UNIDAD_DIDACTICA <> @ID_TIPO_UD_EXPERIENCIA_FORMATIVA) OR
				(@_ES_UNIDAD_DIDACTICA_EF = 1 AND tud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UD_EXPERIENCIA_FORMATIVA))		
	GROUP BY	
			tud.ID_UNIDAD_DIDACTICA,tud.ID_TIPO_UNIDAD_DIDACTICA, 
			mtud.NOMBRE_TIPO_UNIDAD , tm.ID_MODULO ,	tm.NOMBRE_MODULO ,
			tud.ID_SEMESTRE_ACADEMICO , tud.CODIGO_UNIDAD_DIDACTICA ,
			tud.NOMBRE_UNIDAD_DIDACTICA , tud.HORAS ,
			tud.CREDITOS ,
			se_ciclo.VALOR_ENUMERADO, tudd.ID_UNIDAD_DIDACTICA 
		
	OPEN unidades_didacticas_cursor  
	
	FETCH NEXT FROM unidades_didacticas_cursor   
	INTO	@IdUnidadDidactica ,@IdTipoUnidadDidactica , @NombreTipoUnidadDidactica ,
			@IdModulo , @NombreModulo, @IdSemestreAcademico,@CodigoUnidadDidactica,
			@NombreUnidadDidactica, @Horas, @Creditos, @SemestreAcademico, @TienePredecesoras,@NroClasesProgramadas

	WHILE @@FETCH_STATUS = 0  
	BEGIN 
		BEGIN		
			PRINT 'INI - SIN PREDECESORAS - ' + CONVERT(VARCHAR(20), @Creditos)  + ' - '+CONVERT(VARCHAR(20), @IdUnidadDidactica) 
					
			SET @Estado = NULL
			SELECT TOP 1 @Estado =
				(CASE WHEN A.NOTA IS NULL THEN 'NA'
				WHEN A.NOTA >= @NotaMinimaAprobatoria THEN 'APROBADO'
				ELSE 'DESAPROBADO' 
				END ) 
			FROM 
			transaccional.matricula_estudiante tme 
			LEFT JOIN 					
				(SELECT tevd.ID_MATRICULA_ESTUDIANTE, tude.ID_UNIDAD_DIDACTICA, tevd.NOTA 
				 FROM transaccional.evaluacion_detalle tevd 
					INNER JOIN transaccional.evaluacion tev on tev.ID_EVALUACION = tevd.ID_EVALUACION and tev.ES_ACTIVO=1 and tevd.ES_ACTIVO=1 
					INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc on tudpc.ID_PROGRAMACION_CLASE= tev.ID_PROGRAMACION_CLASE AND tudpc.ES_ACTIVO=1 
					INNER JOIN transaccional.unidades_didacticas_por_enfoque tude on tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND tude.ES_ACTIVO=1
					INNER JOIN transaccional.matricula_estudiante me ON me.ID_MATRICULA_ESTUDIANTE = tevd.ID_MATRICULA_ESTUDIANTE AND me.ES_ACTIVO=1
				 AND me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
				 UNION ALL
				 SELECT me.ID_MATRICULA_ESTUDIANTE, udxe.ID_UNIDAD_DIDACTICA, eef.NOTA
				 FROM transaccional.evaluacion_experiencia_formativa eef
					INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe on udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= eef.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE and udxe.ES_ACTIVO=1
					INNER JOIN transaccional.matricula_estudiante me ON me.ID_MATRICULA_ESTUDIANTE = eef.ID_MATRICULA_ESTUDIANTE AND me.ES_ACTIVO=1
				 AND eef.ES_ACTIVO=1 AND me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
				) A on A.ID_MATRICULA_ESTUDIANTE = tme.ID_MATRICULA_ESTUDIANTE AND A.ID_UNIDAD_DIDACTICA=@IdUnidadDidactica
			WHERE tme.ID_ESTUDIANTE_INSTITUCION =@ID_ESTUDIANTE_INSTITUCION and tme.ES_ACTIVO=1
			ORDER BY A.ID_MATRICULA_ESTUDIANTE DESC 

			--if(@Estado is null) set @Estado= 'NA'
			print 'original:' +  @Estado
			IF @Estado IS NULL or @Estado='NA'
			BEGIN
			SET @ID_ESTADO_CONVALIDACION = (SELECT TOP 1 tcd.ESTADO FROM transaccional.convalidacion tc
								INNER JOIN transaccional.convalidacion_detalle tcd on tc.ID_CONVALIDACION = tcd.ID_CONVALIDACION AND tc.ES_ACTIVO =1 AND tcd.ES_ACTIVO=1
								WHERE tc.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION 
								AND tcd.ID_UNIDAD_DIDACTICA =@IdUnidadDidactica  and tcd.ESTADO= @ID_ESTADO_CONVALIDADO)
			print 'evaluando'
				IF @ID_ESTADO_CONVALIDACION = @ID_ESTADO_CONVALIDADO 
					--EVALUAR SI SE TIENE CONVALIDACION						  
				set @Estado ='CONVALIDADO'
						 
				IF @ID_ESTADO_CONVALIDACION is null
				SET @Estado='NC' --NO CONVALIDADO
			END					
				
			if(@Estado is null) set @Estado= 'NA'
			--PRINT 'NO HAY PREDECESORAS - CRÉDITOS: '+  CONVERT(VARCHAR(10),@Creditos)
			print @Estado + ' (malva) - '+CONVERT(VARCHAR(20), @IdUnidadDidactica) 
			set @UDInsertada = 0
					

			if (@Estado<>'APROBADO' AND @Estado<>'CONVALIDADO' AND (NOT (@TienePredecesoras = 1 AND @Estado ='NC') or (--@ExcepcionEstudianteHistorico =1 and 
			@ID_SEMESTRE_ACADEMICO_INI =@IdSemestreAcademico)) ) 
			BEGIN					
				INSERT INTO #UnidadesDidacticas
				SELECT  
				@IdUnidadDidactica ,
				@IdTipoUnidadDidactica ,
				@NombreTipoUnidadDidactica ,
				@IdModulo ,
				@NombreModulo,
				@IdSemestreAcademico,
				@CodigoUnidadDidactica,
				@NombreUnidadDidactica,
				@Horas,
				@Creditos,
				@SemestreAcademico,					
				CASE WHEN (@Estado='NA' OR @Estado ='NC') and @IdSemestreAcademico>@ID_SEMESTRE_ACADEMICO_ACTUAL THEN 'ADELANTO'	
						WHEN @Estado='DESAPROBADO' THEN 'SUBSANACIÓN' 
						ELSE  'REGULAR'
				END,
				@NroClasesProgramadas,
				CASE WHEN (@Estado='NA' OR @Estado ='NC') and @IdSemestreAcademico>@ID_SEMESTRE_ACADEMICO_ACTUAL THEN 3
						WHEN @Estado='DESAPROBADO' THEN 2
						ELSE  1
				END,
				0,
				0,
				null,
				null
				set @UDInsertada = 1
			END
		END  	
		IF (@TienePredecesoras = 1 AND ( @ID_TIPO_ESTUDIANTE <> @ID_TIPO_HISTORICO OR @CANTIDAD_EVALUACIONES > 0  --OR @HayConvalidaciones = 1
		OR (@ID_TIPO_ESTUDIANTE=@ID_TIPO_HISTORICO AND @IdSemestreAcademico <> @ID_SEMESTRE_ACADEMICO_INI) ) and (@UDInsertada =0 and @Estado<>'APROBADO' AND @Estado<>'CONVALIDADO')  )  --EVALUAR SI SE DEBE MOSTRAR, ESTO PARA LA VISUALIZACIÓN DE SEMESTRES > I And @EsDeProcesoAdmision=1 ??
		BEGIN
		
			SET @UnidadDesaprobada = 0

			--Se identifican las unidades didácticas predecesoras
			DECLARE unidades_didacticas_predecesoras_cursor CURSOR FOR   
			SELECT
				tud.ID_UNIDAD_DIDACTICA IdUnidadDidacticaPredecesora 				
			FROM transaccional.unidad_didactica tud
				LEFT JOIN transaccional.unidad_didactica_detalle tudd ON tudd.ID_UNIDAD_DIDACTICA = tud.ID_UNIDAD_DIDACTICA
				INNER JOIN transaccional.unidad_didactica_detalle tudd2 ON tud.CODIGO_UNIDAD_DIDACTICA= tudd2.CODIGO_PREDECESORA
			WHERE tudd2.ID_UNIDAD_DIDACTICA=@IdUnidadDidactica AND tud.ID_MODULO IN (SELECT ID_MODULO 
																					FROM transaccional.modulo 
																					WHERE ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO)										
															
			OPEN unidades_didacticas_predecesoras_cursor  
			FETCH NEXT FROM unidades_didacticas_predecesoras_cursor   
			INTO @IdUnidadDidacticaPredecesora
			WHILE @@FETCH_STATUS = 0  
			BEGIN
				SET @UnidadDesaprobada=0 
						
				--buscar en evaluación
				IF NOT EXISTS(SELECT TOP 1
								tme.ID_PERIODO_ACADEMICO IdPeriodoAcademico, 
								tude.ID_UNIDAD_DIDACTICA IdUnidadDidactica ,
								tme.ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
								tev.ID_PROGRAMACION_CLASE IdProgramacionClase,
								tevd.NOTA Nota								
							  FROM transaccional.evaluacion tev
								INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc on tev.ID_PROGRAMACION_CLASE = tudpc.ID_PROGRAMACION_CLASE AND                                                                 tev.ES_ACTIVO=1 and tudpc.ES_ACTIVO=1
								INNER JOIN transaccional.unidades_didacticas_por_enfoque tude on tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE=tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE                                                                 and tude.ES_ACTIVO=1
								INNER JOIN transaccional.evaluacion_detalle tevd on tevd.ID_EVALUACION = tev.ID_EVALUACION and tevd.ES_ACTIVO=1
								INNER JOIN transaccional.matricula_estudiante tme on tme.ID_MATRICULA_ESTUDIANTE = tevd.ID_MATRICULA_ESTUDIANTE and tme.ES_ACTIVO=1
							  WHERE tme.ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION  
								AND tude.ID_UNIDAD_DIDACTICA=@IdUnidadDidacticaPredecesora AND ROUND(tevd.NOTA,0)>= @NotaMinimaAprobatoria
							  UNION ALL
							  SELECT TOP 1
								me.ID_PERIODO_ACADEMICO IdPeriodoAcademico,
								udxe.ID_UNIDAD_DIDACTICA IdUnidadDidactica ,
								me.ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
								0 IdProgramacionClase,
								eef.NOTA Nota		
							  FROM transaccional.evaluacion_experiencia_formativa eef
								INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe on udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= eef.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE and udxe.ES_ACTIVO=1
								INNER JOIN transaccional.matricula_estudiante me ON me.ID_MATRICULA_ESTUDIANTE = eef.ID_MATRICULA_ESTUDIANTE AND me.ES_ACTIVO=1
							  WHERE me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
								AND eef.ES_ACTIVO=1 AND udxe.ID_UNIDAD_DIDACTICA=@IdUnidadDidacticaPredecesora AND ROUND(eef.NOTA,0)>= @NotaMinimaAprobatoria
							  /*ORDER BY tme.ID_PERIODO_ACADEMICO DESC*/)
				BEGIN
							
					--buscar en convalidaciones 
					SET @ID_ESTADO_CONVALIDACION = (SELECT TOP 1 tcd.ESTADO 
													FROM transaccional.convalidacion tc
													INNER JOIN transaccional.convalidacion_detalle tcd on tc.ID_CONVALIDACION = tcd.ID_CONVALIDACION AND tc.ES_ACTIVO =1 AND tcd.ES_ACTIVO=1
													WHERE tc.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION 
													AND tcd.ID_UNIDAD_DIDACTICA =@IdUnidadDidacticaPredecesora and tcd.ESTADO= @ID_ESTADO_CONVALIDADO  )

					--IF @ID_ESTADO_CONVALIDACION = @ID_ESTADO_NO_CONVALIDADO or @ID_ESTADO_CONVALIDACION is null
					IF @ID_ESTADO_CONVALIDACION is null
						--No se puede mostrar porque no se han cumplido con las predecesoras
					SET @UnidadDesaprobada =1
														
					--IF NOT EXISTS (SELECT TOP 1 tcd.NOTA, tcd.ID_UNIDAD_DIDACTICA FROM transaccional.convalidacion tc
					--	INNER JOIN transaccional.convalidacion_detalle tcd on tc.ID_CONVALIDACION= tcd.ID_CONVALIDACION AND tc.ES_ACTIVO=1 AND tcd.ES_ACTIVO=1
					--	WHERE tc.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION 
					--	AND tcd.ID_UNIDAD_DIDACTICA = @IdUnidadDidacticaPredecesora AND tcd.ESTADO = @ID_ESTADO_CONVALIDADO)
					----No se puede mostrar porque no se han cumplido con las predecesoras
					--set @UnidadDesaprobada =1
				END

				PRINT '@IdUnidadDidacticaPredecesora:' + CONVERT (VARCHAR(5),@IdUnidadDidacticaPredecesora)
				FETCH NEXT FROM unidades_didacticas_predecesoras_cursor   
				INTO @IdUnidadDidacticaPredecesora
			END
			CLOSE unidades_didacticas_predecesoras_cursor;
			DEALLOCATE unidades_didacticas_predecesoras_cursor; 

			--2.0 Verificar si existe registro de matrícula y evaluación de la UD predecesora en periodos lectivos anteriores
			IF ((SELECT ID_SEMESTRE_ACADEMICO FROM transaccional.unidad_didactica WHERE ID_UNIDAD_DIDACTICA=@IdUnidadDidacticaPredecesora) < 
				(SELECT ID_SEMESTRE_ACADEMICO FROM transaccional.estudiante_institucion WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION))
			BEGIN
				IF NOT EXISTS(SELECT TOP 1
								tme.ID_PERIODO_ACADEMICO IdPeriodoAcademico, 
								tude.ID_UNIDAD_DIDACTICA IdUnidadDidactica ,
								tme.ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
								tev.ID_PROGRAMACION_CLASE IdProgramacionClase,
								tevd.NOTA Nota								
							  FROM transaccional.evaluacion tev
								INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc on tev.ID_PROGRAMACION_CLASE = tudpc.ID_PROGRAMACION_CLASE AND                                                                 tev.ES_ACTIVO=1 and tudpc.ES_ACTIVO=1
								INNER JOIN transaccional.unidades_didacticas_por_enfoque tude on tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE=tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE                                                                 and tude.ES_ACTIVO=1
								INNER JOIN transaccional.unidad_didactica ud ON tude.ID_UNIDAD_DIDACTICA =  ud.ID_UNIDAD_DIDACTICA
								INNER JOIN transaccional.evaluacion_detalle tevd on tevd.ID_EVALUACION = tev.ID_EVALUACION and tevd.ES_ACTIVO=1
								INNER JOIN transaccional.matricula_estudiante tme on tme.ID_MATRICULA_ESTUDIANTE = tevd.ID_MATRICULA_ESTUDIANTE and tme.ES_ACTIVO=1
								INNER JOIN transaccional.estudiante_institucion ei ON tme.ID_ESTUDIANTE_INSTITUCION = ei.ID_ESTUDIANTE_INSTITUCION 
							  WHERE tme.ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION  
								AND tude.ID_UNIDAD_DIDACTICA=@IdUnidadDidacticaPredecesora
							  UNION ALL
							  SELECT TOP 1 
								me.ID_PERIODO_ACADEMICO IdPeriodoAcademico,
								udxe.ID_UNIDAD_DIDACTICA IdUnidadDidactica ,
								me.ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
								0 IdProgramacionClase,
								eef.NOTA Nota		
							  FROM transaccional.evaluacion_experiencia_formativa eef
								INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe on udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= eef.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE and udxe.ES_ACTIVO=1
								INNER JOIN transaccional.matricula_estudiante me ON me.ID_MATRICULA_ESTUDIANTE = eef.ID_MATRICULA_ESTUDIANTE AND me.ES_ACTIVO=1
							  WHERE me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
								AND eef.ES_ACTIVO=1 AND udxe.ID_UNIDAD_DIDACTICA=@IdUnidadDidacticaPredecesora
							/*ORDER BY tme.ID_PERIODO_ACADEMICO DESC*/)
				BEGIN 
					SET @UnidadDesaprobada=0 
				END
			END

			IF(@UnidadDesaprobada=0)
			BEGIN
					INSERT INTO #UnidadesDidacticas
					SELECT  
							@IdUnidadDidactica ,
							@IdTipoUnidadDidactica ,
							@NombreTipoUnidadDidactica ,
							@IdModulo ,
							@NombreModulo,
							@IdSemestreAcademico,
							@CodigoUnidadDidactica,
							@NombreUnidadDidactica,
							@Horas,
							@Creditos,
							@SemestreAcademico,							
							CASE WHEN @IdSemestreAcademico>@ID_SEMESTRE_ACADEMICO_ACTUAL THEN 'ADELANTO' ELSE'REGULAR' END,
							@NroClasesProgramadas,
							CASE WHEN @IdSemestreAcademico>@ID_SEMESTRE_ACADEMICO_ACTUAL THEN 3 ELSE 1 END,
							0,
							0,
							null,
							null
			END
		END 
		--ELSE

		FETCH NEXT FROM unidades_didacticas_cursor   
		INTO		@IdUnidadDidactica ,@IdTipoUnidadDidactica , @NombreTipoUnidadDidactica ,
		@IdModulo , @NombreModulo, @IdSemestreAcademico,@CodigoUnidadDidactica,
		@NombreUnidadDidactica, @Horas ,
		@Creditos, @SemestreAcademico,@TienePredecesoras,@NroClasesProgramadas

	END   
	CLOSE unidades_didacticas_cursor;
	DEALLOCATE unidades_didacticas_cursor;   
	
	IF (@_ES_UNIDAD_DIDACTICA_EF = 1)
	BEGIN
		UPDATE ud SET ud.IdMatriculaEstudiante = eef.ID_MATRICULA_ESTUDIANTE,ud.Nota = eef.NOTA
		FROM #UnidadesDidacticas ud
		LEFT JOIN transaccional.unidades_didacticas_por_enfoque udxe ON ud.IdUnidadDidactica = udxe.ID_UNIDAD_DIDACTICA
		LEFT JOIN transaccional.evaluacion_experiencia_formativa eef ON udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = eef.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
			AND eef.ES_ACTIVO=1 AND eef.ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE

		IF EXISTS(SELECT TOP 1 ID_EVALUACION_EXPERIENCIA_FORMATIVA FROM transaccional.evaluacion_experiencia_formativa WHERE ES_ACTIVO=1 AND ID_MATRICULA_ESTUDIANTE=@ID_MATRICULA_ESTUDIANTE)
		BEGIN 
			--agregar
			
			SELECT * INTO #UnidadesDidacticasTmp
			FROM #UnidadesDidacticas

			DELETE FROM #UnidadesDidacticas

			INSERT INTO #UnidadesDidacticas
			        ( IdUnidadDidactica ,
			          IdTipoUnidadDidactica ,
			          NombreTipoUnidadDidactica ,
			          IdModulo ,
			          NombreModulo ,
			          IdSemestreAcademico ,
			          CodigoUnidadDidactica ,
			          NombreUnidadDidactica ,
			          Horas ,
			          Creditos ,
			          SemestreAcademico ,
			          Estado ,
			          NroClasesProgramadas ,
			          IdEstado ,
			          IdMatriculaEstudiante ,
			          Nota,
					  IdCierreEvaluacion,
					  IdEvaluacionExperienciaFormativa
			        )
			SELECT  ud.ID_UNIDAD_DIDACTICA,ud.ID_TIPO_UNIDAD_DIDACTICA,mtud.NOMBRE_TIPO_UNIDAD,ud.ID_MODULO,m.NOMBRE_MODULO,ud.ID_SEMESTRE_ACADEMICO,
			ud.CODIGO_UNIDAD_DIDACTICA,ud.NOMBRE_UNIDAD_DIDACTICA,ud.HORAS,ud.CREDITOS,CAST(e_sem.VALOR_ENUMERADO AS VARCHAR(5)),'APROBADO',0,1,eef.ID_MATRICULA_ESTUDIANTE,eef.NOTA,
			eef.CIERRE_EVALUACION,eef.ID_EVALUACION_EXPERIENCIA_FORMATIVA
			FROM transaccional.evaluacion_experiencia_formativa eef
			INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe ON udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = eef.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND udxe.ES_ACTIVO=1
			INNER JOIN transaccional.unidad_didactica ud ON ud.ID_UNIDAD_DIDACTICA = udxe.ID_UNIDAD_DIDACTICA AND ud.ES_ACTIVO=1
			INNER JOIN transaccional.modulo m ON m.ID_MODULO = ud.ID_MODULO
			INNER JOIN sistema.enumerado e_sem ON e_sem.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO
			LEFT JOIN maestro.tipo_unidad_didactica mtud on ud.ID_TIPO_UNIDAD_DIDACTICA = mtud.ID_TIPO_UNIDAD_DIDACTICA
			WHERE eef.ES_ACTIVO=1 AND eef.ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE

			INSERT INTO #UnidadesDidacticas
			SELECT * FROM #UnidadesDidacticasTmp WHERE IdUnidadDidactica NOT IN (SELECT IdUnidadDidactica FROM #UnidadesDidacticas)

			DROP TABLE #UnidadesDidacticasTmp

			SET @PERMITE_EDITAR_EF = 0
		END
    END

	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;    

	 WITH tempPaginado AS  
	 ( 
		SELECT  IdUnidadDidactica ,
			IdTipoUnidadDidactica ,
			NombreTipoUnidadDidactica ,
			IdModulo ,
			NombreModulo,
			IdSemestreAcademico,
			CodigoUnidadDidactica,
			NombreUnidadDidactica,
			Horas,
			Creditos,
			SemestreAcademico,
			Estado,
			NroClasesProgramadas,
			ISNULL(IdCierreEvaluacion,234) IdCierreEvaluacion,
			(SELECT ID_ENUMERADO FROM sistema.enumerado WHERE VALOR_ENUMERADO= Estado and ID_TIPO_ENUMERADO=@IdTipoEnumeradoEstadoUD) IdEstadoUnidadDidactica,
			ISNULL(IdMatriculaEstudiante,0) IdMatriculaEstudiante,
			ISNULL(IdEvaluacionExperienciaFormativa,0) IdEvaluacionExperienciaFormativa,
			ISNULL(Nota,0) Nota,
			(CAST ((CASE WHEN @PERMITE_EDITAR_EF = 0 THEN (CASE WHEN IdMatriculaEstudiante = @ID_MATRICULA_ESTUDIANTE THEN 1 ELSE 0 END) ELSE 1 END) AS BIT)) AS PermiteEditar,			
			--ROW_NUMBER() OVER ( ORDER BY  IdEstado, IdUnidadDidactica) AS Row,
		    ROW_NUMBER() OVER ( ORDER BY  IdSemestreAcademico, IdUnidadDidactica) AS Row,
			Total = COUNT(1) OVER ( )			
		FROM #UnidadesDidacticas
	)

	SELECT * FROM tempPaginado T WHERE ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
	DROP TABLE #UnidadesDidacticas;
END
GO


