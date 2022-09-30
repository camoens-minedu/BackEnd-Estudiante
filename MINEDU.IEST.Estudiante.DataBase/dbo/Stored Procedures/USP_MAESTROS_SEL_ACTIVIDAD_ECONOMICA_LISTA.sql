/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los registros de la actividad economica segú la familia productiva
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*

*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_ACTIVIDAD_ECONOMICA_LISTA]
(  
@ID_FAMILIA_PRODUCTIVA INT  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 SELECT        
     NOMBRE_ACTIVIDAD_ECONOMICA Text,  
     ID_ACTIVIDAD_ECONOMICA Value  
 FROM maestro.actividad_economica
 WHERE (ID_FAMILIA_PRODUCTIVA = @ID_FAMILIA_PRODUCTIVA)     
END
GO


