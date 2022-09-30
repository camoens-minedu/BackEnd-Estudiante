/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de evaluador del proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_EVALUADORES 1106, 50, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_EVALUADORES]
(
	@ID_INSTITUCION							INT, 
	@ID_EVALUADOR_ADMISION_MODALIDAD		INT,
	@USUARIO								VARCHAR(20)
)AS 
BEGIN
SET NOCOUNT ON;
DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	

	SELECT 
		@ID_INSTITUCION_CONSULTA = plxi.ID_INSTITUCION 
	FROM 
	transaccional.evaluador_admision_modalidad eam
	INNER JOIN maestro.personal_institucion mpi ON eam.ID_PERSONAL_INSTITUCION = mpi.ID_PERSONAL_INSTITUCION AND eam.ES_ACTIVO=1 AND mpi.ES_ACTIVO=1
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = mpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND plxi.ES_ACTIVO=1
	WHERE 
		eam.ID_EVALUADOR_ADMISION_MODALIDAD = @ID_EVALUADOR_ADMISION_MODALIDAD 

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA 	
		SET @RESULT = -362 	 --no corresponde al instituto	
	ELSE IF EXISTS (SELECT ID_DISTRIBUCION_EXAMEN_ADMISION FROM transaccional.distribucion_examen_admision WHERE ID_EVALUADOR_ADMISION_MODALIDAD= @ID_EVALUADOR_ADMISION_MODALIDAD
			AND ES_ACTIVO=1 )
		SET @RESULT= -162
	ELSE
		BEGIN
		UPDATE transaccional.evaluador_admision_modalidad
		SET 
			ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE
			ID_EVALUADOR_ADMISION_MODALIDAD = @ID_EVALUADOR_ADMISION_MODALIDAD

		SET @RESULT=1
	END
	SELECT @RESULT
END
GO


