--/*************************************************************************************************************************************************
--AUTOR				:	Consultores DRE
--FECHA DE CREACION	:	22/01/2020
--LLAMADO POR			:
--DESCRIPCION			:	Validar cierre programación
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--*/
--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].USP_MATRICULA_VALIDAR_CIERRE_PROGRAMACION (
	@ID_PROGRAMACION_MATRICULA					INT
) AS
DECLARE @RESULT INT
DECLARE @ESTA_CERRADO INT
DECLARE @FECHA_CIERRE DATETIME
DECLARE @FECHA_ACTUAL DATETIME = GETDATE()
BEGIN  
	
	SET @FECHA_CIERRE = (SELECT TOP 1 FECHA_FIN FROM transaccional.programacion_matricula WHERE ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA)

	IF (DATEDIFF(day, @FECHA_CIERRE, @FECHA_ACTUAL) >=1)
	BEGIN
		SET @ESTA_CERRADO = (SELECT TOP 1 CERRADO FROM transaccional.programacion_matricula WHERE ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA)
		IF(@ESTA_CERRADO = 1)
		BEGIN
			SET @RESULT = -346;
		END
		ELSE
		BEGIN
			update transaccional.programacion_matricula set CERRADO = 'true' where ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA;
			SET @RESULT = 1;
		END
	END
	ELSE
	BEGIN
		SET @RESULT = -364;
	END

END

SELECT @RESULT

--**********************************************************
--92. USP_SISTEMA_DEL_ENUMERADO_HISTORICO.sql