CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_PROCESO_ADMISION_PERIODO]
(
	@ID_PROCESO_ADMISION_PERIODO	INT,
	@FECHA_INICIO					DATE,
	@FECHA_FIN						DATE,
	@MODALIDADES					VARCHAR(16),
	@NOTA_MINIMA					DECIMAL(10,2),
	@USUARIO						VARCHAR(20)
)AS
DECLARE @RESULT VARCHAR(50)
BEGIN
	DECLARE @FechaMinModalidadProceso DATE, @FechaMaxModalidadProceso DATE
	SET @FechaMinModalidadProceso = (SELECT MIN(FECHA_INICIO_MODALIDAD) FROM transaccional.modalidades_por_proceso_admision WHERE ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
	AND ES_ACTIVO=1)
	SET @FechaMaxModalidadProceso = (SELECT MAX(FECHA_FIN_MODALIDAD) FROM transaccional.modalidades_por_proceso_admision WHERE ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
	AND ES_ACTIVO=1)

	IF @FECHA_INICIO > @FechaMinModalidadProceso OR @FECHA_FIN < @FechaMaxModalidadProceso
	SET @RESULT = -289
	ELSE
	BEGIN
	BEGIN TRANSACTION T1
	BEGIN TRY
		
		DECLARE @CONSULTA_MODALIDADES VARCHAR(16), @EVALUAR VARCHAR (16) =''
				SET @CONSULTA_MODALIDADES =
		(SELECT MODALIDADES FROM transaccional.proceso_admision_periodo WHERE ID_PROCESO_ADMISION_PERIODO= @ID_PROCESO_ADMISION_PERIODO)

		IF (@CONSULTA_MODALIDADES LIKE '23|24|%' AND  @MODALIDADES LIKE '0|24|%') --ELIMINACIÓN DE EXONERADO
			SET @EVALUAR = '23,'

		IF (@CONSULTA_MODALIDADES LIKE '%|25' AND  @MODALIDADES LIKE '%|0') --ELIMINACIÓN DE EXTRAORDINARIO
			SET @EVALUAR = @EVALUAR  + '25'


		declare @Modalidades1 varchar (50)=''
		select @Modalidades1 =COALESCE(@Modalidades1 + ',', '')+ dbo.UFN_CAPITALIZAR( enum.VALOR_ENUMERADO)   from transaccional.evaluador_admision_modalidad eam 
		inner join transaccional.modalidades_por_proceso_admision mxpa on eam.ID_MODALIDADES_POR_PROCESO_ADMISION = mxpa.ID_MODALIDADES_POR_PROCESO_ADMISION
		INNER JOIN sistema.enumerado enum on enum.ID_ENUMERADO = mxpa.ID_MODALIDAD
		and mxpa.ES_ACTIVO=1 and eam.ES_ACTIVO=1		
		where mxpa.ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO
		and mxpa.ID_MODALIDAD in (SELECT SplitData from dbo.UFN_SPLIT(@EVALUAR, ','))
		PRINT 'm1:'+ @Modalidades1


		declare @Modalidades2 varchar (50) =''
		select  @Modalidades2 =COALESCE(@Modalidades2 + ',', '')+ dbo.UFN_CAPITALIZAR(enum.VALOR_ENUMERADO)
		from transaccional.examen_admision_sede eas 
		inner join transaccional.modalidades_por_proceso_admision mxpa on eas.ID_PROCESO_ADMISION_PERIODO= mxpa.ID_PROCESO_ADMISION_PERIODO 
		and eas.ID_MODALIDAD= mxpa.ID_MODALIDAD
		and mxpa.ES_ACTIVO=1 and eas.ES_ACTIVO=1
		INNER JOIN sistema.enumerado enum on enum.ID_ENUMERADO = eas.ID_MODALIDAD			
		where mxpa.ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO  and eas.ID_MODALIDAD in (SELECT SplitData from dbo.UFN_SPLIT(@EVALUAR, ','))
		PRINT 'm2:'+  @Modalidades2

		declare @TiposModalidadesEvaluadasEnUso varchar (50)
		SELECT DISTINCT SplitData INTO #T_TipoModalidad FROM dbo.UFN_SPLIT (CASE WHEN @Modalidades1 <> '' AND @Modalidades2<>'' THEN  @Modalidades1 + ','  +@Modalidades2
																			WHEN @Modalidades1<>'' AND @Modalidades2='' THEN @Modalidades1
																			WHEN @Modalidades1='' AND @Modalidades2<>'' THEN @Modalidades2
																			END ,  ',')
		order by 1 asc 

		SELECT @TiposModalidadesEvaluadasEnUso = COALESCE(@TiposModalidadesEvaluadasEnUso + ',', '') + SplitData		
		FROM #T_TipoModalidad


		PRINT 'tp:'+ @TiposModalidadesEvaluadasEnUso

		SELECT ID_MODALIDADES_POR_PROCESO_ADMISION, ESTADO INTO #T_Modalidades FROM transaccional.modalidades_por_proceso_admision WHERE ID_PROCESO_ADMISION_PERIODO= @ID_PROCESO_ADMISION_PERIODO


		MERGE INTO transaccional.modalidades_por_proceso_admision AS TARGET
		USING(
			SELECT	@ID_PROCESO_ADMISION_PERIODO	ID_PROCESO_ADMISION_PERIODO,
					SplitData						ID_MODALIDAD
			FROM dbo.UFN_SPLIT(UPPER(@MODALIDADES), '|')
			WHERE SplitData <> 0
		) AS SOURCE ON	TARGET.ID_PROCESO_ADMISION_PERIODO = SOURCE.ID_PROCESO_ADMISION_PERIODO
						AND TARGET.ID_MODALIDAD = SOURCE.ID_MODALIDAD
		WHEN MATCHED
		THEN 
			UPDATE
			SET
				NOTA_MINIMA = @NOTA_MINIMA,
				ES_ACTIVO = 1,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
		WHEN NOT MATCHED BY TARGET
		THEN 
			INSERT (ID_PROCESO_ADMISION_PERIODO,ID_MODALIDAD,NOTA_MINIMA,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
			VALUES (SOURCE.ID_PROCESO_ADMISION_PERIODO,SOURCE.ID_MODALIDAD,@NOTA_MINIMA,1,96,@USUARIO,GETDATE())
		WHEN NOT MATCHED BY SOURCE AND TARGET.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
		THEN 
			UPDATE 
			SET		
				ESTADO=2;
		
		if @TiposModalidadesEvaluadasEnUso<>''
		BEGIN
		

			UPDATE TABLA_MODALIDADES
			SET TABLA_MODALIDADES.ESTADO =(SELECT TOP 1 ESTADO FROM #T_Modalidades WHERE ID_MODALIDADES_POR_PROCESO_ADMISION = TABLA_MODALIDADES.ID_MODALIDADES_POR_PROCESO_ADMISION)
			FROM transaccional.modalidades_por_proceso_admision TABLA_MODALIDADES 
			WHERE ESTADO=2
			SET @RESULT = @TiposModalidadesEvaluadasEnUso
		END
		ELSE 
		BEGIN
			UPDATE transaccional.modalidades_por_proceso_admision SET ES_ACTIVO=0,
				FECHA_INICIO_MODALIDAD = NULL,
				FECHA_FIN_MODALIDAD = NULL,
				FECHA_INICIO_REGSITRO = NULL, 
				FECHA_FIN_REGISTRO = NULL, 
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE(),
				ESTADO =96					
			WHERE ESTADO=2	
			set @RESULT= '1'
		END
		if @RESULT = '1'
		BEGIN
		UPDATE	transaccional.proceso_admision_periodo
		SET
				FECHA_INICIO = @FECHA_INICIO,
				FECHA_FIN = @FECHA_FIN,
				MODALIDADES = @MODALIDADES,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
		WHERE 	ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
		END
		drop table #T_TipoModalidad
		drop table #T_Modalidades
	COMMIT TRANSACTION T1
		
	END TRY
	BEGIN CATCH
		IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION T1	   
			set @RESULT= '-1'
		END
	END CATCH
	END
END
SELECT @RESULT
GO


