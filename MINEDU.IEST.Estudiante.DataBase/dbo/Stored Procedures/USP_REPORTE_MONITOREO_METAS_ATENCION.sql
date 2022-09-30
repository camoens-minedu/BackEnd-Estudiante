/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	13/09/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene información detallada de metas de atención de una institución por periodo lectivo. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			13/09/2021		JCHAVEZ			CREACIÓN
TEST:			
	EXEC USP_REPORTE_MONITOREO_METAS_ATENCION 1163
**********************************************************************************************************/
CREATE PROCEDURE dbo.USP_REPORTE_MONITOREO_METAS_ATENCION
 @ID_PERIODO_LECTIVO_INSTITUCION INT
AS
BEGIN	
	SELECT plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,pe.CODIGO_PERIODO_LECTIVO,i.NOMBRE_DEPARTAMENTO, i.NOMBRE_PROVINCIA, i.NOMBRE_DISTRITO, i.CODIGO_MODULAR, i.NOMBRE_INSTITUCION, i.TIPO_GESTION_NOMBRE,
		enu_s.VALOR_ENUMERADO + ' - ' + si.NOMBRE_SEDE NOMBRE_SEDE,c.NOMBRE_CARRERA, enu.VALOR_ENUMERADO, enumera.VALOR_ENUMERADO TURNO, mci.META META_CARRERA, mcid.META_SEDE, 
		UPPER(r.NUMERO_RESOLUCION) NUMERO_RESOLUCION, UPPER(r.ARCHIVO_RESOLUCION) ARCHIVO_RESOLUCION, 
		(CONVERT(VARCHAR(10),mcid.FECHA_CREACION,103) + ' ' + CONVERT(VARCHAR(10),mcid.FECHA_CREACION,108)) FECHA_CREACION
	FROM db_auxiliar.dbo.UVW_INSTITUCION i 
		INNER JOIN transaccional.periodos_lectivos_por_institucion plectivo ON i.ID_INSTITUCION = plectivo.ID_INSTITUCION
		INNER JOIN transaccional.carreras_por_institucion cin ON i.ID_INSTITUCION = cin.ID_INSTITUCION 
		INNER JOIN transaccional.meta_carrera_institucion mci ON cin.ID_CARRERAS_POR_INSTITUCION = mci.ID_CARRERAS_POR_INSTITUCION 
		INNER JOIN transaccional.meta_carrera_institucion_detalle mcid ON mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION AND mcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		INNER JOIN transaccional.resoluciones_por_carreras_por_institucion rci ON cin.ID_CARRERAS_POR_INSTITUCION = rci.ID_CARRERAS_POR_INSTITUCION
		INNER JOIN maestro.resolucion r ON rci.ID_RESOLUCION = r.ID_RESOLUCION
		INNER JOIN transaccional.resoluciones_por_periodo_lectivo_institucion rpli ON r.ID_RESOLUCION = rpli.ID_RESOLUCION AND rpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		INNER JOIN maestro.sede_institucion si ON mcid.ID_SEDE_INSTITUCION = si.ID_SEDE_INSTITUCION
		INNER JOIN sistema.enumerado enu_s ON si.ID_TIPO_SEDE = enu_s.ID_ENUMERADO 
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cin.ID_CARRERA = c.ID_CARRERA
		INNER JOIN transaccional.plan_estudio pestudio ON cin.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION 
		INNER JOIN sistema.enumerado enu ON pestudio.ID_TIPO_ITINERARIO = enu.ID_ENUMERADO 
		INNER JOIN maestro.turnos_por_institucion ti ON mci.ID_TURNOS_POR_INSTITUCION = ti.ID_TURNOS_POR_INSTITUCION 
		INNER JOIN maestro.turno_equivalencia te ON ti.ID_TURNO_EQUIVALENCIA = te.ID_TURNO_EQUIVALENCIA 
		INNER JOIN sistema.enumerado enumera ON te.ID_TURNO = enumera.ID_ENUMERADO 
		INNER JOIN maestro.periodo_lectivo pe ON plectivo.ID_PERIODO_LECTIVO = pe.ID_PERIODO_LECTIVO
	WHERE plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
		AND cin.ES_ACTIVO=1 AND mci.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1 AND rci.ES_ACTIVO=1 --AND i.TIPO_GESTION=10061
	GROUP BY plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,pe.CODIGO_PERIODO_LECTIVO,i.NOMBRE_DEPARTAMENTO, i.NOMBRE_PROVINCIA, i.NOMBRE_DISTRITO, i.CODIGO_MODULAR, i.NOMBRE_INSTITUCION, i.TIPO_GESTION_NOMBRE,
		enu_s.VALOR_ENUMERADO,si.NOMBRE_SEDE,c.NOMBRE_CARRERA, enu.VALOR_ENUMERADO, mci.META, mcid.META_SEDE, enumera.VALOR_ENUMERADO, r.NUMERO_RESOLUCION, r.ARCHIVO_RESOLUCION ,mcid.FECHA_CREACION
	ORDER BY pe.CODIGO_PERIODO_LECTIVO,i.NOMBRE_DEPARTAMENTO, i.NOMBRE_PROVINCIA, i.NOMBRE_DISTRITO, i.CODIGO_MODULAR,c.NOMBRE_CARRERA
END