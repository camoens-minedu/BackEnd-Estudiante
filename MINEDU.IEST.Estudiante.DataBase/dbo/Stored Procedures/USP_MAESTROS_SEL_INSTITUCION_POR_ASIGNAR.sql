/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	17/02/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de instituciones para asignar
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_INSTITUCION_POR_ASIGNAR]
AS
BEGIN
SELECT	mi.ID_INSTITUCION Value,
		Rtrim(LTrim(cast(mi.CODIGO_MODULAR AS nvarchar) +' - '+mi.NOMBRE_INSTITUCION)) Text,
		mi.CODIGO_MODULAR Code
FROM db_auxiliar.dbo.UVW_INSTITUCION mi 
ORDER BY mi.NOMBRE_INSTITUCION
END