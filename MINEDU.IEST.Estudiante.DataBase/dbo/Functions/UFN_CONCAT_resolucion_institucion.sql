CREATE FUNCTION [dbo].[UFN_CONCAT_resolucion_institucion] (@Number INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @values AS NVARCHAR(100)

SELECT @values = COALESCE(@values + ', ', '') + CONVERT(VARCHAR,a.ID_INSTITUCION) FROM
(SELECT DISTINCT plxi.ID_INSTITUCION
FROM	transaccional.resoluciones_por_periodo_lectivo_institucion rxpli
		INNER JOIN transaccional.periodos_lectivos_por_institucion plxi on rxpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND plxi.ES_ACTIVO = 1
WHERE ID_RESOLUCION = @Number AND rxpli.ES_ACTIVO = 1) a
RETURN @values

END