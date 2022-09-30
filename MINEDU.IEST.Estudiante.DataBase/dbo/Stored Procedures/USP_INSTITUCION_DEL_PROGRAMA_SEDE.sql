/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro del programa de una sede
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_DEL_PROGRAMA_SEDE]  
(  
    @ID_CARRERAS_POR_INSTITUCION_DETALLE         int,          
    @USUARIO_MODIFICACION nvarchar(20)  
)  
AS  

IF EXISTS (SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION 
			from transaccional.estudiante_institucion WHERE ID_CARRERAS_POR_INSTITUCION_DETALLE = @ID_CARRERAS_POR_INSTITUCION_DETALLE AND ES_ACTIVO=1)
	SELECT -162
ELSE
BEGIN
	--UPDATE [transaccional].[carreras_por_institucion_detalle]  
	--SET   
 --      [ES_ACTIVO] = 0   
 --     ,[FECHA_MODIFICACION]   = GETDATE()     
 --     ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
	--WHERE   
 --   [ID_CARRERAS_POR_INSTITUCION_DETALLE]     = @ID_CARRERAS_POR_INSTITUCION_DETALLE       
	SELECT 1
END
GO


