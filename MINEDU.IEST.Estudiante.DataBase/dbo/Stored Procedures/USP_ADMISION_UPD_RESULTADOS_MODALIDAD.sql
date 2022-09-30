CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_RESULTADOS_MODALIDAD]
(  
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@ID_MODALIDADES_POR_PROCESO_ADMISION	INT,
	@USUARIO								VARCHAR(20)
)  
AS  
BEGIN  
	DECLARE @ANIO INT, @ID_PROCESO_ADMISION_PERIODO INT, @TOTAL_METAS INT,
	@IdTipoModalidadInstitucion INT, @MetaNumericaTipoModalidad INT, @IdTipoMeta INT, @ESTADO INT,
	@RESULT INT,  @ID_MODALIDAD_SGTE INT, @Modalidad varchar(20), @PuntajeMinimo decimal,
	@ID_ALCANZO_VACANTE INT, @ID_NO_ALCANZO_VACANTE INT, @ID_DESAPROBADO INT,
	@IdPostulanteModalidad INT, @IdMetaCarreraInstitucion INT, @IdCarreraInstitucion INT, @IdSedeInstitucion INT,
	@IdModalidadOrdinario INT,
	@IdMetaCarreraInstitucionDetalle INT, @MetaSede INT, @MetaActual INT, @TEMP VARCHAR(100), @IdInstitucion INT,
	@ID_PENDIENTE_EVALUACION INT =213,
	@ID_TIPO_META_NUMERO INT =66,
	@ID_TIPO_META_PORCENTAJE INT =65,
	@IdTipoModalidadInstitucionExo int, 	
	@IdCarrerasPorInstitucionExo int, 
	@MetaNumericaTipoModalidadExo int,
	@MetaAlcanzadaExo int


	
	BEGIN TRY
	BEGIN TRANSACTION T1
	SET NOCOUNT ON;  

		SET @ID_ALCANZO_VACANTE=174
		SET @ID_NO_ALCANZO_VACANTE=176
		SET @ID_DESAPROBADO=177

		SET @IdModalidadOrdinario = (SELECT ID_ENUMERADO FROM sistema.enumerado WHERE VALOR_ENUMERADO='ORDINARIO')
		SET @IdInstitucion = (SELECT ID_INSTITUCION FROM transaccional.periodos_lectivos_por_institucion where ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION and ES_ACTIVO=1)
		
		SELECT @ANIO = mpl.ANIO FROM transaccional.periodos_lectivos_por_institucion tplxi
								INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
								WHERE tplxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION


		SELECT  @TOTAL_METAS = SUM (META) FROM transaccional.meta_carrera_institucion mci
		INNER JOIN  maestro.turnos_por_institucion txi on mci.ID_TURNOS_POR_INSTITUCION= txi.ID_TURNOS_POR_INSTITUCION and mci.ES_ACTIVO =1 and txi.ES_ACTIVO=1 
		where txi.ID_INSTITUCION= @IdInstitucion and mci.ANIO =@ANIO 
	
		SELECT @ID_PROCESO_ADMISION_PERIODO= ID_PROCESO_ADMISION_PERIODO FROM transaccional.modalidades_por_proceso_admision 
		WHERE ID_MODALIDADES_POR_PROCESO_ADMISION= @ID_MODALIDADES_POR_PROCESO_ADMISION
	
		UPDATE transaccional.modalidades_por_proceso_admision
		SET ESTADO = CASE WHEN ESTADO = 96 THEN 97 ELSE 96 END,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE
			ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION
		
		PRINT '@ID_MODALIDADES_POR_PROCESO_ADMISION' +  CONVERT (VARCHAR(5), @ID_MODALIDADES_POR_PROCESO_ADMISION)
		
		SELECT @ESTADO = ESTADO FROM transaccional.modalidades_por_proceso_admision WHERE	ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION
		PRINT '@ESTADO' + CONVERT (VARCHAR(5), @ESTADO)
		SET @Modalidad= (	SELECT se_modal.VALOR_ENUMERADO 
							FROM transaccional.modalidades_por_proceso_admision tmxpa
							INNER JOIN sistema.enumerado se_modal on  se_modal.ID_ENUMERADO=tmxpa.ID_MODALIDAD
							WHERE	ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION
						)

		select @PuntajeMinimo = NOTA_MINIMA from transaccional.modalidades_por_proceso_admision WHERE	ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION
		PRINT 'Modalidad:' + @Modalidad
		IF @ESTADO = 97 
		BEGIN
				IF @Modalidad ='EXONERADO' 
				BEGIN 
					DECLARE metasTipoModalidadInstitucion_cursor CURSOR FOR   
					
					select	ttmxpa.ID_TIPOS_MODALIDAD_POR_INSTITUCION				IdTipoModalidadInstitucion,							
							ttmxpa.META MetaNumericaTipoModalidad,
							ttmxpa.ID_TIPO_META IdTipoMeta
					from transaccional.modalidades_por_proceso_admision tmxpa
					inner join maestro.tipo_modalidad mtm on tmxpa.ID_MODALIDAD= mtm.ID_MODALIDAD 
					inner join maestro.tipos_modalidad_por_institucion ttmxi on ttmxi.ID_TIPO_MODALIDAD =mtm.ID_TIPO_MODALIDAD and ttmxi.ES_ACTIVO=1
					inner join transaccional.tipos_modalidad_por_proceso_admision ttmxpa on ttmxpa.ID_TIPOS_MODALIDAD_POR_INSTITUCION = ttmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION and ttmxpa.ES_ACTIVO=1
					INNER JOIN transaccional.proceso_admision_periodo tpap on tpap.ID_PROCESO_ADMISION_PERIODO= ttmxpa.ID_PROCESO_ADMISION_PERIODO
					where ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION  and ttmxi.ID_INSTITUCION=@IdInstitucion
					and tpap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
					AND ttmxpa.META<>0


					OPEN metasTipoModalidadInstitucion_cursor  
					
					FETCH NEXT FROM metasTipoModalidadInstitucion_cursor   
					INTO	@IdTipoModalidadInstitucion , @MetaNumericaTipoModalidad, @IdTipoMeta

					WHILE @@FETCH_STATUS = 0  
					BEGIN  
					PRINT '@IdTipoModalidadInstitucion:' + CONVERT(VARCHAR(10),@IdTipoModalidadInstitucion) + ' - '+
								'@MetaNumericaTipoModalidad:' +CONVERT(VARCHAR(10),@MetaNumericaTipoModalidad)  + ' - '  +	'@IdTipoMeta:' +CONVERT(VARCHAR(10),@IdTipoMeta)
							SELECT RXP.ID_RESULTADOS_POR_POSTULANTE, MCI.ID_CARRERAS_POR_INSTITUCION, PXM.ID_POSTULANTES_POR_MODALIDAD, RXP.NOTA_RESULTADO, OXP.ID_OPCIONES_POR_POSTULANTE,
							PXM.ID_TIPOS_MODALIDAD_POR_INSTITUCION
							INTO #T_ResultadosPostulantes
							FROM transaccional.resultados_por_postulante RXP
							INNER JOIN transaccional.postulantes_por_modalidad PXM ON RXP.ID_POSTULANTES_POR_MODALIDAD= PXM.ID_POSTULANTES_POR_MODALIDAD AND RXP.ES_ACTIVO=1 AND PXM.ES_ACTIVO=1
							INNER JOIN transaccional.opciones_por_postulante OXP ON OXP.ID_POSTULANTES_POR_MODALIDAD= PXM.ID_POSTULANTES_POR_MODALIDAD AND OXP.ES_ACTIVO=1
							AND OXP.ORDEN=1
							INNER JOIN transaccional.meta_carrera_institucion_detalle MCID ON MCID.ID_META_CARRERA_INSTITUCION_DETALLE= OXP.ID_META_CARRERA_INSTITUCION_DETALLE AND MCID.ES_ACTIVO=1
							INNER JOIN transaccional.meta_carrera_institucion MCI ON MCI.ID_META_CARRERA_INSTITUCION= MCID.ID_META_CARRERA_INSTITUCION AND MCI.ES_ACTIVO=1
							WHERE PXM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION AND PXM.ID_TIPOS_MODALIDAD_POR_INSTITUCION=@IdTipoModalidadInstitucion

							select * into #T_ResultadosPostulantesAux from #T_ResultadosPostulantes 
							declare @id int = 0
							declare @totales int
							declare @idCarrerasPorInstitucionTemp int
							declare @metaEvaluar int 

							set @totales = (SELECT COUNT (1) FROM (select  distinct ID_CARRERAS_POR_INSTITUCION  from #T_ResultadosPostulantes) a)							
							while @id<@totales
							begin
								set @idCarrerasPorInstitucionTemp = (select TOP 1 ID_CARRERAS_POR_INSTITUCION  from #T_ResultadosPostulantes ORDER BY 1 ASC )								
								set @metaEvaluar = Case when @IdTipoMeta = @ID_TIPO_META_NUMERO then  @MetaNumericaTipoModalidad
								else (select sum( _mcid.META_SEDE)*@MetaNumericaTipoModalidad/100 MetaTotalSede from transaccional.meta_carrera_institucion _mci
								inner join transaccional.meta_carrera_institucion_detalle _mcid on _mci.ID_META_CARRERA_INSTITUCION= _mcid.ID_META_CARRERA_INSTITUCION
								where 	_mcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION  AND _mci.ES_ACTIVO=1 AND _mcid.ES_ACTIVO=1
								and _mci.ID_CARRERAS_POR_INSTITUCION=@idCarrerasPorInstitucionTemp
								)
								end 	
								PRINT '@idCarrerasPorInstitucionTemp:' + CONVERT(VARCHAR(10),@idCarrerasPorInstitucionTemp) + ' - '+
								'@metaEvaluar:' +CONVERT(VARCHAR(10),@metaEvaluar)  + ' - '  +	'@IdTipoModalidadInstitucion:' +CONVERT(VARCHAR(10),@IdTipoModalidadInstitucion)
															
								UPDATE TABLA_RESULTADOS
								SET TABLA_RESULTADOS.ESTADO=2,  --valor temporal a evaluar @ID_ALCANZO_VACANTE,  --ALCANZÓ VACANTE  --2
								ID_OPCIONES_POR_POSTULANTE = A.ID_OPCIONES_POR_POSTULANTE,
								USUARIO_MODIFICACION= @USUARIO,
								FECHA_MODIFICACION= GETDATE()
								FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
								INNER JOIN
								(	SELECT	
									ID_POSTULANTES_POR_MODALIDAD,
									NOTA_RESULTADO,
									ID_OPCIONES_POR_POSTULANTE,
									ROW_NUMBER() OVER (PARTITION BY ID_CARRERAS_POR_INSTITUCION ORDER BY NOTA_RESULTADO DESC) Orden
									FROM #T_ResultadosPostulantes WHERE NOTA_RESULTADO >= @PuntajeMinimo AND ID_CARRERAS_POR_INSTITUCION = @idCarrerasPorInstitucionTemp 

								) A on 
										A.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD 
										AND A.Orden<=@metaEvaluar										

											
								DELETE FROM #T_ResultadosPostulantes WHERE ID_CARRERAS_POR_INSTITUCION = @idCarrerasPorInstitucionTemp 

								set @id = @id+1
							end 

						DROP TABLE #T_ResultadosPostulantes

				


						UPDATE TABLA_RESULTADOS
						SET TABLA_RESULTADOS.ESTADO=@ID_DESAPROBADO,  --DESAPROBADO
							USUARIO_MODIFICACION= @USUARIO,
							FECHA_MODIFICACION= GETDATE()
						FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
						INNER JOIN transaccional.postulantes_por_modalidad TPM	ON  TPM.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD
																									AND TPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION 
																									AND TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucion
						WHERE TABLA_RESULTADOS.NOTA_RESULTADO<@PuntajeMinimo
						
						
						UPDATE TABLA_RESULTADOS
						SET TABLA_RESULTADOS.ESTADO=@ID_NO_ALCANZO_VACANTE,  --NO ALCANZÓ VACANTE
							USUARIO_MODIFICACION= @USUARIO,
							FECHA_MODIFICACION= GETDATE()
						FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
						INNER JOIN transaccional.postulantes_por_modalidad TPM	ON  TPM.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD
																									AND TPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION 
																									AND TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucion
						--WHERE TABLA_RESULTADOS.ESTADO=1
						WHERE TABLA_RESULTADOS.ESTADO=213

						SELECT 
							@IdTipoModalidadInstitucion IdTipoModalidadInstitucion, 
							ID_CARRERAS_POR_INSTITUCION IdCarrerasPorInstitucion, 
							@MetaNumericaTipoModalidad MetaNumericaTipoModalidad,
							COUNT (RXP.ID_POSTULANTES_POR_MODALIDAD) MetaAlcanzada
						INTO #T_MetasAlcanzadasTModalidadyCarrera
						FROM #T_ResultadosPostulantesAux TEMP
							INNER JOIN transaccional.resultados_por_postulante RXP ON RXP.ID_RESULTADOS_POR_POSTULANTE= TEMP.ID_RESULTADOS_POR_POSTULANTE AND RXP.ES_ACTIVO=1
							AND RXP.ESTADO=2
						group by  ID_CARRERAS_POR_INSTITUCION

						
						update transaccional.resultados_por_postulante set ESTADO= @ID_ALCANZO_VACANTE where ESTADO=2

						--Evalúa la segunda opción de los estudiantes.
					
						DECLARE metasAlcanzadasExonerados_cursor CURSOR FOR   
						SELECT * FROM #T_MetasAlcanzadasTModalidadyCarrera
						OPEN metasAlcanzadasExonerados_cursor  
					
						FETCH NEXT FROM metasAlcanzadasExonerados_cursor   
						INTO	@IdTipoModalidadInstitucionExo , @IdCarrerasPorInstitucionExo, @MetaNumericaTipoModalidadExo, @MetaAlcanzadaExo
					
						WHILE @@FETCH_STATUS = 0  
						BEGIN  
					
								UPDATE TABLA_RESULTADOS
								SET ESTADO = @ID_ALCANZO_VACANTE, 
								ID_OPCIONES_POR_POSTULANTE = A.ID_OPCIONES_POR_POSTULANTE,
								USUARIO_MODIFICACION= @USUARIO,
								FECHA_MODIFICACION= GETDATE()
								FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
								INNER JOIN 
								(select 
									MCI.ID_CARRERAS_POR_INSTITUCION, 
									T1.ID_RESULTADOS_POR_POSTULANTE,
									OXP.ID_OPCIONES_POR_POSTULANTE,
									T1.ID_TIPOS_MODALIDAD_POR_INSTITUCION, 
									ROW_NUMBER() OVER (PARTITION BY T1.ID_CARRERAS_POR_INSTITUCION ORDER BY NOTA_RESULTADO DESC) Orden
								 from #T_ResultadosPostulantesAux T1 
								INNER JOIN transaccional.opciones_por_postulante OXP ON OXP.ID_POSTULANTES_POR_MODALIDAD = T1.ID_POSTULANTES_POR_MODALIDAD AND OXP.ES_ACTIVO=1 AND OXP.ORDEN=2
								INNER JOIN transaccional.meta_carrera_institucion_detalle MCID ON MCID.ID_META_CARRERA_INSTITUCION_DETALLE = OXP.ID_META_CARRERA_INSTITUCION_DETALLE AND MCID.ES_ACTIVO=1														
								INNER JOIN transaccional.meta_carrera_institucion MCI ON MCI.ID_META_CARRERA_INSTITUCION = MCID.ID_META_CARRERA_INSTITUCION AND MCI.ES_ACTIVO=1								
								) A on A.ID_RESULTADOS_POR_POSTULANTE  = TABLA_RESULTADOS.ID_RESULTADOS_POR_POSTULANTE AND TABLA_RESULTADOS.ES_ACTIVO=1
								WHERE A.ID_CARRERAS_POR_INSTITUCION=@IdCarrerasPorInstitucionExo and TABLA_RESULTADOS.ESTADO=@ID_NO_ALCANZO_VACANTE
								AND A.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucionExo
								AND A.Orden<=@MetaNumericaTipoModalidadExo-@MetaAlcanzadaExo		
						
							FETCH NEXT FROM metasAlcanzadasExonerados_cursor   
							INTO	@IdTipoModalidadInstitucionExo , @IdCarrerasPorInstitucionExo, @MetaNumericaTipoModalidadExo, @MetaAlcanzadaExo
						END
						CLOSE metasAlcanzadasExonerados_cursor;
						DEALLOCATE metasAlcanzadasExonerados_cursor;
						DROP TABLE #T_ResultadosPostulantesAux
						DROP TABLE #T_MetasAlcanzadasTModalidadyCarrera

						

						
						FETCH NEXT FROM metasTipoModalidadInstitucion_cursor   
						INTO	@IdTipoModalidadInstitucion , @MetaNumericaTipoModalidad, @IdTipoMeta
					END   
					CLOSE metasTipoModalidadInstitucion_cursor;
					DEALLOCATE metasTipoModalidadInstitucion_cursor;

						exec USP_ADMISION_UPD_RESULTADOS_METAS_ALCANZADAS @ID_PERIODOS_LECTIVOS_POR_INSTITUCION, @ID_PROCESO_ADMISION_PERIODO,@ID_MODALIDADES_POR_PROCESO_ADMISION,
						@Modalidad,'S', @ID_ALCANZO_VACANTE, 0, @USUARIO

					
				END				
				--PROCEDER SEGÚN METAS DE CARRERA  --@Modalidad ='ORDINARIO' OR @Modalidad='EXTRAORDINARIO'
				IF @Modalidad ='ORDINARIO' OR @Modalidad='EXTRAORDINARIO'
				BEGIN
			
					print 'ingresó' + convert(varchar(5), @IdModalidadOrdinario)
					IF @Modalidad ='ORDINARIO'
					BEGIN					
							SET	@IdTipoModalidadInstitucion	=	(	SELECT mtmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION 
																	FROM	maestro.tipos_modalidad_por_institucion mtmxi
																	INNER JOIN maestro.tipo_modalidad mtm on mtmxi.ID_TIPO_MODALIDAD= mtm.ID_TIPO_MODALIDAD AND mtmxi.ES_ACTIVO = 1
																	WHERE mtm.ID_MODALIDAD=@IdModalidadOrdinario and mtmxi.ID_INSTITUCION=@IdInstitucion
																	and mtmxi.ES_ACTIVO=1)																
																	
					END
					ELSE 	IF @Modalidad ='EXTRAORDINARIO'
					BEGIN 	
							SET @IdTipoModalidadInstitucion =	(	SELECT mtmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION FROM maestro.tipos_modalidad_por_institucion mtmxi 
																	INNER JOIN maestro.tipo_modalidad mtm on mtm.ID_TIPO_MODALIDAD= mtmxi.ID_TIPO_MODALIDAD AND mtmxi.ES_ACTIVO = 1
																	WHERE mtm.NOMBRE_TIPO_MODALIDAD='ORDINARIO ALTERNATIVO' and mtmxi.ID_INSTITUCION=@IdInstitucion
																)							
					END				


					print 'IdTipoModalidadInstitución:' + convert (varchar(5),@IdTipoModalidadInstitucion)

					DECLARE metasCarreraInstitucionDetalle_cursor CURSOR FOR   
					SELECT	tmcid.ID_META_CARRERA_INSTITUCION_DETALLE			IdMetaCarreraInstitucionDetalle, 
							tmcid.META_SEDE										MetaSede,
							tmcid.META_SEDE-ISNULL(tmcid.META_ALCANZADA,0)		MetaActual
					FROM transaccional.meta_carrera_institucion_detalle tmcid 
							INNER JOIN transaccional.meta_carrera_institucion tmci ON tmcid.ID_META_CARRERA_INSTITUCION= tmci.ID_META_CARRERA_INSTITUCION AND tmci.ES_ACTIVO=1 and tmcid.ES_ACTIVO=1
							where tmcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION

					OPEN metasCarreraInstitucionDetalle_cursor  

					FETCH NEXT FROM metasCarreraInstitucionDetalle_cursor   
					INTO	@IdMetaCarreraInstitucionDetalle , @MetaSede , @MetaActual

					WHILE @@FETCH_STATUS = 0  
					BEGIN   
								PRINT '---' + CONVERT(VARCHAR(50), @IdMetaCarreraInstitucionDetalle) + ' - ' +CONVERT(VARCHAR(50), @MetaSede )+ ' - '+ CONVERT(VARCHAR(50), @MetaActual )
								UPDATE TABLA_RESULTADOS
								SET ESTADO = @ID_ALCANZO_VACANTE, ID_OPCIONES_POR_POSTULANTE = A.ID_OPCIONES_POR_POSTULANTE,
								USUARIO_MODIFICACION= @USUARIO,
								FECHA_MODIFICACION= GETDATE()
								FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
									INNER JOIN
									(	SELECT	TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION, 
												TRXP.ID_POSTULANTES_POR_MODALIDAD,
												TRXP.NOTA_RESULTADO,
												TOXP.ID_OPCIONES_POR_POSTULANTE,
										ROW_NUMBER() OVER (PARTITION BY TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION ORDER BY TRXP.NOTA_RESULTADO DESC) Orden
										FROM transaccional.resultados_por_postulante TRXP
											INNER JOIN transaccional.postulantes_por_modalidad TPM	ON  TPM.ID_POSTULANTES_POR_MODALIDAD= TRXP.ID_POSTULANTES_POR_MODALIDAD
																									AND TPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION 
																									AND (TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucion or @IdTipoModalidadInstitucion=0)
																									AND TRXP.NOTA_RESULTADO>= @PuntajeMinimo
											inner join transaccional.opciones_por_postulante TOXP ON TOXP.ID_POSTULANTES_POR_MODALIDAD= TPM.ID_POSTULANTES_POR_MODALIDAD
																									and TOXP.ID_META_CARRERA_INSTITUCION_DETALLE= @IdMetaCarreraInstitucionDetalle 
																									and  TOXP.ES_ACTIVO=1 and TOXP.ORDEN=1
									) A on 
											A.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD 
											AND A.Orden<=@MetaActual and TABLA_RESULTADOS.ESTADO in (@ID_PENDIENTE_EVALUACION,2)
										
										PRINT 'PAS 1:' + CONVERT (VARCHAR(10),@@rowcount)
											PRINT '@@ID_MODALIDADES_POR_PROCESO_ADMISION:' + convert (varchar(5), @ID_MODALIDADES_POR_PROCESO_ADMISION)
											PRINT '@IdTipoModalidadInstitucion:' + convert (varchar(5), @IdTipoModalidadInstitucion)
											PRINT '@PuntajeMinimo:' + convert (varchar(5), @PuntajeMinimo)
											PRINT '@IdMetaCarreraInstitucionDetalle:' + convert (varchar(5), @IdMetaCarreraInstitucionDetalle)
											print '@MetaActual:' + convert (varchar(5),@MetaActual)

									UPDATE TABLA_RESULTADOS
									SET TABLA_RESULTADOS.ESTADO=@ID_DESAPROBADO, --DESAPROBADO
									USUARIO_MODIFICACION= @USUARIO,
									FECHA_MODIFICACION= GETDATE()
									FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
									INNER JOIN transaccional.postulantes_por_modalidad TPM	ON  TPM.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD
																												AND TPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION 
																												AND (TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucion or @IdTipoModalidadInstitucion=0)

									INNER JOIN transaccional.opciones_por_postulante TOXP ON TOXP.ID_POSTULANTES_POR_MODALIDAD= TPM.ID_POSTULANTES_POR_MODALIDAD
																										and TOXP.ID_META_CARRERA_INSTITUCION_DETALLE= @IdMetaCarreraInstitucionDetalle 
																										and  TOXP.ES_ACTIVO=1 and TOXP.ORDEN=1
									WHERE TABLA_RESULTADOS.NOTA_RESULTADO<@PuntajeMinimo and TABLA_RESULTADOS.ESTADO = @ID_PENDIENTE_EVALUACION--1 
						PRINT 'PAS 2:' + CONVERT (VARCHAR(10),@@rowcount)
						
									UPDATE TABLA_RESULTADOS
									SET TABLA_RESULTADOS.ESTADO=@ID_NO_ALCANZO_VACANTE,  --NO ALCANZÓ VACANTE
									USUARIO_MODIFICACION= @USUARIO,
									FECHA_MODIFICACION= GETDATE()
									FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
									INNER JOIN transaccional.postulantes_por_modalidad TPM	ON  TPM.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD
																												AND TPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION 
																												AND (TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucion or  @IdTipoModalidadInstitucion=0)
									INNER JOIN transaccional.opciones_por_postulante TOXP ON TOXP.ID_POSTULANTES_POR_MODALIDAD= TPM.ID_POSTULANTES_POR_MODALIDAD
																										and TOXP.ID_META_CARRERA_INSTITUCION_DETALLE= @IdMetaCarreraInstitucionDetalle 
																										and  TOXP.ES_ACTIVO=1 and TOXP.ORDEN=1
									WHERE TABLA_RESULTADOS.ESTADO = @ID_PENDIENTE_EVALUACION --1
									PRINT 'PAS 3:' + CONVERT (VARCHAR(10),@@rowcount)

						FETCH NEXT FROM metasCarreraInstitucionDetalle_cursor   
						INTO	@IdMetaCarreraInstitucionDetalle , @MetaSede , @MetaActual
					END   
					CLOSE metasCarreraInstitucionDetalle_cursor;
					DEALLOCATE metasCarreraInstitucionDetalle_cursor;
					
					
					DECLARE
					@TEMP2 INT 
					SET @TEMP2 = (SELECT ESTADO FROM transaccional.resultados_por_postulante WHERE ID_POSTULANTES_POR_MODALIDAD=45)
					PRINT 'REVISANDO eSTADO-' + CONVERT (VARCHAR (4), @TEMP2)
					PRINT 'REVISANDO @ID_MODALIDADES_POR_PROCESO_ADMISION 2 -' + CONVERT (VARCHAR (4), @ID_MODALIDADES_POR_PROCESO_ADMISION)
					PRINT 'REVISANDO @IdTipoModalidadInstitucion 3-' + CONVERT (VARCHAR (4), @IdTipoModalidadInstitucion)

					exec USP_ADMISION_UPD_RESULTADOS_METAS_ALCANZADAS @ID_PERIODOS_LECTIVOS_POR_INSTITUCION, @ID_PROCESO_ADMISION_PERIODO,@ID_MODALIDADES_POR_PROCESO_ADMISION,
					@Modalidad,'S', @ID_ALCANZO_VACANTE,0, @USUARIO

					--Se evalúa la segunda opción de los postulantes
					exec USP_ADMISION_UPD_RESULTADOS_MODALIDAD_SEGUNDA_OPCION @ID_PERIODOS_LECTIVOS_POR_INSTITUCION,@ID_MODALIDADES_POR_PROCESO_ADMISION, @IdTipoModalidadInstitucion, @USUARIO

					
					--No alcanzaron vacantes, los exonerados(por falta de vacantes en los cursos).
					--UPDATE TABLA_RESULTADOS
					--SET TABLA_RESULTADOS.ESTADO=@ID_NO_ALCANZO_VACANTE,  --NO ALCANZÓ VACANTE
					--USUARIO_MODIFICACION= @USUARIO,
					--FECHA_MODIFICACION= GETDATE()
					--FROM transaccional.resultados_por_postulante TABLA_RESULTADOS
					--INNER JOIN transaccional.postulantes_por_modalidad TPM	ON  TPM.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD
					--																							AND TPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION 
					--																							AND (TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucion or  @IdTipoModalidadInstitucion=0)
					--WHERE TABLA_RESULTADOS.ESTADO = 2
			
					exec USP_ADMISION_UPD_RESULTADOS_METAS_ALCANZADAS @ID_PERIODOS_LECTIVOS_POR_INSTITUCION, @ID_PROCESO_ADMISION_PERIODO,@ID_MODALIDADES_POR_PROCESO_ADMISION,
					@Modalidad,'S', @ID_ALCANZO_VACANTE, 1, @USUARIO

				END

				
		END 
		ELSE
		BEGIN
			exec USP_ADMISION_UPD_RESULTADOS_METAS_ALCANZADAS @ID_PERIODOS_LECTIVOS_POR_INSTITUCION, @ID_PROCESO_ADMISION_PERIODO,@ID_MODALIDADES_POR_PROCESO_ADMISION,
					@Modalidad,'R', @ID_ALCANZO_VACANTE, 0, @USUARIO
				
		END
		
						
		COMMIT TRANSACTION T1	
			SET @RESULT = 1			
			
END TRY
BEGIN CATCH
	IF @@ERROR = 50000
	BEGIN
		ROLLBACK TRANSACTION T1	   
		SET @RESULT = -180
	END
	ELSE
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -1
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -2 
			PRINT ERROR_MESSAGE()
		END
END CATCH
SELECT @RESULT
END
GO


