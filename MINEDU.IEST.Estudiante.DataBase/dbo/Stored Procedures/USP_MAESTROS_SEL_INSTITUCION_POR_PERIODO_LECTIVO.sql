/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro de instituci>n por periodo lectivo
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*

*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_INSTITUCION_POR_PERIODO_LECTIVO]
(
	@ID_ENUMERADO_TIPO_OPCION INT,
	@ID_PERIODO_LECTIVO INT
)
AS
BEGIN

	SELECT I.ID_INSTITUCION IdInstitucion
	FROM transaccional.periodos_lectivos_por_institucion PLXI
	INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION I ON PLXI.ID_INSTITUCION= I.ID_INSTITUCION AND PLXI.ES_ACTIVO=1 
	WHERE PLXI.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO	
	AND (I.TIPO_GESTION = @ID_ENUMERADO_TIPO_OPCION OR @ID_ENUMERADO_TIPO_OPCION = 5)
END
GO


