/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	25/01/2022
LLAMADO POR			:
DESCRIPCION			:	Lista las unidades de competencias por modulo equivalente
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

TEST:  
	USP_INSTITUCION_SEL_UNIDADES_COMPETENCIA_MODULO 14
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_UNIDADES_COMPETENCIA_MODULO]
(
    @ID_MODULO_EQUIVALENCIA INT
)
AS
BEGIN
	SELECT 
	CONVERT(VARCHAR(MAX),muc.ID_UNIDAD_COMPETENCIA) + '|' +
	CONVERT(VARCHAR(MAX),muc.ID_MODULO_EQUIVALENCIA) + '|' +
	CONVERT(VARCHAR(MAX),muc.NOMBRE_UNIDAD_COMPETENCIA) + '|' +
	CONVERT(VARCHAR(MAX),mequi.NOMBRE_MODULO) AS TotalUCompetencias
		 
	FROM transaccional.modulo_unidad_competencia muc 
	INNER JOIN [transaccional].[modulo_equivalencia] mequi ON muc.ID_MODULO_EQUIVALENCIA = mequi.ID_MODULO_EQUIVALENCIA
	WHERE muc.ID_MODULO_EQUIVALENCIA = @ID_MODULO_EQUIVALENCIA AND muc.ES_ACTIVO = 1 AND mequi.ES_ACTIVO = 1
	ORDER BY muc.ID_UNIDAD_COMPETENCIA ASC
END