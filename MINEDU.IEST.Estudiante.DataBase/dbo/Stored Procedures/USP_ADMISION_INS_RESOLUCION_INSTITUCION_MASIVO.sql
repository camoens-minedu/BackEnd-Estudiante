CREATE PROCEDURE [dbo].[USP_ADMISION_INS_RESOLUCION_INSTITUCION_MASIVO]
(
	@ID_INSTITUCION NVARCHAR(max) 
    ,@ID_RESOLUCION	    int
    --,@ID_PERIODO_LECTIVO int  =2
	,@ANIO INT
    ,@ID_TIPO_RESOLUCION int 
	,@USUARIO VARCHAR(20)
)
AS
BEGIN TRY
BEGIN TRANSACTION T1
	MERGE INTO transaccional.resoluciones_por_periodo_lectivo_institucion AS TARGET
		USING (
				select 	IdPeriodoLectivoInstitucion from (
				SELECT  ID_PERIODOS_LECTIVOS_POR_INSTITUCION  IdPeriodoLectivoInstitucion,
				ROW_NUMBER() OVER ( PARTITION BY ID_INSTITUCION ORDER BY  ID_PERIODOS_LECTIVOS_POR_INSTITUCION ASC) AS Orden
				FROM transaccional.periodos_lectivos_por_institucion tplxi
				inner join maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
				WHERE ES_ACTIVO=1  AND mpl.ANIO=@ANIO AND tplxi.ID_INSTITUCION IN (SELECT SplitData FROM dbo.UFN_SPLIT(UPPER(@ID_INSTITUCION), ','))) A
		 where Orden= CASE WHEN @ID_TIPO_RESOLUCION= (SELECT ID_ENUMERADO FROM sistema.enumerado where VALOR_ENUMERADO='AMPLIACIÓN DE META DE ATENCIÓN') THEN 2
		 ELSE 1 END
		) AS SOURCE ON TARGET.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = SOURCE.IdPeriodoLectivoInstitucion
			AND TARGET.ES_ACTIVO =1
		WHEN MATCHED
		THEN
			UPDATE 
			SET ES_ACTIVO = 1,
				USUARIO_MODIFICACION = @USUARIO,		
				FECHA_MODIFICACION = GETDATE()
		WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
				ID_RESOLUCION,
				ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
				ES_ACTIVO,
				ESTADO,				
				USUARIO_CREACION,
				FECHA_CREACION
			) VALUES (
				@ID_RESOLUCION,
				SOURCE.IdPeriodoLectivoInstitucion,
				1,
				1,
				@USUARIO,
				GETDATE()
			)
		WHEN NOT MATCHED BY SOURCE AND TARGET.ID_RESOLUCION = @ID_RESOLUCION
		THEN
			UPDATE
			SET ES_ACTIVO = 0,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE();
	COMMIT TRANSACTION T1
END TRY	
BEGIN CATCH
    IF @@ERROR<>0
    BEGIN
	   ROLLBACK TRANSACTION T1	   
	   SELECT -1
    END
END CATCH
GO


