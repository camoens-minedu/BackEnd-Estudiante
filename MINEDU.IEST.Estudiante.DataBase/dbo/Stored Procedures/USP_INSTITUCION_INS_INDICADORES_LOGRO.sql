/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	26/01/2022
LLAMADO POR			:
DESCRIPCION			:	Agrega indicadores de logro para unidades de competencia
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
	
TEST:  

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_INS_INDICADORES_LOGRO]
(
	@ID_UNIDAD_COMPETENCIA INT,
	@DETALLE_NOMBRE_INDICADOR_LOGRO VARCHAR(MAX),
    @USUARIO VARCHAR(8)
)
AS
BEGIN
	DECLARE @MSG_TRANS VARCHAR(MAX)

	BEGIN TRY

		SELECT @ID_UNIDAD_COMPETENCIA as ID_UNIDAD_COMPETENCIA,SplitData as NOMBRE_INDICADOR_LOGRO,ROW_NUMBER() OVER(ORDER BY SplitData) NRO
		INTO #TmpDetalleIndicadorLogro
		FROM dbo.UFN_SPLIT(UPPER(@DETALLE_NOMBRE_INDICADOR_LOGRO), '|')

		BEGIN TRAN TransactSQL
			
			DECLARE @I INT = 1
			DECLARE @TOTAL INT = (SELECT COUNT(1) FROM #TmpDetalleIndicadorLogro)
			DECLARE @NOMBRE_INDICADOR_LOGRO NVARCHAR(500) = ''

			UPDATE transaccional.indicadores_logro SET
				ES_ACTIVO=0,USUARIO_MODIFICACION=@USUARIO,FECHA_MODIFICACION=GETDATE()
			WHERE ID_UNIDAD_COMPETENCIA=@ID_UNIDAD_COMPETENCIA AND ES_ACTIVO=1

			WHILE (@I <= @TOTAL)
			BEGIN
				SELECT @NOMBRE_INDICADOR_LOGRO=NOMBRE_INDICADOR_LOGRO FROM #TmpDetalleIndicadorLogro WHERE NRO = @I

				IF EXISTS (SELECT ID_UNIDAD_COMPETENCIA
							FROM transaccional.indicadores_logro
							WHERE ID_UNIDAD_COMPETENCIA=@ID_UNIDAD_COMPETENCIA AND NOMBRE_INDICADOR_LOGRO=@NOMBRE_INDICADOR_LOGRO)
				BEGIN
					UPDATE transaccional.indicadores_logro SET
						ES_ACTIVO=1,USUARIO_MODIFICACION=@USUARIO,FECHA_MODIFICACION=GETDATE()
					WHERE ID_UNIDAD_COMPETENCIA=@ID_UNIDAD_COMPETENCIA AND NOMBRE_INDICADOR_LOGRO=@NOMBRE_INDICADOR_LOGRO
                END
                ELSE BEGIN
					INSERT INTO transaccional.indicadores_logro
						    (ID_UNIDAD_COMPETENCIA,NOMBRE_INDICADOR_LOGRO,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
					VALUES  (@ID_UNIDAD_COMPETENCIA,@NOMBRE_INDICADOR_LOGRO,1,1,@USUARIO,GETDATE())
                END
				SET @I = @I + 1
			END
	   
		COMMIT TRAN TransactSQL
		SELECT 1 AS valor

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN TransactSQL
		DECLARE @ERROR_MESSAGE VARCHAR(MAX) = ''
		SET @ERROR_MESSAGE = ERROR_MESSAGE() + ' -- '
		SELECT 'Error: ' + @ERROR_MESSAGE
		SELECT 0 AS valor
	END CATCH
END