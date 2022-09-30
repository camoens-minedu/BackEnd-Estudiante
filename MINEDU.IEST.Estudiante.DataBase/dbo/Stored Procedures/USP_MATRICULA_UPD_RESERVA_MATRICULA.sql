/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de reserva de matricula 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--1.1		15/05/2020		MALVA			ADICIÓN DE PARÁMETRO @ID_ESTUDIANTE_INSTITUCION
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_RESERVA_MATRICULA]
(    
	@ID_RESERVA_MATRICULA INT, 	
	@ID_MOTIVO_RESERVA INT, 
	@ID_TIEMPO_PERIODO_RESERVA INT,
	@ID_ESTUDIANTE_INSTITUCION INT, 
	@USUARIO VARCHAR(20)
)
AS
DECLARE @RESULT INT
BEGIN

	UPDATE transaccional.reserva_matricula
	SET ID_MOTIVO_RESERVA = @ID_MOTIVO_RESERVA, 
		ID_TIEMPO_PERIODO_RESERVA = @ID_TIEMPO_PERIODO_RESERVA,
		ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION,
		USUARIO_MODIFICACION = @USUARIO,
		FECHA_MODIFICACION = GETDATE()
	WHERE ID_RESERVA_MATRICULA= @ID_RESERVA_MATRICULA
	SET @RESULT = 1
END
SELECT @RESULT

--*************************************************************
--55. USP_MATRICULA_UPD_LICENCIA_ESTUDIANTE.sql
GO


