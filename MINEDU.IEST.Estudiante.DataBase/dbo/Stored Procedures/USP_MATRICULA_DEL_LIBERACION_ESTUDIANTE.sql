--/***************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Elimina un registro de liberación de estudiante
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--	1.1		    31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:		USP_MATRICULA_DEL_LIBERACION_ESTUDIANTE 1106, 25, 'MALVA'
--****************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_DEL_LIBERACION_ESTUDIANTE]
(
	@ID_INSTITUCION						INT,
    @ID_LIBERACION_ESTUDIANTE	        INT,        
    @USUARIO							nvarchar(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = plxi.ID_INSTITUCION 
	FROM transaccional.liberacion_estudiante le
	INNER JOIN transaccional.periodos_lectivos_por_institucion  plxi ON le.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	AND le.ES_ACTIVO=1 AND plxi.ES_ACTIVO=1
	WHERE le.ID_LIBERACION_ESTUDIANTE = @ID_LIBERACION_ESTUDIANTE

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF EXISTS(SELECT TOP 1 ID_TRASLADO_ESTUDIANTE FROM [transaccional].[traslado_estudiante]
					WHERE ID_LIBERACION_ESTUDIANTE = @ID_LIBERACION_ESTUDIANTE AND ES_ACTIVO=1)				
		SET @RESULT = -265 -- EXISTE EN LA TABLA TRASLADO	
	ELSE
	BEGIN    	
			UPDATE transaccional.liberacion_estudiante
			SET 
				[ES_ACTIVO]	= 0 
				,[FECHA_MODIFICACION]	  = GETDATE()   
				,[USUARIO_MODIFICACION]	  = @USUARIO
			WHERE 
				[ID_LIBERACION_ESTUDIANTE]			  = @ID_LIBERACION_ESTUDIANTE	

			SET @RESULT = 1
	END	
	SELECT @RESULT
END
GO


