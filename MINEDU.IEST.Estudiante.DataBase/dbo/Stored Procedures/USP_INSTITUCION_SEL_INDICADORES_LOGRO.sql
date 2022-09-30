/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	26/01/2022
LLAMADO POR			:
DESCRIPCION			:	Lista los indicadores de logro por unidad de competencia
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

TEST:  
	USP_INSTITUCION_SEL_INDICADORES_LOGRO 13
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_INDICADORES_LOGRO]
(
    @ID_UNIDAD_COMPETENCIA INT
)
AS
BEGIN	
	SELECT 
		
	CONVERT(VARCHAR(MAX),ilogro.ID_UNIDAD_COMPETENCIA) + '|' +
	CONVERT(VARCHAR(MAX),ilogro.ID_INDICADORES_LOGRO) + '|' +
	CONVERT(VARCHAR(MAX),ilogro.NOMBRE_INDICADOR_LOGRO) /*+ '|' +
	CONVERT(VARCHAR(MAX),muc.ID_MODULO_EQUIVALENCIA)*/ AS TotalILogro
		 
	FROM transaccional.modulo_unidad_competencia muc 
	INNER JOIN [transaccional].[indicadores_logro] ilogro ON muc.ID_UNIDAD_COMPETENCIA = ilogro.ID_UNIDAD_COMPETENCIA
	WHERE ilogro.ID_UNIDAD_COMPETENCIA = @ID_UNIDAD_COMPETENCIA AND muc.ES_ACTIVO = 1 AND ilogro.ES_ACTIVO = 1
	ORDER BY muc.ID_UNIDAD_COMPETENCIA ASC
END