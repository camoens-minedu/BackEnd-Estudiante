--USP_ADMISION_UPD_RESULTADOS_MODALIDAD_SEGUNDA_OPCION  897, 10,8,'MALVA'
--USP_ADMISION_UPD_RESULTADOS_MODALIDAD_SEGUNDA_OPCION  896, 7,1,'MALVA'
--5520, 1209, 1098

CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_RESULTADOS_MODALIDAD_SEGUNDA_OPCION]
(  
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@ID_MODALIDADES_POR_PROCESO_ADMISION	INT,
	@IdTipoModalidadInstitucion				INT,
	@USUARIO								VARCHAR(20)
)
AS  
BEGIN  

	DECLARE  @ID_ALCANZO_VACANTE INT,  @Modalidad varchar(20),@PuntajeMinimo decimal, @IdMetaCarreraInstitucionDetalle INT,@IdModalidadOrdinario INT,
	@MetaSede INT, @MetaActual INT, @ID_NO_ALCANZO_VACANTE INT

	SET @ID_ALCANZO_VACANTE=174
	SET @ID_NO_ALCANZO_VACANTE=176
	
	--SET @IdModalidadOrdinario = (SELECT ID_ENUMERADO FROM sistema.enumerado WHERE VALOR_ENUMERADO='ORDINARIO')


	select @PuntajeMinimo = NOTA_MINIMA from transaccional.modalidades_por_proceso_admision WHERE	ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION
	SET @Modalidad= (	SELECT se_modal.VALOR_ENUMERADO 
						FROM transaccional.modalidades_por_proceso_admision tmxpa
						INNER JOIN sistema.enumerado se_modal on  se_modal.ID_ENUMERADO=tmxpa.ID_MODALIDAD
						WHERE	ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION
					)
					
	--IF @Modalidad ='ORDINARIO' OR @Modalidad='EXTRAORDINARIO'
	--BEGIN
	--		SET	@IdTipoModalidadInstitucion	=	(	SELECT mtmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION 
	--												FROM	maestro.tipos_modalidad_por_institucion mtmxi
	--												INNER JOIN maestro.tipo_modalidad mtm on mtmxi.ID_TIPO_MODALIDAD= mtm.ID_TIPO_MODALIDAD
	--												WHERE mtm.ID_MODALIDAD=@IdModalidadOrdinario)
	--END
	--ELSE
	--BEGIN
	--		SET @IdTipoModalidadInstitucion =	(	SELECT mtmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION FROM maestro.tipos_modalidad_por_institucion mtmxi 
	--												INNER JOIN maestro.tipo_modalidad mtm on mtm.ID_TIPO_MODALIDAD= mtmxi.ID_TIPO_MODALIDAD
	--												WHERE mtm.NOMBRE_TIPO_MODALIDAD='ORDINARIO ALTERNATIVO' )							
	--END

	DECLARE metasCarreraInstitucionDetalle_cursor CURSOR FOR   
	SELECT	tmcid.ID_META_CARRERA_INSTITUCION_DETALLE			IdMetaCarreraInstitucionDetalle, 
			tmcid.META_SEDE										MetaSede,
			tmcid.META_SEDE-ISNULL(tmcid.META_ALCANZADA,0)		MetaActual
	FROM transaccional.meta_carrera_institucion_detalle tmcid 
			INNER JOIN transaccional.meta_carrera_institucion tmci ON tmcid.ID_META_CARRERA_INSTITUCION= tmci.ID_META_CARRERA_INSTITUCION AND tmci.ES_ACTIVO=1 AND tmcid.ES_ACTIVO=1
	WHERE tmcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION

	OPEN metasCarreraInstitucionDetalle_cursor  

	FETCH NEXT FROM metasCarreraInstitucionDetalle_cursor   
	INTO	@IdMetaCarreraInstitucionDetalle , @MetaSede , @MetaActual

	WHILE @@FETCH_STATUS = 0  
	BEGIN   
	PRINT 'SUBCONSULTA'
					UPDATE 
							TABLA_RESULTADOS
					SET		
							ESTADO = @ID_ALCANZO_VACANTE, 
							ID_OPCIONES_POR_POSTULANTE = A.ID_OPCIONES_POR_POSTULANTE,
							USUARIO_MODIFICACION = @USUARIO,
							FECHA_MODIFICACION=GETDATE()
					FROM 
							transaccional.resultados_por_postulante TABLA_RESULTADOS
							INNER JOIN
							(	SELECT	TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION, 
										TRXP.ID_POSTULANTES_POR_MODALIDAD,
										TRXP.NOTA_RESULTADO,
										TOXP.ID_OPCIONES_POR_POSTULANTE,

								ROW_NUMBER() OVER (PARTITION BY TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION ORDER BY TRXP.NOTA_RESULTADO DESC) Orden
								FROM transaccional.resultados_por_postulante TRXP
									INNER JOIN transaccional.postulantes_por_modalidad TPM	ON  TPM.ID_POSTULANTES_POR_MODALIDAD= TRXP.ID_POSTULANTES_POR_MODALIDAD
																							AND TPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION 
																							AND (TPM.ID_TIPOS_MODALIDAD_POR_INSTITUCION =@IdTipoModalidadInstitucion
																									OR @IdTipoModalidadInstitucion=0)
																							AND TRXP.NOTA_RESULTADO>= @PuntajeMinimo
									inner join transaccional.opciones_por_postulante TOXP ON TOXP.ID_POSTULANTES_POR_MODALIDAD= TPM.ID_POSTULANTES_POR_MODALIDAD
																							and TOXP.ID_META_CARRERA_INSTITUCION_DETALLE= @IdMetaCarreraInstitucionDetalle 
																							and  TOXP.ES_ACTIVO=1 and  TOXP.ORDEN=2
									WHERE TRXP.ESTADO = 176

							) A on 
									A.ID_POSTULANTES_POR_MODALIDAD= TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD 
									AND A.Orden<=@MetaActual  					
					
		
											PRINT '@@ID_MODALIDADES_POR_PROCESO_ADMISION:' + convert (varchar(5), @ID_MODALIDADES_POR_PROCESO_ADMISION)
											PRINT '@IdTipoModalidadInstitucion:' + convert (varchar(5), @IdTipoModalidadInstitucion)
											PRINT '@PuntajeMinimo:' + convert (varchar(5), @PuntajeMinimo)
											PRINT '@IdMetaCarreraInstitucionDetalle:' + convert (varchar(5), @IdMetaCarreraInstitucionDetalle)
											print '@MetaActual:' + convert (varchar(5),@MetaActual)

			FETCH NEXT FROM metasCarreraInstitucionDetalle_cursor   
			INTO	@IdMetaCarreraInstitucionDetalle , @MetaSede , @MetaActual
		END   
		CLOSE metasCarreraInstitucionDetalle_cursor;
		DEALLOCATE metasCarreraInstitucionDetalle_cursor;

END
GO


