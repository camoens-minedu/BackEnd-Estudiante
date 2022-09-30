		
CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_RESULTADOS_METAS_ALCANZADAS]
(
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION		INT,
	@ID_PROCESO_ADMISION_PERIODO				INT,
	@ID_MODALIDADES_POR_PROCESO_ADMISION		INT,
	@MODALIDAD									varchar(20),	
	@OPERACION									CHAR(1),  --S: sumar, R: restar
	@ID_ESTADO_RESULTADO						INT,
	@SEGUNDA_OPCION								BIT, --0:NO, 1: sí
	@USUARIO									VARCHAR(20)
	
)
AS
BEGIN

			DECLARE @IdPostulanteModalidad INT, 
			@IdMetaCarreraInstitucion INT,
			@IdCarreraInstitucion INT,
			@IdSedeInstitucion INT, 
			@IdModalidad INT,
			@ID_PENDIENTE_EVALUACION INT =213,
			@SegundaOpcion Bit
			SET @IdModalidad = (SELECT ID_ENUMERADO FROM sistema.enumerado where VALOR_ENUMERADO=@MODALIDAD)
			DECLARE metasAlcanzadas_cursor CURSOR FOR   
					
			select 
					toxp.ID_POSTULANTES_POR_MODALIDAD, 
					tmci.ID_META_CARRERA_INSTITUCION, 
					tmci.ID_CARRERAS_POR_INSTITUCION,
					tmcid.ID_SEDE_INSTITUCION,
					case when toxp.ORDEN = 2 then cast(1 as bit) else cast(0 as bit) end SegundaOpcion
			from transaccional.resultados_por_postulante trxp
			INNER JOIN transaccional.opciones_por_postulante toxp			on	trxp.ID_OPCIONES_POR_POSTULANTE= toxp.ID_OPCIONES_POR_POSTULANTE  			
			INNER JOIN transaccional.meta_carrera_institucion_detalle tmcid on tmcid.ID_META_CARRERA_INSTITUCION_DETALLE= toxp.ID_META_CARRERA_INSTITUCION_DETALLE
			INNER JOIN transaccional.meta_carrera_institucion tmci			on tmci.ID_META_CARRERA_INSTITUCION= tmcid.ID_META_CARRERA_INSTITUCION
			inner join transaccional.postulantes_por_modalidad	tpxm		on tpxm.ID_POSTULANTES_POR_MODALIDAD= trxp.ID_POSTULANTES_POR_MODALIDAD
			INNER JOIN transaccional.modalidades_por_proceso_admision tmxpa on tmxpa.ID_MODALIDADES_POR_PROCESO_ADMISION= tpxm.ID_MODALIDADES_POR_PROCESO_ADMISION
			where trxp.ESTADO=@ID_ESTADO_RESULTADO AND tmxpa.ID_MODALIDADES_POR_PROCESO_ADMISION= @ID_MODALIDADES_POR_PROCESO_ADMISION
		
			OPEN metasAlcanzadas_cursor  

			FETCH NEXT FROM metasAlcanzadas_cursor   
			INTO	@IdPostulanteModalidad , @IdMetaCarreraInstitucion , @IdCarreraInstitucion , @IdSedeInstitucion, @SegundaOpcion

										
			WHILE @@FETCH_STATUS = 0  
			BEGIN   
				IF(@SEGUNDA_OPCION =0 or (@SEGUNDA_OPCION=1 and @SegundaOpcion =1))
				BEGIN
				UPDATE 
				transaccional.meta_carrera_institucion_detalle
				set		
						META_ALCANZADA = CASE WHEN @OPERACION ='S'  THEN ISNULL(META_ALCANZADA,0)+1 ELSE ISNULL(META_ALCANZADA,0)-1 END ,
						USUARIO_MODIFICACION= @USUARIO,
						FECHA_MODIFICACION=GETDATE()						
				WHERE	ID_META_CARRERA_INSTITUCION= @IdMetaCarreraInstitucion 
						AND ID_SEDE_INSTITUCION=  @IdSedeInstitucion
						AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
				END						

				FETCH NEXT FROM metasAlcanzadas_cursor   
				INTO	@IdPostulanteModalidad , @IdMetaCarreraInstitucion , @IdCarreraInstitucion , @IdSedeInstitucion, @SegundaOpcion
			END   
			CLOSE metasAlcanzadas_cursor;
			DEALLOCATE metasAlcanzadas_cursor;

			IF @OPERACION='R'
			BEGIN
					UPDATE TABLA_RESULTADOS
						SET TABLA_RESULTADOS.ESTADO = @ID_PENDIENTE_EVALUACION,
							ID_OPCIONES_POR_POSTULANTE =NULL,
							USUARIO_MODIFICACION= @USUARIO,
							FECHA_MODIFICACION=GETDATE()
					FROM  transaccional.resultados_por_postulante TABLA_RESULTADOS
						INNER JOIN transaccional.postulantes_por_modalidad TPM ON TABLA_RESULTADOS.ID_POSTULANTES_POR_MODALIDAD= TPM.ID_POSTULANTES_POR_MODALIDAD
						INNER JOIN transaccional.modalidades_por_proceso_admision TMXPA on TMXPA.ID_MODALIDADES_POR_PROCESO_ADMISION= TPM.ID_MODALIDADES_POR_PROCESO_ADMISION
					WHERE TMXPA.ID_MODALIDAD= @IdModalidad
						AND TMXPA.ID_PROCESO_ADMISION_PERIODO= 	@ID_PROCESO_ADMISION_PERIODO	

					
			END
				

END
GO


