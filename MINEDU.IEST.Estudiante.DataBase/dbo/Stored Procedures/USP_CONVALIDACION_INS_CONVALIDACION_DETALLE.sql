﻿--USP_CONVALIDACION_INS_CONVALIDACION_DETALLE 21, '4373:16.1:201|4375:12.5:202|4379:14.5:201', 'MALVA'

CREATE PROCEDURE [dbo].[USP_CONVALIDACION_INS_CONVALIDACION_DETALLE]
(
@ID_CONVALIDACION					INT,
@DETALLE_CONVALIDACION				nvarchar(max),
@USUARIO							VARCHAR(20)
)
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION T1
	MERGE INTO transaccional.convalidacion_detalle AS TARGET
		USING (
				select SUBSTRING(SplitData,0,CHARINDEX(':',SplitData)) ID_UNIDAD_DIDACTICA,
				SUBSTRING(REPLACE (SplitData,SUBSTRING(SplitData,0,CHARINDEX(':',SplitData)+1),''), 0, CHARINDEX(':',REPLACE (SplitData,SUBSTRING(SplitData,0,CHARINDEX(':',SplitData)+1),''))) NOTA,
				SUBSTRING(REPLACE (SplitData,SUBSTRING(SplitData,0,CHARINDEX(':',SplitData)+1),''), CHARINDEX(':',REPLACE (SplitData,SUBSTRING(SplitData,0,CHARINDEX(':',SplitData)+1),''))+1, LEN(REPLACE (SplitData,SUBSTRING(SplitData,0,CHARINDEX(':',SplitData)+1),''))) ESTADO
				from dbo.UFN_SPLIT(@DETALLE_CONVALIDACION, '|')
		) AS SOURCE ON TARGET.ID_UNIDAD_DIDACTICA = SOURCE.ID_UNIDAD_DIDACTICA
			AND TARGET.ID_CONVALIDACION=@ID_CONVALIDACION			
		WHEN MATCHED
		THEN
			UPDATE
			SET ES_ACTIVO = 1,
				NOTA = SOURCE.NOTA,
				ESTADO=SOURCE.ESTADO,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
		WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (ID_CONVALIDACION, ID_UNIDAD_DIDACTICA, NOTA, ES_ACTIVO, ESTADO, USUARIO_CREACION,FECHA_CREACION)
			VALUES(
				@ID_CONVALIDACION,
				SOURCE.ID_UNIDAD_DIDACTICA,
				SOURCE.NOTA,
				1,
				SOURCE.ESTADO,	
				@USUARIO,
				GETDATE()		
			)
		WHEN NOT MATCHED BY SOURCE AND TARGET.ID_CONVALIDACION= @ID_CONVALIDACION		
		THEN
			UPDATE
			SET
				ES_ACTIVO = 0,				
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE();
				
		UPDATE transaccional.convalidacion SET ESTADO= 201 WHERE ID_CONVALIDACION=@ID_CONVALIDACION

	COMMIT TRANSACTION T1
	SELECT 1
END TRY
BEGIN CATCH
    IF @@ERROR<>0
    BEGIN
	   ROLLBACK TRANSACTION T1	   
	   SELECT -1
	   PRINT @@ERROR
    END
END CATCH
END
GO

