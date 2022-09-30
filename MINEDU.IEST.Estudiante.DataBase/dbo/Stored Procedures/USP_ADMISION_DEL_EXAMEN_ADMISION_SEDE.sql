/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de la sede del proceso de admisi>n
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_EXAMEN_ADMISION_SEDE 1106, 67, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_EXAMEN_ADMISION_SEDE]
(
	@ID_INSTITUCION					INT, 
	@ID_EXAMEN_ADMISION_SEDE		INT,
	@USUARIO						VARCHAR(20)
)AS
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	
	SELECT 
		@ID_INSTITUCION_CONSULTA = si.ID_INSTITUCION 
	FROM transaccional.examen_admision_sede eas
		INNER JOIN maestro.sede_institucion si ON eas.ID_SEDE_INSTITUCION = si.ID_SEDE_INSTITUCION AND eas.ES_ACTIVO=1 AND si.ES_ACTIVO=1
	WHERE eas.ID_EXAMEN_ADMISION_SEDE = @ID_EXAMEN_ADMISION_SEDE

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA 	
		SET @RESULT = -362 	 --no corresponde al instituto	
	ELSE IF EXISTS (select TOP 1 ID_POSTULANTES_POR_MODALIDAD from transaccional.postulantes_por_modalidad where ID_EXAMEN_ADMISION_SEDE = @ID_EXAMEN_ADMISION_SEDE AND ES_ACTIVO=1)
			OR EXISTS(SELECT TOP 1 ID_DISTRIBUCION_EXAMEN_ADMISION FROM transaccional.distribucion_examen_admision WHERE ID_EXAMEN_ADMISION_SEDE=@ID_EXAMEN_ADMISION_SEDE AND ES_ACTIVO=1)
		SET @RESULT = -162
	ELSE
	BEGIN
		UPDATE transaccional.examen_admision_sede
		SET ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE
			ID_EXAMEN_ADMISION_SEDE = @ID_EXAMEN_ADMISION_SEDE		

		SET @RESULT =1	
	END
	SELECT @RESULT
END
GO


