/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	13/09/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene información detallada de admisión y postulantes de una institución por periodo lectivo. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			13/09/2021		JCHAVEZ			CREACIÓN
--  TEST:			
	EXEC USP_REPORTE_MONITOREO_ADMISION_POSTULANTES 272
**********************************************************************************************************/
CREATE PROCEDURE dbo.USP_REPORTE_MONITOREO_ADMISION_POSTULANTES
 @ID_PERIODO_LECTIVO_INSTITUCION INT
AS
BEGIN	
	SELECT pe.CODIGO_PERIODO_LECTIVO,i.ID_INSTITUCION,i.NOMBRE_DEPARTAMENTO, i.NOMBRE_PROVINCIA,i.NOMBRE_DISTRITO,i.CODIGO_MODULAR, i.NOMBRE_INSTITUCION,i.TIPO_GESTION_NOMBRE,
		REPLICATE('0',10-LEN(p.ID_PERSONA)) + CAST(p.ID_PERSONA AS VARCHAR(20)) ID,
		enutd.VALOR_ENUMERADO TIPO_DOCUMENTO,p.NUMERO_DOCUMENTO_PERSONA,p.APELLIDO_PATERNO_PERSONA, p.APELLIDO_MATERNO_PERSONA, p.NOMBRE_PERSONA,enulm.VALOR_ENUMERADO LENGUA_MATERNA,
		ISNULL(ibasica.UBIGEO_IE_BASICA,'') CODIGO_UBIGEO_IE_BASICA,ISNULL(ubiieb.DEPARTAMENTO_UBIGEO,'') UBIGEO_IE_BASICA,enu_ti_ieb.VALOR_ENUMERADO TIPO_INSTITUCION_IE_BASICA,
		ibasica.CODIGO_MODULAR_IE_BASICA,UPPER(ibasica.NOMBRE_IE_BASICA) NOMBRE_IE_BASICA,enu_tg_ieb.VALOR_ENUMERADO TIPO_GESTION_IE_BASICA,pmod.ANIO_EGRESO,
		pins.ID_PERSONA_INSTITUCION, enu.ID_ENUMERADO, enu.VALOR_ENUMERADO MODALIDAD,tm.NOMBRE_TIPO_MODALIDAD,c.NOMBRE_CARRERA, rpp.NOTA_RESULTADO, enume.VALOR_ENUMERADO
		,(CONVERT(VARCHAR(10),pmod.FECHA_CREACION,103) + ' ' + CONVERT(VARCHAR(10),pmod.FECHA_CREACION,108)) FECHA_CREACION
	from maestro.persona (NOLOCK) p 
		INNER JOIN sistema.enumerado (NOLOCK) enutd ON p.ID_TIPO_DOCUMENTO = enutd.ID_ENUMERADO
		INNER JOIN sistema.enumerado (NOLOCK) enulm ON p.ID_LENGUA_MATERNA = enulm.ID_ENUMERADO 
		INNER JOIN maestro.persona_institucion (NOLOCK) pins ON p.ID_PERSONA = pins.ID_PERSONA 
		INNER JOIN transaccional.postulantes_por_modalidad (NOLOCK) pmod ON pins.ID_PERSONA_INSTITUCION = pmod.ID_PERSONA_INSTITUCION 
		INNER JOIN maestro.tipos_modalidad_por_institucion (NOLOCK) tmxi ON pmod.ID_TIPOS_MODALIDAD_POR_INSTITUCION=tmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION AND tmxi.ES_ACTIVO=1
		INNER JOIN maestro.tipo_modalidad (NOLOCK) tm ON tmxi.ID_TIPO_MODALIDAD=tm.ID_TIPO_MODALIDAD AND tm.ESTADO=1
		INNER JOIN transaccional.modalidades_por_proceso_admision (NOLOCK) mppad ON pmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mppad.ID_MODALIDADES_POR_PROCESO_ADMISION 
		INNER JOIN transaccional.proceso_admision_periodo (NOLOCK) padp ON mppad.ID_PROCESO_ADMISION_PERIODO = padp.ID_PROCESO_ADMISION_PERIODO 
		INNER JOIN transaccional.periodos_lectivos_por_institucion (NOLOCK) plectivo ON padp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
		INNER JOIN maestro.periodo_lectivo (NOLOCK) pe ON plectivo.ID_PERIODO_LECTIVO = pe.ID_PERIODO_LECTIVO
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION (NOLOCK) i ON pins.ID_INSTITUCION = i.ID_INSTITUCION 
		INNER JOIN sistema.enumerado (NOLOCK) enu ON mppad.ID_MODALIDAD = enu.ID_ENUMERADO 
		INNER JOIN transaccional.opciones_por_postulante (NOLOCK) opp  ON pmod.ID_POSTULANTES_POR_MODALIDAD = opp.ID_POSTULANTES_POR_MODALIDAD 
		INNER JOIN transaccional.meta_carrera_institucion_detalle (NOLOCK) mcidet ON opp.ID_META_CARRERA_INSTITUCION_DETALLE = mcidet.ID_META_CARRERA_INSTITUCION_DETALLE 
		INNER JOIN transaccional.meta_carrera_institucion (NOLOCK) mci ON mcidet.ID_META_CARRERA_INSTITUCION = mci.ID_META_CARRERA_INSTITUCION 
		INNER JOIN transaccional.carreras_por_institucion (NOLOCK) cins ON mci.ID_CARRERAS_POR_INSTITUCION = cins.ID_CARRERAS_POR_INSTITUCION 
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA (NOLOCK) c ON cins.ID_CARRERA = c.ID_CARRERA 
		INNER JOIN transaccional.resultados_por_postulante (NOLOCK) rpp ON pmod.ID_POSTULANTES_POR_MODALIDAD = rpp.ID_POSTULANTES_POR_MODALIDAD 
		INNER JOIN sistema.enumerado (NOLOCK) enume ON rpp.ESTADO = enume.ID_ENUMERADO
		LEFT JOIN maestro.institucion_basica ibasica (NOLOCK) ON pmod.ID_INSTITUCION_BASICA = ibasica.ID_INSTITUCION_BASICA 
		LEFT JOIN sistema.enumerado enu_tg_ieb (NOLOCK) ON ibasica.ID_TIPO_GESTION_IE_BASICA = enu_tg_ieb.ID_ENUMERADO 
		LEFT JOIN sistema.enumerado enu_ti_ieb (NOLOCK) ON ibasica.ID_TIPO_INSTITUCION_BASICA = enu_ti_ieb.ID_ENUMERADO 
		--LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_INEI (NOLOCK) ubiieb ON ibasica.UBIGEO_IE_BASICA = ubiieb.CODIGO_UBIGEO
		LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO (NOLOCK) ubiieb ON ibasica.UBIGEO_IE_BASICA = ubiieb.CODIGO_UBIGEO
	WHERE plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
		AND pmod.ES_ACTIVO=1 AND padp.ES_ACTIVO=1 AND plectivo.ES_ACTIVO=1 AND opp.ES_ACTIVO=1 AND mcidet.ES_ACTIVO=1 AND mci.ES_ACTIVO=1 --AND i.CODIGO_MODULAR=0359729--AND p.NUMERO_DOCUMENTO_PERSONA='60153402' 	
	ORDER BY pe.ID_PERIODO_LECTIVO,i.NOMBRE_DEPARTAMENTO, i.NOMBRE_PROVINCIA,i.NOMBRE_DISTRITO,i.CODIGO_MODULAR, i.NOMBRE_INSTITUCION,mppad.ID_MODALIDAD,c.NOMBRE_CARRERA,rpp.NOTA_RESULTADO DESC
END