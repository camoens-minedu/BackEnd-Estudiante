/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	17/02/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro de instituci>n asignados
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*

*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_INSTITUCION_ASIGNADOS]
AS
BEGIN

    SELECT I.ID_INSTITUCION IdInstitucion
	FROM transaccional.asignación_institucion_carga AIC
	INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION I ON AIC.ID_INSTITUCION= I.ID_INSTITUCION AND AIC.ES_ACTIVO=1 
	
END