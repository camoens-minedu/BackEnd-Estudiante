/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de tipo de modalidad del proceso de admision 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_TIPO_MODALIDAD_CONFIG 1106, 2100, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_TIPO_MODALIDAD_CONFIG]
(
	@ID_INSTITUCION						INT, 
	@ID_TIPO_MODALIDAD_PROCESO_ADMISION	INT,
	@USUARIO							VARCHAR(20)
)AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	

	SELECT @ID_INSTITUCION_CONSULTA= plxi.ID_INSTITUCION 
	FROM transaccional.tipos_modalidad_por_proceso_admision tmxpa
	INNER JOIN transaccional.proceso_admision_periodo pap ON pap.ID_PROCESO_ADMISION_PERIODO = tmxpa.ID_PROCESO_ADMISION_PERIODO AND tmxpa.ES_ACTIVO=1 AND  pap.ES_ACTIVO=1
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = pap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND plxi.ES_ACTIVO=1
	WHERE tmxpa.ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION = @ID_TIPO_MODALIDAD_PROCESO_ADMISION

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE 
	BEGIN
		UPDATE transaccional.tipos_modalidad_por_proceso_admision
		SET	ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE
			ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION = @ID_TIPO_MODALIDAD_PROCESO_ADMISION	
		SET @RESULT = @ID_TIPO_MODALIDAD_PROCESO_ADMISION
	END 

	SELECT @RESULT
END
GO


