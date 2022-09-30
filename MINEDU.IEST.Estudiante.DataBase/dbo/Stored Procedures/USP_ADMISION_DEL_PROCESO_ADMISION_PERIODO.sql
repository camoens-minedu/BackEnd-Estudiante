/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro del periodo del proceso de admision 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
-- VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0			30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_PROCESO_ADMISION_PERIODO 1106, 2191, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_PROCESO_ADMISION_PERIODO]
(
	@ID_INSTITUCION					INT, 
	@ID_PROCESO_ADMISION_PERIODO	INT,
	@USUARIO						VARCHAR(20)
)AS
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	

	SELECT 
		@ID_INSTITUCION_CONSULTA = plxi.ID_INSTITUCION 
	FROM 
		transaccional.proceso_admision_periodo pap
		INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON pap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND pap.ES_ACTIVO=1 AND plxi.ES_ACTIVO=1
	WHERE 
		pap.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA 
		SET @RESULT = -362
	ELSE IF EXISTS (select TOP 1 ID_COMISION_PROCESO_ADMISION from transaccional.comision_proceso_admision 
			where ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO AND ES_ACTIVO=1
			) OR EXISTS(SELECT TOP 1 ID_EXAMEN_ADMISION_SEDE FROM transaccional.examen_admision_sede 
			WHERE ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO AND ES_ACTIVO=1)
			OR EXISTS (SELECT TOP 1 ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION FROM transaccional.tipos_modalidad_por_proceso_admision 
			WHERE ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO AND ES_ACTIVO=1)
			OR EXISTS (SELECT TOP 1 eamod.ID_EVALUADOR_ADMISION_MODALIDAD FROM transaccional.modalidades_por_proceso_admision mppadm INNER JOIN transaccional.evaluador_admision_modalidad eamod
            ON mppadm.ID_MODALIDADES_POR_PROCESO_ADMISION = eamod.ID_MODALIDADES_POR_PROCESO_ADMISION
            WHERE mppadm.ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO AND mppadm.ES_ACTIVO = 1 AND eamod.ES_ACTIVO=1)
			set @RESULT = -162
	ELSE
	BEGIN
		BEGIN TRANSACTION T1
		BEGIN TRY
			UPDATE	transaccional.proceso_admision_periodo
			SET
					ES_ACTIVO = 0,
					USUARIO_MODIFICACION = @USUARIO,
					FECHA_MODIFICACION = GETDATE()
			WHERE 	ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO

			UPDATE transaccional.modalidades_por_proceso_admision
			SET
				ES_ACTIVO = 0,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
			COMMIT TRANSACTION T1
			SET @RESULT = 1
		END TRY
		BEGIN CATCH
			IF @@ERROR<>0
			BEGIN
				ROLLBACK TRANSACTION T1	   
				SET @RESULT =  -1
			END
		END CATCH	
	END
	SELECT @RESULT
END
GO


