
CREATE PROCEDURE [dbo].[USP_ADMISION_INS_RESOLUCION_CARRERAS_INSTITUCION_MASIVO]
(
	 @ID_CARRERAS_INSTITUCION NVARCHAR(max) 
	,@ID_TIPO_RESOLUCION INT
    ,@ID_RESOLUCION	    int      
	,@USUARIO VARCHAR(20)
)
AS
DECLARE @RESULT INT

DECLARE
		@ID_TIPO_META_ANUAL INT =21, 
		@ID_TIPO_META_AMPL INT =22,
		@NRO_ELEM_NO_ACTUALIZADOS INT = 0;


	MERGE INTO transaccional.resoluciones_por_carreras_por_institucion AS TARGET
		USING (
				SELECT @ID_RESOLUCION ID_RESOLUCION, CID.ID_CARRERAS_POR_INSTITUCION, 
					(CASE WHEN @ID_TIPO_RESOLUCION <> @ID_TIPO_META_ANUAL and  @ID_TIPO_RESOLUCION <> @ID_TIPO_META_AMPL
						THEN CID.ID_SEDE_INSTITUCION 
						ELSE
						NULL
						END
					) 
					ID_SEDE_INSTITUCION	
				FROM dbo.UFN_SPLIT(@ID_CARRERAS_INSTITUCION,',')
				INNER JOIN transaccional.carreras_por_institucion_detalle CID ON CID.ID_CARRERAS_POR_INSTITUCION_DETALLE= SplitData AND CID.ES_ACTIVO=1						
		
		) AS SOURCE ON TARGET.ID_RESOLUCION = SOURCE.ID_RESOLUCION AND TARGET.ID_RESOLUCION=@ID_RESOLUCION
			AND TARGET.ID_CARRERAS_POR_INSTITUCION = SOURCE.ID_CARRERAS_POR_INSTITUCION			
		WHEN MATCHED
		THEN
			UPDATE 
			SET ES_ACTIVO = 1,				
				USUARIO_MODIFICACION =@USUARIO,
				FECHA_MODIFICACION = GETDATE()
		WHEN NOT MATCHED BY TARGET
		THEN		
			INSERT 
			(
				ID_RESOLUCION,
				ID_CARRERAS_POR_INSTITUCION,
				ID_SEDE_INSTITUCION,
				ES_ACTIVO,
				ESTADO,
				USUARIO_CREACION,
				FECHA_CREACION			
			)VALUES 
			(
				SOURCE.ID_RESOLUCION,
				SOURCE.ID_CARRERAS_POR_INSTITUCION,
				SOURCE.ID_SEDE_INSTITUCION,
				1,
				1,
				@USUARIO,
				GETDATE()			
			)
		WHEN NOT MATCHED BY SOURCE AND TARGET.ID_RESOLUCION= @ID_RESOLUCION
		THEN
			UPDATE 
			SET ESTADO=2,				
				USUARIO_MODIFICACION =@USUARIO,
				FECHA_MODIFICACION = GETDATE();


		UPDATE TablaResolXCarrXInst
		SET 
			ES_ACTIVO = 0,
			ESTADO=1, 
			USUARIO_MODIFICACION=@USUARIO,
			FECHA_MODIFICACION=GETDATE()
		FROM transaccional.resoluciones_por_carreras_por_institucion TablaResolXCarrXInst
		WHERE 
		ID_CARRERAS_POR_INSTITUCION NOT IN 
				(SELECT ID_CARRERAS_POR_INSTITUCION
						FROM transaccional.meta_carrera_institucion MCI
						INNER JOIN transaccional.resoluciones_por_periodo_lectivo_institucion RXPLI 
						ON MCI.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION= RXPLI.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION AND MCI.ES_ACTIVO=1 AND RXPLI.ES_ACTIVO=1						
						AND RXPLI.ID_RESOLUCION= @ID_RESOLUCION
		)
		AND TablaResolXCarrXInst.ID_RESOLUCION=@ID_RESOLUCION AND TablaResolXCarrXInst.ESTADO=2

		SET @NRO_ELEM_NO_ACTUALIZADOS = (SELECT COUNT(1) FROM transaccional.resoluciones_por_carreras_por_institucion WHERE ESTADO=2 and ID_RESOLUCION= @ID_RESOLUCION)
		
		UPDATE transaccional.resoluciones_por_carreras_por_institucion
		SET ESTADO=1
		WHERE ID_RESOLUCION=@ID_RESOLUCION AND ESTADO=2

		SET @RESULT=@NRO_ELEM_NO_ACTUALIZADOS 
RETURN (@RESULT)
GO


