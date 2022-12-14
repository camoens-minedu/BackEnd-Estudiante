CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_MODALIDAD_PROCESO_ADMISION]
(
	@ID_MODALIDAD_PROCESO_ADMISION	INT,
	@FECHA_INICIO					DATE,
	@FECHA_FIN						DATE,
	@FECHA_FIN_POSTULANTE   		DATE,
	@USUARIO						VARCHAR(20)

	--DECLARE @ID_MODALIDAD_PROCESO_ADMISION	INT=1205
	--DECLARE @FECHA_INICIO					DATE='2019/07/01'
	--DECLARE @FECHA_FIN						DATE='2018/07/16'
	--DECLARE @FECHA_FIN_POSTULANTE   		DATE='2018/07/15'
	--DECLARE @USUARIO						VARCHAR(20)='42122536'


)AS
DECLARE @RESULT INT =0
BEGIN
	BEGIN TRANSACTION T1
	BEGIN TRY
	
			DECLARE @ID_MODALIDAD_EXONERADO INT = 23,
			@ID_MODALIDAD_ORDINARIO INT =24,
			@ID_MODALIDAD_EXTRAORDINARIO INT = 25,
			@ID_MODALIDAD_ACTUAL INT = 0,
			@ID_PROCESO_ADMISION_PERIODO INT = 0, 
			@FechaFinAnterior date, 
			@FechaIniPosterior date, 
			@FechaMin date,
			@ModalidadMin INT,
			@Traslape BIT =0

			SELECT @ID_MODALIDAD_ACTUAL = ID_MODALIDAD, @ID_PROCESO_ADMISION_PERIODO= ID_PROCESO_ADMISION_PERIODO
			FROM transaccional.modalidades_por_proceso_admision 
			WHERE ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDAD_PROCESO_ADMISION 
			
			set @FechaFinAnterior= (SELECT max (FECHA_FIN_MODALIDAD)  FROM transaccional.modalidades_por_proceso_admision  
			WHERE ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO AND ID_MODALIDAD < @ID_MODALIDAD_ACTUAL AND ES_ACTIVO=1)

				set @FechaIniPosterior= (SELECT min (FECHA_INICIO_MODALIDAD)  FROM transaccional.modalidades_por_proceso_admision  
			WHERE ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO AND ID_MODALIDAD > @ID_MODALIDAD_ACTUAL AND ES_ACTIVO=1)

			set @FechaMin = (select min (FECHA_INICIO_MODALIDAD) from transaccional.modalidades_por_proceso_admision
			where ID_PROCESO_ADMISION_PERIODO= @ID_PROCESO_ADMISION_PERIODO AND ES_ACTIVO=1 )

			set @ModalidadMin = (select min (ID_MODALIDAD) from transaccional.modalidades_por_proceso_admision
			where ID_PROCESO_ADMISION_PERIODO= @ID_PROCESO_ADMISION_PERIODO AND ES_ACTIVO=1 )
			
			
				SELECT ID_MODALIDAD, FECHA_INICIO_MODALIDAD, FECHA_FIN_MODALIDAD INTO #TempFechas 
				FROM transaccional.modalidades_por_proceso_admision  WHERE ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO
				AND ID_MODALIDAD<>@ID_MODALIDAD_ACTUAL

				DECLARE @ID INT =0
				DECLARE @ID_MODALIDAD_TEMP INT =0
				DECLARE @FECHA_INICIO_TEMP DATE
				DECLARE @FECHA_FIN_TEMP DATE
			
				DECLARE @TotalFechas INT = 0
				SET @TotalFechas = ( SELECT COUNT(1) FROM #TempFechas)
				WHILE @ID <@TotalFechas AND @Traslape = 0
				BEGIN
					SET @ID_MODALIDAD_TEMP =(SELECT TOP 1 ID_MODALIDAD FROM #TempFechas order by 1 ASC )

					SELECT @FECHA_INICIO_TEMP= FECHA_INICIO_MODALIDAD, @FECHA_FIN_TEMP= FECHA_FIN_MODALIDAD FROM #TempFechas where ID_MODALIDAD = @ID_MODALIDAD_TEMP
					IF @FECHA_INICIO BETWEEN @FECHA_INICIO_TEMP AND @FECHA_FIN_TEMP SET @Traslape = 1
					IF @FECHA_FIN BETWEEN @FECHA_INICIO_TEMP AND @FECHA_FIN_TEMP  SET @Traslape =1 
					IF @FECHA_INICIO < @FechaMin and @ID_MODALIDAD_ACTUAL <> @ModalidadMin SET @Traslape=1

					DELETE FROM #TempFechas where ID_MODALIDAD = @ID_MODALIDAD_TEMP
				SET @ID = @ID+1
				END

				DROP TABLE #TempFechas
			
				IF EXISTS(SELECT TOP 1 DEAD.ID_DISTRIBUCION_EVALUACION_ADMISION_DETALLE FROM transaccional.distribucion_examen_admision DEA 
				INNER JOIN transaccional.examen_admision_sede EAS ON DEA.ID_EXAMEN_ADMISION_SEDE = EAS.ID_EXAMEN_ADMISION_SEDE AND DEA.ES_ACTIVO=1 AND EAS.ES_ACTIVO=1
				INNER JOIN transaccional.proceso_admision_periodo PAP ON PAP.ID_PROCESO_ADMISION_PERIODO= EAS.ID_PROCESO_ADMISION_PERIODO AND PAP.ES_ACTIVO=1
				INNER JOIN transaccional.modalidades_por_proceso_admision MXPAP ON MXPAP.ID_PROCESO_ADMISION_PERIODO= PAP.ID_PROCESO_ADMISION_PERIODO AND MXPAP.ID_MODALIDAD= EAS.ID_MODALIDAD AND MXPAP.ES_ACTIVO=1
				INNER JOIN transaccional.distribucion_evaluacion_admision_detalle DEAD ON DEAD.ID_DISTRIBUCION_EXAMEN_ADMISION = DEA.ID_DISTRIBUCION_EXAMEN_ADMISION AND DEA.ES_ACTIVO=1 AND DEAD.ES_ACTIVO=1
				WHERE MXPAP.ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDAD_PROCESO_ADMISION)
				BEGIN
					SET @RESULT = -281 -- EL PROCESO YA ESTA SIENDO UTILIZADO
				END
				ELSE
					BEGIN    	--print 'dentro de la transaccion'
	                 IF EXISTS (SELECT TOP 1 ID_MODALIDADES_POR_PROCESO_ADMISION FROM transaccional.modalidades_por_proceso_admision WHERE ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDAD_PROCESO_ADMISION AND ESTADO = 97)
					 BEGIN

					 SET @RESULT = -319

					 END
					 ELSE
					 BEGIN
					  if @Traslape=1
						SET @RESULT = -270
					ELSE IF ((@FechaFinAnterior IS NOT NULL AND  @FECHA_INICIO< @FechaFinAnterior) or (@FechaIniPosterior IS NOT NULL AND @FECHA_FIN >@FechaIniPosterior))
						SET @RESULT = -271
					ELSE 
					BEGIN 
						UPDATE transaccional.modalidades_por_proceso_admision
						SET FECHA_INICIO_MODALIDAD = @FECHA_INICIO,
							FECHA_FIN_MODALIDAD = @FECHA_FIN,
							FECHA_INICIO_REGSITRO = @FECHA_INICIO,
							FECHA_FIN_REGISTRO = @FECHA_FIN_POSTULANTE,
							USUARIO_MODIFICACION = @USUARIO,
							FECHA_MODIFICACION = GETDATE()
						WHERE ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDAD_PROCESO_ADMISION
							SET @RESULT = 1
					END 
					END
				END	

				
		COMMIT TRANSACTION T1
		
	END TRY
	BEGIN CATCH	
		IF @@ERROR = 50000
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -223
		END
		ELSE	
			IF @@ERROR<>0
			BEGIN
			   
			   ROLLBACK TRANSACTION T1	   			   
			   SET @RESULT = -1
			
			END
	END CATCH
END
SELECT @RESULT
GO


