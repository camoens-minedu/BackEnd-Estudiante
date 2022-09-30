/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de instituciones por tipo de gestión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
1.1			10/09/2021		JCHAVEZ			Se modificó campo Text para agregar mi.TIPO_INSTITUCION_NOMBRE 
	
	TEST:			
	USP_MAESTROS_SEL_INSTITUCION_POR_GESTION_LISTA 5,2
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_INSTITUCION_POR_GESTION_LISTA]
(
	@ID_ENUMERADO_TIPO_OPCION INT,
	@ID_PERIODO_LECTIVO INT
)
AS

SELECT	mi.ID_INSTITUCION Value,
		Rtrim(LTrim(cast(mi.CODIGO_MODULAR AS nvarchar) + ' - ' + mi.NOMBRE_INSTITUCION + ' - ' + mi.TIPO_INSTITUCION_NOMBRE)) Text,
		mi.CODIGO_MODULAR + '-' + cast(mi.ID_INSTITUCION AS nvarchar) Code
FROM db_auxiliar.dbo.UVW_INSTITUCION mi 
WHERE 
	(mi.TIPO_GESTION = @ID_ENUMERADO_TIPO_OPCION OR @ID_ENUMERADO_TIPO_OPCION = 5)
ORDER BY mi.NOMBRE_INSTITUCION
GO


