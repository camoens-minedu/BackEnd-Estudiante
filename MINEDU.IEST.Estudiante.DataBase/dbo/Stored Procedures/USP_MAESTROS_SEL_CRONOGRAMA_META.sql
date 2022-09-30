/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro del cronograma de meta para el periodo lectivo
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_CRONOGRAMA_META]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT
)
AS
DECLARE @ANIO INT
DECLARE @PERIODOLECTIVO INT

SET @ANIO = (SELECT ISNULL((SELECT ANIO FROM maestro.periodo_lectivo WHERE ID_PERIODO_LECTIVO
			= (SELECT ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion 
			WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION)),0))

SET @PERIODOLECTIVO = (SELECT TOP 1 ID_PERIODO_LECTIVO  FROM transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION)

SELECT 
	CM.ID_CRONOGRAMA_META_ATENCION				IdCronogramaMeta,
	CM.ID_PERIODO_LECTIVO				IdPeriodoLectivoInstitucion,
	CM.NOMBRE_CRONOGRAMA_META			Nombre,
	CM.FECHA_INICIO						FechaInicio,
	CM.FECHA_FIN						FechaFin
FROM maestro.cronograma_meta_atencion CM 
WHERE ID_PERIODO_LECTIVO IN (SELECT ID_PERIODO_LECTIVO FROM maestro.periodo_lectivo 
							WHERE ANIO = @ANIO AND ESTADO = 1 AND ID_PERIODO_LECTIVO = @PERIODOLECTIVO)

							--WHERE ID_PERIODO_LECTIVO IN (SELECT TOP 1 ID_PERIODO_LECTIVO FROM maestro.periodo_lectivo 
							--WHERE ANIO = @ANIO AND ESTADO = 1)
	  AND ESTADO = 1
GO


