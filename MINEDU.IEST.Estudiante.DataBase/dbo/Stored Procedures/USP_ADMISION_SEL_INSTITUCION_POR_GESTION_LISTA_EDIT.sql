CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_INSTITUCION_POR_GESTION_LISTA_EDIT]
(	
	@ID_RESOLUCION						INT,
	@ID_PERIODO_LECTIVO_INSTITUCION		INT
)
AS
DECLARE @ANIO INT, @NOMBRE_APERTURADO VARCHAR(20)
SELECT @ANIO = mpl.ANIO FROM transaccional.periodos_lectivos_por_institucion  tpli
INNER JOIN maestro.periodo_lectivo mpl on tpli.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION
SET @NOMBRE_APERTURADO = 'APERTURADO'

 SELECT mi.CODIGO_MODULAR												Code,
		Rtrim(LTrim(mi.CODIGO_MODULAR +' - '+mi.NOMBRE_INSTITUCION))		Text,
		mi.ID_INSTITUCION													Value
 FROM
 transaccional.resoluciones_por_periodo_lectivo_institucion  trpli 
 inner join transaccional.periodos_lectivos_por_institucion tpli on tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=trpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
 inner join maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tpli.ID_PERIODO_LECTIVO
 inner join db_auxiliar.dbo.UVW_INSTITUCION mi on mi.ID_INSTITUCION= tpli.ID_INSTITUCION
 WHERE mpl.ANIO=@ANIO AND trpli.ES_ACTIVO=1
 and ID_RESOLUCION=@ID_RESOLUCION
 UNION
	SELECT mi.CODIGO_MODULAR													Code,
			Rtrim(LTrim(mi.CODIGO_MODULAR +' - '+mi.NOMBRE_INSTITUCION))		Text,
			mi.ID_INSTITUCION													Value
	FROM		db_auxiliar.dbo.UVW_INSTITUCION mi 
	INNER JOIN	transaccional.periodos_lectivos_por_institucion tpli on mi.ID_INSTITUCION = tpli.ID_INSTITUCION
				and tpli.ESTADO=(SELECT ID_ENUMERADO from sistema.enumerado where VALOR_ENUMERADO=@NOMBRE_APERTURADO) 
	INNER JOIN	maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tpli.ID_PERIODO_LECTIVO 
	left join 
				(	SELECT ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION, tpli.ID_INSTITUCION
					FROM transaccional.resoluciones_por_periodo_lectivo_institucion trpli 
					INNER JOIN transaccional.periodos_lectivos_por_institucion tpli 
					ON trpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
					AND trpli.ES_ACTIVO=1
				) A ON A.ID_INSTITUCION= mi.ID_INSTITUCION 
	 where mpl.ANIO=@ANIO 
	and A.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION is null
 ORDER BY Rtrim(LTrim(mi.CODIGO_MODULAR  +' - '+mi.NOMBRE_INSTITUCION)),mi.CODIGO_MODULAR,mi.ID_INSTITUCION
GO


