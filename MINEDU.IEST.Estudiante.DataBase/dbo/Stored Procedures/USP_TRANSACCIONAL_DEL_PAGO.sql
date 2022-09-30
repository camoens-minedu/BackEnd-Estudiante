/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	27/02/2021
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de pago
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
  TEST:  
		USP_TRANSACCIONAL_DEL_PAGO 1106, 1061, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_DEL_PAGO]
(
	@ID_INSTITUCION			INT, 
    @ID_PAGO_INSTITUCION	int,        
    @USUARIO_MODIFICACION	nvarchar(20)
)
AS
BEGIN
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = ID_INSTITUCION 
	FROM [transaccional].[pago_institucion] (nolock) 	
	WHERE ID_PAGO_INSTITUCION = @ID_PAGO_INSTITUCION AND ES_ACTIVO = 1

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE
	BEGIN
		UPDATE [transaccional].[pago_institucion]
		SET 
			   [ES_ACTIVO]	= 0 
			  ,[FECHA_MODIFICACION]		= GETDATE()   
			  ,[USUARIO_MODIFICACION]	= @USUARIO_MODIFICACION 
		WHERE 
			   [ID_PAGO_INSTITUCION]	= @ID_PAGO_INSTITUCION	
		
		 SET @RESULT =@@ROWCOUNT
	END 
	SELECT @RESULT	      
END