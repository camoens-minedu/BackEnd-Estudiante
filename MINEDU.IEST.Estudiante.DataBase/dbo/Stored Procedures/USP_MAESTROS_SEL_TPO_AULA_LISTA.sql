/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los registros de los tipos de aula
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_TPO_AULA_LISTA]
(  
@ID_TIPO_ENUMERADO INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;   
 SELECT 
VALOR_ENUMERADO Text, 
ID_ENUMERADO Value,
CODIGO_ENUMERADO Code 
FROM sistema.enumerado
WHERE ID_TIPO_ENUMERADO=4 AND ESTADO=1
order by 1 asc
END
GO


