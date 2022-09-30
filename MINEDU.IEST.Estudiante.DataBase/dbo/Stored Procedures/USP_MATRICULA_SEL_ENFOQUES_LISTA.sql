/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de enfoques según el plan de estudio
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*

*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ENFOQUES_LISTA]
(  
	@ID_PLAN_ESTUDIO INT
)  
AS  
BEGIN  
	SET NOCOUNT ON;  

	SELECT NOMBRE_ENFOQUE Text,
		   ID_ENFOQUE Value
	FROM maestro.enfoque 
	WHERE ID_ENFOQUE IN (SELECT ID_ENFOQUE 
						FROM transaccional.enfoques_por_plan_estudio 
						WHERE ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO)

END
GO


