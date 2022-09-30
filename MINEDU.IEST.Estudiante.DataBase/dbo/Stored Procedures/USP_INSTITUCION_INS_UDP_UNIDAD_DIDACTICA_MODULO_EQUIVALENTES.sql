/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	07/01/2022
LLAMADO POR			:
DESCRIPCION			:	Agrega unidad didáctica a un módulo equivalentes
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
	
 TEST:  
	USP_INSTITUCION_INS_UDP_UNIDAD_DIDACTICA_MODULO_EQUIVALENTES 14,'119494|119495','42122536'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_INS_UDP_UNIDAD_DIDACTICA_MODULO_EQUIVALENTES]
(
	@ID_MODULO_EQUIVALENCIA INT,
	@ID_UNIDADES_DIDACTICAS VARCHAR(MAX),
	@USUARIO VARCHAR(8)
)
AS
BEGIN
	DECLARE @MSG_TRANS VARCHAR(MAX)

	BEGIN TRY

	SELECT SplitData as ID_UNIDAD_DIDACTICA,ROW_NUMBER() OVER(ORDER BY SplitData) NRO
	INTO #TmpDetalleUnidadesDidacticasEquivalencia
	FROM dbo.UFN_SPLIT(UPPER(@ID_UNIDADES_DIDACTICAS), '|')

	BEGIN TRAN TransactSQL
			
		DECLARE @I INT = 1
		DECLARE @TOTAL INT = (SELECT COUNT(1) FROM #TmpDetalleUnidadesDidacticasEquivalencia)
		DECLARE @ID_UNIDAD_DIDACTICA INT

		WHILE (@I <= @TOTAL)
		BEGIN
			SELECT @ID_UNIDAD_DIDACTICA=ID_UNIDAD_DIDACTICA FROM #TmpDetalleUnidadesDidacticasEquivalencia WHERE NRO = @I

			IF EXISTS (SELECT ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA
						FROM transaccional.unidad_didactica_modulo_equivalencia
						WHERE ID_MODULO_EQUIVALENCIA=@ID_MODULO_EQUIVALENCIA AND ID_UNIDAD_DIDACTICA=@ID_UNIDAD_DIDACTICA)
			BEGIN
				UPDATE transaccional.unidad_didactica_modulo_equivalencia SET
					ES_ACTIVO=1,USUARIO_MODIFICACION=@USUARIO,FECHA_MODIFICACION=GETDATE()
				WHERE ID_MODULO_EQUIVALENCIA=@ID_MODULO_EQUIVALENCIA AND ID_UNIDAD_DIDACTICA=@ID_UNIDAD_DIDACTICA
            END
            ELSE BEGIN
				INSERT INTO transaccional.unidad_didactica_modulo_equivalencia
						(ID_MODULO_EQUIVALENCIA,ID_UNIDAD_DIDACTICA,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
				VALUES  (@ID_MODULO_EQUIVALENCIA,@ID_UNIDAD_DIDACTICA,1,1,@USUARIO,GETDATE())
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