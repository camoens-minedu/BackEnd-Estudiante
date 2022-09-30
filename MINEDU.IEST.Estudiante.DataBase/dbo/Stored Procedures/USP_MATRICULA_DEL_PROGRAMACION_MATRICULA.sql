/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro de la matricula programada
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--/*
--	1.0		    31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:		USP_MATRICULA_DEL_PROGRAMACION_MATRICULA 1106, 73, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_DEL_PROGRAMACION_MATRICULA]
(
	@ID_INSTITUCION					INT, 
    @ID_PROGRAMACION_MATRICULA		INT,        
    @USUARIO						nvarchar(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0
	
	SELECT @ID_INSTITUCION_CONSULTA = plxi.ID_INSTITUCION FROM transaccional.programacion_matricula pm
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON pm.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND pm.ES_ACTIVO=1 AND plxi.ES_ACTIVO=1
	WHERE pm.ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF (EXISTS (SELECT TOP 1 ID_PROGRAMACION_MATRICULA FROM transaccional.matricula_estudiante WHERE ID_PROGRAMACION_MATRICULA=@ID_PROGRAMACION_MATRICULA AND ES_ACTIVO=1))
		SET @RESULT=-162
	ELSE
	BEGIN
		UPDATE transaccional.programacion_matricula
		   SET 
			   [ES_ACTIVO]	= 0 
			  ,[FECHA_MODIFICACION]	  = GETDATE()   
			  ,[USUARIO_MODIFICACION]	  = @USUARIO
		 WHERE 
			   [ID_PROGRAMACION_MATRICULA]			  = @ID_PROGRAMACION_MATRICULA	
		SET @RESULT = @@ROWCOUNT	      
	END
	SELECT @RESULT
END
GO


