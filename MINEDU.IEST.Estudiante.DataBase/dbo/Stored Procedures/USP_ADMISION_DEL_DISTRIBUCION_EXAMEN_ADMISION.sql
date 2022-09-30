/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro del proceso de distribución de examen de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_DISTRIBUCION_EXAMEN_ADMISION 1106, 2106, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_DISTRIBUCION_EXAMEN_ADMISION]
(
	@ID_INSTITUCION					INT, 
    @ID_DISTRIBUCION_EXAMEN_ADMISION	       int,        
    @USUARIO                                   nvarchar(20)
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT 
		@ID_INSTITUCION_CONSULTA = pli.ID_INSTITUCION 
	FROM 
	transaccional.distribucion_examen_admision dea
	INNER JOIN transaccional.examen_admision_sede eas ON dea.ID_EXAMEN_ADMISION_SEDE = eas.ID_EXAMEN_ADMISION_SEDE AND dea.ES_ACTIVO=1 AND eas.ES_ACTIVO=1
	INNER JOIN transaccional.proceso_admision_periodo pap ON pap.ID_PROCESO_ADMISION_PERIODO= eas.ID_PROCESO_ADMISION_PERIODO AND pap.ES_ACTIVO=1
	INNER JOIN transaccional.periodos_lectivos_por_institucion pli ON pli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= pap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND pli.ES_ACTIVO=1
	WHERE 
		dea.ID_DISTRIBUCION_EXAMEN_ADMISION = @ID_DISTRIBUCION_EXAMEN_ADMISION

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA 
	BEGIN
		SET @RESULT = -362 	 --no corresponde al instituto
	END 
	ELSE 
	BEGIN 
		UPDATE transaccional.distribucion_examen_admision
		SET 
			 [ES_ACTIVO]	= 0 
			,[FECHA_MODIFICACION]	  = GETDATE()   
			,[USUARIO_MODIFICACION]	  = @USUARIO
		WHERE 
			 [ID_DISTRIBUCION_EXAMEN_ADMISION]			  = @ID_DISTRIBUCION_EXAMEN_ADMISION		 
	    SET @RESULT = 1
	END
	SELECT @RESULT
END
GO


