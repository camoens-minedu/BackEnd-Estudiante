/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de la meta de programa de estudios
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:		USP_ADMISION_DEL_META_CARRERA_INSTITUCION 1106, 2515, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_META_CARRERA_INSTITUCION]
(
	@ID_INSTITUCION							INT, 
	@ID_META_CARRERA_INSTITUCION			INT,	
	@USUARIO								VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;

DECLARE @RESULT INT, @ID_TIPO_RESOLUCION INT, @ANIO INT, @ID_PLAN_ESTUDIO INT, @ID_META_CARRERA_INSTITUCION_AMPL INT = 0, @ID_INSTITUCION_CONSULTA INT = 0

SELECT @ID_INSTITUCION_CONSULTA = cxi.ID_INSTITUCION, @ID_PLAN_ESTUDIO = mci.ID_PLAN_ESTUDIO FROM transaccional.meta_carrera_institucion mci
INNER JOIN transaccional.carreras_por_institucion cxi ON mci.ID_CARRERAS_POR_INSTITUCION = cxi.ID_CARRERAS_POR_INSTITUCION and mci.ES_ACTIVO=1 and cxi.ES_ACTIVO=1
where mci.ID_META_CARRERA_INSTITUCION = @ID_META_CARRERA_INSTITUCION		 	 

IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA 
BEGIN
	 SET @RESULT = -362 GOTO FIN	 --no corresponde al instituto
END 

IF EXISTS(SELECT TOP 1 ID_META_CARRERA_INSTITUCION_DETALLE FROM transaccional.meta_carrera_institucion_detalle WHERE ID_META_CARRERA_INSTITUCION = @ID_META_CARRERA_INSTITUCION AND ES_ACTIVO=1 )
BEGIN
	SET @RESULT = -162 GOTO FIN  --tiene registros asociados
END 
	
SELECT
	 @ID_TIPO_RESOLUCION = r.ID_TIPO_RESOLUCION, 
	 @ANIO = mci.ANIO
FROM 
	transaccional.meta_carrera_institucion mci
	INNER JOIN transaccional.resoluciones_por_periodo_lectivo_institucion rxpli ON mci.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION = rxpli.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION 
	AND mci.ES_ACTIVO=1 AND rxpli.ES_ACTIVO=1
	INNER JOIN maestro.resolucion r ON r.ID_RESOLUCION = rxpli.ID_RESOLUCION AND r.ES_ACTIVO=1 AND r.ESTADO=1
WHERE 
	mci.ID_META_CARRERA_INSTITUCION= @ID_META_CARRERA_INSTITUCION
	
if @ID_TIPO_RESOLUCION = 21 
BEGIN
	SELECT  
		@ID_META_CARRERA_INSTITUCION_AMPL = mci.ID_META_CARRERA_INSTITUCION 
	FROM 
		transaccional.meta_carrera_institucion mci
		INNER JOIN transaccional.resoluciones_por_periodo_lectivo_institucion rxpli ON mci.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION = rxpli.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION 
		AND mci.ES_ACTIVO=1 AND rxpli.ES_ACTIVO=1
		INNER JOIN maestro.resolucion r ON r.ID_RESOLUCION = rxpli.ID_RESOLUCION AND r.ES_ACTIVO=1 AND r.ESTADO=1
	WHERE 
		ANIO=@ANIO AND ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO AND ID_META_CARRERA_INSTITUCION<>@ID_META_CARRERA_INSTITUCION
END

IF @ID_TIPO_RESOLUCION = 21 AND @ID_META_CARRERA_INSTITUCION_AMPL IS NOT NULL AND @ID_META_CARRERA_INSTITUCION_AMPL <> 0
	SET @RESULT = -361  --se debe eliminar primero la meta de ampliación anual.
ELSE
BEGIN

	UPDATE transaccional.meta_carrera_institucion
	SET		ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
	WHERE 
			ID_META_CARRERA_INSTITUCION= @ID_META_CARRERA_INSTITUCION
	SET @RESULT =   1	
END
FIN:
SELECT @RESULT
END 


--**************************************************************
--49. USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_CAB.sql