
/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un aula
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_MAESTROS_DEL_AULA 1106, 1061, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_DEL_AULA]
(
	@ID_INSTITUCION			INT, 
    @ID_AULA				int,        
    @USUARIO_MODIFICACION	nvarchar(20)
)
AS
BEGIN
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = si.ID_INSTITUCION 
	FROM maestro.aula a
	INNER JOIN maestro.sede_institucion si ON a.ID_SEDE_INSTITUCION = si.ID_SEDE_INSTITUCION AND a.ES_ACTIVO=1 AND si.ES_ACTIVO=1
	WHERE a.ID_AULA =@ID_AULA

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF EXISTS(select TOP 1 ID_DISTRIBUCION_EXAMEN_ADMISION from transaccional.distribucion_examen_admision where ID_AULA=@ID_AULA AND ES_ACTIVO=1)
			OR EXISTS(SELECT TOP 1 ID_SESION_PROGRAMACION_CLASE FROM transaccional.sesion_programacion_clase WHERE ID_AULA=@ID_AULA AND ES_ACTIVO=1)
		SET @RESULT = -162
	ELSE
	BEGIN
		UPDATE [maestro].[aula]
		SET 
			   [ES_ACTIVO]	= 0 
			  ,[FECHA_MODIFICACION]	  = GETDATE()   
			  ,[USUARIO_MODIFICACION]	  = @USUARIO_MODIFICACION 
		WHERE 
			   [ID_AULA]			  = @ID_AULA	
		
		 SET @RESULT =@@ROWCOUNT
	END 
	SELECT @RESULT	      
END
GO


