/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	25/08/2021
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de parametro
REVISIONES			:
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_DEL_PARAMETROS]
(
	@ID_PARAMETRO							INT,  
    @USUARIO								nvarchar(20)
)
AS
BEGIN
DECLARE @RESULT INT
SET NOCOUNT ON;

		UPDATE [sistema].parametro
		   SET 
			   [ESTADO]	= 0 
			  ,[FECHA_MODIFICACION]	  = GETDATE()   
			  ,[USUARIO_MODIFICACION]	  = @USUARIO
		 WHERE 
			   [ID_PARAMETRO]			  = @ID_PARAMETRO		      

		SET @RESULT = @@ROWCOUNT


	SELECT @RESULT
END