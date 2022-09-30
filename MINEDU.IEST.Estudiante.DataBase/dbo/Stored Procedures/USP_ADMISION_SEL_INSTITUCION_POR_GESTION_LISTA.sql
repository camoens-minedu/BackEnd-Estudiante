CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_INSTITUCION_POR_GESTION_LISTA]
(	
	@ID_PERIODO_LECTIVO_INSTITUCION INT
)
AS
DECLARE @ANIO INT, @NOMBRE_APERTURADO VARCHAR(20)
SELECT @ANIO = mpl.ANIO FROM transaccional.periodos_lectivos_por_institucion  tpli
INNER JOIN maestro.periodo_lectivo mpl on tpli.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION
SET @NOMBRE_APERTURADO = 'APERTURADO'

SELECT Code, Text, Value from 
(SELECT mi.CODIGO_MODULAR																	Code,
		Rtrim(LTrim(mi.CODIGO_MODULAR +' - '+mi.NOMBRE_INSTITUCION))		Text,
		mi.ID_INSTITUCION		Value,
		 ROW_NUMBER() OVER ( PARTITION BY mi.ID_INSTITUCION ORDER BY tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION) AS Orden 
FROM		db_auxiliar.dbo.UVW_INSTITUCION mi 
INNER JOIN	transaccional.periodos_lectivos_por_institucion tpli on mi.ID_INSTITUCION = tpli.ID_INSTITUCION
			and tpli.ESTADO=(SELECT ID_ENUMERADO from sistema.enumerado where VALOR_ENUMERADO='APERTURADO') 
INNER JOIN	maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tpli.ID_PERIODO_LECTIVO 
WHERE  mi.ID_INSTITUCION NOT IN (
							SELECT distinct  tplxi.ID_INSTITUCION FROM transaccional.resoluciones_por_periodo_lectivo_institucion trxpli
							INNER JOIN transaccional.periodos_lectivos_por_institucion tplxi
							on trxpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tplxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
							INNER JOIN maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tplxi.ID_PERIODO_LECTIVO
							and mpl.ANIO= 2018 and trxpli.ES_ACTIVO=1
							)
AND mpl.ANIO=@ANIO )A where A.Orden=1
ORDER BY Text,Code,Value
GO


