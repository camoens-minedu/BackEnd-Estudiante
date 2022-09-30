
/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	17/05/2022
LLAMADO POR			:
DESCRIPCION			:	Elimina una solicitud de carnet del IEST
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:  
--			USP_CARNET_DEL_SOLICITUD_CARNET_PERIODO 1106, 'JTOVAR'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARNET_DEL_SOLICITUD_CARNET_PERIODO]
(
	@ID_SOLICITUD_CARNET	INT, 
    @USUARIO            	nvarchar(20)
)
AS
BEGIN
	DECLARE @RESULT INT
	BEGIN
		UPDATE [transaccional].[solicitud_carnet]
		SET 
			   [ES_ACTIVO]	= 0 
			  ,[FECHA_MODIFICACION]	  = GETDATE()   
			  ,[USUARIO_MODIFICACION] = @USUARIO 
		WHERE 
			   [ID_SOLICITUD_CARNET]  = @ID_SOLICITUD_CARNET	
		
		 SET @RESULT =@@ROWCOUNT
	END 
	SELECT @RESULT	      
END