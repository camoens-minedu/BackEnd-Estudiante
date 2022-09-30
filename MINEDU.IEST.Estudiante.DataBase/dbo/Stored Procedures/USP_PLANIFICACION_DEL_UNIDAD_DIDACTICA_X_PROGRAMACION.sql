/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro la una clase programada para una unidad didactica
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	EXEC	SP_PLANIFICACION_DEL_PROGRAMACION_CLASE 2, 'MALVA'
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_DEL_UNIDAD_DIDACTICA_X_PROGRAMACION]  
(  
    @ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE INT,
    @USUARIO_MODIFICACION nvarchar(20)  
)  
AS  
DECLARE @RESULT INT
	begin  
	SET @RESULT =0
	UPDATE [transaccional].[unidades_didacticas_por_programacion_clase]
	SET  [ES_ACTIVO] = 0   
		  ,[FECHA_MODIFICACION]   = GETDATE()     
		  ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
		  WHERE ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE=@ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE

SET @RESULT =1
end
SELECT @RESULT
GO


