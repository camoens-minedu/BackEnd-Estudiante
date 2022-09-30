/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de la sesión programada para una clase.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_DEL_SESION_X_PROGRAMACION]  
(  
    @ID_SESION_PROGRAMACION_CLASE INT,
    @USUARIO_MODIFICACION nvarchar(20)  
)  
AS  
DECLARE @RESULT INT
	begin  
	SET @RESULT =0

	UPDATE transaccional.sesion_programacion_clase
	SET  [ES_ACTIVO] = 0   
		  ,[FECHA_MODIFICACION]   = GETDATE()     
		  ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
		  WHERE ID_SESION_PROGRAMACION_CLASE=@ID_SESION_PROGRAMACION_CLASE


SET @RESULT =1
end
SELECT @RESULT
GO


