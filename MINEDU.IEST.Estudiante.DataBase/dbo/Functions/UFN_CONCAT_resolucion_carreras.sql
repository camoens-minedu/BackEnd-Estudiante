CREATE FUNCTION [dbo].[UFN_CONCAT_resolucion_carreras] (@Number INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @values AS NVARCHAR(100)

--SELECT @values = COALESCE(@values + ',', '') + CONVERT(VARCHAR,a.ID_CARRERAS_POR_INSTITUCION) FROM
--(select ID_CARRERAS_POR_INSTITUCION from transaccional.resoluciones_por_carreras_por_institucion 
--where ID_RESOLUCION= @Number 
--and ES_ACTIVO=1) a
--RETURN @values

SELECT @values = COALESCE(@values + ',', '') + CONVERT(VARCHAR,a.ID_CARRERAS_POR_INSTITUCION_DETALLE) FROM
(select CXID.ID_CARRERAS_POR_INSTITUCION_DETALLE
from transaccional.resoluciones_por_carreras_por_institucion RXCI 
INNER JOIN  transaccional.carreras_por_institucion_detalle CXID ON CXID.ID_CARRERAS_POR_INSTITUCION = RXCI.ID_CARRERAS_POR_INSTITUCION AND RXCI.ES_ACTIVO=1
AND CXID.ES_ACTIVO=1
AND (CXID.ID_SEDE_INSTITUCION= RXCI.ID_SEDE_INSTITUCION OR RXCI.ID_SEDE_INSTITUCION IS NULL )
where RXCI.ID_RESOLUCION= @Number ) a
order by a.ID_CARRERAS_POR_INSTITUCION_DETALLE asc


RETURN @values

END