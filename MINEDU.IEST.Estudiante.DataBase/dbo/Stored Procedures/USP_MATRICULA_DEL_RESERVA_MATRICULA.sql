--/************************************************************************************************************************************
--AUTOR				:	Mayra Alva
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Eliminación de reserva de matrícula
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		USP_MATRICULA_DEL_RESERVA_MATRICULA 1106, 10143, 'MALVA'
--/*
--	1.0			24/12/2019		MALVA          MODIFICACIÓN PARA QUE OBTENGA LA ÚLTIMA FECHA DE FIN DE MATRÍCULA DEL PERIODO LECTIVO IEST,
--											   PRECISIÓN DE FECHA ACTUAL 
--	1.1		    31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_DEL_RESERVA_MATRICULA]
(
	@ID_INSTITUCION					INT, 
    @ID_RESERVA_MATRICULA		    INT,        
    @USUARIO						nvarchar(20))
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0, @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT

	SELECT  
	@ID_INSTITUCION_CONSULTA = plxi.ID_INSTITUCION, 
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION= plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	FROM transaccional.reserva_matricula rm
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = rm.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	AND rm.ES_ACTIVO=1 AND plxi.ES_ACTIVO=1
	WHERE ID_RESERVA_MATRICULA = @ID_RESERVA_MATRICULA 

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
	BEGIN
		SET @RESULT = -362 GOTO FIN
	END
	
	DECLARE @FECHA_FIN_MATRICULA DATETIME
	DECLARE @FECHA_ACTUAL DATE


	SET @FECHA_FIN_MATRICULA = (SELECT TOP 1 FECHA_FIN FROM transaccional.programacion_matricula WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND ES_ACTIVO=1 ORDER BY FECHA_FIN DESC)
	SET @FECHA_ACTUAL = (SELECT SYSDATETIME ( ))

	IF (@FECHA_ACTUAL > @FECHA_FIN_MATRICULA)
			SET @RESULT = -328
	ELSE IF EXISTS (SELECT TOP 1 ID_REINGRESO_ESTUDIANTE FROM transaccional.reingreso_estudiante WHERE ID_RESERVA_MATRICULA = @ID_RESERVA_MATRICULA AND ES_ACTIVO = 1)
			SET @RESULT = -162
	ELSE
	BEGIN
		UPDATE transaccional.reserva_matricula
		SET 
			[ES_ACTIVO]	= 0 
			,[FECHA_MODIFICACION]	  = GETDATE()   
			,[USUARIO_MODIFICACION]	  = @USUARIO
		WHERE 
		   ID_RESERVA_MATRICULA= @ID_RESERVA_MATRICULA
		
		SET @RESULT = 1
	END
	FIN:
	SELECT @RESULT
END
GO


