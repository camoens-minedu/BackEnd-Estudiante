/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	24/08/2021
LLAMADO POR			:
DESCRIPCION			:	Actualiza registros de la tabla PARAMETRO en el SISTEMA
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_UPD_PARAMETROS]
(    
    @ID_PARAMETRO      int,
	@CODIGO            int,
	@NOMBRE            VARCHAR(50),
	@VALOR             VARCHAR(16),
	@USUARIO           VARCHAR(20)

)
AS
BEGIN
	DECLARE @RESULT INT

	IF NOT EXISTS(SELECT TOP 1 [ID_PARAMETRO] FROM [sistema].[parametro] 
				  WHERE NOMBRE_PARAMETRO = UPPER(@NOMBRE) COLLATE LATIN1_GENERAL_CI_AI AND ESTADO=1 AND ID_PARAMETRO = @ID_PARAMETRO AND CODIGO_PARAMETRO = @CODIGO)
		SET @RESULT = -300
	ELSE
	BEGIN
		UPDATE sistema.parametro 
		SET /*CODIGO_PARAMETRO = @CODIGO, NOMBRE_PARAMETRO = @NOMBRE,*/ VALOR_PARAMETRO = @VALOR,
		FECHA_MODIFICACION = GETDATE(),
		USUARIO_MODIFICACION = @USUARIO
		WHERE ID_PARAMETRO = @ID_PARAMETRO

		SET @RESULT = 1
	END
	SELECT @RESULT
END