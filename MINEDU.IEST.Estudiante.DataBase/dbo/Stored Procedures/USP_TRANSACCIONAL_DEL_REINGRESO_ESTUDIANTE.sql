/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro de reingreso del estudiante.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--/*
--	1.0		31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:		USP_TRANSACCIONAL_DEL_REINGRESO_ESTUDIANTE 1106, 19, 'MALVA'
**********************************************************************************************************/

CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_DEL_REINGRESO_ESTUDIANTE]
(
	@ID_INSTITUCION						INT, 
    @ID_REINGRESO_ESTUDIANTE	        INT,        
    @USUARIO							nvarchar(20)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0, @ID_LICENCIA_ESTUDIANTE INT, @ID_RESERVA_MATRICULA INT, @ID_ESTUDIANTE_INSTITUCION INT

	SELECT @ID_INSTITUCION_CONSULTA =  plxi.ID_INSTITUCION from transaccional.reingreso_estudiante ri
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = ri.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	AND ri.ES_ACTIVO=1 AND plxi.ES_ACTIVO=1
	WHERE ri.ID_REINGRESO_ESTUDIANTE = @ID_REINGRESO_ESTUDIANTE

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
	BEGIN
		SET @RESULT = -362 GOTO FIN
	END
	
	SET @ID_LICENCIA_ESTUDIANTE = (SELECT TOP 1 ID_LICENCIA_ESTUDIANTE FROM transaccional.reingreso_estudiante WHERE ID_REINGRESO_ESTUDIANTE = @ID_REINGRESO_ESTUDIANTE AND ES_ACTIVO = 1)
	SET @ID_RESERVA_MATRICULA = (SELECT TOP 1 ID_RESERVA_MATRICULA FROM transaccional.reingreso_estudiante WHERE ID_REINGRESO_ESTUDIANTE = @ID_REINGRESO_ESTUDIANTE AND ES_ACTIVO = 1)

	SET @ID_ESTUDIANTE_INSTITUCION = (SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION FROM transaccional.licencia_estudiante WHERE ID_LICENCIA_ESTUDIANTE = @ID_LICENCIA_ESTUDIANTE AND ES_ACTIVO = 1)
	SET @ID_ESTUDIANTE_INSTITUCION = (SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION FROM transaccional.reserva_matricula WHERE ID_RESERVA_MATRICULA = @ID_RESERVA_MATRICULA AND ES_ACTIVO = 1)

	IF EXISTS (SELECT TOP 1 ID_MATRICULA_ESTUDIANTE FROM transaccional.matricula_estudiante WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND ES_ACTIVO = 1)
		SET @RESULT = -162
	ELSE
	BEGIN

		UPDATE transaccional.reingreso_estudiante
		   SET 
			   [ES_ACTIVO]	= 0 
			  ,[FECHA_MODIFICACION]	  = GETDATE()   
			  ,[USUARIO_MODIFICACION]	  = @USUARIO
		 WHERE 
			   [ID_REINGRESO_ESTUDIANTE]			  = @ID_REINGRESO_ESTUDIANTE		
		
		SET @RESULT = 1     
	END
	FIN:
	SELECT  @RESULT
END
GO


